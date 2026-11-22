class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.1-pmx.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.2/provimux_8.1.1-pmx.2_darwin_aarch64.tar.gz"
      sha256 "a55b1816e56fd789148591b09f728130c572001a1e7e9973a610b4dab87ae7e9"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.2/provimux_8.1.1-pmx.2_darwin_amd64.tar.gz"
      sha256 "1a5b7612eb7763388944ed888e210fadfa1015db11be74649bd3b3e0c4b7c640"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.2/provimux_8.1.1-pmx.2_linux_aarch64.tar.gz"
      sha256 "e908a7f8c5f897fdb1b50024dc7fe067e672d23bd749dd80206c8499d0a65a1a"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.2/provimux_8.1.1-pmx.2_linux_amd64.tar.gz"
      sha256 "5849755377750321bad52373367adc12cbd4734dc9abc8f2171fb7972af933b1"
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
