class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.8.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.0/aliae-darwin-arm64"
      sha256 "aed488a937e14a2c3e77d46db0c02d7324024475f09676c766b0fda83db6b350"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.0/aliae-darwin-amd64"
      sha256 "30e9fcf47279ccf1ad9579f84cbb7f1cd047b156e27cfbc1508e05c05738dbdb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.0/aliae-linux-arm64"
      sha256 "cdcd4bf7e15fdee7b1ca8ad26f8cbe138356a95aeeefc49bf6025f73804d82e6"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.0/aliae-linux-amd64"
      sha256 "ce1691763301c47d1f949391bd997abc8f8e62998aa1c76c91ad47b75b3ccbd3"
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
