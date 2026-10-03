---
title: 'Waveshare Todoist Panel'
description: 'A dedicated Todoist dashboard on a Waveshare ESP32-S3 reflective LCD — always-on, standalone, and built by stewarding LLM agents through a bench-handoff development loop. In development.'
heroImage: '../../../public/project/waveshare-todoist-panel.svg'
relatedPosts: ['waveshare-todoist-panel']
---

**Waveshare Todoist Panel** is a dedicated Todoist dashboard built around the Waveshare ESP32-S3-RLCD-4.2: tasks, saved views, and filter results on a 400×300 reflective LCD that's readable by ambient light, navigated by physical buttons, always on the desk. Still in development — and the first hardware project built by stewarding LLM agents.

**[Source on GitHub](https://github.com/superdave2u/waveshare-todoist-panel)**

## Highlights

- **Standalone appliance:** connects directly to Todoist over Wi-Fi — no companion computer, no phone, no server; manual and periodic refresh with cached data surviving transient failures.
- **Reflective LCD, no backlight:** ST7305 controller at 400×300 monochrome via U8g2, fast refresh like e-paper without the lag, ~15 KB framebuffer.
- **Built by stewardship:** a seeded bead backlog (`docs/SPEC.md`), an agent loop (`harness/ralph.sh`) that claims beads and hands work to an LLM, a compile gate (`pio run` + native tests), and bench handoffs — the agent flashes, Dave verifies on hardware, confirm-or-feedback, rerun.
- **Onion-architecture firmware:** domain and application layers independent of Arduino, Wi-Fi, HTTPS, and U8g2; test-first native tests run without hardware; `main.cpp` as composition root.
- **Secrets discipline enforced by design:** gitignored `secrets.h`, `#error` build guard, agent guardrails against printing or committing credentials — verified clean across 123 commits.
- **Phases 1–6 complete:** hardware bring-up, Wi-Fi with auto-reconnect, Todoist API with pagination, application model, filter selector with arbitrary query strings; phase 7 (task display) in progress.
