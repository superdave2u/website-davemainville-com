---
title: 'Hourly Estimate Calculator'
description: 'An estimation experiment that enhances gut instinct with a Delta for the fog of the unknown.'
heroImage: '../../../public/project/hourly-estimate.svg'
relatedPosts: ['hourly-estimate-calculator']
---

**Hourly Estimate Calculator** is an experiment in project estimation. A gut-instinct base estimate is enhanced with a **Delta** derived from four factors — Expertise, Process Familiarity, Execution Frequency, and Clarity of Done — producing a realistic Optimistic → Most Likely → Pessimistic range that reflects the fog of the unknown and its impact on timelines.

**[Try the calculator](https://superdave2u.github.io/hourly-estimate-calculator/)** · **[Source on GitHub](https://github.com/superdave2u/hourly-estimate-calculator)**

## Highlights

- **Two dimensions of confidence:** *Precision* (weighted toward familiarity and frequency) narrows the range; *Accuracy* (weighted toward expertise and clarity) centers and skews it — because uncertainty isn't symmetric.
- **PERT output:** optimistic, most likely, pessimistic, and a weighted Expected value, not one falsely confident number.
- **Functional core, thin UI:** the estimation math is pure functions bound to Vue 3 sliders.
- **One file, no build:** a single HTML page with Vue from a CDN, deployed to GitHub Pages by GitHub Actions.
- **Visible math:** the weights and formulas are documented in the app itself — no black box.
