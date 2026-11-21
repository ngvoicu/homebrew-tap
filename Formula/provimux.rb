class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.0.79-pmx.3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.3/provimux_8.0.79-pmx.3_darwin_aarch64.tar.gz"
      sha256 "9ec8ddcae6e3cc26355ac414d077ce49efaa3e47c7e87e3427a9c1a3597940d7"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.3/provimux_8.0.79-pmx.3_darwin_amd64.tar.gz"
      sha256 "c2b6eb62fee078de8abff9b5399fab792b97faca95194db3bf7f9fd4d1103ff4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.3/provimux_8.0.79-pmx.3_linux_aarch64.tar.gz"
      sha256 "c05da25bb47295f7b3b542d2e6852da554c080703f1729e5f00ae6076cf8ba97"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.3/provimux_8.0.79-pmx.3_linux_amd64.tar.gz"
      sha256 "a76ec083ce9939c31fa44f59e66aef38a9e91be79481522feff9a2219e8531de"
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
