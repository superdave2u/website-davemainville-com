---
title: 'The Monkey in the Middle: Ripping 400 DVDs Without Losing My Mind'
description: 'I carried 400+ DVDs for decades promising to rip them for my home streaming system. The volume killed every attempt — until I turned myself into a human-in-the-middle disc loader and automated everything else: Plex naming with Wikipedia year lookups, and a disk-backed queue that decouples ripping from transcoding.'
pubDate: 'Sep 23 2026'
heroImage: '/project/dvd-backup-pipeline.svg'
tags: ['automation', 'home-lab', 'ffmpeg', 'powershell']
---

For decades I carried around more than 400 DVDs, always telling myself I'd rip them into my home media streaming system. The sheer volume made the task impossible to pick up — every approach started with a weekend of heroic encoding that never arrived. The breakthrough was accepting a humble truth: **the machine can't load the tray, but I can.** So I turned myself into a human in the middle — a monkey to load a DVD tray — and automated everything else.

The result is [dvd-backup-pipeline](https://github.com/superdave2u/dvd-backup-pipeline): lawful personal-backup DVD automation that evolved from a simple "watch the drive bay and rip what it finds" script into a two-worker pipeline with metadata lookup and a decoupled transcode queue.

## The evolution

**Stage one: watch and rip.** The first version monitored the drive bay, ripped what it found, encoded, filed. The fatal flaw was coupling: the DVD drive sat hostage for the whole encode (an hour+ per disc), so throughput was bounded by patience, and the tray spent most of its time empty and waiting.

**Stage two: decouple rip from transcode.** The core insight of the pipeline: **ripping and encoding are separate workers connected by a disk-backed queue.** The rip worker identifies the disc, classifies it as a movie or TV season, resolves Plex metadata, rips every selected title to raw MKVs with MakeMKV, publishes encode items to the queue — and **ejects the disc immediately**. The encode worker (auto-started in a second console) claims the oldest queued item and encodes in the background while I'm already loading the next disc. My job is reduced to tray-loading; the queue absorbs the speed mismatch between a disc drive and an encoder.

**Stage three: metadata without an API key.** Classification produces Plex-perfect names — `Movie (Year).mkv` for a movie's longest main feature; `Show\Season 01\Show - S01E01 - Episode Title.mkv` for a TV season (episodic labels or several similar runtimes tip it off; multi-disc seasons get `-Season`/`-StartEpisode` overrides). Missing years are filled from **Wikipedia/Wikidata lookups** — no API key needed — cached in `year-cache.json`, with optional `movie-map.csv`/`tv-map.csv` overrides for the discs that need human truth.

## The engineering details

- **Two runtimes, one baseline.** The drive-facing watcher is PowerShell + HandBrakeCLI (Windows, where the drive lives); the cross-platform baseline is Python + ffmpeg (`bin/transcode.py` — the *single source of truth* for the streaming profile). The repo's docs compare them setting by setting: CRF 20 + bitrate caps vs. two-pass ABR sized to a 1.4 GB movie / 450 MB episode target, 720p ceiling with no upscaling, detelecine, interlaced-only deinterlacing, first-audio-track AAC, subtitles copied, metadata and chapters preserved.
- **A queue you can operate with your hands.** Queue items are JSON files in `pending/`, `claimed/`, `failed/`. A failure parks the raws in `queue\failed` for manual retry (move the JSON back to pending; delete both to abandon). No database, no daemon — you can fix the pipeline with a file explorer.
- **Standardization by composition.** Encoding inherits the prescription from my [downscale-videos](/blog/downscale-videos/) project — `bin/_downscale.py` and a directory watcher lean on that tool's decide-then-act logic, so anything entering the library conforms to the same household streaming standard.
- **The remaining bin tools** round out the library: `scrub-titles` (backfill missing years with a dry-run preview), `combine`, `conform` (scan a directory, transcode anything off-baseline, replace only after a successful encode), and `sync`.

## What it taught me

The bottleneck of a 400-disc archive was never encoding — it was **attention**. Decoupling stages so the expensive resource (me) only does the one thing machines can't (load the tray) converted a dreaded weekend project into a background behavior: a disc or two in the evening, the queue drains overnight, the shelf grows. The other lesson is that queues beat pipelines for physical-world work — eject-on-rip means the drive's duty cycle is mine to control, and `failed/` means errors are a parking lot, not a crash. Somewhere between stage one and stage three, "I should really rip those DVDs" became a system that finishes the thought for me.
