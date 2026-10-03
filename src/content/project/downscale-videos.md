---
title: 'Downscale Videos'
description: 'A Python + FFmpeg batch normalizer that standardizes video files across my network for streaming — capped resolution, framerate, and audio bitrate, applied only where needed.'
heroImage: '../../../public/project/downscale-videos.svg'
relatedPosts: ['downscale-videos']
---

**Downscale Videos** is my helper tool for videos ripped from DVDs or obtained from other sources, standardizing them across my network for streaming. One prescription — capped resolution (480p), framerate (24 fps), and audio bitrate (96 kbps), plus optional CRF compression — applied recursively and idempotently: compliant files are skipped, originals are replaced only after a successful transcode.

**[Source on GitHub](https://github.com/superdave2u/downscale-videos)**

## Highlights

- **Decide, then act:** probes resolution, framerate, and audio bitrate (MoviePy + ffprobe) and transcodes only the files out of spec — running it twice changes nothing.
- **Never upscales:** a 360p file stays 360p; audio streams are copied untouched unless they exceed the cap.
- **Newest-first batch processing:** `--recursive` walks the tree most-recently-modified first; per-file errors skip and continue.
- **Atomic-ish replacement:** output goes to a `_resized` sibling and is swapped in only on a clean FFmpeg exit.
- **Live progress:** precomputed frame counts and FFmpeg stdout parsing produce a real percent-complete readout per file.
- **Python + FFmpeg CLI** with limit overrides (`--height-limit`, `--rate-limit`, `--bitrate-limit`, `--compression-factor`) and preserved metadata.
