require 'formula'

class ZealATQt55 < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  url 'https://github.com/zealdocs/zeal/archive/v0.6.1.tar.gz'
  sha256 '095c08f9903071849d5c79878abd48237ce1615f16d324afff1873ab6b5f0026'
  head "https://github.com/zealdocs/zeal.git"
  version '0.6.1'

  depends_on "cmake" => :build
  depends_on "qt@5.5"
  depends_on "libarchive"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", ".."
      system "make"
      prefix.install "bin/Zeal.app"
      (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
    end
  end

  test do
    system "zeal", "-h"
  end
end
__END__
diff --git a/src/libs/core/CMakeLists.txt b/src/libs/core/CMakeLists.txt
index cd212bb..bd9b903 100644
--- a/src/libs/core/CMakeLists.txt
+++ b/src/libs/core/CMakeLists.txt
@@ -9,9 +9,12 @@ add_library(Core

 target_link_libraries(Core Registry Ui)

+list(APPEND CMAKE_PREFIX_PATH /usr/local/opt/qt@5.5)
 find_package(Qt5 COMPONENTS Network WebKit Widgets REQUIRED)
 target_link_libraries(Core Qt5::Network Qt5::WebKit Qt5::Widgets)

+list(APPEND CMAKE_PREFIX_PATH /usr/local/opt/libarchive)
+list(APPEND CMAKE_LIBRARY_PATH /usr/local/opt/libarchive)
 find_package(LibArchive REQUIRED)
 include_directories(${LibArchive_INCLUDE_DIRS})
 target_link_libraries(Core ${LibArchive_LIBRARIES})
