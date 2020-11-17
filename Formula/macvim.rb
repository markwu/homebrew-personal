# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  head "https://github.com/macvim-dev/macvim.git"

  # patch xcode project
  patch :DATA

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
  depends_on "lua"
  depends_on "python@3.9"
  depends_on "ruby"

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp",
                          "--disable-sparkle"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output
    assert_match "+gettext", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.9"].opt_bin/"python3-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end

__END__
diff --git a/src/MacVim/MacVim.xcodeproj/project.pbxproj b/src/MacVim/MacVim.xcodeproj/project.pbxproj
index 729c23009..9b66f5335 100644
--- a/src/MacVim/MacVim.xcodeproj/project.pbxproj
+++ b/src/MacVim/MacVim.xcodeproj/project.pbxproj
@@ -3,7 +3,7 @@
 	archiveVersion = 1;
 	classes = {
 	};
-	objectVersion = 47;
+	objectVersion = 54;
 	objects = {
 
 /* Begin PBXBuildFile section */
@@ -1169,6 +1169,7 @@
 			buildSettings = {
 				COMBINE_HIDPI_IMAGES = YES;
 				COPY_PHASE_STRIP = NO;
+				EXCLUDED_ARCHS = arm64;
 				FRAMEWORK_SEARCH_PATHS = (
 					"$(inherited)",
 					"$(FRAMEWORK_SEARCH_PATHS_QUOTED_FOR_TARGET_1)",
@@ -1202,6 +1203,7 @@
 			buildSettings = {
 				COMBINE_HIDPI_IMAGES = YES;
 				COPY_PHASE_STRIP = YES;
+				EXCLUDED_ARCHS = arm64;
 				FRAMEWORK_SEARCH_PATHS = (
 					"$(inherited)",
 					"$(FRAMEWORK_SEARCH_PATHS_QUOTED_FOR_TARGET_1)",
@@ -1233,6 +1235,7 @@
 			buildSettings = {
 				CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES;
 				ENABLE_TESTABILITY = YES;
+				EXCLUDED_ARCHS = arm64;
 				GCC_VERSION = 4.2;
 				GCC_WARN_ABOUT_RETURN_TYPE = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
@@ -1246,6 +1249,7 @@
 			isa = XCBuildConfiguration;
 			buildSettings = {
 				CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES;
+				EXCLUDED_ARCHS = arm64;
 				GCC_VERSION = 4.2;
 				GCC_WARN_ABOUT_RETURN_TYPE = YES;
 				GCC_WARN_UNUSED_VARIABLE = YES;
