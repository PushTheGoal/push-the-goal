#!/usr/bin/env bash
# Builds Hannah's Skool kit as PNGs (palette A: blush and cream, same as the VSL deck):
# group cover, group icon, about-page images, classroom covers and Instagram highlight covers.
# Each image is an HTML page screenshotted by headless Chrome, so the real Google Fonts render.
# Usage: bash therabox/build-skool-kit.sh <output folder>
set -euo pipefail

OUT="${1:?output folder}"
mkdir -p "$OUT/html"
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe"

CSS='
@import url("https://fonts.googleapis.com/css2?family=Montserrat:wght@500;600&family=Playfair+Display:ital,wght@0,500;1,500&display=block");
:root { --cream:#FAF6F1; --blush:#F2D4D7; --rose:#C9707E; --deep:#A9505F; --ink:#3E2F2B; --taupe:#9C8B7E; }
* { margin:0; padding:0; box-sizing:border-box; }
html, body { width:var(--w); height:var(--h); overflow:hidden; }
body { background:var(--bg); color:var(--ink); font-family:"Playfair Display", serif; position:relative; }
.frame { position:absolute; inset:var(--inset); border:2px solid var(--rose); opacity:.55; }
.orb { position:absolute; border-radius:50%; background:var(--orb); }
.wrap { position:absolute; inset:0; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; padding:0 9%; }
.label { font-family:Montserrat, sans-serif; font-weight:600; letter-spacing:.32em; text-transform:uppercase; color:var(--lab); }
.h { font-weight:500; line-height:1.08; color:var(--ink); }
.h i { color:var(--acc); }
.sub { font-family:Montserrat, sans-serif; font-weight:500; color:var(--ink); opacity:.85; line-height:1.5; }
.rule { width:70px; height:2px; background:var(--rose); }
.foot { position:absolute; left:0; right:0; text-align:center; font-family:Montserrat, sans-serif; font-weight:600; letter-spacing:.3em; color:var(--lab); }
.cards { display:flex; gap:34px; width:100%; }
.card { flex:1; background:var(--blush); border-radius:22px; padding:44px 36px; text-align:left; }
.card .label { color:var(--deep); font-size:17px; }
.card .h { font-size:44px; margin:16px 0 18px; }
.card .sub { font-size:21px; }
.list { list-style:none; }
.list li { font-size:52px; line-height:1.32; }
.list li i { color:var(--acc); }
.ticks { list-style:none; text-align:left; }
.ticks li { font-family:Montserrat, sans-serif; font-weight:500; font-size:30px; line-height:1.35; margin:0 0 22px; padding-left:44px; position:relative; }
.ticks li:before { content:""; position:absolute; left:0; top:13px; width:18px; height:18px; border-radius:50%; background:var(--rose); }
.num { font-style:italic; color:var(--acc); }
'

# page <name> <width> <height> <bg cream|blush> <body html>
page() {
  local name=$1 w=$2 h=$3 bg=$4 body=$5 vars
  if [ "$bg" = blush ]; then
    vars="--bg:#F2D4D7;--orb:#FAF6F1;--lab:#A9505F;--acc:#A9505F"
  else
    vars="--bg:#FAF6F1;--orb:#F2D4D7;--lab:#9C8B7E;--acc:#C9707E"
  fi
  cat > "$OUT/html/$name.html" <<EOF
<!doctype html><html><head><meta charset="utf-8"><style>$CSS</style></head>
<body style="--w:${w}px;--h:${h}px;$vars">$body</body></html>
EOF
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$w,$h" --virtual-time-budget=8000 \
    --screenshot="$(cygpath -w "$OUT/$name.png")" "file:///$(cygpath -m "$OUT/html/$name.html")" 2>/dev/null
  echo "built $name.png (${w}x${h})"
}

FOOT_W='HANNAH BEYLER &nbsp;·&nbsp; THE WARRIOR METHOD'

# ---------- Skool group cover (1084 x 576) ----------
page 01-skool-cover 1084 576 cream "
<div class='orb' style='width:420px;height:420px;right:-210px;top:-230px'></div>
<div class='orb' style='width:300px;height:300px;left:-120px;bottom:-150px'></div>
<div class='frame' style='--inset:26px'></div>
<div class='wrap'>
  <div class='label' style='font-size:14px'>A six-month journey with Hannah Beyler</div>
  <div class='h' style='font-size:92px;margin:22px 0 20px'>The Warrior <i>Method</i></div>
  <div class='rule'></div>
  <div class='sub' style='font-size:21px;margin-top:22px'>Become the woman your calling requires.</div>
</div>"

# ---------- Skool group icon (512 x 512, shows small and rounded) ----------
page 02-skool-icon 512 512 blush "
<div class='orb' style='width:400px;height:400px;left:56px;top:56px'></div>
<div class='wrap' style='padding:0'>
  <div class='h' style='font-size:300px;line-height:1;margin-top:-20px'><i>W</i></div>
</div>"

# ---------- About page images (1460 x 752) ----------
page 03-about-welcome 1460 752 blush "
<div class='orb' style='width:640px;height:640px;left:-220px;top:-260px'></div>
<div class='frame' style='--inset:34px'></div>
<div class='wrap'>
  <div class='label' style='font-size:18px'>Welcome, warrior</div>
  <div class='h' style='font-size:118px;margin:28px 0 30px'>You were chosen<br><i>for this.</i></div>
  <div class='rule'></div>
  <div class='foot' style='bottom:66px;font-size:15px'>$FOOT_W</div>
</div>"

page 04-about-inside 1460 752 cream "
<div class='frame' style='--inset:34px'></div>
<div class='wrap'>
  <div class='label' style='font-size:18px'>What's inside</div>
  <div class='h' style='font-size:66px;margin:18px 0 46px'>Six months to <i>become her</i></div>
  <div class='cards'>
    <div class='card'><div class='label'>Months 1-3</div><div class='h'>Become her</div><div class='sub'>A 45-minute one-on-one session every week. Lies replaced with God's truth. Clarity, purpose, and weekly assignments.</div></div>
    <div class='card'><div class='label'>Months 4-6</div><div class='h'>Live it out</div><div class='sub'>You put your plan into action, with a 30-minute check-in every other week to keep you on course.</div></div>
    <div class='card'><div class='label'>All 6 months</div><div class='h'>Never alone</div><div class='sub'>The community, weekly group coaching calls, classes, and videos the whole way through.</div></div>
  </div>
</div>"

page 05-about-session 1460 752 blush "
<div class='orb' style='width:560px;height:560px;right:-180px;bottom:-240px'></div>
<div class='frame' style='--inset:34px'></div>
<div class='wrap'>
  <div class='label' style='font-size:18px'>Every session</div>
  <div class='h' style='font-size:120px;margin:26px 0 34px'>Release. Truth. <i>Plan.</i></div>
  <div class='rule'></div>
  <div class='sub' style='font-size:28px;margin-top:30px'>You leave lighter, standing on truth, with a plan.</div>
</div>"

page 06-about-for-you 1460 752 cream "
<div class='orb' style='width:620px;height:620px;right:-260px;top:-200px'></div>
<div class='frame' style='--inset:34px'></div>
<div class='wrap' style='flex-direction:row;justify-content:flex-start;gap:90px;padding:0 120px'>
  <div style='text-align:left;flex:0 0 430px'>
    <div class='label' style='font-size:18px'>Who it's for</div>
    <div class='h' style='font-size:76px;margin-top:22px'>This is<br>for you <i>if...</i></div>
  </div>
  <ul class='ticks'>
    <li>You know God is calling you to more.</li>
    <li>You're done waiting to feel ready.</li>
    <li>You're ready to do the inner work and take real action.</li>
    <li>You want a sisterhood walking the same road.</li>
  </ul>
</div>"

page 07-about-six-months 1460 752 blush "
<div class='orb' style='width:600px;height:600px;left:-240px;bottom:-260px'></div>
<div class='frame' style='--inset:34px'></div>
<div class='wrap'>
  <div class='label' style='font-size:18px'>In six months</div>
  <ul class='list' style='margin-top:30px'>
    <li>Confident.</li><li><i>Anchored in Christ.</i></li><li>Clear on your purpose.</li><li><i>Free from the lies.</i></li><li>Walking it out.</li>
  </ul>
</div>"

# ---------- Classroom covers (1460 x 752) ----------
# course <file> <bg> <label> <title html> <one line>
course() {
  page "$1" 1460 752 "$2" "
<div class='orb' style='width:520px;height:520px;right:-290px;top:-320px'></div>
<div class='frame' style='--inset:34px'></div>
<div class='wrap'>
  <div class='label' style='font-size:20px'>$3</div>
  <div class='h' style='font-size:108px;margin:26px 0 30px'>$4</div>
  <div class='rule'></div>
  <div class='sub' style='font-size:28px;margin-top:30px'>$5</div>
  <div class='foot' style='bottom:66px;font-size:15px'>$FOOT_W</div>
</div>"
}
course 08-class-0-start-here cream 'Begin here' 'Start <i>Here</i>' 'Welcome, how the group works, and your first week.'
course 09-class-1-decide blush 'Phase 1' '<i>Decide</i>' 'Your vision, your why, and who you are becoming.'
course 10-class-2-comfort-zone cream 'Phase 2' 'Crucify the<br><i>Comfort Zone</i>' 'Face the fear, the avoidance, and the old identities.'
course 11-class-3-remove-replace blush 'Phase 3' 'Remove and <i>Replace</i>' "The lies out. God's truth in."
course 12-class-4-become-act cream 'Phase 4' 'Become and <i>Act</i>' 'Your plan, and real acts of faith.'
course 13-class-5-live-it-out blush 'Months 4-6' 'Live It <i>Out</i>' 'Your plan in action, with check-ins to keep you on course.'
course 14-class-6-group-calls cream 'Every week' 'Group Call <i>Replays</i>' 'Every weekly call, newest first.'

# ---------- Instagram highlight covers (1080 x 1920, Instagram shows the centre circle) ----------
# highlight <file> <title html> <small label>
highlight() {
  page "$1" 1080 1920 blush "
<div class='orb' style='width:900px;height:900px;left:90px;top:510px'></div>
<div class='orb' style='width:820px;height:820px;left:130px;top:550px;background:transparent;border:2px solid #C9707E;opacity:.6'></div>
<div class='wrap' style='padding:0 200px'>
  <div class='label' style='font-size:30px;color:#A9505F'>$3</div>
  <div class='h' style='font-size:128px;margin-top:26px'>$2</div>
</div>"
}
highlight 15-highlight-start-here 'Start <i>Here</i>' 'Welcome'
highlight 16-highlight-the-method 'The <i>Method</i>' 'Warrior'
highlight 17-highlight-transformations '<i>Stories</i>' 'Transformations'
highlight 18-highlight-my-story 'My <i>Story</i>' 'Hannah'
highlight 19-highlight-therabox '<i>TheraBox</i>' 'Nashville'
