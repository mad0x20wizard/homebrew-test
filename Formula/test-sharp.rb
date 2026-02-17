class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "83d0bfcde771098a9a6f5a0cb0ab1e117dd5c5aff152e9398e3f230f36f2aaf2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any, arm64_sequoia: "beaf7c1f552d19b215fe6c9017e64c934c2b293c24279c58bb03492efa130d34"
  end

  depends_on "dotnet" => [:build]

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
    assert_match "Hello, World!", output
    # assert_match "Hello, World!", "Hello, World!"
  end
end
