# Builds the TheraBox Sales Call Tracker as an .xlsx (LAUNCH PLAN, TOTALS, one tab per month).
# This laptop has no Python and the Sheets editor connector is off, so the workbook is built here,
# uploaded to Drive, then opened in Sheets and saved as a Google Sheet. Usage: .\build-tracker.ps1 -Out <path.xlsx>
param([string]$Out)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

function Esc($s) { [System.Security.SecurityElement]::Escape([string]$s) }
function ColL([int]$n) { $s = ''; while ($n -gt 0) { $m = ($n - 1) % 26; $s = [char](65 + $m) + $s; $n = [math]::Floor(($n - 1) / 26) }; $s }
function Cell($ref, $val, [int]$style = 0) {
  if ($null -eq $val -or ($val -is [string] -and $val -eq '')) { if ($style) { return "<c r=`"$ref`" s=`"$style`"/>" } else { return '' } }
  if ($val -is [string] -and $val.StartsWith('=')) { return "<c r=`"$ref`" s=`"$style`"><f>$(Esc $val.Substring(1))</f></c>" }
  if ($val -is [int] -or $val -is [double]) { return "<c r=`"$ref`" s=`"$style`"><v>$val</v></c>" }
  return "<c r=`"$ref`" s=`"$style`" t=`"inlineStr`"><is><t xml:space=`"preserve`">$(Esc $val)</t></is></c>"
}
# A sheet = @{ name; rows = ordered dict rowNum -> list of @(colNum, value, style); widths = @(..); merges; validations; freeze }
function SheetXml($sh) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">')
  if ($sh.freeze) { [void]$sb.Append("<sheetViews><sheetView workbookViewId=`"0`"><pane ySplit=`"$($sh.freeze)`" topLeftCell=`"A$($sh.freeze + 1)`" activePane=`"bottomLeft`" state=`"frozen`"/></sheetView></sheetViews>") }
  [void]$sb.Append('<cols>')
  for ($i = 0; $i -lt $sh.widths.Count; $i++) { [void]$sb.Append("<col min=`"$($i+1)`" max=`"$($i+1)`" width=`"$($sh.widths[$i])`" customWidth=`"1`"/>") }
  [void]$sb.Append('</cols><sheetData>')
  foreach ($r in ($sh.rows.Keys | Sort-Object)) {
    $ht = ''; if ($sh.heights -and $sh.heights[$r]) { $ht = " ht=`"$($sh.heights[$r])`" customHeight=`"1`"" }
    [void]$sb.Append("<row r=`"$r`"$ht>")
    foreach ($c in $sh.rows[$r]) { [void]$sb.Append((Cell "$(ColL $c[0])$r" $c[1] $c[2])) }
    [void]$sb.Append('</row>')
  }
  [void]$sb.Append('</sheetData>')
  if ($sh.merges) { [void]$sb.Append("<mergeCells count=`"$($sh.merges.Count)`">"); foreach ($m in $sh.merges) { [void]$sb.Append("<mergeCell ref=`"$m`"/>") }; [void]$sb.Append('</mergeCells>') }
  if ($sh.validations) {
    [void]$sb.Append("<dataValidations count=`"$($sh.validations.Count)`">")
    foreach ($v in $sh.validations) { [void]$sb.Append("<dataValidation type=`"list`" allowBlank=`"1`" showErrorMessage=`"1`" sqref=`"$($v[0])`"><formula1>$(Esc ('"' + $v[1] + '"'))</formula1></dataValidation>") }
    [void]$sb.Append('</dataValidations>')
  }
  [void]$sb.Append('</worksheet>')
  $sb.ToString()
}
function AddRow($sh, [int]$r, $cells) { if (-not $sh.rows.Contains($r)) { $sh.rows[$r] = New-Object System.Collections.ArrayList }; foreach ($c in $cells) { [void]$sh.rows[$r].Add($c) } }

# Styles: 0 default | 1 header | 2 title | 3 currency | 4 bold percent | 5 bold label | 6 bold currency | 7 wrap | 8 date | 9 grey label | 10 bold number
$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<numFmts count="1"><numFmt numFmtId="164" formatCode="&quot;$&quot;#,##0"/></numFmts>
<fonts count="4">
<font><sz val="10"/><name val="Arial"/></font>
<font><b/><sz val="10"/><color rgb="FFFFFFFF"/><name val="Arial"/></font>
<font><b/><sz val="14"/><name val="Arial"/></font>
<font><b/><sz val="10"/><name val="Arial"/></font>
</fonts>
<fills count="4">
<fill><patternFill patternType="none"/></fill>
<fill><patternFill patternType="gray125"/></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FF1C1F24"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFF1EEE8"/><bgColor indexed="64"/></patternFill></fill>
</fills>
<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs count="11">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"><alignment vertical="top"/></xf>
<xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
<xf numFmtId="0" fontId="2" fillId="0" borderId="0" xfId="0" applyFont="1"/>
<xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>
<xf numFmtId="9" fontId="3" fillId="0" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyAlignment="1"><alignment horizontal="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment horizontal="center"/></xf>
<xf numFmtId="164" fontId="3" fillId="0" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyAlignment="1"><alignment horizontal="center"/></xf>
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
<xf numFmtId="14" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>
<xf numFmtId="0" fontId="3" fillId="3" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment horizontal="center"/></xf>
</cellXfs>
</styleSheet>
'@

$sheets = New-Object System.Collections.ArrayList

# ---------- LAUNCH PLAN ----------
$plan = @(
  @('FOUNDATION','Lock the offer','What Izi sells on the call: program name, length, what is included, online (Skool) vs in person in Nashville.','Both'),
  @('FOUNDATION','Set price and payment plans','Internal only - lives in this sheet and on the tracker, never on the VSL, booking page or IG.','Both'),
  @('FOUNDATION','Sign the FCMO agreement','Izi = Fractional CMO + sales calls for 10% of earnings. Define what counts as earnings (all TheraBox revenue or only funnel sales), when it is paid, start date.','Both'),
  @('FOUNDATION','Payment link for closing on the call','Stripe (or similar) checkout link for full pay and each payment plan, so Izi can close live.','Hannah'),
  @('FOUNDATION','Fathom on every TheraBox call','Title calls "TheraBox - [Name]" so they never mix with Push the Goal Strategy Sessions.','Izi'),
  @('VSL','Approve the VSL outline','Outline is in the TheraBox launch plan doc.','Hannah'),
  @('VSL','Write the VSL script','Built from the approved outline in Hannah''s own words and story.','Izi'),
  @('VSL','Film the VSL','8-15 minutes, filmed section by section so no single long take is needed.','Hannah'),
  @('VSL','Edit, caption and host','Unlisted YouTube or Wistia. Captions on - most people watch muted first.','Izi'),
  @('VSL','Put the VSL on the booking page','Video above the calendar. Every ManyChat link points here.','Izi'),
  @('INSTAGRAM','Add a link in bio','There is no link in her bio today. Point it at the booking page.','Hannah'),
  @('INSTAGRAM','Pin 3 posts','Her story, what TheraBox is, one client transformation.','Hannah'),
  @('INSTAGRAM','"Start Here" highlight','VSL clip + the ManyChat keyword.','Hannah'),
  @('INSTAGRAM','Keyword CTA on content','3 reels a week that end on "Comment [KEYWORD]".','Hannah'),
  @('MANYCHAT','Connect ManyChat to Instagram','ManyChat Pro on Hannah''s account - she owns the login, adds Izi as admin.','Hannah'),
  @('MANYCHAT','Keyword triggers','Comment, DM and story reply triggers on one keyword.','Izi'),
  @('MANYCHAT','DM booking flow','Welcome - 2 quick questions - VSL - booking link. Full flow in the launch plan doc.','Izi'),
  @('MANYCHAT','Nudges for people who did not book','One nudge about 23 hours after the link - Instagram only allows automated DMs within 24 hours. Email after that.','Izi'),
  @('MANYCHAT','Test it end to end','From a second IG account: comment, DM, watch, book.','Izi'),
  @('BOOKING','Calendar for TheraBox calls','Izi''s availability, 45-60 min, Zoom with Fathom.','Izi'),
  @('BOOKING','Booking page + qualifying questions','Questions in the launch plan doc.','Izi'),
  @('BOOKING','Confirmation and reminders','Confirmation now, 24 hours and 1 hour before - each one says rewatch the VSL.','Izi'),
  @('BOOKING','Booked call lands on this tracker','Automation (Zapier / GHL) or Izi logs it same day.','Izi'),
  @('SALES','TheraBox sales script','Adapt the Push the Goal v3 script and playbook to her offer.','Izi'),
  @('SALES','Log every call here same day','OUTCOME is always one of the dropdown values.','Izi'),
  @('SALES','Follow-up for FOLLOW-UP rows','Written from each person''s own call, asks for a decision, never another call.','Izi'),
  @('SKOOL','Create the Skool group','Hannah owns the account and billing, adds Izi as admin.','Hannah'),
  @('SKOOL','Free or paid','Paid community inside the offer, or a free group as a funnel into calls. Decide before building.','Both'),
  @('SKOOL','Classroom, calendar, welcome post','Structure in the launch plan doc.','Izi'),
  @('SKOOL','Weekly live call','Hannah, same time every week.','Hannah'),
  @('LAUNCH','Announce to her audience','Story sequence + reel to her 98K pointing at the keyword.','Hannah'),
  @('LAUNCH','Weekly numbers review','Read TOTALS together every week: calls, show rate, close rate, cash, Izi''s 10%.','Both')
)
$lp = @{ name = 'LAUNCH PLAN'; rows = @{}; widths = @(5, 14, 34, 70, 10, 12, 14, 40); merges = @('A1:H1'); freeze = 3; heights = @{ 1 = 26 } }
AddRow $lp 1 @(, @(1, 'THERABOX - LAUNCH PLAN', 2))
AddRow $lp 2 @(, @(1, 'Izi = Fractional CMO + sales calls (10% of earnings). Every build step for the funnel, in order. Change STATUS as you go.', 0))
$hdr = 'ID','PHASE','TASK','DETAIL','OWNER','STATUS','DUE','NOTES / LINK'
AddRow $lp 3 @(for ($i = 0; $i -lt $hdr.Count; $i++) { , @(($i + 1), $hdr[$i], 1) })
$r = 4; $n = 1
foreach ($p in $plan) {
  AddRow $lp $r @(@(1, $n, 0), @(2, $p[0], 9), @(3, $p[1], 7), @(4, $p[2], 7), @(5, $p[3], 0), @(6, 'Not started', 0), @(7, '', 8))
  $r++; $n++
}
$lp.validations = @(, @("F4:F$($r-1)", 'Not started,In progress,Waiting on Hannah,Waiting on Izi,Done'))
[void]$sheets.Add($lp)

# ---------- Month tabs ----------
$months = @(
  @('NOV 26', 'NOVEMBER 2026'), @('DEC 26', 'DECEMBER 2026'), @('JAN 27', 'JANUARY 2027'), @('FEB 27', 'FEBRUARY 2027'),
  @('MAR 27', 'MARCH 2027'), @('APR 27', 'APRIL 2027'), @('MAY 27', 'MAY 2027'), @('JUN 27', 'JUNE 2027'),
  @('JUL 27', 'JULY 2027'), @('AUG 27', 'AUGUST 2027'), @('SEP 27', 'SEPTEMBER 2027'), @('OCT 27', 'OCTOBER 2027'))
$first = 6; $last = 105
$monthSheets = @()
foreach ($m in $months) {
  $sh = @{ name = $m[0]; rows = @{}; widths = @(9, 12, 30, 28, 17, 30, 34, 14, 12, 12, 50); merges = @('B2:C3'); freeze = 5 }
  AddRow $sh 2 @(@(2, "$($m[1]) CLOSING", 2), @(4, 'CLOSE RATE', 5), @(5, 'DEPOSIT RATE', 5), @(6, 'NO SHOW RATE', 5), @(7, 'REV PER CALL', 5), @(8, 'CASH PER CALL', 5), @(9, 'IZI 10%', 5))
  $calls = "COUNTA(B$($first):B$($last))"; $ns = "COUNTIF(H$($first):H$($last),""NO SHOW"")"
  $held = "($calls-$ns)"
  AddRow $sh 3 @(
    @(4, "=IFERROR(COUNTIF(H$($first):H$($last),""WON"")/$held,0)", 4),
    @(5, "=IFERROR(COUNTIF(H$($first):H$($last),""DEPOSIT"")/$held,0)", 4),
    @(6, "=IFERROR($ns/$calls,0)", 4),
    @(7, "=IFERROR(SUM(I$($first):I$($last))/$calls,0)", 6),
    @(8, "=IFERROR(SUM(J$($first):J$($last))/$calls,0)", 6),
    @(9, "=SUM(J$($first):J$($last))*TOTALS!`$C`$3", 6))
  $h = '', 'DATE', 'NAME', 'EMAIL', 'PHONE', 'IG LINK', 'RECORDING', 'OUTCOME', 'REVENUE', 'CASH', 'NOTES'
  AddRow $sh 5 @(for ($i = 0; $i -lt $h.Count; $i++) { , @(($i + 1), $h[$i], 1) })
  for ($k = $first; $k -le $last; $k++) { AddRow $sh $k @(@(1, "CALL $($k - $first + 1)", 5), @(2, '', 8), @(9, '', 3), @(10, '', 3)) }
  $sh.validations = @(, @("H$($first):H$($last)", 'WON,DEPOSIT,FOLLOW-UP,LOST,NO SHOW,RESCHEDULED,CANCELLED'))
  $monthSheets += $sh
}

# ---------- TOTALS ----------
$t = @{ name = 'TOTALS'; rows = @{}; widths = @(4, 12, 11, 11, 11, 11, 13, 13, 13, 12); merges = @(); freeze = 5 }
AddRow $t 1 @(, @(2, 'THERABOX SALES CALL TRACKER', 2))
AddRow $t 3 @(@(2, 'IZI SHARE', 5), @(3, 0.1, 4), @(4, '<- 10% of cash collected. Change here if the agreement changes.', 0))
$th = 'MONTH', 'SS CALLS', 'NO SHOWS', 'CLOSES', 'DEPOSITS', 'REVENUE', 'CASH', 'IZI 10%', 'CLOSE RATE'
AddRow $t 5 @(for ($i = 0; $i -lt $th.Count; $i++) { , @(($i + 2), $th[$i], 1) })
$row = 6
foreach ($m in $months) {
  $q = "'$($m[0])'!"
  AddRow $t $row @(
    @(2, $m[0], 5),
    @(3, "=COUNTA($($q)B$($first):B$($last))", 10),
    @(4, "=COUNTIF($($q)H$($first):H$($last),""NO SHOW"")", 10),
    @(5, "=COUNTIF($($q)H$($first):H$($last),""WON"")", 10),
    @(6, "=COUNTIF($($q)H$($first):H$($last),""DEPOSIT"")", 10),
    @(7, "=SUM($($q)I$($first):I$($last))", 6),
    @(8, "=SUM($($q)J$($first):J$($last))", 6),
    @(9, "=H$row*`$C`$3", 6),
    @(10, "=IFERROR(E$row/(C$row-D$row),0)", 4))
  $row++
}
$lr = $row - 1
AddRow $t $row @(@(2, 'TOTAL', 1), @(3, "=SUM(C6:C$lr)", 10), @(4, "=SUM(D6:D$lr)", 10), @(5, "=SUM(E6:E$lr)", 10), @(6, "=SUM(F6:F$lr)", 10), @(7, "=SUM(G6:G$lr)", 6), @(8, "=SUM(H6:H$lr)", 6), @(9, "=SUM(I6:I$lr)", 6), @(10, "=IFERROR(E$row/(C$row-D$row),0)", 4))
[void]$sheets.Add($t)
foreach ($s in $monthSheets) { [void]$sheets.Add($s) }

# ---------- Write the package ----------
if (Test-Path $Out) { Remove-Item $Out -Force }
$zip = [System.IO.Compression.ZipFile]::Open($Out, 'Create')
function Put($name, $text) { $e = $zip.CreateEntry($name); $w = New-Object System.IO.StreamWriter($e.Open(), (New-Object System.Text.UTF8Encoding($false))); $w.Write($text); $w.Close() }
$ct = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
for ($i = 1; $i -le $sheets.Count; $i++) { $ct += "<Override PartName=`"/xl/worksheets/sheet$i.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml`"/>" }
Put '[Content_Types].xml' ($ct + '</Types>')
Put '_rels/.rels' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>'
$wb = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>'
$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
for ($i = 1; $i -le $sheets.Count; $i++) {
  $wb += "<sheet name=`"$(Esc $sheets[$i-1].name)`" sheetId=`"$i`" r:id=`"rId$i`"/>"
  $rels += "<Relationship Id=`"rId$i`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet`" Target=`"worksheets/sheet$i.xml`"/>"
  Put "xl/worksheets/sheet$i.xml" (SheetXml $sheets[$i-1])
}
$n = $sheets.Count + 1
$rels += "<Relationship Id=`"rId$n`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles`" Target=`"styles.xml`"/></Relationships>"
Put 'xl/workbook.xml' ($wb + '</sheets><calcPr fullCalcOnLoad="1"/></workbook>')
Put 'xl/_rels/workbook.xml.rels' $rels
Put 'xl/styles.xml' $styles
$zip.Dispose()
"wrote $Out ($((Get-Item $Out).Length) bytes, $($sheets.Count) tabs)"




