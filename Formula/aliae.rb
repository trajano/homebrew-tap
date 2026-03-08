class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.18.3"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.3/aliae-darwin-arm64"
      sha256 "b24fa4f7e13c50259426b6ed1f8939387ffc0bb4279b687f663bcbe1bd17fb30"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.3/aliae-darwin-amd64"
      sha256 "3555262cbea27ea942239bf1c4eac4086a4b774e85a4a4a7f17907255abf7b3e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.18.3/aliae-linux-arm64"
      sha256 "47198e61b6e0ff974b939a8fc1fd34534df2faebe19795e44b2f23d99bebbc44"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.18.3/aliae-linux-amd64"
      sha256 "35d7e9c18e6bbe85e2882e79e3406c70f4051f8b2a687a2c0db2e7cf0734db6c"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.18.3.tar.gz"
    sha256 "e4a20ccd171e3914476778be238ceb7fde35a0cef7178783f9de9cca00467d21"
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
