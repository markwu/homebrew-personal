require 'formula'

class Glogg < Formula
  desc 'glogg is a multi-platform GUI application to browse and search through long or complex log files.'
  homepage "http://glogg.bonnefon.org/"
  url 'https://github.com/nickbnf/glogg/archive/v1.1.1.tar.gz'
  sha256 '6aadf220989937af5b97b2254f13c88bfbe9d37dc80de273ce03418fa8151d24'
  head "https://github.com/nickbnf/glogg.git"

  depends_on "qt5"
  depends_on "boost"

  def install
    system "/usr/local/opt/qt5/bin/qmake"
    system "/usr/bin/make"
    prefix.install "release/glogg.app"
  end
end
