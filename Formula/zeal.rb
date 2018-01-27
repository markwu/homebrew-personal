require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.5.0.tar.gz'
  sha256 '3efb7b1b5d9a05f0fc60a6686571f7a4b58fa6f6d66f1baf608e83b10fb1290c'
  head "https://github.com/zealdocs/zeal.git"
  version '0.5.0'

  depends_on "qt@5.5"
  depends_on "libarchive"

  patch :DATA

  def install
    system "/usr/local/Cellar/qt@5.5/5.5.1_1/bin/qmake"
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
index 67bc5ec..f19e643 100644
--- a/src/libs/core/core.pri
+++ b/src/libs/core/core.pri
@@ -9,3 +9,7 @@ unix:!macx {
 win32: {
     LIBS += -larchive_static -lz
 }
+macx: {
+    INCLUDEPATH += /usr/local/opt/libarchive/include
+    LIBS += -L/usr/local/opt/libarchive/lib -larchive -lsqlite3
+}
