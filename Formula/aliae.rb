class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.6.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.6.0/aliae-darwin-arm64"
      sha256 "2034694fe82fe8928a845d49be78d6afba3f271fe8e36a2b2d31b06ea94a7efa"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.6.0/aliae-darwin-amd64"
      sha256 "6541c8a229e4cabf41eba2cdb79292abdbc13a75d58a537dc6f01ecaf5cf9c05"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.6.0/aliae-linux-arm64"
      sha256 "9e635518afc006c6f7e2c5297e74914fed05605e067683e009f254d9eb03add3"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.6.0/aliae-linux-amd64"
      sha256 "24da2b9106ec412d43996f4f2041e060d0e871f67d2ff7bea42baf4183563b81"
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
