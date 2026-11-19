class Provimux < Formula
  desc "Local endpoint for AI subscriptions and API keys, built on CLIProxyAPI"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.0.77-pmx.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.77-pmx.1/provimux_8.0.77-pmx.1_darwin_aarch64.tar.gz"
      sha256 "9fe84074ad4cb80390330d9fc39e386c8e7406cf5c3f50dab8e91dbcefb4b992"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.77-pmx.1/provimux_8.0.77-pmx.1_darwin_amd64.tar.gz"
      sha256 "13a6cc7b8d3d693fa4deaaa2935a67d050ca5c457bf5303dcf5e474aee0d49a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.77-pmx.1/provimux_8.0.77-pmx.1_linux_aarch64.tar.gz"
      sha256 "55d498052d248860560a831fa8d80aa03a9403f0b2f75ae9d6a17ece3cf21fb8"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.77-pmx.1/provimux_8.0.77-pmx.1_linux_amd64.tar.gz"
      sha256 "a38607cd0a0c09d6ce8adc0845f01a49168f6f039707b248b7fbe3b6caaba303"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  def install
    bin.install "provimux"
    pkgshare.install "config.example.yaml"
  end

  def post_install
    config = etc/"provimux.conf"
    cp pkgshare/"config.example.yaml", config unless config.exist?
  end

  def caveats
    <<~EOS
      Provimux reads #{etc}/provimux.conf, created from the example on first install.
      It uses the same config format and auth folder (~/.cli-proxy-api) as CLIProxyAPI.
      To reuse an existing Homebrew CLIProxyAPI setup:
        ln -sf #{etc}/cliproxyapi.conf #{etc}/provimux.conf
      Do not run it beside the cliproxyapi service on the same port:
        brew services stop cliproxyapi
    EOS
  end

  service do
    run [opt_bin/"provimux", "--config", etc/"provimux.conf"]
    keep_alive true
    log_path var/"log/provimux.log"
    error_log_path var/"log/provimux.log"
  end

  test do
    assert_match "Provimux Version:", shell_output("#{bin}/provimux --help 2>&1")
  end
end
