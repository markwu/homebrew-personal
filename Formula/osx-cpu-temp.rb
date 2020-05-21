require 'formula'

class OsxCpuTemp < Formula
  desc "Outputs current CPU temperature for OSX"
  homepage "https://github.com/lavoiesl/osx-cpu-temp"
  head "https://github.com/lavoiesl/osx-cpu-temp.git"

  patch :DATA

  def install
    system "make"
    bin.install "osx-cpu-temp"
  end

  test do
    assert_match "°C", shell_output("#{bin}/osx-cpu-temp -C")
  end
end
__END__
diff --git a/smc.c b/smc.c
index 80926b4..52ff701 100644
--- a/smc.c
+++ b/smc.c
@@ -272,11 +272,11 @@ void readAndPrintFanRPMs(void)
                 continue;
             }

-            float rpm = actual_speed - minimum_speed;
-            if (rpm < 0.f) {
-                rpm = 0.f;
+            float rpm = actual_speed;
+            if (rpm > maximum_speed) {
+                rpm = maximum_speed;
             }
-            float pct = rpm / (maximum_speed - minimum_speed);
+            float pct = rpm / maximum_speed;

             pct *= 100.f;
             printf("Fan %d - %s at %.0f RPM (%.0f%%)\n", i, name, rpm, pct);
