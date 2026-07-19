# CLAUDE.md

Guidance for AI agents working in this repo.

## What this is
`fix-my-windows` is a zero-install, CLI-based Windows diagnostic/repair toolkit (Win 7-11) for
IT pros and power users. There is no build, no package manager, no dependencies. The "app" is a
folder of `.bat` files driven by `Start_Menu.bat`, plus a static marketing site (`index.html`,
`docs.html`) and a bootstrap script (`run.ps1`).

## Live deployment
- Served from **Cloudflare Pages** at https://fix-my-windows.pages.dev/, auto-deployed from `main`.
- `run.ps1` downloads a zip of `main` from GitHub **at runtime** (`irm .../run.ps1 | iex`). This
  means pushing to `main` immediately changes what every user's one-liner installer fetches next
  time they run it — `main` is production, not just a source branch. There is no staging.
- `index.html` and `docs.html` are static files (Tailwind via CDN, no bundler). Edits are live on push.

## Architecture
- `run.ps1` — bootstrap loader: downloads repo zip, extracts to `%TEMP%`, launches `Start_Menu.bat`,
  cleans up after. Must stay Windows 7-compatible (uses `WebClient`, not `Invoke-WebRequest`; forces
  TLS 1.2 explicitly).
- `Start_Menu.bat` — self-elevating (UAC), 3-page paginated menu using `choice`. Each page uses
  `goto` labels and `if errorlevel N` chains (checked highest-to-lowest — order matters). Also
  disables Console QuickEdit Mode (`HKCU\Console\QuickEdit`) before the elevation relaunch, so
  clicking inside the window doesn't freeze long-running SFC/DISM/CHKDSK output until a keypress —
  fixed once here rather than per-module, since every module shares this console.
- `modules/*.bat` — one module per file, numbered by original addition order (not display order).
  Module numbering has drifted from menu key letters (e.g. `22_reboot.bat` vs `22_uac_integrity.bat`)
  — always check `Start_Menu.bat` for what a menu key actually calls, don't assume from the filename number.
  Some modules generate a temp PowerShell payload for interactive/richer UX (e.g. `27_firewall_manager.bat`).

## Website (index.html / docs.html)
- `docs.html` fetches `README.md` at runtime and renders it client-side via `marked` + Tailwind
  Typography (`prose`), instead of linking straight to the raw `.md` file (which browsers show as
  unstyled plain text on Cloudflare Pages).
- Light/dark theming is **automatic only** — driven by `prefers-color-scheme`, no manual toggle, no
  localStorage. Implemented via CSS custom properties (`--color-cli-900/800/700/blue`,
  `--color-gray-300..600`, `--color-white`) declared in a `<style>` block and wired into
  `tailwind.config`'s `colors` using the `rgb(var(--x) / <alpha-value>)` pattern, so existing
  opacity-modifier classes (`bg-cli-800/50`, `border-cli-blue/40`, etc.) keep working unmodified.
  A `@media (prefers-color-scheme: light)` block overrides the same variables — never hardcode a
  new color utility (`text-green-400`, `bg-slate-900`, ...) that bypasses these variables, it won't
  flip between themes and will likely fail contrast in one of them. `docs.html`'s markdown article
  uses `dark:prose-invert` (not bare `prose-invert`) for the same reason, relying on Tailwind's
  default `media`-strategy dark mode.
- SEO/AI-discoverability files at repo root: `robots.txt`, `sitemap.xml`, `llms.txt` (llms.txt spec),
  plus JSON-LD (`SoftwareApplication` + `FAQPage`) in `index.html`'s `<head>`. The FAQ JSON-LD must
  stay in sync with the visible `<details>` FAQ section — Google requires matching visible content
  for FAQ rich results, hidden-only schema doesn't qualify.
- **`.gitignore` has a blanket `*.txt` rule** (meant for scratch/log notes), with explicit
  `!robots.txt` / `!llms.txt` negations to un-ignore those two. If you add another root-level
  `.txt` file that needs to be live (another crawler-facing file, etc.), add a matching `!` negation
  — otherwise it'll sit locally forever, `git status` will show nothing, and Cloudflare Pages will
  silently never see it. This exact bug shipped `robots.txt`/`llms.txt` as dead files for a while.
- `SOURCES.md` maps each module to the official Microsoft Learn/Support article (or third-party
  source, e.g. LibreHardwareMonitor) it's based on. The module grid on `index.html` links each
  module tag straight to its `SOURCES.md` entry's URL. When adding a module whose tag appears in
  the grid, add a verified (not guessed) official source row to `SOURCES.md` and link the tag —
  never publish an unverified outbound URL.

## Hard constraints — do not violate
- **CRLF line endings on all `.bat` files.** LF breaks `goto` labels in `cmd.exe`. If your editor
  or `git diff` shows a `.bat` file flipping to LF, fix it before committing (`.gitattributes`
  already forces CRLF for batch files — don't fight it or add overrides).
- **Windows 7-11 compatibility.** No PowerShell cmdlets that don't exist on Win 7/PS 2.0-5.1
  (e.g. no `Expand-Archive`, no `Invoke-WebRequest -UseBasicParsing` assumptions) unless the module
  already branches by OS version. Prefer WMIC/COM fallbacks where the codebase already does.
- **Non-destructive by default.** Every module that changes state needs a `choice`/confirmation
  prompt before acting. No silent deletes, no silent registry writes beyond read-only `reg query`
  audits. Preserve static IPs and Group Policy settings — never force DHCP.
- **No admin-check bypass.** Modules run under an elevated `Start_Menu.bat`; don't add modules that
  assume non-elevated context or skip the elevation check.

## Adding or editing a module
1. Follow the existing pattern: `@echo off`, a menu/confirmation via `choice`, clear `echo` status
   lines per step (`[1/N] Doing X...`), and graceful Win7/Win10+ branching where APIs differ.
2. Wire it into `Start_Menu.bat`: add the `echo [X] ...` menu line, extend the `choice /c` string,
   and add the matching `if errorlevel N call ".\modules\NN_name.bat" & goto :MenuLabel` line —
   remember errorlevel checks must stay ordered highest-to-lowest.
3. Update `README.md`'s folder structure list and module reference table to match. If the module
   should appear in `index.html`'s module grid, add a verified official source to `SOURCES.md` and
   link the tag to it.
4. If it writes files, use `/Reports` (read-only exports) or `/Backups` (registry/config backups)
   per existing convention.

## Testing
There's no CI/automated test harness — this is batch scripting for real Windows machines. Sanity
check by reading through the logic path by hand (elevation → confirmation → action → status output)
and verifying CRLF endings. If you have access to a Windows VM, actually run the module.
