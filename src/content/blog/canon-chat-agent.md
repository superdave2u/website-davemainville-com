---
title: 'Ask Your Own Library: a RAG Chat Agent on an Onion Core'
description: 'I built a self-hosted RAG chat agent over my private coaching-business library: a pure domain core with five policies, a prompt plan that keeps the provider cache warm across every session, an append-only context pool for follow-ups, and a deploy that provisions its own payload. 174 tests, zero network required.'
pubDate: 'Oct 10 2026'
heroImage: '/project/canon-chat-agent.svg'
tags: ['ai', 'python', 'design-patterns', 'automation']
---

I own a private library of coaching-business material — about 150 transcripts plus a stack of method and operations documents that teach the RED Method (Refine Offer, Engage Opportunity, Develop Audience). For a year it has been reference material: something I search when I remember to. What I actually wanted was to *ask it things*. "How do I pick the one result I sell?" and get an answer in plain English with the sources listed underneath.

The off-the-shelf answer is "throw it at a RAG framework." I didn't, for three reasons I couldn't get around: I need a hard guarantee about a brand-name promise I've made (more on that below), I want answers that cite only sources the retrieval actually returned, and I want the token bill shaped by design instead of by accident. So I built the agent myself, in a private repo, and this post is the architecture tour.

## Spec first, red teams second

I've been running a spec-driven loop for a while now: write the spec, then let independent LLM passes attack it before any code exists. I have a small tool for this — it drafts a spec from a solution-free intent, critiques it against a rubric, and revises until the critique reports clean. I ran it twice on this spec with a five-iteration budget. Both passes converged clean on the first critique, which sounds like a pat on the back but wasn't: the *drafts* diverged from my spec in ways that mattered, and that's where the value was.

The divergences became decisions in a decision log that now runs D1 through D10. Five of them were real gaps the red teams caught before I wrote a line of code: the naming guardrail only covered answer text (not citation labels or error strings), a failed search was indistinguishable from "the canon doesn't cover this," partial support had no defined behavior, the citation wire format didn't exist, and the cache configuration would have silently fallen back to uncached requests. Every one of those is cheaper to fix in a spec than in a deployed system.

## The onion

The core is domain-driven onion architecture, and the dependency rule is the whole trick: dependencies point inward, and the domain knows nothing about AWS, HTTP, or model vendors.

- **Domain (pure Python, zero imports beyond stdlib):** ten value objects (`Query`, `Chunk`, `ChunkId`, `SourceRef`, `Citation`, `Score`, `TopK`, `Answer`, `RetrievalRound`, `TriggerDecision`), two entities, nine ports, and five policies. No I/O anywhere.
- **Application:** one class per use case — `AnswerQuestion`, `LoadMoreContext`, `IngestCorpus`, `CheckHealth` — wired only to the ports.
- **Infrastructure:** adapters that implement the ports. Bedrock today; Ollama and OpenRouter adapters are deferred, and adding one is a new adapter plus a config entry, never a core change.
- **Entry points:** thin Lambda handlers and a local CLI. The composition root is the only place `boto3.client` appears.

The five policies are where the guarantees live, and they're all pure functions you can test with fakes:

- `NamingRulePolicy` — the library's source material carries an original brand name I've promised never to repeat. The policy scrubs every user-visible string: the answer, each citation label, source labels, error text. The forbidden terms themselves load at runtime from a private bucket and never enter git — the code that enforces the promise never contains the thing it guards against.
- `CitationPolicy` — the model writes inline markers like `[S1]`; the policy resolves them against the sources retrieval supplied and *drops* any marker that doesn't resolve. The model never names a source on its own.
- `GroundingPolicy` — an answer with no retrieved context gets marked as the agent's own view, not canon.
- `RetrievalTriggerPolicy` — decides whether a turn needs a second retrieval round, from injected thresholds (a 0.30 cosine bar, 3 chunks minimum) rather than magic numbers.
- `ContextPoolPolicy` — the append-only, deduped, capped context pool (below).

## The prompt plan, or: how the cache pays rent

The best design in the system started as a cost observation. Model providers cache the longest unchanged *prefix* of a request. Most RAG builds put retrieved documents wherever convenient, which shuffles the prefix every turn and quietly disables caching.

So the request is built as an ordered **prompt plan** — and the plan is a domain type whose constructor enforces the order:

```text
1. System block   — persona, method map, style rules   (static)
2. Canon context  — the session's context pool         (dynamic)
3. History        — the last 10 turns                  (dynamic)
4. Query          — the user's question                (dynamic, always last)
```

The system block is byte-stable within a release. That means the static prefix is *identical across every session and every turn* — there's a test that builds two plans from two different sessions and asserts the prefixes match byte for byte. The provider caches that prefix once and every conversation reuses it. The cache boundary sits right after block 1; nothing variable ever appears before it.

And because a cached prefix is the whole point, the configuration is strict on purpose: the composition root refuses to start with a provider/model combination that can't cache, unless you set an explicit override. Silent uncached requests are how token bills surprise people.

## The context pool: follow-ups that remember

Follow-up questions are where naive RAG falls apart. "What about step 2?" retrieves garbage on its own — the meaning lives in the earlier turns.

Two mechanisms handle it. First, every turn rewrites the message into a standalone search query using the recent history (a small model call with a fixed prompt; if it fails, the raw message falls through and the turn stays answerable). Second, retrieved chunks don't just feed the current turn — they join a **context pool** that belongs to the session. The pool is append-only within a session, deduped by chunk id, and capped at 24 chunks; when it's full the oldest chunks leave, which resets the cache exactly once. Thin retrieval scores or an explicit "go deeper" ask trigger a second, wider round (TopK 6 becomes 12, plus one paraphrase variant), capped at two rounds per turn.

Later turns answer from the pool, not just the last search. Each chunk remembers the turn it joined on, so citations can name when a source was loaded.

## Stateless sessions, on purpose

There's no database. The client carries the session on every request: a session id, the ordered history, and the pool as chunk ids. The server rebuilds the session per request and re-validates it — pool ids missing from the current index get dropped and logged, order preserved, duplicates removed, cap enforced.

This was a deliberate trade-off (decision D5). A server-side store is more robust — the red-team draft wanted one — but it adds a component, and a rebuilt prompt with identical content keeps the provider-side cache warm anyway. The store stays the documented v2 path behind a port; the domain doesn't change when it arrives.

## The deploy provisions its own payload

The infra is one `serverless.yml`: an HTTP API, three Lambdas, an encrypted private S3 bucket, Bedrock access, Secrets Manager, and a CloudFront-served UI. Pattern B — no EC2, no VPC, no GPU, pay per token, data inside my AWS account.

The part I'm proudest of is that `serverless deploy` is genuinely one command. A plugin hook runs a prep script that copies the local-only corpus and the local-only terms source into a gitignored payload directory, and a provisioner Lambda behind a CloudFormation custom resource puts the corpus, the transformed terms list, the chat UI, and the secret value into the stack on create and update. On delete it empties the buckets — because CloudFormation can't delete a non-empty bucket, and a rollback command that fails isn't a rollback command.

## Offline TDD, and the audit that earned its keep

The whole test suite runs on a clean machine with no network and no cloud credentials: 174 tests, all green, `mypy --strict` clean, ruff clean. Domain and application tests run against fakes; adapter contract tests run against stub clients recorded in-process; the infrastructure YAML itself is validated offline by contract tests (no EC2 resources, encryption on, IAM scoped, tuning defaults present) without deploying anything.

The last gate was an independent verification pass that mapped all 22 offline acceptance criteria to named tests. It found five gaps — the label-scrubbing hole, the unguarded retrieval call, the missing partial-support proof, and two untested assertions. All five got fixed with tests before I called it done. That's the quiet argument for the whole setup: when the guarantees live in pure policies, "prove it" is a test away.

## What's next

Streaming (the policies want the whole answer before it ships, so it's a presentation-layer change), agentic retrieval where the agent starts its own searches, and the server-side session store — all behind ports that already exist. The core hasn't needed to change for any of them, which is the only architecture review that matters.
