class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.18.2"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.2/aliae-darwin-arm64"
      sha256 "26f3435daff629c749b6fe0aada60286cefb12d1c0a1e170a7b0accc6be1bf1d"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.2/aliae-darwin-amd64"
      sha256 "940b07af2a2a8f71aaaa4a3c121fbd8df6f11c6192cb14d17e6698fc393fe2b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.2/aliae-linux-arm64"
      sha256 "9e479814fcef36a52861083ba2d019133b359cddd10baa5066a1b909025ad91b"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.2/aliae-linux-amd64"
      sha256 "2235beebe27995408161983a90fffe8996ea9600b12d9cb0e23851a2ea93e454"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.18.2.tar.gz"
    sha256 "407740c5a996aced8cc604daf061acf36d42dd4df90d8f71b8f3b73247ce246a"
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
