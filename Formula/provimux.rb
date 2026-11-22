class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.0-pmx.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.2/provimux_8.1.0-pmx.2_darwin_aarch64.tar.gz"
      sha256 "44192529752471efb77a386fd15a0edaa0477e525eb513d5ac4fc3d2d3915c2e"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.2/provimux_8.1.0-pmx.2_darwin_amd64.tar.gz"
      sha256 "0832c8a40fe26d666142e4876fa6df8f6536b502467188e8885ad2edfa579eb9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.2/provimux_8.1.0-pmx.2_linux_aarch64.tar.gz"
      sha256 "5a3cb45dfc8c9c1e92fc601d1ac0aae396f54d99554f18c9f4315faa8aae218b"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.2/provimux_8.1.0-pmx.2_linux_amd64.tar.gz"
      sha256 "ef260d0de9a99331250719b398caaa6c71ac54b32c51898f1533d3a256cf582e"
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
