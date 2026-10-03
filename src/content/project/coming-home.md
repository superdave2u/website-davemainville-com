---
title: 'Coming Home'
description: 'A sequential guided-reflection journey — 27 journaling entries across three stages and nine milestones — built with Alpine.js as a practice of introspection for my wife.'
heroImage: '../../../public/project/coming-home.svg'
relatedPosts: ['coming-home']
---

**Coming Home** is a guided reflection application: 27 journaling entries organized into three stages and nine milestones, presented one at a time with progressive access — each entry unlocks when the previous one is completed. Built as a sequential introspection practice for my wife.

**[Open Coming Home](https://superdave2u.github.io/coming-home/)** · **[Source on GitHub](https://github.com/superdave2u/coming-home)**

## Highlights

- **Sequential by design:** one entry at a time, next unlocks only after the last is finished — the journey map and navigation share the same access-control function, so there's no bypass.
- **One source of truth:** the Journey → Stage → Milestone → Question data structure drives navigation, the map, review, and export alike.
- **Quiet persistence:** debounced autosave to `localStorage` with a saved indicator — no account, no server; UI state stays separate from saved reflections.
- **Portable keepsakes:** browser-side Markdown export (`coming-home-to-myself.md`) via Blob and object URL.
- **Mobile-first:** fixed bottom navigation, large touch targets, bottom-sheet modals, and safe-area support.
- **Single file, zero build:** Alpine.js 3 from a CDN — one `index.html`, no bundler, no router, no backend.
