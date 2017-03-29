require 'formula'

class Glogg < Formula
  desc 'glogg is a multi-platform GUI application to browse and search through long or complex log files.'
  homepage "http://glogg.bonnefon.org/"
  url 'https://github.com/nickbnf/glogg/archive/v1.1.3.tar.gz'
  sha256 '8e78ffe2da306e6d42ec6ab227aa5ada58303022ab271c23f50396974e8b4eb8'
  head "https://github.com/nickbnf/glogg.git"

  depends_on "qt5"
  depends_on "boost"

  def install
    system "/usr/local/opt/qt5/bin/qmake"
    system "/usr/bin/make"
    prefix.install "release/glogg.app"
  end
end
