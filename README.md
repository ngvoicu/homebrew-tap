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

**One key for every AI account.**

A self-hosted AI gateway: one OpenAI-, Claude- and Gemini-compatible endpoint for your API keys and accounts, with the
prompt cache kept in use and the account behind every answer shown. This tap installs it with Homebrew.

**Provimux**, by [providers.dev](https://providers.dev), is a self-hosted AI gateway for you or your whole team. Your
subscriptions and API keys behind one endpoint, open to everyone you choose. Pools of models from every provider, with
the prompt cache kept in use. Run it on your own machine or on a server your team shares, give each person their own
client key, and point their tools at it. To keep the prompt cache in use, Provimux adds cache markers on OpenRouter,
keeps each conversation on one upstream, and forwards the longer cache lifetime on OpenAI API keys. It tells you which
accounts serve each model and which one answered, and its console shows why a route is paused. Provimux is an open-source (MIT) distribution of
[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) by router-for-me, tested against each CLIProxyAPI release.

**[Provimux](https://github.com/ngvoicu/provimux)** · the endpoint &nbsp;·&nbsp; **[provimux-ui](https://github.com/ngvoicu/provimux-ui)** · its
web console &nbsp;·&nbsp; **[providers.dev](https://providers.dev)**

Provimux adds built-in OpenRouter prompt caching, the longer prompt cache on OpenAI API keys, which account serves
each model and which one answered, and live model lists, among
[other features](https://github.com/ngvoicu/provimux/blob/main/.github/README.md#what-provimux-adds).

## Install

The formula installs the prebuilt release binary for macOS (Apple silicon, Intel) and Linux (arm64, x64).

```bash
brew install ngvoicu/tap/provimux
brew services start provimux
```

Then open the console, [provimux-ui](https://github.com/ngvoicu/provimux-ui), at
`http://127.0.0.1:8317/management.html` (on the same machine; from another machine, use the server's address).
Provimux downloads it by itself.

To serve a team from one server, with a client key per person, see
[For a team](https://github.com/ngvoicu/provimux/blob/main/.github/README.md#for-a-team) in Provimux's README.

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

## Support

Provimux is free and stays open source (MIT). For companies that run it, providers.dev offers support plans:
**Community** (free: GitHub issues and discussions, best effort) and **Team**, **Business** and **Priority** (paid),
listed with prices and terms at [providers.dev/support](https://providers.dev/support/). A paid plan buys a private
channel and a first reply within a stated number of business days: a reply, not a promised fix. Provimux has one
maintainer, and we say so: announced holidays pause the clock, there is no 24/7 and no uptime promise for a service
you host yourself, and the code stays MIT, so you can always fork it.

A GitHub **Sponsor** button for providers.dev's own GitHub Sponsors will come later.
