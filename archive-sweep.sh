#!/usr/bin/env bash
# archive-sweep.sh — move retired tracker notes into their Archive folders.
#
# Sweeps this vault per the archiving system:
#   Tasks/*.md    with a swept task status     ->  Tasks/Archive/
#   Projects/*.md with a swept project status  ->  Projects/Archive/
#
# "Done" is never swept — Done stays visible for retrospectives; only
# explicitly retired statuses are archive-eligible.
#
# Moves are pure renames (git mv): filenames don't change, so wikilinks and
# Projects.base backlink counts survive.
#
# Usage (from the vault root, or anywhere — it operates on the vault
# containing this script):
#   ./archive-sweep.sh            # dry run: list what would move
#   ./archive-sweep.sh --apply    # actually git mv the files
#
# Commit afterwards yourself; the script never commits.

set -euo pipefail

TASK_SWEEP_STATUSES="Finished|Cancelled"
PROJECT_SWEEP_STATUSES="Finished"

vault="$(cd "$(dirname "$0")" && pwd)"
apply=0
[[ "${1:-}" == "--apply" ]] && apply=1

[[ -d "$vault/Tasks" ]] || { echo "error: $vault/Tasks not found — is this a tracker vault?" >&2; exit 1; }

# Print a note's frontmatter status: scalar (status: X) or first list item
# (status:\n  - X), quotes stripped, typographic apostrophe normalized.
note_status() {
  awk '
    NR==1 { if ($0 != "---") exit; infm=1; next }
    infm && $0=="---" { exit }
    infm && /^status:/ {
      val=$0; sub(/^status:[ \t]*/, "", val)
      if (val == "") {
        if (getline > 0 && $0 ~ /^[ \t]*-[ \t]/) { val=$0; sub(/^[ \t]*-[ \t]*/, "", val) }
        else exit
      }
      gsub(/^["'\''"]|["'\''"]$/, "", val)
      print val; exit
    }
  ' "$1" | tr '\xE2\x80\x99' "'"
}

sweep() {
  local folder="$1" statuses="$2" f s moved=0
  local archive="$vault/$folder/Archive"
  for f in "$vault/$folder"/*.md; do
    [[ -e "$f" ]] || continue
    s="$(note_status "$f")"
    case "|$statuses|" in
      *"|$s|"*)
        moved=$((moved+1))
        if (( apply )); then
          mkdir -p "$archive"
          git -C "$vault" mv "${f#"$vault"/}" "$folder/Archive/$(basename "$f")"
          echo "moved:  [$s] $folder/$(basename "$f")"
        else
          echo "would move:  [$s] $folder/$(basename "$f")"
        fi
        ;;
    esac
  done
  (( moved )) || echo "nothing to sweep in $folder/"
}

echo "== $vault =="
sweep "Tasks" "$TASK_SWEEP_STATUSES"
sweep "Projects" "$PROJECT_SWEEP_STATUSES"
if (( ! apply )); then
  echo
  echo "(dry run — re-run with --apply to move, then review 'git status' and commit)"
fi
