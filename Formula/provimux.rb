class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.0.78-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.78-pmx.1/provimux_8.0.78-pmx.1_darwin_aarch64.tar.gz"
      sha256 "5254ea294b7942ce639039baf4393678daabe1d2fa8b4da4891c772140381aa5"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.78-pmx.1/provimux_8.0.78-pmx.1_darwin_amd64.tar.gz"
      sha256 "f28ad35a9aca521038f907b6d8dea12384b2fb4c561d65ae98d7f9f2bbf60c4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.78-pmx.1/provimux_8.0.78-pmx.1_linux_aarch64.tar.gz"
      sha256 "cb793d718eb5ccb761606f51e467bc00e19aa0c78c9c402f4f6dee13648ae08a"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.0.78-pmx.1/provimux_8.0.78-pmx.1_linux_amd64.tar.gz"
      sha256 "8dd6c25e6b4dbcb3f43c4fe3e46f6bf955a3dfdc4f2cd5058a35d74e5c1d64d2"
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
