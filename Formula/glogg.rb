require 'formula'

class Glogg < Formula
  desc 'glogg is a multi-platform GUI application to browse and search through long or complex log files.'
  homepage "http://glogg.bonnefon.org/"
  url 'https://github.com/nickbnf/glogg/archive/v1.1.3.tar.gz'
  sha256 '8e78ffe2da306e6d42ec6ab227aa5ada58303022ab271c23f50396974e8b4eb8'
  head "https://github.com/nickbnf/glogg.git"

  depends_on "qt5"
  depends_on "boost"

  patch :DATA

  def install
    system "/usr/local/opt/qt5/bin/qmake"
    system "/usr/bin/make"
    prefix.install "release/glogg.app"
  end
end
__END__
diff --git a/glogg.pro b/glogg.pro
index 3b5eb5f..67e987b 100644
--- a/glogg.pro
+++ b/glogg.pro
@@ -224,7 +224,7 @@ macx {
     QMAKE_CXXFLAGS += -stdlib=libc++
     QMAKE_LFLAGS += -stdlib=libc++

-    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6
+    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.7
 }

 # Official builds can be generated with `qmake VERSION="1.2.3"'
