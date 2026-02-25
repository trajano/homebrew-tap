class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.8.1"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.1/aliae-darwin-arm64"
      sha256 "0ec92cdfd8783abc8a76990c35322586043b95abb7528d96b31c4220398b2857"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.1/aliae-darwin-amd64"
      sha256 "2a1dd0f440dafd17a6aa35cb4aefbd09833cd7253812eb1d9dd4b312eef6728d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.8.1/aliae-linux-arm64"
      sha256 "c60c512bb53f8838513f11b67eee9fafecd576e1387deeaf57ad6d803e6232b5"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.8.1/aliae-linux-amd64"
      sha256 "96fb52b363f96054a812693f8fe87a031055265f7c3196e8ac41b2c4c71ed377"
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
