---
title: 'The Crucible App: An Offline-First Operating System for 12-Week Cohorts'
description: 'The companion app for my discipline and integrity coaching: ambitious men set a direction, organize the chaos into a 12-week season plan, and calibrate weekly — built event-sourced and offline-first, because honest reads happen on job sites and in trucks, not just on wifi.'
pubDate: 'Oct 04 2026'
heroImage: '/project/threef-app.svg'
tags: ['python', 'react', 'family', 'side-projects']
---

My coaching practice — discipline and integrity for ambitious men — kept hitting the same wall: the work happened in rooms I could only rent by the hour, and the practice lived in email threads and WhatsApp groups that forgot everything. A man sets a direction in week one and by week four nobody can see whether he's still on it. Most men don't lack effort — they lack a way to **measure themselves honestly**.

So I built [the 3F App](https://github.com/3f-mindset/3f-app): the companion platform that runs **the Crucible**, my 12-week cohort format — season design, weekly calibration, accountable relationships, and Coach review in one place.

## The Crucible

A Crucible is an organized 12-week cycle: a **Review Week** (current reality, unfinished commitments), a **Refinement Week** (clarify and make the plan realistic), then the **12-week season** of execute-and-calibrate. Members join circles — small groups, buddy pairs, triads — with Coaches assigned to participants and Captains assigned to Coaches, and every conversation happens in explicit, membership-scoped channels.

The backbone is the **Season Plan**: a *stewardship* plan, not a productivity plan. Ten steps — name the life domains that actually matter, define current reality in facts rather than shame, declare a 12-week outcome per domain, build **protected containers** (time, action, boundary, what gets removed), choose weekly actions, and — the step most men skip — **name what must be eliminated**. A season is not built on top of an overloaded life. It closes with a weekly scoreboard (Green/Yellow/Red — awareness, not punishment) and a named season describing the kind of man you're becoming.

## The 3F System Read: the weekly furnace

The weekly check-in is a structured calibration — six sections, mapped onto forge imagery:

1. **Aim — the Furnace Stack.** What am I building toward, and a **Momentum Scale** read (*Clogged → Clean-Burning*, nine named levels) with required evidence: *what specifically created that level this week?*
2. **Meaning — the Hearth.** The one moment that carried weight (or an honest record of numbness when nothing did).
3. **Values — the Refractory Lining.** Values ranked *as actually lived* that week, not aspired to.
4. **Responsibility — the Anvil.** A **Forge Read** (*Crushed → Unbreakable*) per role — man, father, builder, leader — with the evidence demanded: *no stories. Just weight and truth.*
5. **Friction — the Slag Channel.** What I avoided, what drained me, what I'm still carrying. Exposure first; fixing comes later.
6. **Cultivation — the Hammer.** One role to strengthen, and up to **three strikes** for next week — no fourth strike — pre-populated into next week's read.

The operating method underneath: *read your system, tell the truth, strike where it matters.*

## The engineering

The build reflects the same seriousness as the material:

- **Offline-first PWA.** Weekly reads happen in trucks and on job sites, so the React/TypeScript app works with no connection: encrypted local storage, a durable **outbox** (client-generated IDs, expected stream versions, retries, idempotency), conflict preservation instead of silent overwrite, and an Outbox screen showing every queued command's state.
- **Event-sourced core.** FastAPI backend where the source of truth is append-only event streams — `SeasonPlanSubmitted`, `MomentumAssessed`, `FrictionExposed`, `DeliberateStrikeCommitted`, `WeeklyCalibrationReviewed` — with read models as asynchronous projections and optimistic concurrency on writes.
- **Submissions are immutable unless a Coach reopens them** — review history is preserved, revision is an explicit separate workflow.
- **Versioned templates.** Every submission snapshots the exact prompts and scale definitions used, so a Coach reviewing week 9 always sees the questions the participant actually answered.
- **Relationship-based privacy.** Roles never grant access — only explicit relationships and channel membership do. Coaches can't rewrite plans, only request revisions; Captains see Coach status, never participant content.
- **A non-generative assistant.** The AI boundary is deliberate: it ranks *published* glossary terms and composes answers **verbatim with citations** — declining and escalating to the assigned Coach rather than inventing guidance.

## What it taught me

The deepest one: **honesty needs infrastructure.** "Tell the truth about your week" is a nice poster; a required evidence field after every scale read is a system. The app's design choices all flow from taking the coaching seriously — immutable submissions because revisionism is real, relationship-scoped privacy because a man's disclosure belongs to the relationship he chose, no streaks or leaderboards because this is calibration, not performance.

The second lesson is operational: the whole platform is built through an autonomous Ralph loop with the backlog as the contract — shipping fast, adjusting quickly, exactly as the product principles demand. The first Crucible to run fully in-app is the laboratory, and the app improves the way it asks its members to: one honest read at a time.
