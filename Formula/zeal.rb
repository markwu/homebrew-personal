require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.3.0.tar.gz'
  sha256 'd723c6bc3cb08398d10e7c204929853c9d40d57431a5a16752630b258ae96dc1'
  head "https://github.com/zealdocs/zeal.git"

  depends_on "qt5"
  depends_on "libarchive"

  patch :DATA

  def install
    system "/usr/local/opt/qt5/bin/qmake"
    system "/usr/bin/make"
    prefix.install "bin/Zeal.app"
    (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
  end

  test do
    system "zeal", "-h"
  end
end
__END__
diff --git a/src/libs/core/core.pri b/src/libs/core/core.pri
index 0f7c62e..919bf0d 100644
--- a/src/libs/core/core.pri
+++ b/src/libs/core/core.pri
@@ -9,3 +9,7 @@ unix:!macx {
 win32: {
     LIBS += -larchive_static -lz
 }
+macx: {
+    INCLUDEPATH += /usr/local/opt/libarchive/include
+    LIBS += -L/usr/local/opt/libarchive/lib -larchive
+}
