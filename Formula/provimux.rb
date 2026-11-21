class Provimux < Formula
  desc "One local endpoint for your AI subscriptions and API keys, by providers.dev"
  homepage "https://github.com/ngvoicu/provimux"
  version "8.1.0-pmx.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-pmx\.\d+)$/i)
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.1/provimux_8.1.0-pmx.1_darwin_aarch64.tar.gz"
      sha256 "9de1d27732dbcb720daf49e41992828ccb5c963f54dff27e9ae847f4b28e9e07"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.1/provimux_8.1.0-pmx.1_darwin_amd64.tar.gz"
      sha256 "8f462c3cca4363a35733ff456f9173517998a07e8939d215e06c1c52388a85f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.1/provimux_8.1.0-pmx.1_linux_aarch64.tar.gz"
      sha256 "76d5a1c0686005d0de3fbb7cca0f1ae23b1fd0cf39976cde9df4964cf30ebfa2"
    end
    on_intel do
      url "https://github.com/ngvoicu/provimux/releases/download/v8.1.0-pmx.1/provimux_8.1.0-pmx.1_linux_amd64.tar.gz"
      sha256 "538fdaa80169829719fab3b069683e2892d6f8b791d04dfdbf9d45b2cec01bf8"
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
