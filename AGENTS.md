# AGENTS.md — Dave Mainville's personal site (davemainville.com)

Astro 4 static site. This repo is the hub for Dave's projects and experiments; each featured experiment gets a blog post plus a Projects entry. Run `bun run build` (there is no `npm`; node is v12 and only useful for trivial scripts — `bun` at `/snap/bin/bun` is the runtime).

## Publish workflow (established pattern)

When Dave says "publish this experiment" (gives a GitHub repo URL):

1. **Visibility + sensitivity check FIRST (standing rule).**
   - Check unauthenticated `GET api.github.com/repos/<owner>/<repo>`; 404 means private.
   - If private: pull every file (`gh api repos/.../contents/<path> --jq .content | base64 -d`) AND scan **all historical blobs** (`git rev-list --objects --all` + `git cat-file blob`) for tokens/secrets (`api[_-]?token`, `Bearer <literal>`, `[a-f0-9]{40}`, `.env`, sqlite/db dumps). Benign hash-only hits (e.g. PyPI sha256 in lockfiles) are fine.
   - Assumption: publishing implies the repo should be public. If clean, flip it: `gh repo edit <owner>/<repo> --visibility public` (add `--description "..."` if missing).
   - If findings are ambiguous, ask Dave before flipping.
2. **Set the date rule (standing rule).** Post frontmatter `pubDate` = the featured repo's **most recent commit** date (`GET /commits/<default_branch>`), not the publish date. Exception: if the repo is modified as part of publishing, use the last commit **before** the publishing-related modification. Project entries have no pubDate.
3. **Create three artifacts:**
   - Hero SVG in `public/project/<slug>.svg` (1020×510, hand-drawn, site palette: `--accent #2337ff`, blues/cyans `#4fc3dd`/`#4f6bff`, plus per-project colors; no stock photos).
   - Blog post `src/content/blog/<slug>.md` — frontmatter: title, description, pubDate, heroImage (`/project/<slug>.svg`), tags. First-person, warm, tells the story + the technology honestly (research the actual code/repo — cite real functions, patterns, defaults).
   - Project entry `src/content/project/<slug>.md` — frontmatter: title, description, heroImage (`../../../public/project/<slug>.svg`), `relatedPosts: ['<post-slug>'...]`. Body: one-line pitch, bold links to live demo and/or repo, "## Highlights" bullet list.
   - Note: no live demo (CLI/Python tools) → link repo only.
4. **Cross-link:** `relatedPosts` renders automatically on project pages; tags render as pills and generate `/blog/tag/<tag>/` pages automatically (no manual page creation).
5. **Verify before pushing:** `bun run build`, then grep `dist/` for the new `<title>`s, tag pages, and cross-link hrefs. For p5/web experiments, verify in a real browser via headless Chrome CDP (see quirks below).
6. **`git status --short` must be EMPTY of untracked files before pushing.** The `Deploy Vite.js site to Pages` workflow builds the site on every push to main; committing content without its `public/project/<slug>.svg` hero asset (or any artifact split across commits) fails CI publicly. A push is only done when the build can go green.
7. **Commit style:** repo follows short `feat:`/`chore:`/`fix:` messages. Fetch before push; transient DNS failures happen — retry the push.

## Tag inventory (auto-generated pages — reuse these before inventing new ones)

`javascript, games, family, side-projects, accessibility, vue, p5js, ux, python, google-api, design-patterns, personal-finance, estimation, react, typescript, ffmpeg, home-lab, sqlite, automation`

Blog schema: title, description, pubDate, updatedDate?, heroImage?, tags (default []). Project schema: title, description?, heroImage?, relatedPosts? (references to blog slugs).

## Published so far (post slug → repo → pubDate)

| Post slug | Repo | pubDate |
|---|---|---|
| bubble-pop | bubble-pop | Aug 14 2026 |
| household-budget | household-budget-tracker | Oct 18 2024 |
| hourly-estimate-calculator | hourly-estimate-calculator | Sep 12 2025 |
| contact-list-cleanup | contact-list-cleanup | Aug 11 2023 |
| progress-bar-experiment | progress-bar-experiment | Jan 29 2026 (commit before the publishing-day platform rebuild) |
| visual-timer | visual-timer | Mar 22 2026 |
| downscale-videos | downscale-videos | May 25 2026 (repo flipped public at publish) |
| todoist-workflowy-transfer | todoist-workflowy-transfer | Aug 13 2026 (repo flipped public at publish) |
| coming-home | coming-home | Aug 20 2026 |
| good-judgments-workshop | good-judgments-workshop | Sep 03 2026 |
| google-photos-audit | google-photos-audit | Sep 03 2026 (repo flipped public at publish) |
| rpg-training-platform | rpg-training-platform | Sep 03 2026 |
| waveshare-todoist-panel | waveshare-todoist-panel | Sep 14 2026 (in development; SSID in ERROR.md left as-is per Dave) |
| fire-target-tracker | fire-target-tracker | Sep 23 2026 (spec-only repo, no code — companion to fire-and-strike) |
| dvd-backup-pipeline | dvd-backup-pipeline | Sep 23 2026 (repo flipped public at publish; uses downscale-videos) |
| fire-and-strike | fire-and-strike | Sep 24 2026 |
| proof | proof | Sep 25 2026 |

## Environment quirks (learned the hard way)

- `bun run build` works; `npm`/`npx` don't exist. Node v12.22.9 — too old for modern Playwright.
- Headless Chromium: `/home/wsl/.cache/ms-playwright/chromium-1243/chrome-linux64/chrome` (libs resolve; use `--headless=new --no-sandbox --disable-dev-shm-usage`).
- bun is snap-confined: HOME redirects (`/home/wsl/snap/bun-js/...`), Playwright browsers not found without `PLAYWRIGHT_BROWSERS_PATH=/home/wsl/.cache/ms-playwright`, and module loads from `/tmp` fail (copy scripts into the project dir).
- `pkill -f <pattern>` self-matches the bash command line if the pattern text appears later in the same command — bracket the pattern (`pkill -f "[r]emote-debugging"`) and keep pkill in its own command.
- Headless `--virtual-time-budget` does NOT advance p5's rAF loop in `--headless=new`; deterministic logic testing works with a Node harness (stub p5 globals + fake DOM as function parameters, drive `setup()`/`draw()` with a fake clock), and end-to-end verification via CDP websocket (bun has built-in WebSocket): launch chrome with `--remote-debugging-port`, connect, `Runtime.evaluate`.
- p5 gotcha found in the wild: p5 globals (`min`, `max`, `sqrt`) attach to window only after p5 boots — top-level sketch code calling them kills the script; use `Math.*` in p5-adjacent top-level code.
- git push via SSH occasionally hits transient DNS failure — retry once.

## Key paths

- Site repo: `/home/wsl/website-davemainville-com` (this file's root)
- Cloned experiment repos live as siblings: e.g. `/home/wsl/progress-bar-experiment`
- Layouts: `src/layouts/BlogPost.astro` (renders date + tag pills; shared by project pages); tag pages: `src/pages/blog/tag/[tag].astro`; relatedPosts rendering: `src/pages/project/[...slug].astro`
