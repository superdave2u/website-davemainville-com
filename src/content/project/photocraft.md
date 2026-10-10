---
title: 'PhotoCraft'
description: 'A clean-room reimplementation of Adobe Photoshop in pure Rust — public specs instead of source code, Photoshop-authored PSDs as test oracles, 627/627 menu parity, and every feature drivable by agents. Web build deployed on my Atlas cluster.'
heroImage: '../../../public/project/photocraft.svg'
relatedPosts: ['photocraft']
---

**PhotoCraft** is an open-source, clean-room reimplementation of Adobe Photoshop, rebuilt in pure Rust — layers, masks, adjustment layers, type, vectors, brushes and real PSD files, with every feature drivable by agents.

**[Try the web build](https://photocraft.atlas.lan/)** — deployed on my [Atlas cluster](/blog/atlas/)

**[Source on GitHub](https://github.com/storytold/photocraft)**

## Highlights

- **Clean-room discipline:** Photoshop studied for behaviour and look only — implemented from public specs (Adobe PSD spec, ICC, ISO 32000 blend modes) and observation; no Adobe code, shaders, profiles or assets.
- **The original as oracle:** a corpus of real Photoshop-authored PSDs drives pixel-level render comparisons, so proprietary output becomes the test suite instead of the source.
- **Measured parity:** `cargo xtask parity` walks Photoshop's menu tree against the live command registry — currently 627 of 627 menu items live, with an honest roadmap admitting where behaviour still lags.
- **Rust only, never crash:** no JavaScript, no webview shell; `unsafe` forbidden except one isolated pen-tablet crate; no `unwrap`/`panic` in non-test code — a malformed file yields an error, never a lost document.
- **Agent-first architecture:** everything is a command (UI, CLI, control channel and MCP dispatch the same ids); JSON control protocol over loopback TCP with token auth; generated parity and performance scorecards.
- **Web build on the homelab:** the same Rust compiled to WASM (trunk + wasm-bindgen), served by nginx, deployed through the Atlas GitOps pipeline — Gitea CI builds, promotes the tag into git, and Argo CD syncs.
