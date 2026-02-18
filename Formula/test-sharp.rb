class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d489c018bde6a32f54fc07f53c6f2072d3d869218b42790a1236d0a9c7dd36c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any, arm64_sequoia: "cd7bc466fe79457e1bb2b08c999edca7c25fce7341090cc1619c35584d2816a2"
  end

  depends_on "dotnet" => [:build]
  depends_on "brotli"
  depends_on "openssl"
  depends_on "icu4c"

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
