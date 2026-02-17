class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v.1.0.4.tar.gz"
  sha256 "a14bf5f77efd231f79632e69b34f2f690a67e826e0176465c2510db623640835"
  license "MIT"

  depends_on "dotnet"

  def install
    rid = Utils.safe_popen_read("dotnet", "--info")
                .lines
                .find { |l| l.start_with?(" RID:") || l.start_with?("RID:") }
                &.split(":", 2)&.last&.strip

    odie "Could not determine .NET RID from `dotnet --info`" if rid.blank?

    # Adjust path if your csproj lives elsewhere
    system "dotnet", "publish", "test-sharp.csproj",
            "-c", "Release",
            "-r", rid,
            "--self-contained", "true",
            "-p:PublishSingleFile=true",
            "-p:IncludeNativeLibrariesForSelfExtract=true",
            "-o", buildpath/"publish"

    bin.install buildpath/"publish/test-sharp"
  end

  test do
    # Update to whatever your app prints/does
    output = shell_output("#{bin}/test-sharp").strip
    assert_match "Hello, World!", output
  end
end
