---
title: 'OpenCode: Codex-First Provider Setup and Server Mode for Parallel Sessions'
description: 'My opencode configuration: the ChatGPT/Codex subscription as the primary provider, an automatic fallback plugin that replays failed requests against OpenRouter''s auto model, and opencode serve on Titan so remote sessions run tabbed and in parallel.'
pubDate: 'Oct 09 2026'
heroImage: '/project/opencode.svg'
tags: ['ai', 'home-lab', 'automation']
---

The [Atlas post](/blog/atlas/) covered the cluster. This post covers the tool that operates it: [opencode](https://opencode.ai), the terminal coding agent I run against every repo in the lab, Atlas included. Two parts of the setup do most of the work: the provider configuration, and server mode.

## Provider setup: Codex first, OpenRouter as the fallback

The primary provider is my ChatGPT/Codex subscription. opencode authenticates it through the "sign in with ChatGPT" OAuth flow (`opencode auth login`), and the default model in `~/.config/opencode/opencode.json` is:

```json
{ "model": "openai/gpt-6-luna" }
```

That model runs against the subscription's usage allowance rather than per-token API billing, which matters when agents run for hours. Until this morning the default was actually `openrouter/openrouter/auto`; the change is preserved in my config directory as `opencode.json.bak-codex-primary-20261009T092024`. OpenRouter moved from primary to safety net.

The safety net is the [opencode-runtime-fallback](https://www.npmjs.com/package/opencode-runtime-fallback) plugin — a community package by youngbinkim, MIT-licensed, not mine — wired in with one config line:

```json
{ "plugin": ["opencode-runtime-fallback"] }
```

Its behavior is configured in `~/.config/opencode/opencode-fallback.json`:

```json
{
  "enabled": true,
  "retry_on_errors": [429, 500, 502, 503, 504],
  "max_fallback_attempts": 10,
  "cooldown_seconds": 1800,
  "timeout_seconds": 30,
  "notify_on_fallback": true,
  "fallback_models": ["openrouter/openrouter/auto"]
}
```

`openrouter/auto` is OpenRouter's auto router: it selects a model per request instead of pinning one. When the subscription returns a 429 or a 5xx, the plugin:

1. Classifies the error from the status code and message patterns (rate limit, quota exceeded, overloaded, insufficient credits).
2. Aborts the in-flight request.
3. Replays the last user message against the fallback model, degrading the payload if necessary (all parts → text and image → text only).
4. Marks the failed model in cooldown; after 30 minutes it recovers to the primary automatically.
5. Posts a fallback notice in the session (`notify_on_fallback`).

The 30-second `timeout_seconds` also catches silent failures: a request that goes idle without producing a first token is treated as failed and retried on the fallback. The plugin carries fallback state into subagent sessions as well, so a delegated `task` call doesn't lose the fallback mid-flight.

I didn't rely on any of that until I saw it fire. Before switching the default, I ran opencode against a mock provider that returns 429 with a "Rate limit reached for gpt-6-luna" body. The plugin log shows the complete sequence: error detected → fallback planned (`rltest/test -> openrouter/openrouter/auto`) → in-flight request aborted → replay dispatched → `Fallback replay accepted by host` → state committed. A second case — a session that went idle without a first token — triggered the first-token timeout and stopped cleanly once no fallback models remained.

There is a third provider leg in the same config: `llama-swap` on `127.0.0.1:11434`, serving quantized Qwen models on Titan's RTX 3090 ([covered earlier](/blog/language-model-research/)). The fallback list holds one model today, but it is a list — local models can slot in as an additional tier.

## Server mode: sessions that live on the server

The second pillar is server mode. On Titan — the RTX 3090 workstation from the Atlas naming post — I run:

```bash
opencode serve --hostname 0.0.0.0 --port 4096
```

The server listens on all interfaces and is protected with HTTP basic auth via `OPENCODE_SERVER_USERNAME` and `OPENCODE_SERVER_PASSWORD`. It is reachable only over my Tailscale network, consistent with the lab's threat model: internal addresses are fine to operate, tailnet identities are not for publishing.

Any machine on the tailnet attaches to it:

```bash
opencode attach http://titan:4096   # MagicDNS name
```

The distinction that matters: with `opencode serve`, sessions live on the server, not in the terminal. A TUI is a view. Closing a tab, a laptop lid, or an SSH connection does not touch the session — the agent keeps working, and the next `attach` resumes where it left off.

## Tabbed parallel work

Server mode is the backend; the tab layer is two tools.

**aoe** ([Agent of Empires](https://github.com/agent-of-empires/agent-of-empires)) is a tmux-based session manager for AI coding agents. It tracks opencode and Claude Code sessions in tmux windows, exposes a `ps`-style dashboard, supports groups and git worktrees for parallel development, and has a `send` command for passing input to a running session. Each tab is one agent session in one repo.

**Ralph loops** are a while-loop harness around `opencode run`. Each cycle does exactly one bounded, independently verifiable item, commits it, and stops; the loop repeats until a definition-of-done file appears. Cycles run headless with a per-run `OPENCODE_CONFIG` that disables opencode's filesystem snapshots — a lesson learned after one session that touched `node_modules` wrote 28 MB snapshot events and grew the session database to 8.6 GB.

A representative evening, all against the same server: one session researching an Atlas network redesign and commenting on a GitHub issue; one opening a spec PR against `211lab/atlas`; a Ralph loop working through an implementation plan in another repo; and this post. Four workstreams, one machine, coordinated only by git.

## The Atlas connection

The reason this setup works against Atlas specifically is that the [atlas repo](https://github.com/211lab/atlas) ships opencode skills under `.opencode/skills/`: `atlas-deploy-app` onboards an application end to end (git remote, Gitea repo, CI secrets, Helm chart, Argo CD Application, release tag, deploy verification), and `atlas-cluster` covers live cluster recon and operations. The cluster documents itself to the agent, and the agent operates the cluster through the same GitOps doors a human would — no imperative side doors.

## Summary

- Primary provider: Codex subscription (`openai/gpt-6-luna`), authenticated via ChatGPT OAuth.
- Fallback: `opencode-runtime-fallback` plugin → `openrouter/auto`, with replay, cooldown, and automatic recovery to the primary.
- Server mode: `opencode serve` on Titan, basic auth, reachable over Tailscale, sessions persist server-side.
- Parallel work: aoe-managed tmux tabs plus headless Ralph cycles.
- Atlas integration: repo-shipped skills make the agent a competent cluster operator.

The subscription does the daily work, the fallback absorbs the rate limits, and the server keeps the sessions alive. The setup is unremarkable parts — config files, a plugin, a long-running process — but it is the difference between using an AI agent occasionally and operating a small fleet of them.
