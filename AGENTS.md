# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this is

An Obsidian vault template (Markdown notes plus `.obsidian/` config) built around Obsidian Bases: a project & task tracker with a kanban board and a dashboard. There is no code, build, lint, or test step. Work here means creating and editing Markdown notes and `.base` files in a way the Obsidian app handles cleanly.

Unless the vault owner has enabled Obsidian Sync or git history of their own, edit history may be limited to the File Recovery core plugin. Treat destructive edits (deletes, renames) accordingly.

## Layout

- `Projects/<Note>.md` — one note per project (flat, no subfolders). Each ends with a `## Tasks` section embedding `![[Tasks.base#Project Tasks]]`.
- `Tasks/<Note>.md` — one note per task, linked to its project via the `project` frontmatter property (a wikilink), **not** folder placement.
- `Attachments/` — images referenced by notes, saved here automatically (`app.json` → `attachmentFolderPath`).
- `Templates/Task.md`, `Templates/Project.md` — starting frontmatter for new notes (Templates core plugin folder is `Templates/`).
- `Projects.base`, `Tasks.base` — the tracker's view/formula definitions.
- `Dashboard.md` — home note embedding the key base views; forced into reading view via `obsidianUIMode: preview` frontmatter (Force note view mode plugin).
- `.obsidian/` — app configuration (see below).

## Project & task tracker (Bases)

- Task frontmatter: `status`, `project` (wikilink to the owning project note), `owner`, `tags`, `due`, plus optional `summary`.
- **Task statuses** (exact strings — kanban columns and view filters depend on them): `Backlog`, `Up Next`, `In progress`, `Done`, `Cancelled`.
- **Project statuses:** `Not started`, `In progress`, `Ongoing`, `Done`.
- Project frontmatter: `status`, `summary`, `latest`. Done/Total/Open/Progress % are **not** stored — `Projects.base` computes them live via formulas over `file.backlinks`, counting only tasks whose `project` property resolves back to that project note (not folder-based backlinks, since task bodies may link to other projects in prose).
- `file.backlinks`-based formulas do not live-refresh reliably right after a bulk external write (e.g. a script creating/editing many notes outside the app). If `Projects.base` shows stale/undercounted numbers, fully quit and relaunch Obsidian to force a re-index rather than assuming the formula is wrong.
- If you rename or add a status, update it everywhere at once: task frontmatter, `Tasks.base` view filters, and `columnOrders`. The strings must match exactly.
- `due` has its property type set to `date` in `.obsidian/types.json`; keep it there so empty values don't fall back to plain text.
- Tasks tagged `bug` surface in the dashboard's Bugs view.

## Obsidian conventions that apply here

- Links are wikilinks: `[[Note Name]]` resolves by filename anywhere in the vault, no path needed unless two notes share a name. Renaming a note on disk breaks inbound links; either rename inside Obsidian or update every `[[...]]` reference yourself.
- Note metadata lives in YAML frontmatter (Properties core plugin is on). Bases filter and display those properties, so keep property names consistent across notes meant to show up in the same base.
- Daily notes are enabled with default settings: `YYYY-MM-DD.md` at the vault root.
- The Natural Language Dates community plugin is installed (trigger `@`, output format `YYYY-MM-DD`). Write dates in that format so they match what the plugin inserts.
- Banners plugin: give a note a cover image with `banner: "![[Attachments/image.jpg]]"` frontmatter. Banners render **only in reading view**, not in editing/Live Preview.
- Force note view mode plugin: `obsidianUIMode: preview` (or `source`) in frontmatter forces a note's view mode.

## `.obsidian/` config

- `workspace.json` — UI state, rewritten constantly by the app. Never hand-edit; it is gitignored.
- `core-plugins.json`, `community-plugins.json` — which plugins are enabled. Community plugin builds are vendored in `.obsidian/plugins/` so the template works on first launch.
- `plugins/<id>/data.json` — per-plugin settings.
- `types.json` — explicit property types (`due` is `date`).
- `snippets/wide-embeds.css` — full-width embeds for notes with `cssclasses: [wide-embeds]` (the dashboard uses this).
- `app.json`, `appearance.json`, `templates.json`, `bookmarks.json` — app settings; change only when asked.
