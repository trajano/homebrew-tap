class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.18.1"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.1/aliae-darwin-arm64"
      sha256 "c6860b1fc167289048b43aac4bace20b3db23057b373a6a5b179d9a0f6ad6a3e"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.1/aliae-darwin-amd64"
      sha256 "788b96ff28e605f4b026b4e34df8be25c02962de4e766663ced2d2cd02a1b863"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.1/aliae-linux-arm64"
      sha256 "7006ab736ea33368e1cb73cbe5e3b04375554360ee964d4bcaa0d33df6ad6fae"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.1/aliae-linux-amd64"
      sha256 "b71372cbdd6468450961e2d07fc39e5f9f4667ca53a55be474a9a119ffa84c11"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.18.1.tar.gz"
    sha256 "619ce24345e58994a442a07ec023995429f5c60418d3362ae6b2f337ee5346f1"
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
