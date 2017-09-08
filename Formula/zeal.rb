require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.3.1.tar.gz'
  sha256 '55f8511977818612e00ae87a4fddaa346210189531469690f2e3961bb4c2c318'
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
