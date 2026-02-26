class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.13.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.13.0/aliae-darwin-arm64"
      sha256 "7d134c69b5586a041a108561aacbb17f20300351248d4bcbf2d4bac1a8515b59"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.13.0/aliae-darwin-amd64"
      sha256 "d6261d16d588415f0e0202b1f55451a947cb82042a3b0aa7a21d71804cb14013"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.13.0/aliae-linux-arm64"
      sha256 "ea3599920e229b48b09577906b4ddf87c611bca18c320d89988854de6424708a"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.13.0/aliae-linux-amd64"
      sha256 "30beb4f1594e412dc0c0dc8ec4fa881315e31fce480963d73955942ffc414537"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.13.0.tar.gz"
    sha256 "f6b97bb5ebb7340662bf2c4aad9b375502e93ef906376968c461de3198ceb5d7"
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
