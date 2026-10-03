---
title: 'A Fire Drill for Judgment: Tabletop RPG Mechanics for Team Decision Practice'
description: 'My team works in LLM-rich enterprise technology, so I built a platform for running scenario simulations with the mechanics of tabletop RPGs — roles, rounds, meters, and limited-use tools — to practice assessing, strategizing, and following through with no reasoning technology allowed at the table.'
pubDate: 'Sep 03 2026'
heroImage: '/project/rpg-training-platform.svg'
tags: ['games', 'typescript', 'leadership']
---

Teams in enterprise technology are leaning harder on LLMs and reasoning tools every quarter, and I wanted to keep the muscle that atrophies when that happens: the ability to assess a situation, come up with a strategy, implement, and follow through — **without reaching for technology**. So I built [a platform for running scenario simulations](https://github.com/superdave2u/rpg-training-platform) for the team I manage, borrowing the mechanisms of tabletop RPGs like Dungeons & Dragons and applying them to scenarios at work. Think of it as a fire drill, but through the conceptual approach: no fire, no pager, just practiced judgment.

## The translation layer

Tabletop RPGs solved this problem decades ago — how do you get a group of people to collaboratively assess, decide, and act under constraints while having fun? — so I stole the mechanisms and translated them into plain words so non-gamers can join quickly:

- The **Experience Driver** runs the session (the Game Master, without the name).
- **Roles** give each person a clear job, with stated strengths and limits.
- **Tools** show what a role can do — each with limited uses. The Navigator's *Quick Map* works once; the Analyst's *Signal Scan* twice. Resource scarcity forces real choices.
- **Rounds** keep the team moving together through phases: **brief → act → resolve → review**.
- **Replay** lets managers and teams look back at every key choice afterward.

As the operator, I set up the experience: a scenario template defines the meters (**progress**, **risk**, **time-pressure**), action options with their meter impacts, role slots, per-round allowed actions, and debrief prompts. The team plays through. The platform enforces the rules — one action per participant per round, only options allowed that round, tools that actually run out — so the fire drill can't be gamed.

## The engineering

It's a TypeScript monorepo with deliberate architecture, because a session log is the one thing a good debrief depends on:

- **Onion architecture per module** — `identity-access`, `character-library`, `scenario-catalog`, `live-session`, and `replay-reporting` each keep domain logic at the center.
- **Event-sourced `live-session`.** The entire session is an append-only stream of a dozen event types — `SessionCreated`, `RoleAssigned`, `RoundPhaseAdvanced`, `ActionSubmitted`, `MeterChanged` (with a reason attached to every delta), `ConditionChanged` (RPG-style status effects), `ToolUsed`, `ReportGenerated`. The event stream *is* the replay truth, which makes after-action review a projection rather than a reconstruction.
- **CQRS + outbox worker.** Writes flow through the `SessionAggregate`; the worker drains an outbox and rebuilds read models for the dashboard, session board, and replay timeline.
- **The stack:** Next.js web app, Fastify + tRPC API, Drizzle schema for PostgreSQL, Vitest tests over the aggregate rules, and an in-memory runtime so the whole platform can be explored and tested locally before a database exists.

The demo seed shows the intent end to end: a *Navigator* (keeps the team pointed at the goal, can miss side effects) and an *Analyst* (spots patterns, can slow the pace) playing "Lost Shipment Check-In," where *Check the facts* lowers risk while *Make a clear call* buys progress at the cost of time pressure.

One honest note the README carries too: this was implemented and tested against the aggregate rules, but not yet executed on a live session — the next milestone is seating a real team.

## What it taught me

The RPG frame works because it **externalizes decision-making into shared artifacts**. Meters make trade-offs visible; limited-use tools make prioritization physical; rounds make pacing collective; the replay makes reasoning inspectable. And precisely because no LLM is allowed at the table, the participants get reps at exactly the skill the tools are quietly absorbing — framing an ambiguous situation and owning a call.

It's also the same methodology I keep circling back to: take known IP, package it sequentially, and let the system enforce the discipline. D&D figured out collaborative judgment under pressure long before I needed to teach it. I just moved it into a repo.
