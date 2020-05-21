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
index 80926b4..fc7bb1b 100644
--- a/smc.c
+++ b/smc.c
@@ -272,11 +272,12 @@ void readAndPrintFanRPMs(void)
                 continue;
             }

-            float rpm = actual_speed - minimum_speed;
-            if (rpm < 0.f) {
-                rpm = 0.f;
+            float rpm = actual_speed;
+            float difference = actual_speed - minimum_speed;
+            if (difference < 0.f) {
+                difference = 0.f;
             }
-            float pct = rpm / (maximum_speed - minimum_speed);
+            float pct = difference / (maximum_speed - minimum_speed);

             pct *= 100.f;
             printf("Fan %d - %s at %.0f RPM (%.0f%%)\n", i, name, rpm, pct);
