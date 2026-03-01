class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.16.1"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.1/aliae-darwin-arm64"
      sha256 "d76def9293d9d879565d9173314518981d7d9c019f3dabfc0147cf3fda85e094"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.1/aliae-darwin-amd64"
      sha256 "bd81f350428b589a62f23ac93a7004038f192766b524f10a370a27006f04d659"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.1/aliae-linux-arm64"
      sha256 "7e3e6a7bea70a2400252ad3b758b0e1ffb4ae622e59c1f2e5b293b9d4eb3f9d0"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.1/aliae-linux-amd64"
      sha256 "df0618900bff4ff949b4c23464a4d7b73d658b16f8867ef66bb456cdb600f43b"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.16.1.tar.gz"
    sha256 "dc98477c30b429278e31fc25049448904a62bfab4c95bd2ceb5aecc627a41f02"
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
