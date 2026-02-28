class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.16.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.0/aliae-darwin-arm64"
      sha256 "548356e0f99398a929af3708ab67749c02ff3d6cd71dac0d130dfa800076e0d1"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.0/aliae-darwin-amd64"
      sha256 "cef7b1fdde5366f891c5b16a200d51dfdb02f5261c569d5bfbca7c0e2170f770"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.0/aliae-linux-arm64"
      sha256 "5d8879fcefde05890a9064b0b48f409fb9032ed9f84c160b91fd68cc093b6e3d"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.0/aliae-linux-amd64"
      sha256 "7f2e728e89796e224fdbb00154d9091a59834547b193c00598d6fbdc43f647cd"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.16.0.tar.gz"
    sha256 "5c74f4378726693aeaed7f46b7803b97b26027dbb970d696bcbff3a4e4499d4a"
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
