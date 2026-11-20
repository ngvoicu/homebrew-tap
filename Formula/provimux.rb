class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.0.79-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.1/provimux_8.0.79-pmx.1_darwin_aarch64.tar.gz"
      sha256 "36ec504d3837d82b30743107a61fd8fd7082d8e2e49e04d05446f6e2fce6967f"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.1/provimux_8.0.79-pmx.1_darwin_amd64.tar.gz"
      sha256 "6cd313e3a2dea1386bacb5e1b1ea590b8744b293ea010cbe9ee70a1fdbcd335e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.1/provimux_8.0.79-pmx.1_linux_aarch64.tar.gz"
      sha256 "12494775ed013944405335585c8e99a84b2d75f6f8989fc98a18565b894598db"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.79-pmx.1/provimux_8.0.79-pmx.1_linux_amd64.tar.gz"
      sha256 "c147ab5bee50023841f086ad145b8448c8f4b2445ddd41137089d09977029c8d"
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
