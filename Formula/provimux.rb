class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.4-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.1/provimux_8.1.4-pmx.1_darwin_aarch64.tar.gz"
      sha256 "ee13b251ee315bbcdc7783209bcfd186c44c759da7472b5dc65bc6186028bd64"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.1/provimux_8.1.4-pmx.1_darwin_amd64.tar.gz"
      sha256 "1c1a7ad8ab5ccd0c8734db734115ea27ddaf12ab05004e184f1a2e7d25fceacb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.1/provimux_8.1.4-pmx.1_linux_aarch64.tar.gz"
      sha256 "05528354ccfa139ee13ff30c4de04bb72fb49c47f3d6ec041dddbefdadbce361"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.1/provimux_8.1.4-pmx.1_linux_amd64.tar.gz"
      sha256 "5b1eb4723bd495fb8db8df77270d2f1c08dbc14184e216ed8d3f6324e8741fd1"
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
