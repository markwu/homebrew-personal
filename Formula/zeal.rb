require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.3.0.tar.gz'
  sha256 '994c5fad079cb34952fc05b0663920118489ed7f00f8e5a5887ff2e2bd05861d'
  head "d723c6bc3cb08398d10e7c204929853c9d40d57431a5a16752630b258ae96dc1"

  depends_on "homebrew/versions/qt55"
  depends_on "libarchive"

  patch :DATA

  def install
    system "/usr/local/opt/qt55/bin/qmake"
    system "/usr/bin/make"
    prefix.install "bin/Zeal.app"
    (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
  end

  test do
    system "zeal", "-h"
  end
end
__END__
diff --git a/src/core/core.pri b/src/core/core.pri
index a9823b8..dd39467 100644
--- a/src/core/core.pri
+++ b/src/core/core.pri
@@ -8,3 +8,7 @@ unix:!macx {
 win32: {
     LIBS += -larchive_static -lz
 }
+macx: {
+    INCLUDEPATH += /usr/local/opt/libarchive/include
+    LIBS += -L/usr/local/opt/libarchive/lib -larchive
+}
