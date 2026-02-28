class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.15.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.15.0/aliae-darwin-arm64"
      sha256 "21dc865977741bed99ab727026d5e1d75544b9b2d5273b6f3e06836b585629c4"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.15.0/aliae-darwin-amd64"
      sha256 "b2a7dd335759e93a3d4e0216880dd3eb60f127a3a6d9cdd9eed85edc9854f9b3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.15.0/aliae-linux-arm64"
      sha256 "1865260d76a09e802bfe7c003743a9e10256b2cda0c2c7846dd0f1fc043de6c0"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.15.0/aliae-linux-amd64"
      sha256 "b63f71789705990ad5b5648963a4cb9f5ec5d6b6d60185ded135e0f251bfce40"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.15.0.tar.gz"
    sha256 "0909fef7ad68c9fecb1d2a51297813813230147b45e05edb24938732fe8620ea"
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
