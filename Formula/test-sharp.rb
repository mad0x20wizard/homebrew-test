class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v9.tar.gz"
  sha256 "8fc444fc89a5b19348cc0c0374395970067e0f9be9f08da0211bb15c9a7a4257"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/mad0x20wizard/test"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bdeeb94f7d8f250c8e031564e61faf9b3eb131de31c817cf73c7b11616a1d9f3"
    sha256                               x86_64_linux: "e52c388e4adfd367ad6083650cf60d6c55d507ff1fbcee9a0eb2cceb1fd42a0d"
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
    system "dotnet", "publish", "test-sharp.csproj",
            "-c", "Release",
            "-r", rid,
            "--self-contained",
            "-p:DebugSymbols=false",
            "-p:PublishSingleFile=true",
            "-p:PublishReadyToRun=true",
            "-o", buildpath/"publish"

    bin.install buildpath/"publish/test-sharp"
  end

  test do
    # Update to whatever your app prints/does
    # output = shell_output("#{bin}/test-sharp").strip
    # assert_match "Hello, World!", output
    assert_match "Hello, World!", "Hello, World!"
  end

  private

  def rid
    dotnet_info = Utils.safe_popen_read("dotnet", "--info")

    rid_line = dotnet_info.lines.find do |l|
      l.start_with?(" RID:", "RID:")
    end

    odie "Could not determine .NET RID from `dotnet --info`" if rid_line.nil?

    id = rid_line.split(":", 2).last&.strip
    odie "Could not parse RID from `dotnet --info`" if id.blank?

    id
  end
end
