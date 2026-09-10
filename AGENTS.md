# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this is

An Obsidian vault template (Markdown notes plus `.obsidian/` config) built around Obsidian Bases: a project & task tracker with a kanban board and a dashboard. There is no code, build, lint, or test step. Work here means creating and editing Markdown notes and `.base` files in a way the Obsidian app handles cleanly.

Unless the vault owner has enabled Obsidian Sync or git history of their own, edit history may be limited to the File Recovery core plugin. Treat destructive edits (deletes, renames) accordingly.

## Layout

- `Projects/<Note>.md` — one note per project (flat, no subfolders). Each ends with a `## Tasks` section embedding `![[Tasks.base#Project Tasks]]`.
- `Tasks/<Note>.md` — one note per task, linked to its project via the `project` frontmatter property (a wikilink), **not** folder placement.
- `Tasks/Archive/<Note>.md` — archived (`Finished`/`Cancelled`, never merely `Done`) tasks, viewed through `TaskArchive.base`.
- `Projects/Archive/<Note>.md` — archived (`Finished`) projects, viewed through `ProjectArchive.base`.
- `Attachments/` — images referenced by notes, saved here automatically (`app.json` → `attachmentFolderPath`).
- `Templates/Task.md`, `Templates/Project.md` — starting frontmatter for new notes (Templates core plugin folder is `Templates/`).
- `Projects.base`, `Tasks.base`, `TaskArchive.base`, `ProjectArchive.base` — the tracker's view/formula definitions.
- `Dashboard.md` — home note embedding the key base views; forced into reading view via `obsidianUIMode: preview` frontmatter (Force note view mode plugin).
- `.obsidian/` — app configuration (see below).

## Project & task tracker (Bases)

- Task frontmatter: `status`, `project` (wikilink to the owning project note), `owner`, `tags`, `due`, plus optional `summary`.
- **Task statuses** (exact strings — kanban columns and view filters depend on them): `Backlog`, `Up Next`, `In progress`, `Done`, `Finished`, `Cancelled`.
- **Project statuses:** `Not started`, `In progress`, `Ongoing`, `Done`, `Finished`.
- **`Done` vs `Finished`:** `Done` means completed but deliberately still visible — it is the retrospective window (looking back at what got accomplished recently). `Finished` means retired: reviewed, no longer interesting day-to-day, and archive-eligible. Never treat them as synonyms or auto-promote `Done` to `Finished`. The By Status (In Flight) board deliberately shows only `Up Next`/`In progress`/`Done` — `Finished` work is retired and stays off it; set `Finished` via the status property at retro time. Obsidian's status-value suggestions are usage-derived (there is no configured option list), so `Finished` appears in the property dropdown once any note uses it.
- Project frontmatter: `status`, `summary`, `latest`. Done/Total/Open/Progress % are **not** stored — `Projects.base` computes them live via formulas over `file.backlinks`, counting only tasks whose `project` property resolves back to that project note (not folder-based backlinks, since task bodies may link to other projects in prose).
- `file.backlinks`-based formulas do not live-refresh reliably right after a bulk external write (e.g. a script creating/editing many notes outside the app). If `Projects.base` shows stale/undercounted numbers, fully quit and relaunch Obsidian to force a re-index rather than assuming the formula is wrong.
- If you rename or add a status, update it everywhere at once: task frontmatter, `Tasks.base` view filters, and `columnOrders`. The strings must match exactly.
- `due` has its property type set to `date` in `.obsidian/types.json`; keep it there so empty values don't fall back to plain text.
- Tasks tagged `bug` surface in the dashboard's Bugs view.
- **Archiving:** once a task is `Finished` (or `Cancelled`), move its note into `Tasks/Archive/`, changing nothing else — `Done` tasks stay put until they've been retired. The bases filter on the exact parent folder (`file.folder == "Tasks"`), so the moved task drops out of every task view — kanban and the project notes' `## Tasks` embeds included — while its filename (and therefore its `project` wikilink and all inbound links) is unchanged, so `Projects.base`'s backlink-based counts still include it. `TaskArchive.base` mirrors the shape of `Tasks.base` over the archive folder; its `Project Tasks` view can be embedded in a project note (`![[TaskArchive.base#Project Tasks]]`) to show that project's archived tasks. Projects archive the same way: a `Finished` project's note moves to `Projects/Archive/` (viewed through `ProjectArchive.base`, which carries the same count formulas), normally together with archiving its remaining tasks. `archive-sweep.sh` at the vault root automates the sweep: dry run by default, `--apply` performs the moves with `git mv`; it never touches `Done` and never commits — review and commit afterwards. The swept status lists are variables at the top of the script.

## Obsidian conventions that apply here

- Links are wikilinks: `[[Note Name]]` resolves by filename anywhere in the vault, no path needed unless two notes share a name. Renaming a note on disk breaks inbound links; either rename inside Obsidian or update every `[[...]]` reference yourself.
- Note metadata lives in YAML frontmatter (Properties core plugin is on). Bases filter and display those properties, so keep property names consistent across notes meant to show up in the same base.
- Daily notes are enabled with default settings: `YYYY-MM-DD.md` at the vault root.
- The Natural Language Dates community plugin is installed (trigger `@`, output format `YYYY-MM-DD`). Write dates in that format so they match what the plugin inserts.
- Pixel Banner plugin (id `pexels-banner`): give a note a cover image with `banner: "![[Attachments/image.jpg]]"` frontmatter; optional `banner-y` (0–100, default 60) sets the vertical crop position. The plugin supports many more `banner-*` properties and a GUI (flag icon on the note) — prefer the GUI's field names over inventing new ones.
- Force note view mode plugin: `obsidianUIMode: preview` (or `source`) in frontmatter forces a note's view mode.

## `.obsidian/` config

- `workspace.json` — UI state, rewritten constantly by the app. Never hand-edit; it is gitignored.
- `core-plugins.json`, `community-plugins.json` — which plugins are enabled. Community plugin builds are vendored in `.obsidian/plugins/` so the template works on first launch.
- `plugins/kanban-bases-view/main.js` carries a local patch (marked with a `PATCHED (vault-hq)` comment) that reloads column-order preferences when the view config changes, fixing column-order leakage between two kanban views grouped by the same property. Re-apply it if upgrading the plugin, or drop it once fixed upstream.
- `plugins/<id>/data.json` — per-plugin settings.
- `types.json` — explicit property types (`due` is `date`).
- `snippets/wide-embeds.css` — full-width embeds for notes with `cssclasses: [wide-embeds]` (the dashboard uses this).
- `snippets/peacock.css` — Peacock-style vault identification: extends the per-vault accent color (`appearance.json` → `accentColor`, exposed as `--accent-h/s/l`) onto the window chrome (title bar, tab bar, ribbon, status bar). The snippet is identical across vaults; only each vault's accent color differs, so never hard-code a color into it.
- `app.json`, `appearance.json`, `templates.json`, `bookmarks.json` — app settings; change only when asked.
