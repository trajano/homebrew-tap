class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.11.0"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.11.0/aliae-darwin-arm64"
      sha256 "0626e02d25249e90c7c33c33021647b1fb5fa3589ae08a2b0d3bb7b0a97d1d98"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.11.0/aliae-darwin-amd64"
      sha256 "ccd0808118bbc06d6f7f350f80c6732c791e4493a2ea1e22a42790ca5cdf22ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.11.0/aliae-linux-arm64"
      sha256 "7f49eecaff50ac645d9cafe0b9ce5fafad64fe20d4de94f53a6d02bf028de0af"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.11.0/aliae-linux-amd64"
      sha256 "7f5860c9af456e4484aec773c748a833862fcab8b98781e5ff03d7897372c4e0"
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
