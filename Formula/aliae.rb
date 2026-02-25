class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.5.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.5.0/aliae-darwin-arm64"
      sha256 "822b5260aad16a1fea470a50c1b2e6bddbc378fd7a4303a3925a41b0c902a50e"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.5.0/aliae-darwin-amd64"
      sha256 "16b93284c205e0f446a6d9ca97ed126e6fb99f5ca76254169ef56acfb69edb6f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.5.0/aliae-linux-arm64"
      sha256 "5776edfbd3f0ed45bd2e896c61b32be74856658e70e34f1e8ea32932138f814d"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.5.0/aliae-linux-amd64"
      sha256 "96e813080a15e8a9bbfa049701594d03510161b1d3c3feaa1df35eeb0ed80bfa"
    end
  end

  def install
    arch = if OS.mac? && Hardware::CPU.arm?
      "darwin-arm64"
    elsif OS.mac?
      "darwin-amd64"
    elsif OS.linux? && Hardware::CPU.arm?
      "linux-arm64"
    elsif OS.linux?
      "linux-amd64"
    end

    odie "Unsupported platform" if arch.nil?

    bin.install "aliae-#{arch}" => "aliae"
  end

  test do
    system "#{bin}/aliae", "--help"
  end
end
