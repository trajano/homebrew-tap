class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.18.4"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.4/aliae-darwin-arm64"
      sha256 "ca357e33bbfc6105ef2823c7d1447500b2f157821136a3dee1577f1a32e89f0c"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.4/aliae-darwin-amd64"
      sha256 "787684268ffca3ecc6a02b0ae3c73a85afec5c49c99765507ca61daf882b0fbf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.4/aliae-linux-arm64"
      sha256 "98ecf08aa35e2d049fc175f6cee935fce2e56eb48915b24264b93a6c55e15be0"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.4/aliae-linux-amd64"
      sha256 "019a40071ab4637a0f8f01343f3aa60b5eaa97dc96c6410d390ff7d029c4494b"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.18.4.tar.gz"
    sha256 "7f26c2d957e52ba4aad80e213f42a26a152e3402649578c2a389a9cd3c5c65ef"
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
