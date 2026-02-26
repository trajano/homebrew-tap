class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.10.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.10.0/aliae-darwin-arm64"
      sha256 "f9141c112ec25ab78fb96ed109cf81b23ddfbd71d894732a889bd5cd2859bd7d"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.10.0/aliae-darwin-amd64"
      sha256 "059179253cf57232713c454e6fd766a13bf93e3e70a66c79b98761eb830e6172"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.10.0/aliae-linux-arm64"
      sha256 "aceaae7fb8d7e666ab2f58f273632dd3dbea419d312722f1fa6355e6510bb182"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.10.0/aliae-linux-amd64"
      sha256 "2cb37cd6921a98df41f8650a9db78a4ff69b20490fd36d9d64f2ed934ba2f4a0"
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
