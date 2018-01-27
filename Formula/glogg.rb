require 'formula'

class Glogg < Formula
  desc 'glogg is a multi-platform GUI application to browse and search through long or complex log files.'
  homepage "http://glogg.bonnefon.org/"
  url 'http://glogg.bonnefon.org/files/glogg-1.1.4.tar.gz'
  sha256 '0c1ddc72ebfc255bbb246446fb7be5b0fd1bb1594c70045c3e537cb6d274965b'
  head "https://github.com/nickbnf/glogg.git"
  version '1.1.4'

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
