class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/trajano/aliae/archive/v1.2.1.tar.gz"
  head "https://github.com/trajano/aliae.git", branch: "master"
  sha256 "c94f01fd18cebb4dcfcb928796c0a9021ac9084216093d4dd2137378b09ac6c8"
  license "MIT"
  version "1.2.1"

  depends_on "go" => :build

  def install
    Dir.chdir("src") do
      ENV["GOPROXY"] = ENV.key?("HOMEBREW_GOPROXY") ? ENV["HOMEBREW_GOPROXY"] : ""
      system "go", "build", "-o=aliae", "-ldflags=-s -w -X main.Version=#{version}"
      bin.install "aliae"
    end
  end

  test do
    system "#{bin}/aliae", "--help"
  end
end
