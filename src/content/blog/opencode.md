---
title: 'A Journal of OpenCode Discovery: Fallback Nets, a Server That Stays Up, and Too Many Tabs'
description: 'My tinkerer''s log from the last few weeks of exploring opencode: making my ChatGPT/Codex subscription the primary provider, testing an OpenRouter fallback plugin against a fake 429 server, and falling for server mode — sessions that live on Titan and follow me around the tailnet, tabbed for parallel work.'
pubDate: 'Oct 09 2026'
heroImage: '/project/opencode.svg'
tags: ['ai', 'home-lab', 'automation']
---

The [Atlas post](/blog/atlas/) was about the machine. This entry is bench notes: the last few weeks of poking at [opencode](https://opencode.ai), the terminal coding agent I use at that bench, and the two discoveries that turned it from "a tool I use" into "a setup I'm proud of." Nothing here was planned end to end. It all came from noticing something annoying, or something delightful, and following it.

## How it started: an agent that stops mid-thought

I run agents for hours at a stretch — against my repos, against the cluster, against this blog. And every so often the subscription would hit its rate limit mid-task. The agent would just stop. Not fail interestingly. Stop. I'd wait, retry, lose my place.

At some point I went looking for whether opencode had an answer, and found the [opencode-runtime-fallback](https://www.npmjs.com/package/opencode-runtime-fallback) plugin — a community package by youngbinkim, MIT-licensed, not mine. The idea is simple: when the primary provider errors, replay the request against a backup model. I installed it, pointed it at `openrouter/openrouter/auto` — OpenRouter's auto router, which picks a model per request — and forgot about it for a while.

## The experiment: a fake server that only says 429

Here's the thing about me and infrastructure: I don't trust it until I've watched it fail on purpose. So one morning this week I stood up a mock provider — a tiny local server that does exactly one thing: return 429 with a "Rate limit reached for gpt-6-luna" body. I pointed opencode at it and typed a prompt.

The plugin's log file is chatty, and reading it felt like watching a little Rube Goldberg machine do its job:

```
Provider retry detected ... "Rate limit reached for gpt-6-luna"
Planned fallback for session ...: rltest/test -> openrouter/openrouter/auto
Aborted in-flight session request (pre-fallback.session.status)
Prepared replay payload ... "replaySource":"last-user"
Fallback replay accepted by host (session.status)
Committed fallback state after successful dispatch
```

That's the whole dance: classify the error, abort the in-flight request, take my last message and send it to the fallback model, commit the switch. If the fallback also fails, the failed model goes into cooldown and the plugin tries the next one — up to ten attempts. And my favorite detail: after the cooldown expires (I set it to 30 minutes), it quietly recovers back to the primary. The safety net lowers itself.

A second test case taught me something I hadn't thought about: a request that doesn't error but also never produces a first token. The plugin watches for that too — a 30-second first-token timeout treats silence as failure and retries. Silent failures are the ones that would have eaten an evening.

What I ended up with in `~/.config/opencode/opencode-fallback.json`:

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

## The flip: this morning's config change

Until this week, `openrouter/auto` was actually my *default* model. This morning I flipped it: the Codex subscription is now the daily driver — `openai/gpt-6-luna`, authenticated through the "sign in with ChatGPT" OAuth flow — and OpenRouter got demoted to the safety net. My config directory keeps a diary of these changes; the backup file is literally named `opencode.json.bak-codex-primary-20261009T092024`.

The economics finally make sense to me: the subscription's usage allowance carries the daily work, and the fallback only spends OpenRouter credit when the subscription says "not right now." There's a third leg in the same config — `llama-swap` on `127.0.0.1:11434`, serving quantized Qwen models on Titan's RTX 3090 from my [local-model experiments](/blog/language-model-research/) — and since the fallback list is just a list, a local model can slot in as another tier someday. I haven't yet. It's nice knowing I can.

## The server that stays up

The second discovery was less about models and more about where sessions *live*.

I'd been running opencode in whatever terminal was in front of me, and every session died with its terminal. Close the laptop, lose the thread. Then I found server mode:

```bash
opencode serve --hostname 0.0.0.0 --port 4096
```

It's been running on Titan — the RTX 3090 workstation from the Atlas naming post — since October 8th. It listens on all interfaces, guarded by HTTP basic auth (`OPENCODE_SERVER_USERNAME` / `OPENCODE_SERVER_PASSWORD`), and it's reachable only over my Tailscale network. Same threat model as the rest of the lab: internal addresses are fine to operate, tailnet identities are not for publishing.

From any machine on the tailnet:

```bash
opencode attach http://titan:4096   # MagicDNS name
```

The realization that rearranged my habits: **the session lives on the server; the terminal is just a view.** Right now, as I write this, there are seven live connections to that server from another machine in my tailnet. Close the tab, shut the laptop, walk away — the agent keeps working, and the next `attach` picks up exactly where it left off. I keep thinking of it like the cluster itself: the state is in the machine, not in my hands.

## Too many tabs (in a good way)

Server mode is the backend. The tab layer turned out to be two tools I've grown attached to.

The first is [aoe](https://github.com/agent-of-empires/agent-of-empires) — "Agent of Empires," a tmux-based session manager for AI coding agents. It keeps track of opencode and Claude Code sessions in tmux windows, shows a `ps`-style dashboard of what's running, supports git worktrees for parallel development, and has a `send` command for slipping input into a running session. One tab, one agent, one repo. It's the hobby-shop pegboard for all of this.

The second is my Ralph loop — a dumb `while` loop around `opencode run`. Each cycle does exactly one bounded, independently verifiable item, commits it, and stops; the loop repeats until a definition-of-done file appears. No cleverness in the loop, which is the point. The one scar worth mentioning: opencode records filesystem snapshots, and one session that wandered into `node_modules` wrote 28 MB snapshot events until the session database hit 8.6 GB. Now every harness run disables snapshots with a per-run `OPENCODE_CONFIG`, and I prune old sessions the way I prune old branches.

A representative evening, all against that one server: one session researching an Atlas network redesign and commenting on a GitHub issue; one opening a spec PR against `211lab/atlas`; a Ralph loop chewing through an implementation plan in another repo; and this post. Four workstreams, one machine, coordinated only by git. That's the hobby paying rent.

## What the cluster has to do with it

The reason all of this works against Atlas specifically is that the [atlas repo](https://github.com/211lab/atlas) ships opencode skills under `.opencode/skills/`: `atlas-deploy-app` onboards an application end to end — git remote, Gitea repo, CI secrets, Helm chart, Argo CD Application, release tag, deploy verification — and `atlas-cluster` covers live cluster recon and operations. I wrote those skills the way I write runbooks, and it turns out runbooks work just as well for agents. The cluster documents itself to the agent, and the agent operates it through the same GitOps doors I would — no imperative side doors, no "let me just kubectl apply this once."

## Where this leaves me

The subscription does the daily work. The fallback absorbs the rate limits and recovers on its own. The server keeps the sessions alive whether I'm watching or not. The tabs keep the parallel work honest. None of the parts are exotic — a config file, a plugin, a long-running process, a dumb loop — but stacked together they changed how much I get to build in an evening.

That's the notebook entry. The server's still up, the fallback log is still chattering, and there are four tabs open. Some experiments you conclude; this one I just keep living in.
