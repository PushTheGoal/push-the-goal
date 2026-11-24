"""One-time import: Gem's approved drafts (queen-lml/muse clients/push-the-goal/drafts) -> src/content/blog.

Usage: python3 tools/import_drafts.py <muse checkout> <dates.tsv>
dates.tsv: slug<TAB>YYYY-MM-DD, the live WordPress publish dates (from Sage's per-post report).
Drafts without a live date (Month 3) are imported as draft: true.
"""
import re, sys, json, shutil, pathlib

muse = pathlib.Path(sys.argv[1]) / "clients/push-the-goal"
dates = dict(l.split("\t") for l in open(sys.argv[2]).read().split("\n") if "\t" in l)
out = pathlib.Path("src/content/blog"); img = pathlib.Path("src/assets/blog")
GUIDE_LINE = re.compile(r"^This post is one chapter of our \[complete guide[^\n]*\n?", re.M)
CATS = {
    "Recruiting basics": "college-soccer-recruiting-timeline is-it-too-late-to-get-recruited when-does-college-soccer-recruiting-start ncaa-eligibility-center-soccer verbal-commitment-vs-signing girls-college-soccer-recruiting goalkeeper-recruiting recruiting-platforms-vs-recruiting-strategy what-your-club-coach-will-and-wont-do do-you-need-ecnl-or-mls-next-to-get-recruited transfer-portal-high-school-recruits international-players-d1-soccer-rosters",
    "Getting noticed": "how-to-email-college-soccer-coaches how-to-get-noticed-by-college-soccer-coaches how-to-make-a-soccer-recruiting-video soccer-recruiting-profile what-college-soccer-coaches-look-for are-soccer-id-camps-worth-it social-media-and-recruiting questions-to-ask-a-college-coach college-soccer-target-school-list soccer-personal-statement-video college-soccer-visits when-college-coaches-stop-responding college-soccer-showcase-strategy small-town-soccer-recruiting",
    "Divisions and money": "d1-vs-d2-vs-d3-vs-naia-college-soccer how-to-get-a-d1-soccer-scholarship college-soccer-scholarship-requirements academic-money-vs-athletic-money grades-and-college-soccer-recruiting how-to-avoid-being-a-walk-on-college-soccer is-my-athlete-good-enough-for-d1-soccer juco-soccer-recruiting d3-soccer-recruiting naia-soccer-recruiting what-college-soccer-recruiting-costs choosing-between-college-soccer-offers",
    "For parents": "parents-role-in-soccer-recruiting recruiting-after-an-injury staying-motivated-in-recruiting",
    "Junior Prep (Grades 5 to 8)": "middle-school-soccer-recruiting when-to-start-preparing-for-college-soccer-recruiting why-kids-quit-soccer-at-14 should-my-12-year-old-specialize-in-soccer",
}
def category(slug, cats, hub):
    for name, slugs in CATS.items():
        if slug in slugs.split(): return name
    raise SystemExit(f"no category for {slug}")

rows = []
for f in sorted((muse / "drafts").glob("*.md")):
    t = f.read_text()
    m = re.match(r"---\n(.*?)\n---\n(.*)", t, re.S)
    meta, body = m.group(1), m.group(2)
    def field(name):
        mm = re.search(rf"^\s*{re.escape(name)}[^:\n]*:\s*(.+)$", meta, re.M)
        return mm.group(1).strip() if mm else ""
    slug = field("Slug")
    h1m = re.search(r"^# (.+)$", body, re.M)
    title = h1m.group(1).strip() if h1m else field("Suggested title")
    body = body[h1m.end():].lstrip("\n") if h1m else body
    # Izi's bio footer is rendered by the template
    body = re.split(r"\n---\n\*Izi Murray", body)[0].rstrip() + "\n"
    had_guide = bool(GUIDE_LINE.search(body))
    body = GUIDE_LINE.sub("", body)
    seo = field("SEO title tag")
    desc = field("Meta description")
    cats = field("Categories")
    hub = field("Hub")
    kw = field("Primary keyword")
    cat = category(slug, cats, hub)
    date = dates.get(slug)
    hdr = muse / "blog-headers" / f"{slug}-header.png"
    fm = {"title": title, "seoTitle": seo or title, "description": desc, "category": cat,
          "keyword": kw, "date": (date + "T11:00:00Z") if date else "2026-12-31T11:00:00Z"}
    lines = ["---"] + [f"{k}: {json.dumps(v, ensure_ascii=False)}" for k, v in fm.items()]
    if hdr.exists():
        shutil.copy(hdr, img / hdr.name); lines.append(f"image: ../../assets/blog/{hdr.name}")
    if not date: lines.append("draft: true")
    lines.append("---")
    (out / f"{slug}.md").write_text("\n".join(lines) + "\n\n" + body)
    rows.append((slug, date or "DRAFT", cat, hdr.exists(), had_guide, f.name))
for r in rows: print(*r, sep="\t")
