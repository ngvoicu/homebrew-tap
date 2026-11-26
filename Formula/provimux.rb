class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.7-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.1/provimux_8.1.7-pmx.1_darwin_aarch64.tar.gz"
      sha256 "0518f08ea05ba29d3907ad9b978aa965fb9c62c94d4e6f1779d879067785f67d"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.1/provimux_8.1.7-pmx.1_darwin_amd64.tar.gz"
      sha256 "84af26ff2defb921034aebec5500d8e629c4fc8b3dc5d692df22de1905120a01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.1/provimux_8.1.7-pmx.1_linux_aarch64.tar.gz"
      sha256 "0ac55760e05dbdc09a5c00c0fd8418dd9b32ff9fb1a72173bc1df0628b59fe28"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.7-pmx.1/provimux_8.1.7-pmx.1_linux_amd64.tar.gz"
      sha256 "750c162b29072d5bc085404c9bb99f861a45c1f0973278478f754236098ffcad"
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
