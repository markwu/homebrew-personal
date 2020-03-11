class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  head "https://github.com/macvim-dev/macvim.git"

  depends_on :xcode => :build
  depends_on "pkg-config" => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "python"

  def install
    # Avoid issues finding SDK Ruby headers
    ENV.delete("SDKROOT")

    # Use RVM Ruby
    ENV["PKG_CONFIG_PATH"] = ENV["HOMEBREW_CUSTOM_RUBY_HOME"] + "/lib/pkgconfig"
    ENV.prepend_path "PATH" , `pkg-config --variable=bindir ruby-2.7`.chomp
    ENV.append "LDFLAGS", '-L'+`pkg-config --variable=libdir ruby-2.7`.chomp
    ENV.append "CFLAGS", '-I'+`pkg-config --variable=includedir ruby-2.7`.chomp

    # Use Homebrew Python
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

    # Vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--with-compiledby=Homebrew",
                          "--with-features=huge",
                          "--enable-multibyte",
                          "--with-macarchs=#{MacOS.preferred_arch}",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  def caveats; <<~EOS
    To compile MacVim with custom Ruby, you have to specify the following 
    HOMEBREW_CUSTOM_RUBY_HOME environment variable in you shell environment:

    # example: get the prefix from RbConfig
    $ export HOMEBREW_CUSTOM_RUBY_HOME=$(ruby -r rbconfig -e "print RbConfig::CONFIG['prefix']")

    # example: get the prefix from RVM environment variable
    $ export HOMEBREW_CUSTOM_RUBY_HOME=$MY_RUBY_HOME

    Without  HOMEBREW_CUSTOM_RUBY_HOME, custom Ruby can not link correctly.
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
