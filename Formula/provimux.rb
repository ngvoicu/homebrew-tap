class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.4-pmx.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.2/provimux_8.1.4-pmx.2_darwin_aarch64.tar.gz"
      sha256 "d2f2fa54b5b233583b37f87794e113974fe1ab1c0c867938c1ee3d6cfa030c94"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.2/provimux_8.1.4-pmx.2_darwin_amd64.tar.gz"
      sha256 "287ba61e92ca23eb5cda00444566a3db4715b912d530e47ffcbf3fc796ad25c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.2/provimux_8.1.4-pmx.2_linux_aarch64.tar.gz"
      sha256 "1b2d0dea820a6cee9d0d1cc56df5b65fcba01f5394d0516f984b83aad2ad2eab"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.4-pmx.2/provimux_8.1.4-pmx.2_linux_amd64.tar.gz"
      sha256 "bcda71d4d6834d58cb11797dee8af1444ff1fd0e6b4c3ce17bc3395f02793115"
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
