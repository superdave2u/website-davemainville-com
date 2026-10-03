---
title: 'Deleting with Confidence: A Crash-Safe Queue for Moving Tasks Out of Todoist'
description: 'My Todoist list was full of tasks that would never be done — they were references. This tool moves @reference-labeled tasks into Workflowy through a SQLite-backed queue with leases, rate limiting, and one absolute rule: nothing is deleted until the mirror is confirmed.'
pubDate: 'Oct 03 2026'
heroImage: '/project/todoist-workflowy-transfer.svg'
tags: ['python', 'sqlite', 'automation', 'side-projects']
---

My Todoist has a purer purpose than "everything I've written down": it's the list of things that can be *done*. But over time it accumulated a second population — tasks I labeled `@reference` that would never be completed, because they aren't tasks at all. They're reference material: notes, links, fragments worth keeping that landed in my inbox because my inbox is where everything lands.

Workflowy is where my long-form thinking lives, so the obvious move is a one-way transfer: mirror `@reference` tasks into Workflowy, then delete them from Todoist so the list stays actionable. The obvious move is also quietly dangerous — it ends in a bulk delete. So instead of a script, I built a [queue with a safety religion](https://github.com/superdave2u/todoist-workflowy-transfer).

## The system

Two small commands, run on two cron schedules under one non-blocking `flock`:

- **`collect`** (hourly) fetches active Todoist tasks, filters to `@reference`, and enqueues each into a SQLite-backed queue. Eligibility is hereditary: a task qualifies only if its whole parent chain is eligible, and every payload is hashed (SHA-256 of the task, its project, and eligible ancestors) so unchanged tasks aren't re-queued.
- **`work`** (every minute) claims the ten oldest ready jobs — under a **900-second lease** — and processes them. The worker is where all the danger lives, and the design leans into it.

The worker's loop is a state machine more than a script. For each job it re-fetches the live task: deleted on the Todoist side? Complete or cancel depending on whether a mirror already exists. Label removed? Cancel — and *retain* the mapping rather than deleting anything. Parent not yet mirrored? Defer a minute and wait. The transfer itself is idempotent — create or update by mapping, with the source link, IDs, labels, and metadata packed into the Workflowy note.

Only then, deletion — governed by three rules:

1. **Deepest first.** Children are deleted before parents, so a parent's delete implies its whole subtree is already settled.
2. **Confirmed mirror only.** An ancestor isn't eligible for deletion until every descendant's mapping says `source_deleted` — proven, not assumed.
3. **One untagged descendant retains the parent.** If any child isn't marked `@reference`, the parent survives with a "retained" status. Ambiguity never resolves to delete.

## The infrastructure details

Because both Todoist and Workflowy rate-limit (the defaults: 20 requests/minute each), the clients sit behind **token buckets**, honor server `Retry-After` instructions, and back off with **full-jitter exponential delays** capped at an hour. Non-retryable errors park a job as `blocked` instead of thrashing. A worker that dies mid-lease simply loses the lease — expired claims are reclaimed on the next run, and a `recover` command releases anything still held, which matters when you're stopping containers intentionally under Docker Compose.

## What it taught me

The big lesson: **deletion is the most underrated engineering problem.** Copying data between two APIs is an afternoon; deleting the source *safely* is a distributed-systems exercise in confirmation ordering, partial failure, and crash recovery. Leases, deepest-first ordering, and retain-on-ambiguity aren't enterprise ceremony — each one earned its place by answering "what if this dies right now?"

The second lesson is architectural: **the collector only enqueues; the worker does the dangerous work.** Keeping read-only ingestion separate from destructive processing made every safety rule easy to locate, and the queue made the whole thing restartable at will.

The [source is on GitHub](https://github.com/superdave2u/todoist-workflowy-transfer) — the README covers setup, cron, and the Docker Compose deployment. My Todoist list is all signal now, and my references live where thinking happens.
