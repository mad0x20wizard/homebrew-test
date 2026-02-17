class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "2e07c3258c70dc1305c21641512efc8d93b6a24560267b4707e813d87f6730d2"
  license "MIT"

  depends_on "dotnet"
  depends_on "brotli"

  def install
    dotnet_info = Utils.safe_popen_read("dotnet", "--info")

    rid_line = dotnet_info.lines.find do |l|
        l.start_with?(" RID:", "RID:")
    end

    odie "Could not determine .NET RID from `dotnet --info`" if rid_line.nil?

    rid = rid_line.split(":", 2).last&.strip
    odie "Could not parse RID from `dotnet --info`" if rid.blank?

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
    assert_match "Hello, Worldd!", output
  end
end
