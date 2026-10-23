# Builds the two TheraBox workbooks as .xlsx files:
#   ceo   - "TheraBox CEO Tracker": DASHBOARD + one colour-coded task tab per area
#   sales - "TheraBox Sales Call Tracker": TOTALS + one tab per month, calls only
# This laptop has no Python and the Sheets editor connector is off, so each workbook is built
# here, uploaded to Drive, opened in Sheets and saved as a Google Sheet. Checkboxes are added
# in Sheets afterwards (Insert > Checkbox on each task tab's A5:A40) - xlsx has no checkbox.
# Usage: .\build-workbooks.ps1 -Which ceo|sales -Out <path.xlsx> [-SalesUrl <url>] [-CeoUrl <url>]
param([string]$Which, [string]$Out, [string]$SalesUrl = '', [string]$CeoUrl = '')
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$DocUrl = 'https://claude.ai/artifact/P3wZRN2z5LuSi8LXiouuvW'
$FolderUrl = 'https://drive.google.com/drive/folders/1YyQOesywCnpq8I7LGamxa14jLfG1nLkf'

function Esc($s) { [System.Security.SecurityElement]::Escape([string]$s) }
function ColL([int]$n) { $s = ''; while ($n -gt 0) { $m = ($n - 1) % 26; $s = [char](65 + $m) + $s; $n = [math]::Floor(($n - 1) / 26) }; $s }
function NewSheet($name, $tab, $widths, $freeze) { @{ name = $name; tab = $tab; widths = $widths; freeze = $freeze; cells = @{}; heights = @{}; merges = @(); validations = @(); cf = @() } }
function Put($sh, [int]$r, [int]$c, $val, [int]$style = 0) { if (-not $sh.cells.ContainsKey($r)) { $sh.cells[$r] = @{} }; $sh.cells[$r][$c] = @($val, $style) }
function CellXml($ref, $val, [int]$style) {
  if ($val -is [bool]) { return "<c r=`"$ref`" s=`"$style`" t=`"b`"><v>$([int]$val)</v></c>" }
  if ($null -eq $val -or ($val -is [string] -and $val -eq '')) { return "<c r=`"$ref`" s=`"$style`"/>" }
  if ($val -is [string] -and $val.StartsWith('=')) { return "<c r=`"$ref`" s=`"$style`"><f>$(Esc $val.Substring(1))</f></c>" }
  if ($val -is [int] -or $val -is [double]) { return "<c r=`"$ref`" s=`"$style`"><v>$val</v></c>" }
  "<c r=`"$ref`" s=`"$style`" t=`"inlineStr`"><is><t xml:space=`"preserve`">$(Esc $val)</t></is></c>"
}
function SheetXml($sh) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">')
  [void]$sb.Append("<sheetPr><tabColor rgb=`"FF$($sh.tab)`"/></sheetPr>")
  [void]$sb.Append('<sheetViews><sheetView workbookViewId="0" showGridLines="0">')
  if ($sh.freeze) { [void]$sb.Append("<pane ySplit=`"$($sh.freeze)`" topLeftCell=`"A$($sh.freeze + 1)`" activePane=`"bottomLeft`" state=`"frozen`"/>") }
  [void]$sb.Append('</sheetView></sheetViews><cols>')
  for ($i = 0; $i -lt $sh.widths.Count; $i++) { [void]$sb.Append("<col min=`"$($i+1)`" max=`"$($i+1)`" width=`"$($sh.widths[$i])`" customWidth=`"1`"/>") }
  [void]$sb.Append('</cols><sheetData>')
  foreach ($r in ($sh.cells.Keys | Sort-Object)) {
    $ht = ''; if ($sh.heights.ContainsKey($r)) { $ht = " ht=`"$($sh.heights[$r])`" customHeight=`"1`"" }
    [void]$sb.Append("<row r=`"$r`"$ht>")
    $row = $sh.cells[$r]
    foreach ($c in ($row.Keys | Sort-Object)) { $v = $row[$c]; [void]$sb.Append((CellXml "$(ColL $c)$r" $v[0] $v[1])) }
    [void]$sb.Append('</row>')
  }
  [void]$sb.Append('</sheetData>')
  if ($sh.merges.Count) { [void]$sb.Append("<mergeCells count=`"$($sh.merges.Count)`">"); foreach ($m in $sh.merges) { [void]$sb.Append("<mergeCell ref=`"$m`"/>") }; [void]$sb.Append('</mergeCells>') }
  $p = 1
  foreach ($cf in $sh.cf) {
    $rule = if ($cf.kind -eq 'eq') { "<cfRule type=`"cellIs`" dxfId=`"$($cf.dxf)`" priority=`"$p`" operator=`"equal`"><formula>$(Esc ('"' + $cf.value + '"'))</formula></cfRule>" }
            else { "<cfRule type=`"expression`" dxfId=`"$($cf.dxf)`" priority=`"$p`"><formula>$(Esc $cf.value.TrimStart('='))</formula></cfRule>" }
    [void]$sb.Append("<conditionalFormatting sqref=`"$($cf.sqref)`">$rule</conditionalFormatting>"); $p++
  }
  if ($sh.validations.Count) {
    [void]$sb.Append("<dataValidations count=`"$($sh.validations.Count)`">")
    foreach ($v in $sh.validations) { [void]$sb.Append("<dataValidation type=`"list`" allowBlank=`"1`" showErrorMessage=`"1`" sqref=`"$($v.sqref)`"><formula1>$(Esc ('"' + $v.list + '"'))</formula1></dataValidation>") }
    [void]$sb.Append('</dataValidations>')
  }
  [void]$sb.Append('</worksheet>')
  $sb.ToString()
}
function CfEq($sh, $sqref, $value, $dxf) { $sh.cf += @{ kind = 'eq'; sqref = $sqref; value = $value; dxf = $dxf } }
function CfExpr($sh, $sqref, $formula, $dxf) { $sh.cf += @{ kind = 'expr'; sqref = $sqref; value = $formula; dxf = $dxf } }

# ---------- Styles ----------
# cellXfs: 0 body | 1 header | 2 title | 3 currency | 4 bold % centre | 5 bold label centre | 6 bold currency centre
# 7 wrap | 8 date | 9 subtitle | 10 bold number centre | 11 stat label | 12 stat number | 13 stat % | 14 stat currency
# 15 link | 16 checkbox centre | 17 task (bold wrap) | 18 section heading | 19 progress bar | 20 owner/status centre
# 21 cross-off cell (green) | 22 cross-off header | 23 input currency (yellow) | 24 help text (indigo)
# 25 deal % (indigo) | 26 deal label (indigo) | 27 deal currency (indigo)
# Headers are light (indigo on pale indigo) - Izi found the black header bars too hard to read.
$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<numFmts count="1"><numFmt numFmtId="164" formatCode="&quot;$&quot;#,##0"/></numFmts>
<fonts count="9">
<font><sz val="10"/><color rgb="FF1F2937"/><name val="Arial"/></font>
<font><b/><sz val="10"/><color rgb="FF312E81"/><name val="Arial"/></font>
<font><b/><sz val="18"/><color rgb="FF111827"/><name val="Arial"/></font>
<font><b/><sz val="10"/><color rgb="FF1F2937"/><name val="Arial"/></font>
<font><i/><sz val="10"/><color rgb="FF6B7280"/><name val="Arial"/></font>
<font><b/><sz val="16"/><color rgb="FF111827"/><name val="Arial"/></font>
<font><u/><sz val="10"/><color rgb="FF1D4ED8"/><name val="Arial"/></font>
<font><b/><sz val="9"/><color rgb="FF6B7280"/><name val="Arial"/></font>
<font><b/><sz val="12"/><color rgb="FF111827"/><name val="Arial"/></font>
<font><b/><sz val="10"/><color rgb="FF166534"/><name val="Arial"/></font>
<font><sz val="11"/><color rgb="FF1F2937"/><name val="Arial"/></font>
</fonts>
<fills count="8">
<fill><patternFill patternType="none"/></fill>
<fill><patternFill patternType="gray125"/></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFE0E7FF"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFF3F4F6"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFFEF3C7"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFF0FDF4"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFBBF7D0"/><bgColor indexed="64"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFEEF2FF"/><bgColor indexed="64"/></patternFill></fill>
</fills>
<borders count="2"><border><left/><right/><top/><bottom/><diagonal/></border>
<border><left/><right/><top/><bottom style="thin"><color rgb="FFE5E7EB"/></bottom><diagonal/></border></borders>
<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs count="28">
<xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
<xf numFmtId="0" fontId="2" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="164" fontId="0" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyBorder="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="9" fontId="3" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyFont="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="164" fontId="3" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyFont="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>
<xf numFmtId="14" fontId="0" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="4" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="7" fillId="3" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
<xf numFmtId="0" fontId="5" fillId="3" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="9" fontId="5" fillId="3" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="164" fontId="5" fillId="3" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="6" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>
<xf numFmtId="0" fontId="8" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment vertical="center"/></xf>
<xf numFmtId="0" fontId="3" fillId="0" borderId="1" xfId="0" applyFont="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="0" fillId="5" borderId="1" xfId="0" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="9" fillId="6" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
<xf numFmtId="164" fontId="3" fillId="4" borderId="1" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="10" fillId="7" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>
<xf numFmtId="9" fontId="5" fillId="7" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="7" fillId="7" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
<xf numFmtId="164" fontId="5" fillId="7" borderId="0" xfId="0" applyNumberFormat="1" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
</cellXfs>
<dxfs count="16">
<dxf><font><strike/><color rgb="FF6B7280"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFDCFCE7"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF1E40AF"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFDBEAFE"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF9D174D"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFCE7F3"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF5B21B6"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFEDE9FE"/></patternFill></fill></dxf>
<dxf><font><color rgb="FF374151"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFF3F4F6"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF92400E"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFEF3C7"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF9A3412"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFFEDD5"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF166534"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFDCFCE7"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF166534"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFBBF7D0"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF115E59"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFCCFBF1"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF854D0E"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFEF9C3"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF991B1B"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFEE2E2"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF374151"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFE5E7EB"/></patternFill></fill></dxf>
<dxf><font><b/><color rgb="FF9A3412"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFFFEDD5"/></patternFill></fill></dxf>
<dxf><font><color rgb="FF6B7280"/></font><fill><patternFill patternType="solid"><bgColor rgb="FFF3F4F6"/></patternFill></fill></dxf>
<dxf><fill><patternFill patternType="solid"><bgColor rgb="FFF9FAFB"/></patternFill></fill></dxf>
</dxfs>
</styleSheet>
'@
# dxf ids
$D = @{ done = 0; izi = 1; hannah = 2; both = 3; notstarted = 4; inprogress = 5; waiting = 6; statusdone = 7
        won = 8; deposit = 9; followup = 10; lost = 11; noshow = 12; resched = 13; cancelled = 14; band = 15 }

$sheets = New-Object System.Collections.ArrayList

if ($Which -eq 'ceo') {
  # ---------- Task areas ----------
  $areas = @(
    @{ name = 'FOUNDATION'; tab = '64748B'; blurb = 'The offer, the price, the agreement - everything the funnel needs decided first.'; link = ''; tasks = @(
      @('Lock the offer', 'What Izi sells on the call: program name, length, what is included, online (Skool) or in person in Nashville.', 'Both'),
      @('Set price and payment plans', 'Internal only. Lives on the sales tracker - never on the VSL, booking page or Instagram.', 'Both'),
      @('Sign the agreement', 'Izi gets 10% of all TheraBox earnings as Fractional CMO, plus 15% of every sale he closes. Write down what counts as earnings, when each is paid, the start date.', 'Both'),
      @('Payment link for closing on the call', 'Checkout link for full pay and each payment plan, so Izi can close live.', 'Hannah'),
      @('Fathom on every TheraBox call', 'Title each call "TheraBox - [Name]" so it never mixes with Push the Goal calls.', 'Izi')) },
    @{ name = 'VSL'; tab = 'DC2626'; blurb = 'The 10-12 minute video that sells the call. Outline is in the launch plan doc.'; link = 'VSL outline'; tasks = @(
      @('Approve the VSL outline', '8 sections, about 12 minutes.', 'Hannah'),
      @('Story call with Hannah', '30 minutes to capture her story, client wins and how she runs a session.', 'Both'),
      @('Write the VSL script', 'Built from the outline in Hannah''s own words.', 'Izi'),
      @('Film the VSL', 'Section by section, gloves in frame, natural light.', 'Hannah'),
      @('Edit, caption and host', 'Unlisted YouTube or Wistia. Captions burned in.', 'Izi'),
      @('Put the VSL on the booking page', 'Video above the calendar.', 'Izi')) },
    @{ name = 'INSTAGRAM'; tab = 'DB2777'; blurb = 'Her 98.1K personal account is where the funnel starts.'; link = ''; tasks = @(
      @('Add a link in bio', 'There is no link today. Point it at the booking page.', 'Hannah'),
      @('Pin 3 posts', 'Her story, what TheraBox is, one client transformation.', 'Hannah'),
      @('"Start Here" highlight', 'VSL clip + the keyword.', 'Hannah'),
      @('3 reels a week with the keyword CTA', 'Each one ends on "Comment [KEYWORD]".', 'Hannah')) },
    @{ name = 'MANYCHAT'; tab = '2563EB'; blurb = 'Comment or DM the keyword - 2 questions - VSL - booking link.'; link = 'ManyChat flow'; tasks = @(
      @('Pick the keyword', 'Working pick THERA. Alternatives HEAL, BOX.', 'Hannah'),
      @('Connect ManyChat Pro to Instagram', 'On Hannah''s account; she adds Izi as admin.', 'Hannah'),
      @('Keyword triggers', 'Comment, DM and story reply all start the same flow.', 'Izi'),
      @('Build the DM flow', 'Open - why now - Nashville or online - email - VSL - book.', 'Izi'),
      @('Nudge for people who did not book', 'One nudge about 23 hours later. Instagram only allows automated DMs within 24 hours; email after that.', 'Izi'),
      @('Test it end to end', 'From a second Instagram account: comment, DM, watch, book.', 'Izi')) },
    @{ name = 'BOOKING'; tab = '0891B2'; blurb = 'Booking page with the 12 qualifying questions.'; link = 'Booking page'; tasks = @(
      @('Calendar for TheraBox calls', 'Izi''s availability, 45 minutes, Zoom with Fathom.', 'Izi'),
      @('Booking page', 'Headline, VSL, what happens on the call, calendar.', 'Izi'),
      @('12 qualifying questions', 'Under 18 or "not right now" never reaches the calendar.', 'Izi'),
      @('Confirmation and reminders', 'Now, 24 hours and 1 hour before - each links the VSL.', 'Izi'),
      @('Booked calls land on the sales tracker', 'Automation, or Izi logs them the same day.', 'Izi')) },
    @{ name = 'SALES'; tab = '16A34A'; blurb = 'Izi takes every call. The calls themselves live on the TheraBox Sales Call Tracker.'; link = 'Sales calls'; tasks = @(
      @('TheraBox sales script', 'Adapt the Push the Goal v3 script once the offer is locked.', 'Izi'),
      @('Log every call the same day', 'On the TheraBox Sales Call Tracker.', 'Izi'),
      @('Follow-up for FOLLOW-UP calls', 'Written from each person''s own call. Asks for a decision, never another call.', 'Izi'),
      @('Weekly numbers review', 'Calls, show rate, close rate, cash, Izi''s 10% and 15%.', 'Both')) },
    @{ name = 'SKOOL'; tab = '7C3AED'; blurb = 'Where clients live once they buy.'; link = 'Skool community'; tasks = @(
      @('Free or paid', 'Paid program home, free funnel, or both. Decide before building.', 'Both'),
      @('Create the Skool group', 'Hannah owns the account and billing, adds Izi as admin.', 'Hannah'),
      @('Cover, about page, categories', 'Start Here, Wins, Prayer and Faith, Workouts, Questions.', 'Izi'),
      @('Classroom', 'Start Here, Mind, Body, Spirit, Live call replays.', 'Izi'),
      @('Welcome post and auto DM', 'Pinned intro template for new members.', 'Izi'),
      @('Weekly live call', 'Same time every week, on the Skool calendar.', 'Hannah')) },
    @{ name = 'LAUNCH'; tab = 'EA580C'; blurb = 'Going live to her audience.'; link = ''; tasks = @(
      @('Announce to her audience', 'Story sequence + reel to her 98K, pointing at the keyword.', 'Hannah'),
      @('First week check', 'Comments, DMs, bookings, show-ups - fix what leaks.', 'Both')) }
  )
  $first = 5; $last = 40

  # ---------- DASHBOARD ----------
  $db = NewSheet 'DASHBOARD' '4F46E5' @(3, 18, 10, 10, 10, 18, 9, 12, 14) 0
  Put $db 1 2 'THERABOX CEO TRACKER' 2; $db.heights[1] = 34
  Put $db 2 2 'Hannah Beyler - TheraBox. Izi runs marketing as Fractional CMO and closes every sales call.' 9

  # Izi's deal - the two ways he is paid
  Put $db 4 2 'IZI''S DEAL' 18
  Put $db 5 2 'FRACTIONAL CMO' 26; $db.merges += 'B5:D5'; Put $db 5 3 '' 26; Put $db 5 4 '' 26
  Put $db 5 6 'CLOSER' 26; $db.merges += 'F5:I5'; foreach ($c in 7, 8, 9) { Put $db 5 $c '' 26 }
  Put $db 6 2 0.1 25; $db.merges += 'B6:D6'; Put $db 6 3 '' 25; Put $db 6 4 '' 25
  Put $db 6 6 0.15 25; $db.merges += 'F6:I6'; foreach ($c in 7, 8, 9) { Put $db 6 $c '' 25 }
  Put $db 7 2 'of all TheraBox earnings, every month' 26; $db.merges += 'B7:D7'; Put $db 7 3 '' 26; Put $db 7 4 '' 26
  Put $db 7 6 'of every sale Izi closes on a call' 26; $db.merges += 'F7:I7'; foreach ($c in 7, 8, 9) { Put $db 7 $c '' 26 }
  $db.heights[5] = 20; $db.heights[6] = 40; $db.heights[7] = 22
  if ($SalesUrl) { Put $db 8 2 "=HYPERLINK(""$SalesUrl"",""What Izi has earned so far is on the Sales Call Tracker - TOTALS tab"")" 15; $db.merges += 'B8:I8' }

  # How to cross off a task
  Put $db 10 2 'HOW TO CROSS OFF A TASK' 18
  Put $db 11 2 '1.  Click an area tab at the bottom of the screen (FOUNDATION, VSL, INSTAGRAM ...).' 24
  Put $db 12 2 '2.  Tick the box in the green CROSS OFF column next to the task.' 24
  Put $db 13 2 '3.  The task turns green and is crossed out, and the progress below updates.' 24
  foreach ($hr in 11, 12, 13) { $db.merges += "B$($hr):I$($hr)"; foreach ($c in 3..9) { Put $db $hr $c '' 24 }; $db.heights[$hr] = 22 }

  Put $db 15 2 'PROGRESS' 18
  Put $db 16 2 'AREA' 1; Put $db 16 3 'TASKS' 1; Put $db 16 4 'DONE' 1; Put $db 16 5 'LEFT' 1; Put $db 16 6 'PROGRESS' 1; Put $db 16 7 '%' 1; Put $db 16 8 'IZI OPEN' 1; Put $db 16 9 'HANNAH OPEN' 1
  $db.heights[16] = 24
  $r = 17
  $top = $r
  foreach ($a in $areas) {
    $q = "'$($a.name)'!"
    Put $db $r 2 $a.name 19
    Put $db $r 3 "=COUNTA($($q)B$($first):B$($last))" 10
    Put $db $r 4 "=COUNTIF($($q)A$($first):A$($last),TRUE)" 10
    Put $db $r 5 "=C$r-D$r" 10
    Put $db $r 6 "=REPT(""█"",ROUND(G$r*10,0))&REPT(""░"",10-ROUND(G$r*10,0))" 16
    Put $db $r 7 "=IFERROR(D$r/C$r,0)" 4
    Put $db $r 8 "=COUNTIFS($($q)D$($first):D$($last),""Izi"",$($q)A$($first):A$($last),FALSE)+COUNTIFS($($q)D$($first):D$($last),""Both"",$($q)A$($first):A$($last),FALSE)" 10
    Put $db $r 9 "=COUNTIFS($($q)D$($first):D$($last),""Hannah"",$($q)A$($first):A$($last),FALSE)+COUNTIFS($($q)D$($first):D$($last),""Both"",$($q)A$($first):A$($last),FALSE)" 10
    $db.heights[$r] = 22
    $r++
  }
  $lr = $r - 1
  Put $db $r 2 'ALL' 1; Put $db $r 3 "=SUM(C$($top):C$lr)" 1; Put $db $r 4 "=SUM(D$($top):D$lr)" 1; Put $db $r 5 "=SUM(E$($top):E$lr)" 1
  Put $db $r 6 "=REPT(""█"",ROUND(G$r*10,0))&REPT(""░"",10-ROUND(G$r*10,0))" 1; Put $db $r 7 "=IFERROR(D$r/C$r,0)" 4; Put $db $r 8 "=SUM(H$($top):H$lr)" 1; Put $db $r 9 "=SUM(I$($top):I$lr)" 1
  $db.heights[$r] = 24
  CfExpr $db "B$($top):I$lr" "=AND(`$C$top>0,`$D$top=`$C$top)" $D.statusdone
  CfExpr $db "B$($top):I$lr" "=`$D$top>0" $D.inprogress
  $r += 2
  Put $db $r 2 'LINKS' 18; $r++
  $links = @(
    @('TheraBox Sales Call Tracker', $SalesUrl, 'Every sales call Izi takes, by month, with what Izi has earned'),
    @('TheraBox Launch Plan (doc)', $DocUrl, 'Funnel, VSL outline, ManyChat flow, booking questions, Skool setup'),
    @('TheraBox Drive folder', $FolderUrl, 'Everything for TheraBox in one place'),
    @('Hannah on Instagram', 'https://www.instagram.com/hannah_beyler/', '@hannah_beyler - 98.1K followers'),
    @('TheraBox on Instagram', 'https://www.instagram.com/therabox_/', '@therabox_'))
  foreach ($l in $links) {
    if ($l[1]) { Put $db $r 2 "=HYPERLINK(""$($l[1])"",""$($l[0])"")" 15 } else { Put $db $r 2 $l[0] 0 }
    $db.merges += "B$($r):D$($r)"; $db.merges += "E$($r):I$($r)"
    Put $db $r 5 $l[2] 9; $db.heights[$r] = 20; $r++
  }
  $r++
  Put $db $r 2 'KEY' 18; $r++
  Put $db $r 2 'Izi' 20; Put $db $r 3 'Both' 20; Put $db $r 4 'Hannah' 20
  CfEq $db "B$($r):D$($r)" 'Izi' $D.izi; CfEq $db "B$($r):D$($r)" 'Hannah' $D.hannah; CfEq $db "B$($r):D$($r)" 'Both' $D.both
  Put $db $r 6 'Crossed off = green with a line through it' 9
  [void]$sheets.Add($db)

  # ---------- One tab per area ----------
  foreach ($a in $areas) {
    $sh = NewSheet $a.name $a.tab @(12, 34, 62, 11, 19, 12, 34) 4
    Put $sh 1 1 $a.name 2; $sh.heights[1] = 34; $sh.merges += 'A1:C1'
    Put $sh 2 1 "$($a.blurb)  Tick CROSS OFF when a task is done." 9; $sh.merges += 'A2:G2'
    Put $sh 4 1 "CROSS OFF`n✓" 22
    $h = 'TASK', 'DETAIL', 'OWNER', 'STATUS', 'DUE', 'LINK / NOTES'
    for ($i = 0; $i -lt $h.Count; $i++) { Put $sh 4 ($i + 2) $h[$i] 1 }
    $sh.heights[4] = 30
    $r = $first
    foreach ($t in $a.tasks) {
      Put $sh $r 1 $false 21; Put $sh $r 2 $t[0] 17; Put $sh $r 3 $t[1] 7; Put $sh $r 4 $t[2] 20; Put $sh $r 5 'Not started' 20; Put $sh $r 6 '' 8
      if ($a.name -eq 'SALES' -and $SalesUrl) { Put $sh $r 7 "=HYPERLINK(""$SalesUrl"",""Sales Call Tracker"")" 15 }
      elseif ($a.link) { Put $sh $r 7 "=HYPERLINK(""$DocUrl"",""Launch plan - $($a.link)"")" 15 }
      else { Put $sh $r 7 '' 7 }
      $sh.heights[$r] = 32
      $r++
    }
    for (; $r -le $last; $r++) { Put $sh $r 1 $false 21; Put $sh $r 2 '' 17; Put $sh $r 3 '' 7; Put $sh $r 4 '' 20; Put $sh $r 5 '' 20; Put $sh $r 6 '' 8; Put $sh $r 7 '' 7 }
    CfExpr $sh "A$($first):G$($last)" "=`$A$first=TRUE" $D.done
    CfEq $sh "D$($first):D$($last)" 'Izi' $D.izi
    CfEq $sh "D$($first):D$($last)" 'Hannah' $D.hannah
    CfEq $sh "D$($first):D$($last)" 'Both' $D.both
    CfEq $sh "E$($first):E$($last)" 'Not started' $D.notstarted
    CfEq $sh "E$($first):E$($last)" 'In progress' $D.inprogress
    CfEq $sh "E$($first):E$($last)" 'Waiting on Hannah' $D.waiting
    CfEq $sh "E$($first):E$($last)" 'Waiting on Izi' $D.waiting
    CfEq $sh "E$($first):E$($last)" 'Done' $D.statusdone
    $sh.validations += @{ sqref = "D$($first):D$($last)"; list = 'Izi,Hannah,Both' }
    $sh.validations += @{ sqref = "E$($first):E$($last)"; list = 'Not started,In progress,Waiting on Hannah,Waiting on Izi,Done' }
    [void]$sheets.Add($sh)
  }
}
elseif ($Which -eq 'sales') {
  $months = @(
    @('NOV 26', 'NOVEMBER 2026', '7C3AED'), @('DEC 26', 'DECEMBER 2026', '2563EB'), @('JAN 27', 'JANUARY 2027', '0891B2'), @('FEB 27', 'FEBRUARY 2027', 'DB2777'),
    @('MAR 27', 'MARCH 2027', '16A34A'), @('APR 27', 'APRIL 2027', '65A30D'), @('MAY 27', 'MAY 2027', 'CA8A04'), @('JUN 27', 'JUNE 2027', 'EA580C'),
    @('JUL 27', 'JULY 2027', 'DC2626'), @('AUG 27', 'AUGUST 2027', 'E11D48'), @('SEP 27', 'SEPTEMBER 2027', '9333EA'), @('OCT 27', 'OCTOBER 2027', '4F46E5'))
  $first = 6; $last = 105

  # ---------- TOTALS ----------
  # Izi is paid two ways: 10% of ALL TheraBox earnings (Fractional CMO) + 15% of every sale he
  # closes (closer). Closer pay is worked from the cash his calls collect; FCMO pay needs Hannah's
  # total earnings for the month, typed into the yellow column.
  $t = NewSheet 'TOTALS' '4F46E5' @(3, 12, 9, 10, 9, 10, 12, 14, 16, 13, 13, 13, 11) 5
  Put $t 1 2 'THERABOX SALES CALL TRACKER' 2; $t.heights[1] = 34
  if ($CeoUrl) { Put $t 1 11 "=HYPERLINK(""$CeoUrl"",""Open the CEO Tracker"")" 15 }
  Put $t 2 2 'Every sales call Izi takes for TheraBox. Log each call on its month tab the same day.' 9
  Put $t 3 2 'IZI FCMO' 26; Put $t 3 3 0.1 25; Put $t 3 4 'of all TheraBox earnings' 26; $t.merges += 'D3:E3'; Put $t 3 5 '' 26
  Put $t 3 7 'IZI CLOSER' 26; Put $t 3 8 0.15 25; Put $t 3 9 'of every sale he closes' 26; $t.merges += 'I3:J3'; Put $t 3 10 '' 26
  $t.heights[3] = 34
  Put $t 4 2 'Type Hannah''s total TheraBox earnings for each month in the yellow column. Everything else fills itself in.' 9
  $th = 'MONTH', 'CALLS', 'NO SHOWS', 'CLOSES', 'DEPOSIT', 'REVENUE', "CASH FROM`nIZI'S CALLS", 'ALL EARNINGS', "IZI 10%`nFCMO", "IZI 15%`nCLOSER", "IZI`nTOTAL", 'CLOSE RATE'
  for ($i = 0; $i -lt $th.Count; $i++) { Put $t 5 ($i + 2) $th[$i] 1 }
  $t.heights[5] = 32
  $row = 6
  foreach ($m in $months) {
    $q = "'$($m[0])'!"
    Put $t $row 2 $m[0] 19
    Put $t $row 3 "=COUNTA($($q)B$($first):B$($last))" 10
    Put $t $row 4 "=COUNTIF($($q)H$($first):H$($last),""NO SHOW"")" 10
    Put $t $row 5 "=COUNTIF($($q)H$($first):H$($last),""WON"")" 10
    Put $t $row 6 "=COUNTIF($($q)H$($first):H$($last),""DEPOSIT"")" 10
    Put $t $row 7 "=SUM($($q)I$($first):I$($last))" 6
    Put $t $row 8 "=SUM($($q)J$($first):J$($last))" 6
    Put $t $row 9 '' 23
    Put $t $row 10 "=I$row*`$C`$3" 6
    Put $t $row 11 "=H$row*`$H`$3" 6
    Put $t $row 12 "=J$row+K$row" 6
    Put $t $row 13 "=IFERROR(E$row/(C$row-D$row),0)" 4
    $t.heights[$row] = 22
    $row++
  }
  $lr = $row - 1
  Put $t $row 2 'TOTAL' 1
  foreach ($c in 3..12) { $L = ColL $c; Put $t $row $c "=SUM($($L)6:$L$lr)" 1 }
  Put $t $row 13 "=IFERROR(E$row/(C$row-D$row),0)" 4
  $t.heights[$row] = 24
  $row += 2
  Put $t $row 2 'IZI EARNED TO DATE' 26; $t.merges += "B$($row):D$($row)"; Put $t $row 3 '' 26; Put $t $row 4 '' 26
  Put $t $row 5 "=L$($lr + 1)" 27; $t.merges += "E$($row):G$($row)"; Put $t $row 6 '' 27; Put $t $row 7 '' 27
  $t.heights[$row] = 36
  CfExpr $t "B6:H$lr" '=$E6>0' $D.statusdone
  CfExpr $t "J6:M$lr" '=$E6>0' $D.statusdone
  [void]$sheets.Add($t)

  # ---------- Month tabs ----------
  foreach ($m in $months) {
    $sh = NewSheet $m[0] $m[2] @(9, 12, 30, 28, 17, 30, 34, 15, 12, 12, 50) 5
    Put $sh 1 2 "$($m[1])" 2; $sh.heights[1] = 34; $sh.merges += 'B1:D1'
    $labels = @(@(4, 'CLOSE RATE'), @(5, 'DEPOSIT RATE'), @(6, 'NO SHOW RATE'), @(7, 'REV PER CALL'), @(8, 'CASH PER CALL'), @(9, 'IZI 15% CLOSER'))
    Put $sh 2 2 'CALLS' 11; Put $sh 2 3 'CLOSES' 11
    foreach ($l in $labels) { Put $sh 2 $l[0] $l[1] 11 }
    $sh.heights[2] = 22; $sh.heights[3] = 34
    $calls = "COUNTA(B$($first):B$($last))"; $ns = "COUNTIF(H$($first):H$($last),""NO SHOW"")"; $held = "($calls-$ns)"
    Put $sh 3 2 "=$calls" 12
    Put $sh 3 3 "=COUNTIF(H$($first):H$($last),""WON"")" 12
    Put $sh 3 4 "=IFERROR(COUNTIF(H$($first):H$($last),""WON"")/$held,0)" 13
    Put $sh 3 5 "=IFERROR(COUNTIF(H$($first):H$($last),""DEPOSIT"")/$held,0)" 13
    Put $sh 3 6 "=IFERROR($ns/$calls,0)" 13
    Put $sh 3 7 "=IFERROR(SUM(I$($first):I$($last))/$calls,0)" 14
    Put $sh 3 8 "=IFERROR(SUM(J$($first):J$($last))/$calls,0)" 14
    Put $sh 3 9 "=SUM(J$($first):J$($last))*TOTALS!`$H`$3" 14
    $h = '', 'DATE', 'NAME', 'EMAIL', 'PHONE', 'IG LINK', 'RECORDING', 'OUTCOME', 'REVENUE', 'CASH', 'NOTES'
    for ($i = 0; $i -lt $h.Count; $i++) { Put $sh 5 ($i + 1) $h[$i] 1 }
    $sh.heights[5] = 24
    for ($k = $first; $k -le $last; $k++) {
      Put $sh $k 1 "CALL $($k - $first + 1)" 5; Put $sh $k 2 '' 8; Put $sh $k 3 '' 17; Put $sh $k 8 '' 20; Put $sh $k 9 '' 3; Put $sh $k 10 '' 3
      foreach ($c in 4, 5, 6, 7) { Put $sh $k $c '' 0 }; Put $sh $k 11 '' 7
    }
    $o = "H$($first):H$($last)"
    CfEq $sh $o 'WON' $D.won; CfEq $sh $o 'DEPOSIT' $D.deposit; CfEq $sh $o 'FOLLOW-UP' $D.followup; CfEq $sh $o 'LOST' $D.lost
    CfEq $sh $o 'NO SHOW' $D.noshow; CfEq $sh $o 'RESCHEDULED' $D.resched; CfEq $sh $o 'CANCELLED' $D.cancelled
    CfExpr $sh "A$($first):K$($last)" "=MOD(ROW(),2)=0" $D.band
    $sh.validations += @{ sqref = $o; list = 'WON,DEPOSIT,FOLLOW-UP,LOST,NO SHOW,RESCHEDULED,CANCELLED' }
    [void]$sheets.Add($sh)
  }
}
else { throw 'Which must be ceo or sales' }

# ---------- Write the package ----------
if (Test-Path $Out) { Remove-Item $Out -Force }
$zip = [System.IO.Compression.ZipFile]::Open($Out, 'Create')
function Entry($name, $text) { $e = $zip.CreateEntry($name); $w = New-Object System.IO.StreamWriter($e.Open(), (New-Object System.Text.UTF8Encoding($false))); $w.Write($text); $w.Close() }
$ct = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
for ($i = 1; $i -le $sheets.Count; $i++) { $ct += "<Override PartName=`"/xl/worksheets/sheet$i.xml`" ContentType=`"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml`"/>" }
Entry '[Content_Types].xml' ($ct + '</Types>')
Entry '_rels/.rels' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>'
$wb = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>'
$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
for ($i = 1; $i -le $sheets.Count; $i++) {
  $wb += "<sheet name=`"$(Esc $sheets[$i-1].name)`" sheetId=`"$i`" r:id=`"rId$i`"/>"
  $rels += "<Relationship Id=`"rId$i`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet`" Target=`"worksheets/sheet$i.xml`"/>"
  Entry "xl/worksheets/sheet$i.xml" (SheetXml $sheets[$i-1])
}
$n = $sheets.Count + 1
$rels += "<Relationship Id=`"rId$n`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles`" Target=`"styles.xml`"/></Relationships>"
Entry 'xl/workbook.xml' ($wb + '</sheets><calcPr fullCalcOnLoad="1"/></workbook>')
Entry 'xl/_rels/workbook.xml.rels' $rels
Entry 'xl/styles.xml' $styles
$zip.Dispose()
"wrote $Out ($((Get-Item $Out).Length) bytes, $($sheets.Count) tabs: $(($sheets | ForEach-Object { $_.name }) -join ', '))"
