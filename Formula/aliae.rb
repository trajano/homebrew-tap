class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "2.2.1"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v2.2.1/aliae-darwin-arm64"
      sha256 "806ef652186ee8ce6443543b423b9f8dd045fc367f1acb81f7e87c4e0ed13e95"
    else
      url "https://github.com/trajano/aliae/releases/download/v2.2.1/aliae-darwin-amd64"
      sha256 "e487fbe80c61843ace05003bfa1660d4b03f161627cd6bd52a81dcf531dc4dc4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v2.2.1/aliae-linux-arm64"
      sha256 "8dc743eb7d881cc71f98e717f9fe5a082e9a54f39d1682c006f3244d2e201fc8"
    else
      url "https://github.com/trajano/aliae/releases/download/v2.2.1/aliae-linux-amd64"
      sha256 "f3f0b6e430a799341150c04996ec9aad492a6cc566d2ce75f2159a4477c7ab43"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v2.2.1.tar.gz"
    sha256 "e3405d929f73479953659df2758eb59cbe970d1deb709943b392d3163741b854"
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
