---
title: 'Proof of Life: A Collectible Game of Real-World Invitations'
description: 'Fifty-two real-world missions as fantasy-style collectible cards — five territories of desire, discovery, attention, belonging, and awe, plus two prismatic wilds — built as a browser game where the evidence is the life that happened while pursuing them.'
pubDate: 'Sep 25 2026'
heroImage: '/project/proof.svg'
tags: ['ai', 'games', 'side-projects']
---

Some experiments are about software. This one is about the thing the software is *for*. **[Proof of Life](https://superdave2u.github.io/proof/)** is a collectible game of invitations: 52 real-world missions rendered as fantasy-style cards, where the point isn't getting through the deck fastest — there's no deadline, no points, no leaderboard. You draw an invitation, you go live it, you deposit the evidence in your Archive. When you're done, you're holding 52 pieces of evidence that you were here ([source on GitHub](https://github.com/superdave2u/proof)).

The philosophy on the box: *pleasure, curiosity, beauty, connection, and wonder don't have to defend their place on the calendar with productivity. Their evidence isn't what they produced — their evidence is the life that happened while pursuing them.*

## The deck

Five territories — five schools of magic — plus two prismatic Wild Cards:

- **Pleasure** (crimson, desire, cards 01–10), **Curiosity** (cobalt, discovery, 11–20), **Beauty** (gold, attention, 21–30), **Connection** (emerald, belonging, 31–40), **Wonder** (violet, awe, 41–50).
- The Wilds sit above all: **51 Follow the Thread** (Legendary — wander without a plan; its ability, *Serendipity*, declares the question "what is the point of this?" has no power during the invitation) and **52 Proof of Life** (Mythic — choose something you want even if nobody ever hears about it, do it, and keep an ordinary reminder inscribed **"I WANTED THIS. THAT WAS ENOUGH."**).

Every card carries a full anatomy: name, territory, type line, rarity, artwork, quest, Proof of Life requirement, a special stretch, and flavor text that captions the art. Card states are the whole game loop: `UNDISCOVERED → DRAWN → LIVED`.

## The technology

TypeScript + Vite with vanilla DOM (no framework), vitest, no backend, no accounts — draws and Lived evidence (including optional photos) persist in versioned `localStorage`. The deck data is typed in `src/data/` and held to contract by schema tests: exactly 52 cards, unique, complete anatomy, canon text frozen.

The most interesting pipeline is the **art**. Each card's artwork is a 4:3 watercolor painted from its art direction in the territory's tonal range, starring one recurring heroine — the Wayfarer. The canon (figure bible, palettes, prompt recipe, generation standard) lives in `specs/art/ART-DIRECTION.md`, and generation runs offline through [OpenRouter](https://openrouter.ai/) as **base64 PNGs**, committed per card and lazily attached when a card flips into view. The generation loop is the same Ralph-style discipline as the build: `npm run art:loop` produces *one reviewed image per iteration* — the canon keeps the 52 cards coherent, and review keeps the quality honest.

The whole repo is built with the Ralph harness too: `ralph.sh` for build loops, `ralph-plan.sh` for planning loops, `fix_plan.md` as the living backlog, typecheck + tests as back pressure.

## What it taught me

The design constraint that shaped everything: **the game must not gamify the wrong thing.** No streaks, no optimization — card 52 explicitly "cannot be completed for points." Building that meant the persistence model stores *evidence*, not scores, and the schema tests enforce the canon rather than a leaderboard. The other lesson is generative art with a spine: a written canon (palettes, figure bible, prompt recipe) is what lets 52 separately generated watercolors feel like one deck — constraints are the style.

Play it here: [superdave2u.github.io/proof](https://superdave2u.github.io/proof/) — draw an invitation, and come back with your proof.
