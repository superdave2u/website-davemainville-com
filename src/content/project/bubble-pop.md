---
title: 'Bubble Pop'
description: 'A zero-dependency bubble-popping simulation I built for my daughter.'
heroImage: '../../../public/project/bubble-pop-hero.svg'
relatedPosts: ['bubble-pop']
---

**Bubble Pop** is a simple bubble simulation I made for my daughter: tap a bubble before it floats away and it pops. No ads, no timers, no fail states — just bubbles, tuned until the popping felt great.

**[Play Bubble Pop](https://superdave2u.github.io/bubble-pop/)** · **[Source on GitHub](https://github.com/superdave2u/bubble-pop)**

## Highlights

- **Grown-up settings:** presets (calm, playful, zoomy), themes, bubble styles, and pop effects, persisted to localStorage.
- **Zero dependencies, no build step:** plain HTML, CSS, and vanilla JavaScript ES modules.
- **Onion architecture:** pure `domain` rules with `application` use cases, `infrastructure` browser adapters, and `presentation` views, wired together in a single composition root.
- **Testable in plain Node:** domain and application checks run with no browser or test framework.
- **Accessibility built in:** touch/mouse/keyboard play, `aria-live` score announcements, and reduced-motion and high-contrast support.
- **Hands-off deploys:** GitHub Actions publishes to GitHub Pages on every push.
