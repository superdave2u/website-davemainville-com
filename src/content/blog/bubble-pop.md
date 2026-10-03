---
title: 'Bubble Pop: A Tiny Game Built for My Daughter'
description: 'How I turned a simple request from my daughter into a zero-dependency vanilla JavaScript bubble-popping game — and what its clean architecture taught me about building small things well.'
pubDate: 'Oct 03 2026'
heroImage: '/project/bubble-pop-hero.svg'
tags: ['javascript', 'games', 'family', 'side-projects', 'accessibility']
---

Some of the best side projects start as a five-second request. Mine started when I made my daughter a bubble simulation so she could pop bubbles to her heart's content — no ads, no timers, no "level failed," just bubbles.

That project is [Bubble Pop](https://superdave2u.github.io/bubble-pop/), and it's now live on its own page, with [the source on GitHub](https://github.com/superdave2u/bubble-pop).

## The experience

Tap (or click) any bubble before it floats away and it pops with a little sparkle. That's the whole loop, and that's the point. The fun came from making the popping feel *good*: satisfying pop effects, streaks of bubbles, and just enough reward feedback to earn a giggle.

A "grown-up settings" panel lets you tune the experience with presets like **calm**, **playful**, and **zoomy**, along with themes, bubble styles, and pop effects. Sound is off by default — every parent knows why.

## The technology

I gave myself two constraints: **zero dependencies** and **no build step**. Plain HTML, CSS, and vanilla JavaScript with ES modules. That constraint turned a toy into a genuinely interesting build:

- **Onion-style architecture.** The code splits into `domain`, `application`, `infrastructure`, and `presentation` layers. The domain holds deterministic rules for bubble motion, rewards, and settings — it never imports the DOM, audio, storage, or animation APIs. `src/main.js` is the single composition root that wires real browser adapters into the game.
- **Testable without a browser.** Because the domain and application layers take their collaborators through small injected interfaces, the core runs in plain Node with `node tests/domain-checks.js` — no test framework, no jsdom, no browser.
- **Browser niceties through adapters.** localStorage for settings, the Web Audio API for pops, the Vibration API for haptics, and `matchMedia` for honoring system preferences — all behind ports the domain never sees.
- **Accessibility as a feature.** The game is fully operable by touch, mouse, and keyboard, scores announce through `aria-live`, and reduced-motion and high-contrast preferences reshape the whole experience. It's a game a toddler can play and a screen reader can narrate.
- **Deployed by convention.** A single GitHub Actions workflow publishes the static page to GitHub Pages on every push. Nothing to host, nothing to maintain.

## What it taught me

Small projects are where architecture ideas get stress-tested for free. Keeping the domain pure made the game easier to tune — I could change bubble motion or reward rules with confidence that nothing about storage or rendering would silently break. And shipping something my daughter actually asks to play is the best kind of test to pass.

If you want to see how a dependency-free game stays organized as it grows, [browse the repo](https://github.com/superdave2u/bubble-pop) — the `ARCHITECTURE.md` walks through the layering.
