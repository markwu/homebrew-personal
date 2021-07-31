require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  head "https://github.com/zealdocs/zeal.git"

  depends_on "cmake" => :build
  depends_on "qt@5"
  depends_on "libarchive"

  def install
    # system "git fetch --tags"
    # system "git fetch --prune --unshallow"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      prefix.install "bin/Zeal.app"
      (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
    end
  end

  test do
    system "zeal", "-h"
  end
end
