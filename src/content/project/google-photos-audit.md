---
title: 'Google Photos Audit'
description: 'An AutoHotkey + PowerShell tool that audits the Google Photos web UI for the storage signal Google never exposed via API — flagging the photos that consume quota for offload through an unlimited-backup device.'
heroImage: '../../../public/project/google-photos-audit.svg'
relatedPosts: ['google-photos-audit']
---

**Google Photos Audit** inspects the rendered Google Photos page for the one signal Google never shipped in an API — whether an item takes up space in your account storage — and queues the ones that do. It audited ~30,000 photos in my library and flagged ~12,000 consuming quota, now a work queue for offloading back through my Pixel 3's unlimited backup.

**[Source on GitHub](https://github.com/superdave2u/google-photos-audit)**

## Highlights

- **Browser-as-API:** connects to Chrome's local DevTools endpoint (dedicated profile, port 9222) and reads the live signed-in DOM — no cookies sent anywhere, no unofficial API to break.
- **AutoHotkey v2 launcher:** `F8` scan, `F9` scan + advance, `F10` repeat N times with Esc/second-press cancellation.
- **PowerShell helper that clicks like a human:** native hover + press/release on the visible "View next photo" button (Google ignores `HTMLElement.click()` on hidden controls), random 100–1000 ms dwell per photo.
- **Self-verifying advances:** URL-change check with restore-and-retry, failure reasons logged to `GooglePhotos-last-result.txt`, flagged items appended with timestamps to `GooglePhotos-review.txt`.
- **The output is a work queue:** 23,500 audit lines separating unlimited-backup items from the 15 GB consumers waiting to be offloaded.
