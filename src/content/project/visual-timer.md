---
title: 'Visual Timer'
description: 'A themed visual timer that shows how much time is left and grows its goal to motivate continuous activity — built for my daughter.'
heroImage: '../../../public/project/visual-timer.svg'
relatedPosts: ['progress-bar-experiment', 'visual-timer']
---

**Visual Timer** turns waiting into something you can see: a full-screen timer that fills with an eased progress bar and grows its goal icon in the final stretch, motivating continuous activity until the finish. Built for my daughter to give her a visual cue of how much time is left.

**[Open Visual Timer](https://superdave2u.github.io/visual-timer/)** · **[Source on GitHub](https://github.com/superdave2u/visual-timer)**

## Highlights

- **Six themes** (rainbow, ocean, forest, sunset, hourglass, circle), each pairing a start icon with a goal icon — the hourglass even drops animated sand.
- **The goal grows:** during the final 10% of the timer the goal icon scales from half to full size — anticipation as a design element, not just a fill.
- **Eased fill with a dynamic exponent:** the fast-start curve scales with the chosen duration, so long timers still feel immediate.
- **Presets and custom times** (1/5/10/15 minutes or your own), pause and reset, and time shown as passed, remaining, both, or hidden — with persisted settings.
- **Built with React, TypeScript, and Vite**, layered into domain / application (hooks) / presentation, deployed to GitHub Pages.
