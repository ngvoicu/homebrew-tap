class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.7-pmx.3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.3/provimux_8.1.7-pmx.3_darwin_aarch64.tar.gz"
      sha256 "68c678c296c98ba616fb84d4cce42d5a34793974eb01cd6b869281508a67fcb1"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.3/provimux_8.1.7-pmx.3_darwin_amd64.tar.gz"
      sha256 "0597b8b33f2849fc3e2c1ae279060d83cb573a29b0620a8486f199af5c21ea69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.3/provimux_8.1.7-pmx.3_linux_aarch64.tar.gz"
      sha256 "e6ec7b618dc14e845852a4cab5532094ab3eeea10fcd5fe8711ef06dbba727c5"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.3/provimux_8.1.7-pmx.3_linux_amd64.tar.gz"
      sha256 "c4a2cd1ee314a616e6a48663b9f039457dbcaaae162fd52c00b05cd141b4784e"
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
