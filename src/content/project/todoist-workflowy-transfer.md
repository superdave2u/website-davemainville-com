---
title: 'Todoist Reference Transfer'
description: 'A crash-safe, SQLite-backed queue that moves @reference-labeled Todoist tasks into Workflowy and deletes the source only after the mirror is confirmed.'
heroImage: '../../../public/project/todoist-workflowy-transfer.svg'
relatedPosts: ['todoist-workflowy-transfer']
---

**Todoist Reference Transfer** is a one-way pipeline that moves my `@reference`-labeled Todoist tasks into Workflowy through a SQLite-backed queue: a collector that only enqueues, and a rate-limited worker that creates/updates Workflowy nodes and safely deletes the Todoist source after confirmation. My task list stays actionable; my references live where thinking happens.

**[Source on GitHub](https://github.com/superdave2u/todoist-workflowy-transfer)**

## Highlights

- **Safety religion around deletion:** deepest-first ordering, deletes gated on confirmed `source_deleted` mappings, and an untagged descendant retains its parent — ambiguity never resolves to delete.
- **Crash-safe queue:** jobs claim the ten oldest ready items under 900-second leases, with reclaim of expired leases and a `recover` command for intentional stops.
- **Rate-limit-aware clients:** per-platform token buckets (20 req/min), server `Retry-After` honored, full-jitter exponential backoff, non-retryable errors parked as `blocked`.
- **Idempotent transfer:** SHA-256 payload hashes dedupe enqueueing; mappings drive create-or-update and track every task's journey.
- **Two op models:** cron + flock on WSL, or Docker Compose with a shared data volume — plus a pytest suite.
