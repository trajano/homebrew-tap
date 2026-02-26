class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  license "MIT"
  version "1.11.1"
  head "https://github.com/trajano/aliae.git", branch: "master"

  if ENV["HOMEBREW_BUILD_FROM_SOURCE"] == "1"
    url "https://github.com/trajano/aliae.git",
      tag: "v1.11.1",
      revision: "4423e40d08489af7cc35e73ce0df914fd074a6d4"
    depends_on "go" => :build
  else
    on_macos do
      if Hardware::CPU.arm?
        url "https://github.com/trajano/aliae/releases/download/v1.11.1/aliae-darwin-arm64"
        sha256 "6cc6c23b6a533e8abc31246777a9f2bf3f9ed5271545208d257bcb09fb86b785"
      else
        url "https://github.com/trajano/aliae/releases/download/v1.11.1/aliae-darwin-amd64"
        sha256 "76acf94559d81b005e02a1c78f7a8d677490eea5ea6535243213c01b801f1528"
      end
    end

    on_linux do
      if Hardware::CPU.arm?
        url "https://github.com/trajano/aliae/releases/download/v1.11.1/aliae-linux-arm64"
        sha256 "f76b973f802c1153159e4a23e7986028dfcb97b71a76eb6853b862d673a3dad5"
      else
        url "https://github.com/trajano/aliae/releases/download/v1.11.1/aliae-linux-amd64"
        sha256 "901304df72e7c4dc7d62c888c9f21369f1ab9e8c7a060a1bf5195659cefe1b03"
      end
    end
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
    build_from_source = ENV["HOMEBREW_BUILD_FROM_SOURCE"] == "1"

    artifact = "aliae-#{arch}"
    if !build_from_source && File.exist?(artifact)
      bin.install artifact => "aliae"
    else
      cd "src" do
        system Formula["go"].opt_bin/"go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
      end
    end
  end

  test do
    system "#{bin}/aliae", "--help"
  end
end
