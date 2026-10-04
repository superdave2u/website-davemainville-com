---
title: '3F App — The Crucible'
description: 'An offline-first, event-sourced coaching platform that runs 12-week Crucible cohorts: season design, weekly 3F calibration reads, accountable circles and channels, and Coach review.'
heroImage: '../../../public/project/threef-app.svg'
relatedPosts: ['threef-app']
---

**3F App** is the companion platform for the Crucible — the 12-week cohort format of my discipline and integrity coaching. Ambitious men set a direction they can follow, organize the chaos of their life into a stewardship season plan, and calibrate weekly with the 3F System Read — feeding the fire, releasing the slag, and striking where it matters.

**[Source on GitHub](https://github.com/3f-mindset/3f-app)**

## Highlights

- **The 12-week season design:** named life domains, current reality, 12-week outcomes, protected containers, weekly actions, elimination commitments, and a Green/Yellow/Red scoreboard — submitted for Coach approval.
- **The 3F System Read:** a six-section weekly calibration (Aim, Meaning, Values, Responsibility, Friction, Cultivation) with diagnostic scales — Furnace Read (*Clogged → Clean-Burning*) and Forge Read (*Crushed → Unbreakable*) — every read demanding evidence.
- **Offline-first PWA:** durable outbox with idempotent retries, conflict preservation, per-command sync states, and an installable mobile app that works without connectivity.
- **Event-sourced core:** FastAPI + append-only event streams with projected read models; submissions are immutable unless a Coach explicitly reopens them; every submission snapshots its template version.
- **Relationship-based privacy:** explicit channel memberships and coach/captain assignments instead of global roles; participant-private channels invisible to leadership unless invited.
- **AI bounded by design:** a non-generative assistant that answers verbatim from published glossary terms with citations and escalates to the assigned Coach rather than inventing guidance.
