---
title: 'Proof of Life'
description: 'A collectible game of 52 real-world invitations — five territories plus two prismatic wilds, watercolor card art generated with a reviewed one-image-per-iteration loop, and evidence stored where scores would be.'
heroImage: '../../../public/project/proof.svg'
relatedPosts: ['proof']
---

**Proof of Life** is not merely a deck of prompts — it's a collectible game of invitations: 52 real-world missions as fantasy-style cards across five territories (Pleasure, Curiosity, Beauty, Connection, Wonder) plus two prismatic Wilds. Draw an invitation, live it, deposit your evidence in the Archive. No points, no deadlines — the evidence is the life that happened while pursuing it.

**[Play Proof of Life](https://superdave2u.github.io/proof/)** · **[Source on GitHub](https://github.com/superdave2u/proof)**

## Highlights

- **A complete canon deck:** 52 cards with full anatomy (quest, Proof of Life, special stretch, flavor), frozen by schema tests — including 51 *Follow the Thread* (Legendary) and 52 *Proof of Life* (Mythic: **"I WANTED THIS. THAT WAS ENOUGH."**).
- **Game loop as states:** UNDISCOVERED → DRAWN → LIVED, with versioned localStorage persistence for draws, evidence, and optional photos.
- **Generated watercolor with a spine:** every card's art painted from a written canon (figure bible, territory palettes, prompt recipe) via OpenRouter — one reviewed image per Ralph-loop iteration.
- **No framework:** TypeScript + Vite, vanilla DOM, vitest; lazy-attached base64 PNGs; GitHub Pages deploy on every push.
- **Anti-gamification by design:** no streaks, no scores, no leaderboards — card 52 explicitly cannot be completed for points.
