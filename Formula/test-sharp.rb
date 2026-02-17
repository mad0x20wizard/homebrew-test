class TestSharp < Formula
  desc "Hello World .NET sample"
  homepage "https://github.com/mad0x20wizard/test-sharp"
  url "https://github.com/mad0x20wizard/test-sharp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "68cf0abe09cba01b62cccb20e9c13596706048b7abda72f25527daab926d673d"
  license "MIT"

  depends_on "dotnet"

  def install
    # Adjust path if your csproj lives elsewhere
    system "dotnet", "publish", "TestSharp/TestSharp.csproj",
      "-c", "Release",
      "--self-contained", "false",
      "-o", "publish"

    libexec.install Dir["publish/*"]

    (bin/"test-sharp").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/TestSharp.dll" "$@"
    EOS
  end

  test do
    # Update to whatever your app prints/does
    output = shell_output("#{bin}/test-sharp").strip
    assert_match "Hello, World!", output
  end
end