class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.14.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.14.0/aliae-darwin-arm64"
      sha256 "532467b70965ea26052b15fa2462a4d2b86199566c4a0de13b129dc3ad900994"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.14.0/aliae-darwin-amd64"
      sha256 "f8e9dfc4e80ecc179c5acf03cfcdd1872cc7bfa1897af51a164f34d35f4aa7b8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.14.0/aliae-linux-arm64"
      sha256 "4536799792bf0c27132fa7b303932ed494ab88d85f1e36e1e7fae3ce4a858cd1"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.14.0/aliae-linux-amd64"
      sha256 "c4de50c1192575f14ee9e2af77dbbbc31cc23764cc7446805b3175c577d3aead"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.14.0.tar.gz"
    sha256 "320988c89504fcdf191e98bfb20ad48958bb38a0a3b730da837bd1836837d267"
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
