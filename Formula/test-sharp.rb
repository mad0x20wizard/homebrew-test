class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v3.1.tar.gz"
  sha256 "6bb607c861931097fbbb8e617ca46440850747460f86b74c568039450ed6fabd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any,                 arm64_sequoia: "79a020e0b3aaa82f658d31dc750f58ba22c3ebd7f9198cf38d7d6e5033ff5773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd0a92e379403a24e50c88ecb575b66f413dd1c323f212b17c78fcd5acd9eec"
    sha256                               x86_64_linux:  "cfe2227245e4093267c3cc11fb7cd36130df5f14c4614a5d44fd459fb79dac44"
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
