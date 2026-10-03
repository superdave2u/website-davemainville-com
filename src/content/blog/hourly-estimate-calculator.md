---
title: 'Quantifying the Fog: Gut Instinct Plus Delta for Better Estimates'
description: 'I built an experiment that treats a gut-instinct estimate as a base and adjusts it with a Delta derived from four factors — expertise, process familiarity, execution frequency, and clarity of done — producing an honest optimistic-to-pessimistic range instead of a hopeful number.'
pubDate: 'Sep 12 2025'
heroImage: '/project/hourly-estimate.svg'
tags: ['estimation', 'vue', 'javascript', 'side-projects']
---

Ask an experienced developer how long a task will take and you'll get a number that is often *directionally* right and reliably wrong. The gut instinct isn't useless — it's just uncalibrated. It doesn't know how much it doesn't know.

That's the idea behind my [Hourly Estimate Calculator](https://superdave2u.github.io/hourly-estimate-calculator/), an experiment in project estimation: keep the gut-instinct estimate as the base, then enhance it with a **Delta** — an adjustment derived from how foggy the work actually is — to get a more realistic picture of the unknown and its impact on the timeline. [The source is on GitHub](https://github.com/superdave2u/hourly-estimate-calculator).

## The experiment

You start with two inputs and four sliders:

- **Base Hours (H):** your honest gut instinct for the task.
- **Expertise (E):** how skilled you are with this *type* of work.
- **Process Familiarity (F):** how familiar you are with the workflow and tools.
- **Execution Frequency (X):** how often you've done this kind of work before.
- **Clarity of Done (C):** how well-defined "done" actually is.

From those, the calculator derives two dimensions of confidence:

- **Precision** — how *narrow* your range should be. It's weighted toward familiarity and frequency (`0.4F + 0.4X + 0.2C`), because knowing the process and having done it before is what collapses uncertainty. High precision means your base hours barely move; low precision spreads the range toward ±50%.
- **Accuracy** — how *centered* your base guess sits. It's weighted toward expertise and clarity (`0.6E + 0.4C`). Low accuracy skews the range asymmetrically: the optimistic end stretches down modestly, but the pessimistic end stretches *up* dramatically.

That asymmetry is deliberate. The fog of the unknown is not symmetric — work you don't understand has more ways to surprise you than to go smoothly. Every veteran estimator knows the pattern: the underestimate is bigger than the overestimate. The model encodes it.

Finally the outputs are shaped into a classic **PERT** estimate — Optimistic → Most Likely → Pessimistic, with an Expected value weighted `(O + 4×M + P) ÷ 6` — so the result isn't one falsely confident number but a range with a defensible center of mass.

## The technology

I kept this one radically small on purpose:

- **One file, no build.** Plain HTML and Vue 3 loaded from a CDN, deployed as-is to GitHub Pages by a single GitHub Actions workflow. The entire "product" is a page you can read in one sitting.
- **Functional core, thin UI.** The estimation math lives as pure functions — `computePrecision`, `computeAccuracy`, `computeRange`, `adjustByAccuracy`, `computeFinalEstimates` — with the Vue app doing nothing but binding sliders and rendering results. The domain logic never touches the DOM, which makes it trivial to reason about (or lift into another UI later).
- **Visible math.** The "How It Works" callout documents the weights and formulas in plain language. Estimation tools lose trust when they behave like black boxes; this one shows its work.

## What it taught me

The interesting insight came from writing the formulas down. You can't hand a spreadsheet to a team and say "account for the fog" — but you can make the fog *tangible* with four sliders and two named dimensions. Precision and accuracy aren't the same thing, and conflating them is exactly why gut-instinct estimates fail: you can be deeply familiar with a process (high precision) while still having an unclear definition of done (low accuracy), and the resulting estimate needs to be treated very differently in each case.

It's an experiment, and the weights are my first pass rather than gospel. But as a way to turn "I think it's about 60 hours" into "60 hours if we know what we're doing, 90 if we don't," it's already changed the conversations I have about timelines.
