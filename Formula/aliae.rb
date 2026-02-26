class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.12.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.12.0/aliae-darwin-arm64"
      sha256 "bfaf3407631b19514c36338ce1e912d6a0b7e371c1d0ccbdca77e551d0a71533"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.12.0/aliae-darwin-amd64"
      sha256 "9d8cd06be04ca081425e332fa87197e0d079fd4eec4fc170ac72e27b98e1be1b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.12.0/aliae-linux-arm64"
      sha256 "45ac352903c7790c04cf8555fca2b36daf77f63d0ff174fd3b502b5a337ce3cd"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.12.0/aliae-linux-amd64"
      sha256 "922367ffdeccf0feb37d12277157b2b0f571502739333c2782a0fe8fb66734b6"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.12.0.tar.gz"
    sha256 "d786fd2d6beda28f0cb2e7cc877319d68df55acc898e122d17754a822679583d"
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
