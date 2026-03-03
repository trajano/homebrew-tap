class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.17.2"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.2/aliae-darwin-arm64"
      sha256 "0cf2c945b7f131ff5229d6c231edbf602d3268ebeb6dcab4318cddf259ae92b0"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.2/aliae-darwin-amd64"
      sha256 "bbf770f55f6858cdf47ef4e86d397b7dd348a4568df0d26ca55431b60b8eb46f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.2/aliae-linux-arm64"
      sha256 "3dd9c8f2a811a39a2a449f583e1e9b3a2d38e9d4982967cf8054defd221b7b66"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.2/aliae-linux-amd64"
      sha256 "166ca301ace36ca71831e8e6b016c098287cd0a885e637e4e700067c6085f864"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.17.2.tar.gz"
    sha256 "b8a2105173dbef09bcc5081e20196d5c924a446ae747ad7d8d071b006a196790"
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

    artifact = "aliae-#{arch}"
    if build.bottle? && File.exist?(artifact)
      bin.install artifact => "aliae"
    else
      source_root = buildpath
      unless (source_root/"src").directory?
        source_root = buildpath/"_source"
        resource("source").stage source_root
      end
      cd source_root/"src" do
        system Formula["go"].opt_bin/"go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
      end
    end
  end

  test do
    system "#{bin}/aliae", "--help"
  end
end
