---
title: 'Coming Home: Packaging a Journey of Introspection for My Wife'
description: 'My consulting practice packages intellectual property into sequential systems. My greatest work is connecting people with their best selves — so building my wife a guided introspection practice, 27 entries deep, was especially touching. My first experiment with Alpine.js.'
pubDate: 'Aug 20 2026'
heroImage: '/project/coming-home.svg'
tags: ['alpinejs', 'javascript', 'side-projects', 'ux', 'family']
---

Part of my consulting practice is taking interesting intellectual property and packaging it into a system that works sequentially — a methodology that walks someone through transformation one deliberate step at a time. And the truest thing I can say about my life's work is that it's connecting people with their best selves.

This project is where those two threads met at home: I built my wife a series of journaling questions to guide her through a journey of introspection. Honoring her with a practice like this — the same care I'd craft for any client's program, aimed at the person who matters most — was especially touching. I call it [Coming Home](https://superdave2u.github.io/coming-home/), a nod to its export file: `coming-home-to-myself.md`. [Source is on GitHub](https://github.com/superdave2u/coming-home).

## The experience

The journey is **27 entries organized into three stages and nine milestones**. The app shows exactly one entry at a time — a title, a short context, a writing prompt, and (optionally) an example if the blank page feels intimidating.

The sequencing is the methodology. The first entry is always open; every later entry unlocks only when the one before it is completed. There's no skipping ahead to the interesting-looking parts — introspection compounds, and the design enforces it. A **journey map** modal lays out the whole structure with honest states (unavailable, available, completed, current), and it uses the same access-control function as the main navigation, so there's no back door.

Writing is autosaved as you type (debounced, with a brief saved-indicator), responses persist in the browser across sessions, and a **review** view gathers everything written so far. When the journey is finished, an **export** button generates a Markdown document entirely in the browser — a keepsake she can archive anywhere, no server ever involved.

## The technology

This was my first time building with **Alpine.js**, and the simplicity won me over. The whole application is a single `index.html` — no build system, no bundler, no package manager, no router. Alpine loads from a CDN, one component (`reflectionJourney()`) holds the application state, and lightweight `x-show` directives switch between the three views (welcome, journey, complete) and the overlays (map, review, example).

What Alpine made pleasantly small:

- **One source of truth.** The journey lives as a nested data structure — Journey → Stage → Milestone → Question — and the navigation, map, review, and export all derive from it. Sequential access, the map, and the review document are all views of the same data.
- **Persistence without a backend.** `localStorage` under a versioned key holds the deliberately minimal persisted shape — reflections, completed entries, started — while UI-only state (open map, visible example) never touches it. The debounced `@input.debounce.350ms` handler keeps saving responsive without thrashing storage.
- **Export in a few lines.** Build a Markdown string from the same journey data, wrap it in a `Blob`, generate an object URL, click a temporary link, release the URL. Client-side from end to end.
- **Mobile-first care.** Fixed bottom navigation, large touch targets, bottom-sheet modals, safe-area support — a practice someone opens on their phone in a quiet moment.

I was also deliberate about honesty in the README: `localStorage` is convenient persistence, not secure storage — the docs say so plainly and sketch the upgrade path (bundled Alpine, encrypted storage, explicit deletion) rather than overpromising.

## What it taught me

Two things, one technical and one not. Technically: Alpine occupies a genuinely useful band of the spectrum — reactive enough to feel like a real application, small enough to ship as one file with zero build infrastructure. For sequential, state-driven experiences like this, I'd reach for it again without hesitation. The sequential-access pattern itself — one `canOpenQuestion()` function governing every path to the content — is exactly how I package consulting IP: methodology enforced by the system, not by willpower.

Personally: the most meaningful software I've shipped this year wasn't the most complex. It was 27 questions, written for one specific person, in the order that would serve her best. That's the whole methodology — sequencing with intent — applied to the person I most want to see come home to herself.
