class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.16.2"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.2/aliae-darwin-arm64"
      sha256 "63e106e07b547ad71befcc1c040c25fe9a17a4f29b81ef25c3123eba8b068f53"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.2/aliae-darwin-amd64"
      sha256 "a07c5f7be0e985196ad83ffd8db77f7fa7d2ebde61b27614d14bcbaa9fa61c25"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.16.2/aliae-linux-arm64"
      sha256 "9ecf756aed9e42ab6e2d0839a26e588eedeb0a283655b72c1f094b5fbbfebf72"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.16.2/aliae-linux-amd64"
      sha256 "6633584acbc43293d5243776a2f92e6fc91105e6ec2c18a45832a8151f710bb8"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.16.2.tar.gz"
    sha256 "ff36f261b8b4fc7f36bba2fc017b10062ecb1f4e70267a3a65af448c9d53d9d4"
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
