class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.17.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.0/aliae-darwin-arm64"
      sha256 "e42759243c1ff0f7960e8fdce14055d2d032d032bea6d60d9ad981a2ce87c3c8"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.0/aliae-darwin-amd64"
      sha256 "1edf57f25c9e57cca6cef14c0df69861ae10db51b654f752b4083251a317a314"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.0/aliae-linux-arm64"
      sha256 "82e825d50b8c3fbc3a817fbe267e9591dcc54c4e7a3b89b7e47d5ca8d992b5f4"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.0/aliae-linux-amd64"
      sha256 "7680c84eac6d92bcde06a3aa8a9339f89418161d8312750002eddf76960ece26"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.17.0.tar.gz"
    sha256 "919200b025c42b4da675bf72eae29a34ecfbe6844281066767101da144804e9e"
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
