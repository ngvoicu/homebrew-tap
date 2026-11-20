class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.0.79-pmx.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.2/provimux_8.0.79-pmx.2_darwin_aarch64.tar.gz"
      sha256 "58b95c296341b36b589633ed25c98b5f614499a9a6e0a8f3c5f36739f1bb56a4"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.2/provimux_8.0.79-pmx.2_darwin_amd64.tar.gz"
      sha256 "b065d9e956a04e0a3cc0e9e88b475ba60bb93456cde3576fa17b6e041a636145"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.2/provimux_8.0.79-pmx.2_linux_aarch64.tar.gz"
      sha256 "7c88b4f3ccd58dd25413cc602deb15256727d66018c384a6226fd73d9066fff9"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.2/provimux_8.0.79-pmx.2_linux_amd64.tar.gz"
      sha256 "0a02f276910d6e2db2524de247b5837f780baf0b3b938a4dd5c0726453ad96da"
    end
  end

  def install
    bin.install "provimux"
    pkgshare.install "config.example.yaml"
  end

  post_install_steps do
    unless_path_exists "provimux.conf", base: :etc do
      copy "config.example.yaml", "provimux.conf", source_base: :pkgshare, target_base: :etc
    end
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
