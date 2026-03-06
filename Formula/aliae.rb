class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.18.0"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.0/aliae-darwin-arm64"
      sha256 "10a134a0e0e4fe38d73fe766916f7095bedf8650d839d6ba72b02daec0131d96"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.0/aliae-darwin-amd64"
      sha256 "167c06f37976ac8bfe38d13eaf2c05b8c12365e6aaca9e66e8bd82c75f9f36df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.0/aliae-linux-arm64"
      sha256 "fdc8340e99334de083f856557e0e846e4c6dfe8fa3a2ec8e3c2ac94aa3e54093"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.0/aliae-linux-amd64"
      sha256 "9b0b7fbdaf759f9815015a74479f465639257d17667c17b655645d3cd5d58209"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.18.0.tar.gz"
    sha256 "2dd7506e96ef02725c9ee5750299f8bf9cf569dc8c546957943c39945f450827"
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
