# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  head "https://github.com/macvim-dev/macvim.git"

  option 'with-custom-ruby', 'Compiled against with custom ruby.'

  depends_on :xcode => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "python"

  conflicts_with "vim",
    :because => "vim and macvim both install vi* binaries"

  patch do
    url "https://raw.githubusercontent.com/markwu/homebrew-personal/master/Formula/macvim-pr946.patch"
    sha256 "b9588efc2c57174967aa13ee485f1108450cc7818ac33e4175db3009c628c6c8"
  end

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    opts = []
    if build.with? 'custom-ruby'
      custom_ruby_cmd = ENV['HOMEBREW_CUSTOM_RUBY_CMD']
      opts << "--with-ruby-command=#{custom_ruby_cmd}"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-features=huge",
                          "--with-compiledby=Homebrew",
                          "--with-macarchs=#{MacOS.preferred_arch}",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--with-tlib=ncurses",
                          "--enable-multibyte",
                          "--enable-terminal",
                          "--enable-cscope",
                          "--enable-perlinterp",
                          "--enable-rubyinterp=dynamic",
                          "--enable-pythoninterp=dynamic",
                          "--enable-python3interp=dynamic",
                          "--enable-luainterp=dynamic",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          *opts

    system "make"

    # Patch MacVim buildin vimrc to fix homebrew python3 dynamic link problem
    app_path = 'src/MacVim/build/Release/MacVim.app'
    vimrc = "#{buildpath}/#{app_path}/Contents/Resources/vim/vimrc"
    inreplace vimrc, /^if exists\("&pythonthreedll"\) && exists\("&pythonthreehome"\).*$/m, <<~EOS
if exists("&pythonthreedll") && exists("&pythonthreehome")
  if filereadable("/usr/local/Frameworks/Python.framework/Versions/3.7/Python")
    " Homebrew python 3.7
    set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
    set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
  elseif filereadable("/opt/local/Library/Frameworks/Python.framework/Versions/3.7/Python")
    " MacPorts python 3.7
    set pythonthreedll=/opt/local/Library/Frameworks/Python.framework/Versions/3.7/Python
    set pythonthreehome=/opt/local/Library/Frameworks/Python.framework/Versions/3.7
  elseif filereadable("/Library/Frameworks/Python.framework/Versions/3.7/Python")
    " https://www.python.org/downloads/mac-osx/
    set pythonthreedll=/Library/Frameworks/Python.framework/Versions/3.7/Python
    set pythonthreehome=/Library/Frameworks/Python.framework/Versions/3.7
  endif
endif

    EOS

    # Add custom ruby dll to MacVim buildin vimrc
    if build.with? 'custom-ruby'
      custom_ruby_lib = ENV['HOMEBREW_CUSTOM_RUBY_LIB']
      Pathname(vimrc).append_lines <<~EOS
      " Ruby
      " MacVim is configured by --with-custom-ruby option to use custom ruby version
      set rubydll=#{custom_ruby_lib}
      EOS
    end

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  def caveats; <<~EOS
    To compile MacVim with custom ruby, you have to use '--with-custom-ruby'
    option, and also specify the following two enironment variables in you shell
    environment or .bashrc:

    $ export HOMEBREW_CUSTOM_RUBY_CMD=$(ruby -r rbconfig -e "print File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])")
    $ export HOMEBREW_CUSTOM_RUBY_LIB=$(ruby -r rbconfig -e "print File.join(RbConfig::CONFIG['libdir'], RbConfig::CONFIG['LIBRUBY'])")

    Without these two variables, custom ruby can not link correctly.
    EOS
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = Utils.popen_read("python3-config", "--exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
