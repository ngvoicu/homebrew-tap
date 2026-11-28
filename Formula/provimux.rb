class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.8-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.8-pmx.1/provimux_8.1.8-pmx.1_darwin_aarch64.tar.gz"
      sha256 "4bd7c3b55822e03b4afe907d911e7d7491f233a3c07905a394405d2dc5f708d7"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.8-pmx.1/provimux_8.1.8-pmx.1_darwin_amd64.tar.gz"
      sha256 "c1907e5436ae183be29713f0eab5085484786cc4bc0e487f63fb60f0a5be111c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.8-pmx.1/provimux_8.1.8-pmx.1_linux_aarch64.tar.gz"
      sha256 "64883296dea110505d15670e5b223d45e2cd5fdeacc35cf383a1d46dcffd3f52"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.8-pmx.1/provimux_8.1.8-pmx.1_linux_amd64.tar.gz"
      sha256 "3c44b1e27ade29e69165627708595346440cf2a3883de56dacf5866a19295179"
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
      Config: #{etc}/provimux.conf (created from the example on first install).
      Docs: https://provimux.providers.dev
    EOS
  end

  service do
    run [opt_bin/"provimux", "--config", etc/"provimux.conf"]
    keep_alive true
    # On a stop or restart Provimux waits for the answers in flight (server.restart-drain-seconds,
    # 25 seconds by default, 30 at most: the gateway gives its whole stop 30 seconds); launchd and
    # systemd kill it only after 40. stop_timeout exists from Homebrew 6.0.13; an older Homebrew skips it.
    stop_timeout 40 if respond_to?(:stop_timeout)
    log_path var/"log/provimux.log"
    error_log_path var/"log/provimux.log"
  end

  test do
    assert_match "Provimux Version:", shell_output("#{bin}/provimux --help 2>&1")
  end
end
