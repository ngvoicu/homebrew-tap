class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.7-pmx.4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.4/provimux_8.1.7-pmx.4_darwin_aarch64.tar.gz"
      sha256 "9d1b8aeadbc8373fe8d5968efc650965f5d060f62d97fbaa73b11c67bdf11764"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.4/provimux_8.1.7-pmx.4_darwin_amd64.tar.gz"
      sha256 "86237087975272edc08177d643e90a3b110fc74c62659cce5d24788e549c89e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.4/provimux_8.1.7-pmx.4_linux_aarch64.tar.gz"
      sha256 "d54ee8bc8c694c983971f7c83b1a615ea8c2a9c507b48023a068498a4df0df42"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.4/provimux_8.1.7-pmx.4_linux_amd64.tar.gz"
      sha256 "c89df9a616952737a589b0310bd03e2ec61879286efa0ae62df030867e377062"
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
