class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.1-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.1/provimux_8.1.1-pmx.1_darwin_aarch64.tar.gz"
      sha256 "408e48ccbaea1a9453afcc614b72d9b5ab85faf9f2ae132089ca8d8fa7fce1ea"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.1/provimux_8.1.1-pmx.1_darwin_amd64.tar.gz"
      sha256 "525e0604a7bb76a5ebaa9e87ac98e7ee36bc3fa171fba28bbe15f67ef2fb3361"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.1/provimux_8.1.1-pmx.1_linux_aarch64.tar.gz"
      sha256 "312dfa66f4d556d49b4dd6ebca232907d76a471a04032eeef96b539ed651886b"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.1-pmx.1/provimux_8.1.1-pmx.1_linux_amd64.tar.gz"
      sha256 "bfe887640e23728edb9772dcecc62f5ee85c3f82b3421876fcc738895a14c8cf"
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
