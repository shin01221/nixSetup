#!/usr/bin/env bash
# tuios-theme-hook.bash — Noctalia post_hook for the tuios template.
#
# Why this exists: tuios caches theme files in memory. Re-selecting an
# already-registered theme id does NOT re-read its file (see THEMES.md:
# "Selecting a theme that is already registered does not re-read its file,
# so to see an edit to a theme that is already loaded, save it under a
# new id or restart tuios").
#
# So every time Noctalia renders noctalia.json, we publish it under a
# unique id (noctalia-<timestamp>) and select that id. Selecting an
# unregistered id forces tuios to re-scan the themes directory and apply
# the fresh colors immediately — no restart needed.
set -u

THEMES_DIR="$HOME/.config/tuios/themes"
SRC="$THEMES_DIR/noctalia.json"
TS=$(date +%s)
NEW_ID="noctalia-$TS"
DST="$THEMES_DIR/$NEW_ID.json"

# Nothing rendered (yet) — nothing to do.
[ -f "$SRC" ] || exit 0

command -v python3 >/dev/null 2>&1 || exit 0
python3 - "$SRC" "$DST" "$NEW_ID" "$(date +"%m-%d %H:%M")" <<'EOF' || exit 0
import json, sys
src, dst, nid, label = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
with open(src) as f:
    d = json.load(f)
d["id"] = nid
d["display_name"] = "Noctalia " + label
with open(dst, "w") as f:
    json.dump(d, f, indent=2)
EOF

# Live-apply to every running session. Failures are fine (no daemon,
# standalone mode, etc.) — the config file update below still covers
# the next start.
if command -v tuios >/dev/null 2>&1; then
  SESSIONS=$(tuios ls --json 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    items = data if isinstance(data, list) else data.get('sessions', [])
    print(' '.join(s.get('name', '') for s in items if s.get('name')))
except Exception:
    pass")
  # shellcheck disable=SC2086
  for s in $SESSIONS; do
    tuios set-config appearance.theme "$NEW_ID" -s "$s" >/dev/null 2>&1 || true
  done
  tuios set-config appearance.theme "$NEW_ID" >/dev/null 2>&1 || true
fi

# Persist the new id in config.toml as well. set-config already writes it
# when a client is attached, but not otherwise — so do it directly.
# Only the `theme` key inside [appearance] is touched; comments kept.
python3 - "$HOME/.config/tuios/config.toml" "$NEW_ID" <<'EOF' || true
import re, sys
path, nid = sys.argv[1], sys.argv[2]
try:
    with open(path) as f:
        text = f.read()
except FileNotFoundError:
    sys.exit(0)
out, in_appearance, changed = [], False, False
for line in text.splitlines(keepends=True):
    if re.match(r"\s*\[appearance\]\s*$", line):
        in_appearance = True
    elif re.match(r"\s*\[", line):
        in_appearance = False
    if in_appearance and not changed:
        m = re.match(r"^(\s*theme\s*=\s*)['\"].*?['\"](\s*(#.*)?)$", line.rstrip("\n"))
        if m:
            eol = "\n" if line.endswith("\n") else ""
            line = f"{m.group(1)}'{nid}'{m.group(2)}{eol}"
            changed = True
    out.append(line)
if changed:
    with open(path, "w") as f:
        f.writelines(out)
EOF

# Keep the newest few versions for the picker and cold starts; drop the rest.
# The stable noctalia.json is never matched by this pattern and is kept.
ls -t "$THEMES_DIR"/noctalia-[0-9]*.json 2>/dev/null | tail -n +4 | xargs -r rm -f
exit 0
