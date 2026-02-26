class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.9.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.9.0/aliae-darwin-arm64"
      sha256 "6c0a326136139a3dc1b7db81cbeae6840b7a25e36bed2e07dabb777d1cf02d55"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.9.0/aliae-darwin-amd64"
      sha256 "545d9bc63b85fdc7e5b7a072bf6ca1577b9ea154835fd7568a2656b047b0117c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.9.0/aliae-linux-arm64"
      sha256 "ac207c509973f1afabfdfd1d7c6371374d914afc0e7cc198db5dee7ce3bb6272"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.9.0/aliae-linux-amd64"
      sha256 "e6cab379c34d2b27ae76a51822d5c674d2cba3210d4fda4f533348b6541b98ae"
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
