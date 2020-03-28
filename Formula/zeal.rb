require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.6.1.tar.gz'
  sha256 '095c08f9903071849d5c79878abd48237ce1615f16d324afff1873ab6b5f0026'
  head "https://github.com/zealdocs/zeal.git"
  version '0.6.1'

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "markwu/personal/qt5-webkit"
  depends_on "libarchive"

  stable do
    patch do
      url "https://raw.githubusercontent.com/markwu/homebrew-personal/master/Formula/zeal@0.6.1.diff"
      sha256 "55bda868aaa3092b84575db5151f910045b650bdf7b6dfe1058cdea91829a810"
    end
  end

  head do
    patch do
      url "https://raw.githubusercontent.com/markwu/homebrew-personal/master/Formula/zeal@head.diff"
      sha256 "91ea0afb7f18865c859fa47301c6f12a4c9aec4556d8b705f7ce32c1caa8102a"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      prefix.install "bin/Zeal.app"
      (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
      (bin/"zeal-loopbackalias").write("#! /bin/sh\n/sbin/ifconfig lo0 alias 127.0.0.22")
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/zeal/bin/zeal-loopbackalias"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}-loopbackalias</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{Formula["markwu/personal/zeal"].opt_bin}/zeal-loopbackalias</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  def caveats
    <<~EOS
      Before you run Zeal, you have to launch ifconfig loopback alias
      daemon by following command. It will install lookback alias for
      you.

      $ sudo brew services start zeal
    EOS
  end

  test do
    system "zeal", "-h"
  end
end
