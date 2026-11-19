# ngvoicu/homebrew-tap

Homebrew formulae by [ngvoicu](https://github.com/ngvoicu).

## Provimux

[Provimux](https://github.com/ngvoicu/provimux) is one local endpoint for your AI subscriptions and API keys, a
distribution of [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI). The formula installs the prebuilt release
binary for macOS (Apple silicon, Intel) and Linux (arm64, x64).

```bash
brew install ngvoicu/tap/provimux
brew services start provimux
```

The config is `$(brew --prefix)/etc/provimux.conf`, created from `config.example.yaml` on first install and never
overwritten. Provimux uses the same config format and auth folder (`~/.cli-proxy-api`) as CLIProxyAPI. To reuse an
existing Homebrew CLIProxyAPI setup, stop that service and point Provimux at its config:

```bash
brew services stop cliproxyapi
ln -sf "$(brew --prefix)/etc/cliproxyapi.conf" "$(brew --prefix)/etc/provimux.conf"
brew services start provimux
```

The formula is updated by Provimux's release workflow on each release.
