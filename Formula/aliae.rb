class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.2.1"
  head "https://github.com/trajano/aliae.git", branch: "master"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.2.1/aliae-darwin-arm64"
      sha256 "7071159b57488d970776e5b79f339288c385e63e34f0c7fa76fdc77843a24778"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.2.1/aliae-darwin-amd64"
      sha256 "0f8d214c106ae744b8d9f77b69831209b31c596c5a75db093dd3f1ce8eaf0d8d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.2.1/aliae-linux-arm64"
      sha256 "f96d2d14c968ec0f8961269734f65c320f46458b8218ffdced33c9c67d14b971"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.2.1/aliae-linux-amd64"
      sha256 "4d839c2cd77fae90800ff5606ce8a5a25552071ac3d078a19022498f13fa2d00"
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
