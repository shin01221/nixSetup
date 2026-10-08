#!/bin/sh
# Center dock cell: the current workspace as a latin-style (Roman) numeral
# in the active theme's accent color, occupied workspaces as numerals in the
# theme's foreground color, empty ones as plain middle dots.
#
# Both colors are resolved from the theme the session is actually using
# (via `tuios get-config`), so the cell follows live theme switches.
FALLBACK_ACCENT="#e5c47b"
FALLBACK_FG="#c2c2b0"
THEMES_DIR="$HOME/.config/tuios/themes"

_color_from_file() {
  python3 -c 'import json,sys,re
try:
    d = json.load(open(sys.argv[2]))
except Exception:
    raise SystemExit(1)
want = sys.argv[1]
if want == "accent":
    c = ((d.get("chrome") or {}).get("accent")
         or d.get("yellow") or d.get("blue") or "")
else:
    c = d.get("fg") or d.get("white") or ""
print(c if isinstance(c, str) and re.fullmatch(r"#[0-9a-fA-F]{6}", c) else "")' "$1" "$2" 2>/dev/null
}

_resolve() {
  # $1 = accent|fg; prints the resolved hex or nothing.
  _f=""
  if command -v tuios >/dev/null 2>&1; then
    _id=$(tuios get-config appearance.theme 2>/dev/null)
    if [ -n "$_id" ] && [ -f "$THEMES_DIR/$_id.json" ]; then
      _f=$(_color_from_file "$1" "$THEMES_DIR/$_id.json")
    fi
  fi
  if [ -z "$_f" ]; then
    _latest=$(ls -t "$THEMES_DIR"/noctalia-[0-9]*.json 2>/dev/null | head -n 1)
    [ -n "$_latest" ] && _f=$(_color_from_file "$1" "$_latest")
  fi
  if [ -z "$_f" ] && [ -f "$THEMES_DIR/noctalia.json" ]; then
    _f=$(_color_from_file "$1" "$THEMES_DIR/noctalia.json")
  fi
  printf '%s' "$_f"
}

ACCENT=$(_resolve accent)
FG=$(_resolve fg)
case "$ACCENT" in \#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]) ;; *) ACCENT="$FALLBACK_ACCENT" ;; esac
case "$FG" in \#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]) ;; *) FG="$FALLBACK_FG" ;; esac
export ACCENT FG
tuios list-workspaces --json 2>/dev/null | python3 -c 'import json,sys,os
try:
    d = json.load(sys.stdin)
except Exception:
    raise SystemExit
cur = d.get("current_workspace", 1)
counts = {w.get("workspace"): w.get("window_count", 0) for w in d.get("workspaces", [])}
ROMAN = {1: "I", 2: "II", 3: "III", 4: "IV", 5: "V",
         6: "VI", 7: "VII", 8: "VIII", 9: "IX"}
def ink(hexcode):
    r, g, b = int(hexcode[1:3], 16), int(hexcode[3:5], 16), int(hexcode[5:7], 16)
    return f"\x1b[38;2;{r};{g};{b}m", "\x1b[39m"
acc_on, off = ink(os.environ.get("ACCENT") or "#e5c47b")
fg_on, _ = ink(os.environ.get("FG") or "#c2c2b0")
cells = []
for i in range(1, 10):
    num = ROMAN.get(i, str(i))
    if i == cur:
        cells.append(f"{acc_on}{num}{off}")
    elif counts.get(i, 0) > 0:
        cells.append(f"{fg_on}{num}{off}")
    else:
        cells.append("\u00b7")
print(" ".join(cells))'
