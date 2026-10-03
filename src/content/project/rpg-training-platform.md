---
title: 'RPG Training Platform'
description: 'An event-sourced platform for running tabletop-RPG-style scenario simulations at work — roles, rounds, meters, and limited-use tools — to strengthen team reasoning and decision-making without LLMs at the table.'
heroImage: '../../../public/project/rpg-training-platform.svg'
relatedPosts: ['rpg-training-platform']
---

**RPG Training Platform** is a platform for running live scenario simulations for my team: Dungeons & Dragons mechanics translated into plain words — Experience Driver, Roles, Tools with limited uses, Rounds, Replay — so operators can set up work scenarios with options, constraints, and tools, and teams can play through a conceptual fire drill with no reasoning technology allowed.

**[Source on GitHub](https://github.com/superdave2u/rpg-training-platform)**

## Highlights

- **RPG mechanics for work scenarios:** progress/risk/time-pressure meters, per-round action options with meter impacts, role slots with stated strengths, limits, and limited-use tools.
- **Event-sourced `live-session`:** a dozen typed events (ActionSubmitted, MeterChanged, ConditionChanged, ToolUsed…) form the session log — the replay timeline and manager report are projections of the same truth.
- **Rules enforced by the aggregate:** one action per participant per round, actions only in the act phase, only round-allowed options — the drill can't be gamed.
- **Deliberate architecture:** onion-architecture modules (identity-access, character-library, scenario-catalog, live-session, replay-reporting), CQRS with an outbox worker, Drizzle/PostgreSQL schema.
- **TypeScript monorepo:** Next.js dashboard and session board, Fastify + tRPC API, worker for read models, Vitest-tested aggregate rules, in-memory runtime for local exploration.
