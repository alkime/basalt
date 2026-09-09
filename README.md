# Basalt

A project & task tracker template for [Obsidian Bases](https://help.obsidian.md/bases) — kanban board, live project progress, and a single dashboard, all in plain Markdown.

Like its namesake, it's what you get when the molten backlog cools into something solid.

## What you get

- **`Dashboard.md`** — one bookmarked home note: in-flight kanban, active projects, up next, done, bugs, recently edited. Opens in reading view automatically.
- **`Tasks.base`** — a drag-and-drop kanban board plus table views (All, Up Next, Bugs, Done, Recently edited), driven entirely by note frontmatter.
- **`Projects.base`** — projects with **live Done / Open / Progress %** computed from task backlinks; no counts are ever stored or updated by hand.
- **Templates** for new project and task notes.

## Requirements

- Obsidian **1.9+** (Bases core plugin).
- Community plugins are bundled in `.obsidian/plugins/` and pre-enabled — on first launch, Obsidian will ask you to trust the vault and enable community plugins. Say yes and everything works out of the box.

## Easiest way to use this

With the [GitHub CLI](https://cli.github.com/) installed:

```sh
gh repo create my-vault --template alkime/basalt --private --clone
open my-vault
```

Then in Obsidian: **Open folder as vault** → pick the folder, and enable community plugins when prompted. That first open registers the vault; from then on you can jump straight to it from a terminal with:

```sh
open "obsidian://vault/my-vault"
```

No `gh`? See below.

## Getting started

1. Click **Use this template** on GitHub — or, with no git at all, **Code → Download ZIP** and unzip it.
2. In Obsidian: **Open folder as vault** → pick the cloned folder.
3. When prompted, enable community plugins.
4. Open `Dashboard.md` (it's bookmarked) and start replacing the sample projects and tasks with your own.

## How it works

- One note per task in `Tasks/`, one per project in `Projects/`. A task belongs to a project via its `project` frontmatter property (a wikilink like `[[Website Redesign]]`) — not folder placement.
- **Task statuses:** `Backlog`, `Up Next`, `In progress`, `Done`, `Cancelled`. The kanban columns and dashboard views key off these exact strings.
- **Project statuses:** `Not started`, `In progress`, `Ongoing`, `Done`.
- Tag a task `#bug` (or `tags: [bug]`) and it appears in the dashboard's Bugs section.
- Each project note embeds `Tasks.base#Project Tasks`, which filters to tasks whose `project` link resolves to that note. Hitting **+ New** in that embedded view creates the task with its `project` property already pointing at the project you're in.
- Drag cards between kanban columns to change a task's status; use the board's **+** to quick-add a task into a column.

> [!note]
> Project progress is computed from `file.backlinks`. If you create or edit many notes *outside* Obsidian (scripts, git pulls) and the numbers look stale, fully quit and relaunch Obsidian to force a re-index.

## Customizing

- **Statuses:** rename them in task frontmatter *and* in the `Tasks.base` view filters/`columnOrders` — the strings must match exactly.
- **New views:** add them in the Bases UI or by editing the `.base` YAML; embed any view in a note with `![[Tasks.base#View Name]]`.
- **Vault color:** the bundled `peacock.css` snippet extends your accent color (Settings → Appearance → Accent color) onto the window chrome — Peacock-style — so each vault built from this template is recognizable at a glance. Pick a different accent per vault; delete the snippet if you'd rather keep stock chrome.
- **Banners & icons:** the Pixel Banner and Iconic plugins are included. Give any note a cover image with `banner: "![[Attachments/your-image.jpg]]"` frontmatter or the banner-flag icon on the note (adjust the crop with `banner-y: 0–100`), and set per-file icons via Iconic. Add `obsidianUIMode: preview` to make a note always open in reading view.
- **Dates:** type `@` for natural-language dates (`@tomorrow` → `2026-09-09`).

## Bundled community plugins

| Plugin | Purpose |
|---|---|
| [Kanban Bases View](https://obsidian.md/plugins?id=kanban-bases-view) | Drag-and-drop kanban view for Bases |
| [Columns](https://obsidian.md/plugins?id=obsidian-columns) | Side-by-side layout on the dashboard |
| [Force note view mode](https://obsidian.md/plugins?id=obsidian-view-mode-by-frontmatter) | `obsidianUIMode` frontmatter → dashboard opens in reading view |
| [Pixel Banner](https://obsidian.md/plugins?id=pexels-banner) | Cover images via `banner` frontmatter or its banner-flag GUI |
| [Iconic](https://obsidian.md/plugins?id=iconic) | Per-file/tab/folder icons |
| [Natural Language Dates](https://obsidian.md/plugins?id=nldates-obsidian) | `@`-triggered date entry |
| [Single Choice Property](https://obsidian.md/plugins?id=single-choice-property) | Keeps list properties to one value |
| [Bases Toolbox](https://obsidian.md/plugins?id=bases-toolbox) | Find & replace property values, property index |

Bundled plugin builds remain under their respective authors' licenses.

## License

MIT — see [LICENSE](LICENSE). Template only; bundled plugins belong to their authors.
