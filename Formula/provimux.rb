class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.2-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.1/provimux_8.1.2-pmx.1_darwin_aarch64.tar.gz"
      sha256 "fabaf4b149c20b9c9038293d4936cd92b76ece9de9acdece0151223b707e911c"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.1/provimux_8.1.2-pmx.1_darwin_amd64.tar.gz"
      sha256 "a39a82e45893301b36450406d71817b62196f9dde1c7096b43827bfbe0de9183"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.1/provimux_8.1.2-pmx.1_linux_aarch64.tar.gz"
      sha256 "97532ab8a060da508f030c4ec5ab91584dfeafafe4aeb5f7b5b1665f5403013b"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.2-pmx.1/provimux_8.1.2-pmx.1_linux_amd64.tar.gz"
      sha256 "20a7c337ffd809ef999ab8dba0d823bb42b43cb69f94a4a281b1f95fec3022a9"
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
