<h1>
  <a href="https://providers.dev"><picture>
    <source media="(prefers-color-scheme: dark)" srcset="media/lockup-dark.svg">
    <img alt="Provimux by providers.dev" src="media/lockup-light.svg" width="224" height="56">
  </picture></a>
</h1>

<p>
  <a href="https://github.com/ngvoicu/homebrew-tap/blob/main/Formula/provimux.rb"><img alt="Formula: provimux" src="https://img.shields.io/badge/formula-provimux-4338ca"></a>
  <a href="https://github.com/ngvoicu/provimux/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/ngvoicu/provimux?label=release&amp;color=4338ca"></a>
  <a href="https://github.com/ngvoicu/provimux/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/github/license/ngvoicu/provimux?color=4338ca"></a>
</p>

**Provimux**, by [providers.dev](https://providers.dev), is one local endpoint for your AI subscriptions and API keys.
Sign in with your Claude and Codex subscriptions (subscription login, `oauth`), add your API keys (API key, `apikey`)
and an OpenRouter key, and point your tools at `http://127.0.0.1:8317`. It is a drop-in distribution of
[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) by router-for-me: everything CLIProxyAPI does, plus the
features below, with its web console, [provimux-ui](https://github.com/ngvoicu/provimux-ui).

**[Provimux](https://github.com/ngvoicu/provimux)** · the endpoint &nbsp;·&nbsp; **[provimux-ui](https://github.com/ngvoicu/provimux-ui)** · its
web console &nbsp;·&nbsp; **[providers.dev](https://providers.dev)**

Provimux adds per-model account visibility, live model lists and built-in OpenRouter support, among
[other features](https://github.com/ngvoicu/provimux#what-provimux-adds).

## Install

The formula installs the prebuilt release binary for macOS (Apple silicon, Intel) and Linux (arm64, x64).

```bash
brew install ngvoicu/tap/provimux
brew services start provimux
```

Then open the console, [provimux-ui](https://github.com/ngvoicu/provimux-ui), at
`http://127.0.0.1:8317/management.html`. Provimux downloads it by itself.

The config is `$(brew --prefix)/etc/provimux.conf`, created from `config.example.yaml` on first install and never
overwritten. Provimux uses the same config format and auth folder (`~/.cli-proxy-api`) as CLIProxyAPI. To reuse an
existing Homebrew CLIProxyAPI setup, stop that service and point Provimux at its config:

```bash
brew services stop cliproxyapi
ln -sf "$(brew --prefix)/etc/cliproxyapi.conf" "$(brew --prefix)/etc/provimux.conf"
brew services start provimux
```

Provimux releases follow CLIProxyAPI automatically; see
[Versions and releases](https://github.com/ngvoicu/provimux/blob/main/.github/README.md#versions-and-releases).
