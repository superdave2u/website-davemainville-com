---
title: 'Fire Target Tracker'
description: 'A fully local FIRE retirement status board, specified end to end before implementation — the required-save-next-month headline, on-track glidepath, and real-dollar math on paper first.'
heroImage: '../../../public/project/fire-target-tracker.svg'
relatedPosts: ['fire-target-tracker', 'fire-and-strike']
---

**Fire Target Tracker** is a fully local, single-page dashboard that tracks progress toward Financial Independence / Retire Early — answering the monthly question "how much must I save next month?" against a target retirement date. This repo is the **paper-first stage**: a complete README and specification, no application code — the design that became the blueprint for [Fire & Strike](https://github.com/superdave2u/fire-and-strike).

**[Source on GitHub](https://github.com/superdave2u/fire-target-tracker)**

## Highlights

- **The headline number:** required monthly contribution (annuity PMT) to hit the target date given current portfolio, months remaining, and expected real return — with on-track / ahead / behind status.
- **Real-dollar math:** FIRE target = spending ÷ withdrawal rate, real returns throughout, optional nominal toggle — inspired by the Engaging Data FIRE calculator.
- **Data you own:** two validated JSON files (plan constants + monthly entries) with explicit source-of-truth rules and glidepath/projection definitions.
- **Privacy as spec:** no server, no analytics, no network calls — personal data never leaves the machine.
- **Spec of record:** dashboard layout, KPI cards, charts, validation, and edge cases all resolved in prose before any build.
