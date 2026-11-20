"""One-time: the six 2023 posts, rescued from the Wayback Machine (2024 captures), into src/content/blog.
Izi's own words; only em dashes are swapped for commas (house rule). Usage:
  python3 tools/import_wayback.py <dir of archived .html files>
"""
import re, sys, html, json, pathlib
DATES = {"embracing-identity-beyond-the-field-a-journey-of-growth": "2023-11-22", "the-importance-of-holistic-health-for-athletes": "2023-11-22"}
CAT = {"tips-for-getting-recruited": "Getting noticed", "why-you-have-to-promote-yourself-to-get-to-the-next-level": "Getting noticed",
       "tips-for-making-try-outs": "Recruiting basics"}
for f in sorted(pathlib.Path(sys.argv[1]).glob("*.html")):
    slug = f.stem; h = f.read_text(errors="replace")
    title = html.unescape(re.search(r"<title>(.*?)</title>", h, re.S).group(1)).replace(" - Push The Goal", "").strip()
    md = re.search(r'name="description" content="([^"]*)"', h)
    i = h.find('data-elementor-type="wp-post"')
    seg = h[i:]
    for stop in ("Getting started can be the hardest part", ">Follow Me<", "elementor-location-footer"):
        j = seg.find(stop)
        if j > 0: seg = seg[:j]
    seg = re.sub(r"<(script|style)[^>]*>.*?</\1>", "", seg, flags=re.S)
    out = []
    for tag, inner in re.findall(r"<(h[1-6]|p|li)[^>]*>(.*?)</\1>", seg, re.S):
        inner = re.sub(r"<(strong|b)>(.*?)</\1>", r"**\2**", inner, flags=re.S)
        inner = re.sub(r"<(em|i)>(.*?)</\1>", r"*\2*", inner, flags=re.S)
        t = html.unescape(re.sub(r"<[^>]+>", "", inner)).replace(" ", " ")
        t = re.sub(r"\s+", " ", t).strip().replace(" — ", ", ").replace("—", ", ")
        if not t or t == title: continue
        out.append(("## " if tag in ("h1", "h2", "h3") and len(t) < 90 else "- " if tag == "li" else "") + t)
    body = "\n\n".join(out)
    body = re.sub(r"\bactually\b ?", "", body, flags=re.I)
    desc = (md.group(1).strip() if md else out[0])[:155].rsplit(" ", 1)[0]
    fm = {"title": title, "seoTitle": (f"{title.rstrip('.')} | Push The Goal" if len(title) < 46 else title.rstrip(".")[:70]), "description": desc,
          "category": CAT.get(slug, "For parents"), "date": DATES.get(slug, "2023-11-26") + "T17:00:00Z"}
    pathlib.Path(f"src/content/blog/{slug}.md").write_text("---\n" + "\n".join(f"{k}: {json.dumps(v, ensure_ascii=False)}" for k, v in fm.items()) + "\n---\n\n" + body + "\n")
    print(slug, "|", title, "|", len(body.split()), "words")
