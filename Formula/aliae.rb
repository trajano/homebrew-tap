class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.8.2"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.2/aliae-darwin-arm64"
      sha256 "5e872fdfa41591337a553e6c0172eb65cd3e2b35d787dd1a579cbf53031de92e"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.2/aliae-darwin-amd64"
      sha256 "e30037f621dc0b3bc981c592d6edfef62260e42607c0d5a13bd2a7f60e9baccd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.2/aliae-linux-arm64"
      sha256 "32bc264df8a7977702f81a1c6abc114739ab493cbdbfa0f1e501b0d9588200c3"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.2/aliae-linux-amd64"
      sha256 "a1a5eebcf0e612e2020e6482ddeae8bdd448086b43f1812c4a6adead18cff271"
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
