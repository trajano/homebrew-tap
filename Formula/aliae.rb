class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "2.2.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v2.2.0/aliae-darwin-arm64"
      sha256 "51200c60fbcca08502133d0d718f5ab543a7eab089ff20352709743e218d488c"
    else
      url "https://github.com/trajano/aliae/releases/download/v2.2.0/aliae-darwin-amd64"
      sha256 "d9bb3b52e90ea036cf5e30c2a00a8b6c22c120044bf20de9137a65ee45d12db8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v2.2.0/aliae-linux-arm64"
      sha256 "a4dce6e50f511e10ce0465afb68288e2f3b91317fbeb75c4f339571228d6ea48"
    else
      url "https://github.com/trajano/aliae/releases/download/v2.2.0/aliae-linux-amd64"
      sha256 "6097f8b6b779e66705d84b4cd780853b424939d3fe4f3cde9aa09ee9ff9ebce1"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "b02d6b27dfbb391b333a983f3245253bcbfd5231cb49e5f21e2446d84014fc65"
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
