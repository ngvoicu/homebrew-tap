class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.2-pmx.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.2/provimux_8.1.2-pmx.2_darwin_aarch64.tar.gz"
      sha256 "070c1103c4fd027dafa0582aa97178096c2473b09c33f3818f791c39b98dfa78"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.2/provimux_8.1.2-pmx.2_darwin_amd64.tar.gz"
      sha256 "6cd3c122dd2dec76a51efd506fa52d00be208793ac8c5a36803565dc6b48401d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.2/provimux_8.1.2-pmx.2_linux_aarch64.tar.gz"
      sha256 "594f70f0f8b8a658ffa5ce1d840da5af534f085ae3742c96a10f83faba61c705"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.2/provimux_8.1.2-pmx.2_linux_amd64.tar.gz"
      sha256 "7b7b7bebaf179733ab7035c87fce631a3b021205aa41bd8ea195eb7b2b7a6dcd"
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
