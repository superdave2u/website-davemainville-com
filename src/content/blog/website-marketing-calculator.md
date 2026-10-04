---
title: 'The Funnel Calculator: Modeling Marketing Math in Two Directions'
description: 'An interactive calculator for coaches and course creators to model funnel economics — forward from an ad budget to projected profit, or backward from an income goal to the leads required — built as a no-build Vue 2 + Vuetify single page, still live years later.'
pubDate: 'Jun 01 2023'
heroImage: '/project/website-marketing-calculator.svg'
tags: ['vue', 'javascript', 'side-projects']
---

Coaches and course creators live and die by a funnel they rarely see as numbers: ad spend becomes leads, leads become booked calls, booked calls become completed calls, completed calls become enrolled clients — and somewhere in that chain, profit happens or doesn't. [The Website Marketing Calculator](https://redrhino-online.github.io/website-marketing-calculator/) makes the whole chain tangible, in **two directions** ([source on GitHub](https://github.com/redrhino-online/website-marketing-calculator)).

## The two modes

**Budget mode** runs the funnel forward: start with an ad budget and a cost per lead, and the calculator projects everything downstream — leads, bookings, calls, clients, revenue, profit, plus the derived unit economics (max cost per lead/booking/call/client), ROAS, overall conversion rate, and gross margin.

**Income mode** runs it backward — my favorite of the two. Start from an income goal and a profit margin, and the calculator solves for the number of *clients* required (`income goal ÷ (price × margin)`), then uses the funnel's conversion rates to unwind upward: how many calls must be completed, how many must be booked, how many leads must be bought. The same five-stage stepper — Program, Funnel, Projections, Advertising, Metrics — works either direction, with clickable step headers and a training popup for first-time users.

The two modes answer different questions, and having both is the point. Budget mode answers "what will this spend produce?" Income mode answers the one coaches actually start with: "I want to make $10k/month — what does that *require*?"

## The technology

Deliberately small, deliberately 2023-pragmatic: a **single-page Vue 2 + Vuetify 2 app loaded from CDN — no build step at all**. The entire funnel engine is a set of Vue computed properties, one per derived quantity, in two parallel families (`budgetBased*` and `incomeBased*`) selected by a mode switcher. Because every derived number is a pure computed rather than a mutation, changing any input re-derives the whole chain instantly — leads, calls, clients, costs, ROAS — with no recalculation code to write or get wrong.

The math respects the funnel's real-world discreteness: counts use `floor` going forward (you can't buy 3.7 leads) and `ceil` going backward (you can't enroll 0.8 of a client). Deploy is a single GitHub Actions workflow publishing the `src/` directory straight to GitHub Pages — the whole repository is an HTML file, a JS file, and a workflow.

## What it taught me

This one is from my consulting practice — red rhino branding and all — and the lesson it hammered home is that **a good calculator is a model of a mental model**. Practitioners already reason with funnels; the tool's job isn't to teach a new framework but to make *their* framework computable in both directions. The backward mode exists because of that: every real conversation starts at an income goal, not an ad budget, and a tool that only computes forward quietly refuses to answer the question being asked.

Also: no build step ages *well*. Years later this app still runs identically from a CDN include and a static host — nothing to rebuild, nothing to break, nothing to update before it works. For small interactive tools, "boring" is a feature with a long shelf life.
