---
title: 'Fire & Strike'
description: 'A FIRE retirement calculator with seeded Monte Carlo projections (p10/p50/p90) and a STRIKE solver for the extra yearly contribution needed to retire by a target age — test-first, onion-architected, built by an agent loop.'
heroImage: '../../../public/project/fire-and-strike.svg'
relatedPosts: ['fire-and-strike', 'fire-target-tracker']
---

**Fire & Strike** is a retirement calculator for the FIRE community with two use cases: project your current pace as a Monte Carlo fan chart (p10/p50/p90 portfolio paths vs age, each stamped with its FIRE-crossing age), and solve a **STRIKE plan** — the extra yearly contribution so the median path reaches your target retirement age.

**[Open Fire & Strike](https://superdave2u.github.io/fire-and-strike/)** · **[Source on GitHub](https://github.com/superdave2u/fire-and-strike)**

## Highlights

- **Honest projections:** seeded, reproducible Monte Carlo (Mulberry32 normal streams, default 7%/18% stocks, 2.5%/6% bonds) — percentiles instead of a single confident date.
- **STRIKE solver:** binary search over extra yearly contribution until the p50 path crosses FIRE exactly at the declared age — "50% chance" confidence by design.
- **Draft-then-calculate inputs:** never clamped mid-typing, warnings + `aria-invalid` on invalid drafts, collapsed Advanced assumptions.
- **DDD ubiquitous language + onion architecture:** pure domain services behind ports, use cases in application, arch-unit `boundaries.test.ts` guarding the layers.
- **Built by the Ralph loop:** spec of record → ordered TDD tasks → agent iterations gated by lint + typecheck + tests → GitHub Pages deploy on every push.
