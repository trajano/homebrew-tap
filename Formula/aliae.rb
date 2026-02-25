class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.7.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.7.0/aliae-darwin-arm64"
      sha256 "95ed97ee2666b9cbb24ab36a750bbdba15b46e2376777f0f0f289107d6a52755"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.7.0/aliae-darwin-amd64"
      sha256 "e7bbb64457161c50f21e875cfbbd6532bec38971834a1a3a42ea8a608a569952"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.7.0/aliae-linux-arm64"
      sha256 "90e8829df08c001e7329f031cc1b9c9fb2885798906bebae56b04b84fa0545e8"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.7.0/aliae-linux-amd64"
      sha256 "2cbf5089905583cf60a1d70632464783492650285d400819d390ab68fb9deae8"
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
