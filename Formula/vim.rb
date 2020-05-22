class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  head "https://github.com/vim/vim.git"

  depends_on :xcode => :build
  depends_on "pkg-config" => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "python"
  depends_on "perl"

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

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{prefix}",
                          "--with-features=huge",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--with-compiledby=Homebrew",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--enable-gui=no",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  def caveats; <<~EOS
    To compile Vim with custom Ruby, you have to specify the following 
    HOMEBREW_CUSTOM_RUBY_HOME environment variable in you shell environment:

    # example: get the prefix from RbConfig
    $ export HOMEBREW_CUSTOM_RUBY_HOME=$(ruby -r rbconfig -e "print RbConfig::CONFIG['prefix']")

    # example: get the prefix from RVM environment variable
    $ export HOMEBREW_CUSTOM_RUBY_HOME=$MY_RUBY_HOME

    Without  HOMEBREW_CUSTOM_RUBY_HOME, custom Ruby can not link correctly.
    EOS
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
