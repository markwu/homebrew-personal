require 'formula'

class Kindlegen < Formula
  homepage 'http://www.amazon.com/gp/feature.html?docId=1000765211'
  url 'http://kindlegen.s3.amazonaws.com/KindleGen_Mac_i386_v2_9.zip'
  sha256 '7aad3b01c8f0d61096f86d7ba34e4deeef22355b9dbf2555c6dd05a281f5d17e'

  def install
    bin.install 'kindlegen'
  end

  test do
    system "#{bin}/kindlegen"
  end

  def caveats
    <<-EOS.undent
      We agreed to the KindleGen License Agreement for you by downloading KindleGen.
      If this is unacceptable you should uninstall.

      License information at:
      #{homepage}
    EOS
  end
end
