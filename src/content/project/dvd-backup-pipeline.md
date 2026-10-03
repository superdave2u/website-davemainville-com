---
title: 'DVD Backup Pipeline'
description: 'Human-in-the-middle DVD automation for a 400-disc archive: rip worker that ejects immediately into a disk-backed JSON queue, Plex naming with Wikipedia/Wikidata year lookups, and a decoupled transcode worker inheriting the downscale-videos prescription.'
heroImage: '../../../public/project/dvd-backup-pipeline.svg'
relatedPosts: ['dvd-backup-pipeline', 'downscale-videos']
---

**DVD Backup Pipeline** automates turning personal DVD backups into a Plex-ready streaming library. Rip and encode run as separate workers connected by a disk-backed queue — the drive ejects as soon as raws land, encoding continues in the background, and the human does the only thing machines can't: load the tray.

**[Source on GitHub](https://github.com/superdave2u/dvd-backup-pipeline)**

## Highlights

- **Decoupled two-worker design:** rip worker (identify → classify movie/TV → Plex metadata → MakeMKV → queue → eject) and encode worker (claim oldest → HandBrake/ffmpeg → atomic move into the movie share or `Show/Season NN` layout).
- **A queue you can operate by hand:** `pending/`, `claimed/`, `failed/` JSON items — failed raws park for retry by moving a file back to pending; no database, no daemon.
- **Metadata without API keys:** movie vs. TV-season classification, per-title episode ripping, and missing years resolved from Wikipedia/Wikidata with caching (`year-cache.json`), plus optional `movie-map.csv` / `tv-map.csv` overrides.
- **One streaming baseline:** `bin/transcode.py` is the single source of truth — MKV, x264, 720p ceiling with no upscaling, 24 fps cap, CRF 20 or two-pass target sizes (1.4 GB movie / 450 MB episode); the PowerShell drive-facing watcher (`dvdbot.ps1`) mirrors it with HandBrakeCLI, with the divergences documented setting-by-setting.
- **Composed with downscale-videos:** directory watching and `_downscale.py` inherit that tool's decide-then-act standardization, so the whole library converges on one household prescription.
- **Library tooling included:** `scrub-titles` (year backfill with dry-run), `combine`, `conform` (transcode anything off-baseline), `sync`.
