class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.3.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.3.0/aliae-darwin-arm64"
      sha256 "fd7036a172c330e4743699b4e3a977f5ddb7db12fd566365d1fc6edb6d9ffa81"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.3.0/aliae-darwin-amd64"
      sha256 "059c3c128f4dd391e39dbd2dd95202eab945ca839fa2aa1dcec559270f8c77d3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.3.0/aliae-linux-arm64"
      sha256 "f806bc12cab5f451e90a1fd3828fd23896320fa5442c93e732f313be5d76c858"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.3.0/aliae-linux-amd64"
      sha256 "da2fee0a2d9a858e79faedca1830100de7ff91de38faddfd157975085800cedb"
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
