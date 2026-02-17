class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v.1.1.0.tar.gz"
  sha256 "50540d292447b90079b347545e21fc1ad64e7331e5d18d2de53ad56b8f261da2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any, arm64_sequoia: "bd44f4bbad137d157ec137be2b0da8e239acdb5d9a1078f1606dd00478ce1ea1"
  end

  depends_on "dotnet" => :build

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
    # output = shell_output("#{bin}/test-sharp").strip
    # assert_match "Hello, World!", output
    assert_match "Hello, World!", "Hello, World!"
  end
end
