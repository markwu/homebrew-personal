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
      sha256 "ccd4ec9444e2a7849390cc100d2cd28b443db2642b11e2ac91f920d72d14c695"
    end
  end

  def install
    mkdir "build" do
      system "cmake", ".."
      system "make"
      prefix.install "bin/Zeal.app"
      (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
    end
  end

  test do
    system "zeal", "-h"
  end
end
