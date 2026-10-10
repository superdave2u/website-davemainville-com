---
title: 'The Clean Room: How Photoshop Became PhotoCraft'
description: 'A clean-room reimplementation of Photoshop in pure Rust — public specs instead of source code, Photoshop-authored PSDs as test oracles, 627/627 menu parity, and an architecture written for agents. I deployed its web build to my cluster this week, and it is a masterclass in what AI engineering actually means.'
pubDate: 'Oct 10 2026'
heroImage: '/project/photocraft.svg'
tags: ['home-lab', 'automation', 'side-projects']
---

In 1982, Compaq's engineers faced a problem that had nothing to do with
engineering: they wanted to build an IBM PC that could run the same software,
and the only thing standing between them and a lawsuit was discipline. So they
built a wall. One team read IBM's BIOS and wrote down what it *did* — every
interrupt, every quirk — in dry technical prose. A second team, sworn to have
never seen the original, implemented the machine from those papers alone. What
crossed the wall was never code. It was description. The clone shipped, the
lawyers stood down, and the industry learned a trick it still uses: you can
own behavior by writing it down honestly.

I thought about that room a lot this week, because I deployed
[PhotoCraft](https://github.com/storytold/photocraft) — an open-source,
clean-room reimplementation of Adobe Photoshop, rebuilt in pure Rust — onto my
[homelab cluster](/blog/atlas/), and getting to know the project was like
watching the 1982 discipline get a four-decade upgrade.

## What you may copy

Behavior, not code. PhotoCraft states its version of the rule in one paragraph
of its contributor guide:

> We studied Photoshop and other proprietary editors for *behaviour and look
> only*. Never copy their code, shaders, profiles or assets. Implement from
> public specs (Adobe PSD spec, ICC, ISO 32000 blend modes, papers) and
> observation.

That is the whole contract, and it is more permissive than people assume.
Adobe *publishes* the PSD specification, so the file format is fair game:
read the spec, write a parser, no decompiler required. The ICC consortium
publishes color management. ISO 32000 defines the blend modes. Observation
fills the gaps the specs don't cover — what exactly happens when you drag a
layer onto a mask, how the histogram reacts, where the marching ants march.
The look is studied the way a portrait artist studies a face: by looking,
never by tracing.

## The original becomes the oracle

Here is the part that turns the clean room from a legal trick into an
engineering method. You may not read the original's code, but you may read its
*output*.

PhotoCraft keeps a corpus of real Photoshop-authored PSD files and treats them
as test oracles: open each one, render it, compare. If PhotoCraft's compositor
disagrees with Photoshop's rendering of Photoshop's own document, that is a
failing test with a pixel-level diff attached. The proprietary software is
never the source. It becomes the test suite.

That inversion is the quiet heart of this story: the clean room stops being a
wall that keeps engineers away from the original and becomes a funnel that
pulls the original's behavior into the open, one oracle at a time.

## 627 of 627

Parity is measured, not asserted. A generator (`cargo xtask parity`) walks
Photoshop's menu tree against the live command registry and publishes the
score. The current report reads: **627 of 627 menu items live — 100%** — File
51 of 51, Layer 161 of 161, Filter 75 of 75. And the roadmap is more honest
than the number suggests: a menu item can exist and still behave worse than
the original, and the docs say so plainly. The target is not "an editor like
Photoshop." It is 1:1 parity — same menus, same shortcuts, same behavior, same
file fidelity — in pure Rust, with `unsafe` forbidden across the workspace
except one isolated pen-tablet crate, and a "never crash" rule that outranks
feature work: no `unwrap()`, no `panic!`, no unbounded recursion on
input-derived numbers. A malformed file must produce an error you can act on,
never a crash that eats your document.

## Written for a crew of agents

Now the part that makes this story belong on this blog.

The repository's front door is not a README for humans. It is `AGENTS.md` — a
guide *for AI agents and contributors* — and it declares the goal in one
line: every feature must be drivable by agents. The architecture makes that
more than a slogan:

- **Everything is a command.** Each user-visible action is a registered
  command with an id, a menu path and a shortcut. The UI, the CLI, the control
  channel and the MCP server all dispatch the same command ids. There is no
  private path into the app.
- **The app is drivable.** The desktop build speaks JSON over a loopback TCP
  control channel with token authentication — agents open documents, run
  commands, and screenshot the running app to check their own work.
- **The truth is generated.** Parity reports and performance scorecards come
  out of tooling against the live registry, not hand-written optimism.

This is what AI engineering actually is, when it is done seriously. Not
prompting harder — building the seams that make machine work *verifiable*:
command registries instead of screen scraping, oracles instead of vibes,
generated scorecards instead of demos. The agents are not a gimmick bolted
onto the project. They are the intended workforce, and the codebase is their
factory floor.

## Shipping day

The last mile happened here, this week.

PhotoCraft's web build is the same Rust compiled to WebAssembly and served by
nginx — no JavaScript framework, no webview shell. I put it on [my
cluster](/blog/atlas/) through the GitOps pipeline: the repo landed in my
self-hosted Gitea forge, CI built the image and pushed it to the private
registry, CI then promoted the release tag back into the platform repo (that
commit *is* the deployment signal), and Argo CD synced the Helm chart into the
cluster. An agent did the whole path — wrote the workflow, authored the chart,
sealed the registry pull secret, tagged `v0.6.1` — and when the pod sat stuck
in `ImagePullBackOff`, it traced the failure to a drifted `/etc/hosts` line on
one control-plane node, fixed the node, and got its 200 OK from
**[photocraft.atlas.lan](https://photocraft.atlas.lan/)**.

A clean-room reimplementation of Photoshop, delivered end to end by exactly
the kind of crew it was written for.

## What it taught me

Clean rooms used to be about lawyers: keep the code out, keep the lawsuit out.
They still are — but the discipline has grown teeth. A clean room is only as
strong as the specification at its center, and specifications precise enough
for lawyers turn out to be precise enough for machines. Photoshop became
PhotoCraft the way the BIOS became Compaq: someone wrote down what it does,
not what it is.

The difference is who reads the spec next.
