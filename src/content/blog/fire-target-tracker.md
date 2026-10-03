---
title: 'Designing the FIRE Board Before Writing a Line of Code'
description: 'A fully local FIRE retirement dashboard, specified end to end before implementation: the required-save-next-month headline, the on-track glidepath, and the real-dollar math — the paper-first repo that became the blueprint for its own implementation.'
pubDate: 'Sep 23 2026'
heroImage: '/project/fire-target-tracker.svg'
tags: ['personal-finance', 'side-projects']
---

There's a discipline I keep circling in these experiments: design the thing completely before you build it. [Fire Target Tracker](https://github.com/superdave2u/fire-target-tracker) is the purest expression of that so far — a repo that contains no application code at all. Just a README and a specification, worked out until the product is fully formed on paper: a **fully local, single-page FIRE retirement dashboard**.

FIRE — financial independence, retire early — has a well-known body of math, inspired here by the classic [Engaging Data FIRE calculator](https://engaging-data.com/fire-calculator/). But the existing calculators answer "when can I retire?" abstractly. The board I specified answers the question you actually face at the start of every month:

- **How much must I save next month** to stay on track for my target retirement date, given my current portfolio value, the months remaining, and my expected real return?
- Am I **on track, ahead, or behind** that required number?
- Where does my *actual* portfolio sit against the **required balance glidepath** — and against the *projected* path if I keep saving at last month's rate?

## The spec's shape

The specification works out everything a builder would otherwise improvise. The math, in real (today's) dollars throughout: FIRE target is retirement spending ÷ withdrawal rate, the monthly real rate derives from the annual assumption, and the required saving is the annuity payment that closes the gap — the PMT formula written out with its edge cases. The data contract is deliberately human: two JSON files you own (`config.json` for plan constants, `monthly.json` with one entry per month), validated, sortable, source-of-truth explicitly assigned to `investmentValue`. The dashboard layout — KPI cards on top (save-next-month as the headline, status, progress gauge, projected retirement date), then the portfolio-vs-glidepath chart and the savings-vs-spending view — is specified card by card. Even the privacy model is part of the spec: no server, no analytics, no network calls; your financial data never leaves the machine, and the docs say plainly that committing personal JSON is a choice to make carefully.

## What it taught me

The interesting engineering happened *because* there was no code to hide behind. Every ambiguity — real vs. nominal display, what "behind" means numerically, which value is the source of truth, what happens with an empty history — had to be resolved in prose, where a wrong assumption costs a paragraph instead of a regression test. The spec also became immediately reusable: it's the blueprint its sibling project [Fire & Strike](/blog/fire-and-strike/) built from — same FIRE math domain, taken further into Monte Carlo territory.

Writing the whole product before writing any of it turned out to be the cheapest possible prototype. The dashboard is designed; the build is just execution with the answers already decided.
