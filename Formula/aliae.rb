class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.17.1"
  head "https://github.com/trajano/aliae.git", branch: "master"
  depends_on "go" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.1/aliae-darwin-arm64"
      sha256 "96796d81887e207f37024cd510d1bda4c3d2c981ba8a4624a1948f48bcb76e0a"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.1/aliae-darwin-amd64"
      sha256 "1433dc8569e96d43e3267030a42e34620e2b1fa6126c85de1fe4f9b36de1201f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/trajano/aliae/releases/download/v1.17.1/aliae-linux-arm64"
      sha256 "dc7d6914d9ded944e04109a2114871398a8a9cd1dcb99bc4b1d754284f38d837"
    else
      url "https://github.com/trajano/aliae/releases/download/v1.17.1/aliae-linux-amd64"
      sha256 "49b50d4c4a3090dcbb68d704881619e073f0f5d4e910fabb4d303c9e86ae8b7c"
    end
  end

  resource "source" do
    url "https://github.com/trajano/aliae/archive/refs/tags/v1.17.1.tar.gz"
    sha256 "50fc8daed692604bb9e37cdef0502afa6f1e233b76698e360aa2e3d035813949"
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
