require 'formula'

class Glogg < Formula
  desc 'glogg is a multi-platform GUI application to browse and search through long or complex log files.'
  homepage "http://glogg.bonnefon.org/"
  url 'https://github.com/nickbnf/glogg/archive/v1.1.2.tar.gz'
  sha256 '52f0387f4cb896580ec27da24fe93b4ef38e74e5162a8a408c1761d1648f6677'
  head "https://github.com/nickbnf/glogg.git"

  depends_on "qt5"
  depends_on "boost"

  def install
    system "/usr/local/opt/qt5/bin/qmake"
    system "/usr/bin/make"
    prefix.install "release/glogg.app"
  end
end
