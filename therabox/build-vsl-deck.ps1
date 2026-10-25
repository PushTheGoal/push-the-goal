# Builds the Warrior Method VSL slide deck as a .pptx (palette A: blush and cream), from Hannah's
# answers on 24 Oct 2026 ("TheraBox - Hannah's VSL Answers" doc). Upload it to Drive, open it in
# Slides and use File > Save as Google Slides; the .pptx is then trashed.
# Fonts: Playfair Display (headlines, italic rose for the key phrase) + Montserrat (labels).
# Usage: .\build-vsl-deck.ps1 -Out <path.pptx>
param([string]$Out)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$C = @{ cream = 'FAF6F1'; blush = 'F2D4D7'; rose = 'C9707E'; roseDeep = 'A9505F'; ink = '3E2F2B'; taupe = '9C8B7E'; white = 'FFFFFF' }
$IN = 914400                      # EMU per inch
$W = 12192000; $H = 6858000       # 16:9
$M = [int](0.9 * $IN)             # side margin

function Esc($s) { [System.Security.SecurityElement]::Escape([string]$s) }
function E([double]$inches) { [int]($inches * $IN) }

# ---------- shape helpers ----------
$script:sid = 2
function Rect($x, $y, $w, $h, $fill, [string]$geom = 'rect') {
  $id = $script:sid++
  "<p:sp><p:nvSpPr><p:cNvPr id=`"$id`" name=`"Shape $id`"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"$x`" y=`"$y`"/><a:ext cx=`"$w`" cy=`"$h`"/></a:xfrm><a:prstGeom prst=`"$geom`"><a:avLst/></a:prstGeom><a:solidFill><a:srgbClr val=`"$fill`"/></a:solidFill><a:ln><a:noFill/></a:ln></p:spPr></p:sp>"
}
# runs: array of @{ t; font; sz; color; i; b; sp(letter spacing, 1/100 pt) }
function Run($r) {
  $attr = "lang=`"en-US`" sz=`"$([int]($r.sz * 100))`" dirty=`"0`""
  if ($r.i) { $attr += ' i="1"' }
  if ($r.b) { $attr += ' b="1"' }
  if ($r.sp) { $attr += " spc=`"$($r.sp)`"" }
  "<a:r><a:rPr $attr><a:solidFill><a:srgbClr val=`"$($r.color)`"/></a:solidFill><a:latin typeface=`"$($r.font)`"/><a:cs typeface=`"$($r.font)`"/></a:rPr><a:t>$(Esc $r.t)</a:t></a:r>"
}
# paras: array of @{ runs = @(...); algn; after (pt); line (pct) }
function TextBox($x, $y, $w, $h, $paras, [string]$anchor = 't') {
  $id = $script:sid++
  $sb = "<p:sp><p:nvSpPr><p:cNvPr id=`"$id`" name=`"Text $id`"/><p:cNvSpPr txBox=`"1`"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"$x`" y=`"$y`"/><a:ext cx=`"$w`" cy=`"$h`"/></a:xfrm><a:prstGeom prst=`"rect`"><a:avLst/></a:prstGeom><a:noFill/></p:spPr><p:txBody><a:bodyPr wrap=`"square`" lIns=`"0`" tIns=`"0`" rIns=`"0`" bIns=`"0`" anchor=`"$anchor`"><a:noAutofit/></a:bodyPr><a:lstStyle/>"
  foreach ($p in $paras) {
    $algn = if ($p.algn) { $p.algn } else { 'l' }
    $line = if ($p.line) { $p.line } else { 112 }
    $after = if ($p.after) { $p.after } else { 0 }
    $sb += "<a:p><a:pPr algn=`"$algn`"><a:lnSpc><a:spcPct val=`"$($line * 1000)`"/></a:lnSpc><a:spcAft><a:spcPts val=`"$($after * 100)`"/></a:spcAft></a:pPr>"
    foreach ($r in $p.runs) { $sb += (Run $r) }
    $sb += '</a:p>'
  }
  $sb + '</p:txBody></p:sp>'
}

# ---------- type styles ----------
function Head($t, $sz, $color) { @{ t = $t; font = 'Playfair Display'; sz = $sz; color = $color } }
function Accent($t, $sz, $color) { @{ t = $t; font = 'Playfair Display'; sz = $sz; color = $color; i = $true } }
function Label($t, $color) { @{ t = $t.ToUpper(); font = 'Montserrat'; sz = 11; color = $color; sp = 300 } }
function Body($t, $sz, $color) { @{ t = $t; font = 'Montserrat'; sz = $sz; color = $color } }

# Picks a headline size from the total length of the lines on a slide.
function HeadSize($lines) {
  $len = ($lines | ForEach-Object { $_ } | Measure-Object -Property Length -Sum).Sum
  if ($len -le 40) { 48 } elseif ($len -le 75) { 40 } elseif ($len -le 115) { 34 } else { 28 }
}

function Frame($bg, $label) {
  $fg = if ($bg -eq $C.blush) { $C.roseDeep } else { $C.taupe }
  $s = TextBox $M (E 0.65) (E 9) (E 0.3) @(@{ runs = @(Label $label $fg) })
  $s += TextBox $M (E 6.95) (E 6) (E 0.25) @(@{ runs = @(Label 'The Warrior Method' $fg) })
  $s
}

# ---------- slide builders ----------
# Quote slide: plain lines in ink, accent lines in italic rose; optional small note under it.
function QuoteSlide($label, $plain, $accent, $note, [string]$bg = $C.cream) {
  $accentColor = if ($bg -eq $C.blush) { $C.roseDeep } else { $C.rose }
  $sz = HeadSize (@($plain) + @($accent))
  $paras = @()
  foreach ($l in $plain) { if ($l) { $paras += @{ runs = @(Head $l $sz $C.ink); after = 6 } } }
  foreach ($l in $accent) { if ($l) { $paras += @{ runs = @(Accent $l $sz $accentColor); after = 6 } } }
  $s = Frame $bg $label
  $s += Rect $M (E 2.05) (E 0.7) (E 0.06) $accentColor
  $s += TextBox $M (E 2.35) (E 10.2) (E 3.7) $paras
  if ($note) { $s += TextBox $M (E 6.15) (E 10.2) (E 0.5) @(@{ runs = @(Body $note 14 $C.taupe) }) }
  @{ bg = $bg; body = $s }
}
# List slide: a headline, then short lines each led by a rose mark.
function ListSlide($label, $head, $items, [string]$bg = $C.cream) {
  $accentColor = if ($bg -eq $C.blush) { $C.roseDeep } else { $C.rose }
  $s = Frame $bg $label
  $s += Rect $M (E 1.45) (E 0.7) (E 0.06) $accentColor
  $s += TextBox $M (E 1.7) (E 10.2) (E 1.2) @(@{ runs = @(Head $head 34 $C.ink) })
  $paras = @()
  foreach ($it in $items) {
    $paras += @{ runs = @(@{ t = [string][char]0x25AA + '   '; font = 'Montserrat'; sz = 20; color = $accentColor }, (Head $it 26 $C.ink)); after = 14 }
  }
  $s += TextBox $M (E 3.0) (E 10.2) (E 3.6) $paras
  @{ bg = $bg; body = $s }
}
# Three cards side by side on blush.
function ThreeSlide($label, $head, $cards) {
  $s = Frame $C.cream $label
  $s += Rect $M (E 1.45) (E 0.7) (E 0.06) $C.rose
  $s += TextBox $M (E 1.7) (E 10.2) (E 1.0) @(@{ runs = @(Head $head 34 $C.ink) })
  $gap = E 0.35; $cw = [int](((E 11.533) - 2 * $gap) / 3)
  for ($i = 0; $i -lt 3; $i++) {
    $x = $M + $i * ($cw + $gap)
    $s += Rect $x (E 2.95) $cw (E 3.55) $C.blush 'roundRect'
    $s += TextBox ($x + (E 0.3)) (E 3.25) ($cw - (E 0.6)) (E 3.0) @(
      @{ runs = @(Label $cards[$i][0] $C.roseDeep); after = 10 },
      @{ runs = @(Accent $cards[$i][1] 22 $C.ink); after = 12 },
      @{ runs = @(Body $cards[$i][2] 14 $C.ink); line = 135 })
  }
  @{ bg = $C.cream; body = $s }
}

# ---------- the deck (order follows the VSL Plan) ----------
$slides = New-Object System.Collections.ArrayList

# Title
$t = Rect (E 8.9) 0 ($W - (E 8.9)) $H $C.blush
$t += Rect $M (E 2.35) (E 0.7) (E 0.06) $C.rose
$t += TextBox $M (E 1.4) (E 7.5) (E 0.4) @(@{ runs = @(Label 'Hannah Beyler' $C.taupe) })
$t += TextBox $M (E 2.6) (E 7.6) (E 2.2) @(@{ runs = @(Head 'The Warrior' 60 $C.ink) }, @{ runs = @(Head 'Method' 60 $C.ink) })
$t += TextBox $M (E 4.95) (E 7.4) (E 1.2) @(@{ runs = @(Accent 'Become the woman your calling requires.' 26 $C.rose) })
$t += TextBox $M (E 6.6) (E 7.5) (E 0.3) @(@{ runs = @(Label 'Faith-based coaching and guided inner work' $C.taupe) })
[void]$slides.Add(@{ bg = $C.cream; body = $t })

# 1. The hook
[void]$slides.Add((QuoteSlide '01  The hook' @('You were created for something big.') @("But you haven't broken through yet.") $null))
[void]$slides.Add((QuoteSlide '01  The hook' @('You crave purpose.') @('You want to use your gifts and be fully, freely yourself.') $null))
[void]$slides.Add((ListSlide '01  The hook' 'The lies that keep you stuck' @(([string][char]0x201C + "I'm not good enough." + [char]0x201D), ([string][char]0x201C + "I'm not qualified." + [char]0x201D), ([string][char]0x201C + "I'm not ready." + [char]0x201D))))
[void]$slides.Add((QuoteSlide '01  The hook' @("You'll never feel ready.") @('So decide.') $null $C.blush))

# 2. Hannah's story
[void]$slides.Add((QuoteSlide "02  My story" @('I was lost, broken, and alone.') @() 'Hannah chooses how much of this season she shares on camera.'))
[void]$slides.Add((QuoteSlide "02  My story" @('I tried everything.') @('Then I found boxing - and I found Christ.') $null))
[void]$slides.Add((QuoteSlide "02  My story" @() @([char]0x201C + "I'm going to send you my women who I'm calling to be warriors, so you can help equip them for battle." + [char]0x201D) 'What God kept telling me' $C.blush))
[void]$slides.Add((QuoteSlide "02  My story" @("I've never searched for anyone.") @('God has simply sent me these women.') $null))
[void]$slides.Add((QuoteSlide "02  My story" @('There will always be') @('a new level to rise to.') $null))
[void]$slides.Add((QuoteSlide "02  My story" @('Bold warriors, walking confidently in their purpose.') @('Free, authentic, and light.') 'What I watched happen to the women at TheraBox'))
[void]$slides.Add((QuoteSlide "02  My story" @('What you see now') @("isn't where I started.") $null $C.blush))
[void]$slides.Add((QuoteSlide "02  My story" @("A method I've seen work over and over.") @('Now open to women anywhere.') $null))

# 3. The real problem
[void]$slides.Add((QuoteSlide '03  The real problem' @('The power is already in you.') @("We remove everything that's out of alignment with it.") $null))
[void]$slides.Add((ListSlide '03  The real problem' 'Where women hide' @(([string][char]0x201C + "I'm not ready yet." + [char]0x201D), ([string][char]0x201C + "I'm waiting on God." + [char]0x201D))))
[void]$slides.Add((QuoteSlide '03  The real problem' @("You don't feel ready.") @('You decide to be ready.') $null))
[void]$slides.Add((QuoteSlide '03  The real problem' @("You're not waiting on God.") @('God is waiting on you.') $null $C.blush))
[void]$slides.Add((QuoteSlide '03  The real problem' @('Own every step.') @('And let God direct them.') $null))

# 4. Why the usual fixes don't stick
[void]$slides.Add((ThreeSlide "04  Why it hasn't lasted" 'What makes this different' @(
  @('One', 'God at the center', 'He is the foundation of everything we do.'),
  @('Two', 'Action, not just talk', 'Every week ends with real steps to take.'),
  @('Three', 'Release, not rumination', 'You let go of what you have been carrying.'))))
[void]$slides.Add((QuoteSlide "04  Why it hasn't lasted" @('Anchored in who you are.') @('With a plan for when the old cycles show up.') $null))
[void]$slides.Add((QuoteSlide "04  Why it hasn't lasted" @('Christ is the only firm ground.') @('Everything else is built on Him.') $null $C.blush))

# 5. The Warrior Method
[void]$slides.Add((ThreeSlide '05  The Warrior Method' 'Six months to become her' @(
  @('Months 1-3', 'Become her', 'A 45-minute one-on-one session every week. Lies replaced with God''s truth. Clarity, purpose, and weekly assignments.'),
  @('Months 4-6', 'Live it out', 'You put your plan into action, with a 30-minute check-in every other week to keep you on course.'),
  @('All 6 months', 'Never alone', 'The community, weekly group coaching calls, classes, and videos the whole way through.'))))
[void]$slides.Add((ListSlide '05  The Warrior Method' 'Every session' @('Release what you have been carrying.', 'Stand on new truth.', 'Leave with a plan.')))
[void]$slides.Add((QuoteSlide '05  The Warrior Method' @("You won't do this alone.") @('A sisterhood walking the same road.') $null))

# 6. What she walks away with
[void]$slides.Add((ListSlide '06  Where you will be' 'In six months' @('Confident.', 'Anchored in Christ.', 'Clear on your purpose.', 'Free from the lies.', 'Walking it out.') $C.blush))

# 7. Proof
[void]$slides.Add((QuoteSlide '07  Their words' @('[ Client story 1 ]') @('Confidence. Identity in Christ. Authenticity. Letting go.') 'Placeholder - a short clip from a client, with her permission.'))
[void]$slides.Add((QuoteSlide '07  Their words' @('[ Client story 2 ]') @('In her own words.') 'Placeholder - a second client clip, with her permission.'))

# 8. Who it's for
[void]$slides.Add((QuoteSlide "08  Who it's for" @('This is for warriors') @('who feel called to more.') 'Not for anyone who wants a normal life, or isn''t ready to change hers.'))

# 9. The call
[void]$slides.Add((QuoteSlide '09  Your next step' @('You were chosen for this.') @("Be done with the version of you that doesn't believe it.") $null $C.blush))
$cta = Frame $C.cream '09  Your next step'
$cta += Rect $M (E 2.05) (E 0.7) (E 0.06) $C.rose
$cta += TextBox $M (E 2.35) (E 10.2) (E 1.3) @(@{ runs = @(Head 'Book your call' 54 $C.ink) })
$cta += TextBox $M (E 3.6) (E 10.2) (E 1.4) @(@{ runs = @(Accent "We'll talk about what God has put on your heart, what's been in the way, and whether The Warrior Method is right for you." 22 $C.rose); line = 125 })
$cta += Rect $M (E 5.25) (E 3.2) (E 0.65) $C.rose 'roundRect'
$cta += TextBox $M (E 5.25) (E 3.2) (E 0.65) @(@{ runs = @(Label 'Book your call below' $C.white); algn = 'ctr' }) 'ctr'
[void]$slides.Add(@{ bg = $C.cream; body = $cta })
[void]$slides.Add((QuoteSlide '09  Your next step' @("I'm done waiting on a version of me that feels ready.") @('I choose this. God goes before me, and I''m going.') 'Stand and declare it with me.' $C.blush))
$end = Rect 0 0 $W $H $C.blush
$end += TextBox $M (E 2.6) (E 10.2) (E 1.2) @(@{ runs = @(Head 'The Warrior Method' 54 $C.ink); algn = 'ctr' })
$end += TextBox $M (E 3.85) (E 10.2) (E 0.6) @(@{ runs = @(Accent 'Become the woman your calling requires.' 24 $C.roseDeep); algn = 'ctr' })
$end += TextBox $M (E 6.1) (E 10.2) (E 0.6) @(
  @{ runs = @(Label 'Faith-based coaching and guided inner work. Not therapy, counseling, or medical treatment.' $C.roseDeep); algn = 'ctr' })
[void]$slides.Add(@{ bg = $C.blush; body = $end })

# ---------- package ----------
$ns = 'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"'
$grp = '<p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>'
$hdr = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
$theme = @"
$hdr<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Warrior"><a:themeElements>
<a:clrScheme name="Warrior"><a:dk1><a:srgbClr val="3E2F2B"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="3E2F2B"/></a:dk2><a:lt2><a:srgbClr val="FAF6F1"/></a:lt2><a:accent1><a:srgbClr val="C9707E"/></a:accent1><a:accent2><a:srgbClr val="F2D4D7"/></a:accent2><a:accent3><a:srgbClr val="9C8B7E"/></a:accent3><a:accent4><a:srgbClr val="A9505F"/></a:accent4><a:accent5><a:srgbClr val="E8DCCF"/></a:accent5><a:accent6><a:srgbClr val="6B5A52"/></a:accent6><a:hlink><a:srgbClr val="A9505F"/></a:hlink><a:folHlink><a:srgbClr val="9C8B7E"/></a:folHlink></a:clrScheme>
<a:fontScheme name="Warrior"><a:majorFont><a:latin typeface="Playfair Display"/><a:ea typeface=""/><a:cs typeface=""/></a:majorFont><a:minorFont><a:latin typeface="Montserrat"/><a:ea typeface=""/><a:cs typeface=""/></a:minorFont></a:fontScheme>
<a:fmtScheme name="Warrior"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:fillStyleLst>
<a:lnStyleLst><a:ln w="6350"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln><a:ln w="12700"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln><a:ln w="19050"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln></a:lnStyleLst>
<a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle><a:effectStyle><a:effectLst/></a:effectStyle><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst>
<a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:bgFillStyleLst></a:fmtScheme>
</a:themeElements><a:objectDefaults/><a:extraClrSchemeLst/></a:theme>
"@
$master = "$hdr<p:sldMaster $ns><p:cSld><p:bg><p:bgPr><a:solidFill><a:srgbClr val=`"FAF6F1`"/></a:solidFill><a:effectLst/></p:bgPr></p:bg><p:spTree>$grp</p:spTree></p:cSld><p:clrMap bg1=`"lt1`" tx1=`"dk1`" bg2=`"lt2`" tx2=`"dk2`" accent1=`"accent1`" accent2=`"accent2`" accent3=`"accent3`" accent4=`"accent4`" accent5=`"accent5`" accent6=`"accent6`" hlink=`"hlink`" folHlink=`"folHlink`"/><p:sldLayoutIdLst><p:sldLayoutId id=`"2147483649`" r:id=`"rId1`"/></p:sldLayoutIdLst></p:sldMaster>"
$layout = "$hdr<p:sldLayout $ns type=`"blank`" preserve=`"1`"><p:cSld name=`"Blank`"><p:spTree>$grp</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sldLayout>"
$relHdr = "$hdr<Relationships xmlns=`"http://schemas.openxmlformats.org/package/2006/relationships`">"
$R = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'

if (Test-Path $Out) { Remove-Item $Out -Force }
$zip = [System.IO.Compression.ZipFile]::Open($Out, 'Create')
function Entry($name, $text) { $e = $zip.CreateEntry($name); $w = New-Object System.IO.StreamWriter($e.Open(), (New-Object System.Text.UTF8Encoding($false))); $w.Write($text); $w.Close() }

$ct = "$hdr<Types xmlns=`"http://schemas.openxmlformats.org/package/2006/content-types`"><Default Extension=`"rels`" ContentType=`"application/vnd.openxmlformats-package.relationships+xml`"/><Default Extension=`"xml`" ContentType=`"application/xml`"/><Override PartName=`"/ppt/presentation.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml`"/><Override PartName=`"/ppt/slideMasters/slideMaster1.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml`"/><Override PartName=`"/ppt/slideLayouts/slideLayout1.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml`"/><Override PartName=`"/ppt/theme/theme1.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.theme+xml`"/>"
for ($i = 1; $i -le $slides.Count; $i++) { $ct += "<Override PartName=`"/ppt/slides/slide$i.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.presentationml.slide+xml`"/>" }
Entry '[Content_Types].xml' ($ct + '</Types>')
Entry '_rels/.rels' "$relHdr<Relationship Id=`"rId1`" Type=`"$R/officeDocument`" Target=`"ppt/presentation.xml`"/></Relationships>"

$pres = "$hdr<p:presentation $ns saveSubsetFonts=`"1`"><p:sldMasterIdLst><p:sldMasterId id=`"2147483648`" r:id=`"rId1`"/></p:sldMasterIdLst><p:sldIdLst>"
$prels = "$relHdr<Relationship Id=`"rId1`" Type=`"$R/slideMaster`" Target=`"slideMasters/slideMaster1.xml`"/><Relationship Id=`"rId2`" Type=`"$R/theme`" Target=`"theme/theme1.xml`"/>"
for ($i = 1; $i -le $slides.Count; $i++) {
  $rid = $i + 2
  $pres += "<p:sldId id=`"$(255 + $i)`" r:id=`"rId$rid`"/>"
  $prels += "<Relationship Id=`"rId$rid`" Type=`"$R/slide`" Target=`"slides/slide$i.xml`"/>"
  $s = $slides[$i - 1]
  $xml = "$hdr<p:sld $ns><p:cSld><p:bg><p:bgPr><a:solidFill><a:srgbClr val=`"$($s.bg)`"/></a:solidFill><a:effectLst/></p:bgPr></p:bg><p:spTree>$grp$($s.body)</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>"
  Entry "ppt/slides/slide$i.xml" $xml
  Entry "ppt/slides/_rels/slide$i.xml.rels" "$relHdr<Relationship Id=`"rId1`" Type=`"$R/slideLayout`" Target=`"../slideLayouts/slideLayout1.xml`"/></Relationships>"
}
$pres += "</p:sldIdLst><p:sldSz cx=`"$W`" cy=`"$H`"/><p:notesSz cx=`"6858000`" cy=`"9144000`"/></p:presentation>"
Entry 'ppt/presentation.xml' $pres
Entry 'ppt/_rels/presentation.xml.rels' ($prels + '</Relationships>')
Entry 'ppt/slideMasters/slideMaster1.xml' $master
Entry 'ppt/slideMasters/_rels/slideMaster1.xml.rels' "$relHdr<Relationship Id=`"rId1`" Type=`"$R/slideLayout`" Target=`"../slideLayouts/slideLayout1.xml`"/><Relationship Id=`"rId2`" Type=`"$R/theme`" Target=`"../theme/theme1.xml`"/></Relationships>"
Entry 'ppt/slideLayouts/slideLayout1.xml' $layout
Entry 'ppt/slideLayouts/_rels/slideLayout1.xml.rels' "$relHdr<Relationship Id=`"rId1`" Type=`"$R/slideMaster`" Target=`"../slideMasters/slideMaster1.xml`"/></Relationships>"
Entry 'ppt/theme/theme1.xml' $theme
$zip.Dispose()
"wrote $Out ($((Get-Item $Out).Length) bytes, $($slides.Count) slides)"
