class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.3-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.3-pmx.1/provimux_8.1.3-pmx.1_darwin_aarch64.tar.gz"
      sha256 "599169b9a0ca42770204f67984081fc6a32afc0720f5e991e16f0a0cbdd4c696"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.3-pmx.1/provimux_8.1.3-pmx.1_darwin_amd64.tar.gz"
      sha256 "3d477056f144335f57fbe77f1fc8746b7a3210a6361b2e2837f22f8a28f29a62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.3-pmx.1/provimux_8.1.3-pmx.1_linux_aarch64.tar.gz"
      sha256 "9518c4bc4e4c04d4be3adf29c0f2a2420d12bb7fd03daeeef19396b9eb4d9055"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.3-pmx.1/provimux_8.1.3-pmx.1_linux_amd64.tar.gz"
      sha256 "07bc79c5fc451df52cd388f2436fa91ffe54eaad222992d242ed223c48e420fd"
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
