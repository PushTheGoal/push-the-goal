#!/usr/bin/env bash
# Renders one carousel to PNGs (1080 x 1350) with headless Chrome, so the real Google Fonts render.
# A carousel is a folder of slide fragments named 01.html, 02.html ... (inner markup only).
# The first line of a fragment may be a class comment, e.g. <!-- class: yellow -->, to set the body class.
# The renderer wraps each fragment with the brand CSS, the brand line, the slide counter and the footer,
# and puts a "Swipe" cue on slide 1.
# Usage: bash content/tools/render-carousel.sh <carousel folder> [brand css]
#        PNGs land in <carousel folder>/png/
set -euo pipefail

DIR="${1:?carousel folder}"
HERE="$(cd "$(dirname "$0")" && pwd)"
CSS_FILE="${2:-$HERE/carousel.css}"
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe"
BRAND_LINE="${BRAND_LINE:-Push the Goal Soccer}"
HANDLE="${HANDLE:-@pushthegoalsoccer}"

mkdir -p "$DIR/png" "$DIR/.html"
CSS="$(cat "$CSS_FILE")"
mapfile -t SLIDES < <(ls "$DIR" | grep -E '^[0-9]{2}\.html$' | sort)
TOTAL=${#SLIDES[@]}
[ "$TOTAL" -gt 0 ] || { echo "no NN.html slides in $DIR" >&2; exit 1; }
# The app allows 20 slides, but the API (and GHL) publishes only the first 10.
[ "$TOTAL" -le 10 ] || { echo "10 slides max - the API drops everything after slide 10 ($TOTAL found)" >&2; exit 1; }

i=0
for f in "${SLIDES[@]}"; do
  i=$((i+1))
  n="${f%.html}"
  body="$(cat "$DIR/$f")"
  cls="$(head -1 "$DIR/$f" | sed -n 's/.*<!-- *class: *\([a-z -]*\) *-->.*/\1/p')"
  if [ "$i" -eq 1 ]; then right="<span class='swipe'>Swipe &rarr;</span>"; else right="<span>$HANDLE</span>"; fi
  cat > "$DIR/.html/$n.html" <<EOF
<!doctype html><html><head><meta charset="utf-8"><style>$CSS</style></head>
<body class="$cls">
<div class="brand">$BRAND_LINE</div><div class="count">$i / $TOTAL</div>
$body
<div class="foot"><span>Become undeniable.</span>$right</div>
</body></html>
EOF
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1080,1350 --virtual-time-budget=6000 \
    --screenshot="$(cygpath -w "$DIR/png/$n.png")" "file:///$(cygpath -m "$DIR/.html/$n.html")" 2>/dev/null
  echo "rendered $n.png"
done
