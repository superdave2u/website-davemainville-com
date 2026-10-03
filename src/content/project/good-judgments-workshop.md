---
title: 'Good Judgments Workshop'
description: 'A self-contained Reveal.js workshop authored by an LLM — slides as code instead of PowerPoint or Keynote: vendored, diffable, deep-linkable, and deployed to GitHub Pages.'
heroImage: '../../../public/project/good-judgments-workshop.svg'
relatedPosts: ['good-judgments-workshop']
---

**Good Judgments Workshop** is a 45-minute facilitated session I hosted for my team on not letting the LLMs do the deciding — and an experiment in building the presentation itself with an LLM on Reveal.js instead of traditional tools like PowerPoint or Keynote.

**[Open the workshop deck](https://superdave2u.github.io/good-judgments-workshop/)** · **[Source on GitHub](https://github.com/superdave2u/good-judgments-workshop)**

## Highlights

- **Slides as code:** text-first semantic sections — diffable in PRs, versioned by git, deep-linkable per slide via hash routing, deployable as a website.
- **LLM-authored deck:** the source article, audience, and arc went in; 18 structured slides, consistent visual system, and per-slide speaker notes with facilitation timings came out.
- **Self-contained Reveal.js 6:** the distribution is vendored into the repo — no Node build, no CDN; `python -m http.server 8000` is the entire install.
- **Custom presenter tooling:** speaker-notes panel toggled with `N`, `aria-live` slide status, fixed 1440×810 design surface that scales to any screen.
- **The content:** a five-step judgment loop (Frame → Compare → Prove → Constrain → Own) and a six-question review checklist — Problem, Boundary, Evidence, Smallest move, Signals, Recovery.
- **A 12-minute group exercise:** review an AI-generated PR smuggling fleet-wide automation, elevated access, and a policy bypass as "faster deployments."
