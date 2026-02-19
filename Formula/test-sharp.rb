class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "1f5829b8027df4e882f7b0112273095a87fe6a28cf8681cb84f367e63d2cee3f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any,                 arm64_tahoe:   "d990f4c005d6b9d7188783ddd70d4809d5e252585265b400528fe33da3bf0c48"
    sha256 cellar: :any,                 arm64_sequoia: "faf0ae72a7fdb752cf5890f02383b7150041618cb3a65e86d2d6ef900468dcea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49071dc21fb2d26760f6f8ac8ac0e7ae6c473f29a8e9e0ad5e48bb0134006aed"
    sha256                               x86_64_linux:  "4c0bbcfe3839a722e6fc49fe312f8e90f88eea83d34e0c55346abf4e35144177"
  end

  depends_on "dotnet" => [:build]
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "libunwind"
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

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
