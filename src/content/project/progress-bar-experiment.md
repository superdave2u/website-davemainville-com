---
title: 'Progress Bar Experiment'
description: 'A p5.js experiment in managing reader attention by implying progress — comparing linear and eased fill rates, now a platform for side-by-side fill experiments.'
heroImage: '../../../public/project/progress-bar-experiment.svg'
relatedPosts: ['progress-bar-experiment']
---

**Progress Bar Experiment** explores managing the attention of a reader with a visual element that implies progress. It compares two progress bar fill methods — **linear** (uniform over time) and **eased** (square root, fast start and slow finish) — where the same duration produces different perceived progress.

**[Open the live demo](https://superdave2u.github.io/progress-bar-experiment/)** · **[Source on GitHub](https://github.com/superdave2u/progress-bar-experiment)**

## Highlights

- **Fill options registry:** linear, ease-out sqrt (the original), ease-out cubic, ease-in-out cubic, and ease-in quad — pure functions, one line to add more.
- **Per-bar fill rates:** each bar carries its own duration for cross-rate comparisons.
- **Side-by-side bars, one button:** stack multiple bars with different settings and trigger them all with a single Run button — in parallel or sequentially.
- **Built with p5.js** for canvas rendering and animation, deployed to GitHub Pages.
