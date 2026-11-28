class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.7-pmx.5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.5/provimux_8.1.7-pmx.5_darwin_aarch64.tar.gz"
      sha256 "03bcc51ed8b3a9a540f5d769b4e60b4f11bd2a0ca9b418dec50371aea8ac95d5"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.5/provimux_8.1.7-pmx.5_darwin_amd64.tar.gz"
      sha256 "a2173831de6eed2895bae5cf18f5e268d9b66830cd9fbb70bd794a2ade1c0299"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.5/provimux_8.1.7-pmx.5_linux_aarch64.tar.gz"
      sha256 "1efeb75d7f62cbc1fa2389e523ea821a72a13167c5d303218ca3ef22626e53c0"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.5/provimux_8.1.7-pmx.5_linux_amd64.tar.gz"
      sha256 "b169a24483baa7800bdab559c465c8824b043905a59b1bfc8e1893adeb36acc6"
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
