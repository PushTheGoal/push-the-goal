"""One-time: turn a saved Elementor layout (muse clients/push-the-goal/reference/elementor/<slug>.json)
into src/data/pages/<slug>.json, one entry per section, same words.

Usage: python3 tools/extract_elementor.py <layout.json> <slug>
"""
import json, re, sys, html

# Old WordPress media -> rescued photos in src/assets/photos (screenshot crops until the originals arrive)
PHOTOS = {
    "F063F2C6": "team-indoor", "4.jpg": "izi-two-athletes", "1.webp": "coaching-tablet",
    "IMG_1568": "champions-team", "WhatsApp-Image-2023-03-16": "izi-field",
    "Untitled-design-1": "team-indoor", "WhatsApp-Image-2023-03-21": "izi-two-athletes",
    "istockphoto": "champions-team", "WhatsApp-Image-2023-03-31": "izi-field",
}
def photo(url):
    for k, v in PHOTOS.items():
        if k in url: return v
    return None

def clean(h):
    h = re.sub(r'\s(class|style|data-[a-z-]+|id)="[^"]*"', "", h)
    h = re.sub(r"<span>(.*?)</span>", r"\1", h, flags=re.S)
    h = re.sub(r"https?://(www\.)?push-the-goal\.com(?=/)", "", h)
    h = h.replace(" ", " ")
    h = re.sub(r"<p>\s*</p>", "", h)
    return h.strip()

def settings(el):
    s = el.get("settings"); return s if isinstance(s, dict) else {}

def walk(els):
    for e in els:
        yield e; yield from walk(e.get("elements", []))

tree = json.load(open(sys.argv[1]))
tree = tree.get("data", tree) if isinstance(tree, dict) else tree
out = []
for top in tree:
    sec = {"dark": settings(top).get("background_color", "").lower() in ("#000000", "#141418", "#1d1d1d"),
           "eyebrow": None, "heading": None, "h1": None, "blocks": [], "image": None, "buttons": []}
    accordion_seen = set()
    for el in walk([top]):
        s = settings(el); wt = el.get("widgetType")
        if wt == "heading":
            t = html.unescape(re.sub(r"<[^>]+>", "", s.get("title", ""))).strip()
            size = s.get("header_size", "h2")
            if size == "h1": sec["h1"] = t
            elif sec["heading"] is None and (sec["eyebrow"] is not None or not t.isupper()) and not t.isupper():
                sec["heading"] = t
            elif t.isupper() or sec["eyebrow"] is None and sec["heading"] is None:
                if sec["eyebrow"] is None and sec["heading"] is None: sec["eyebrow"] = t
                else: sec["blocks"].append({"type": "h3", "text": t})
            else:
                sec["blocks"].append({"type": "h3", "text": t})
        elif wt == "text-editor":
            if any(el["id"] in a for a in accordion_seen): continue
            h = clean(s.get("editor", ""))
            if h.startswith("<p><strong>READ MORE") or "READ MORE:" in h[:60]:
                links = re.findall(r'<a[^>]*href="([^"]+)"[^>]*>(.*?)</a>', h, re.S)
                sec["blocks"].append({"type": "readmore", "links": [{"href": u, "text": html.unescape(re.sub(r"<[^>]+>", "", t)).strip()} for u, t in links]})
            elif re.match(r"<p><strong>(Step \d|Online|Enroll|Re-enroll|Hand off)", h):
                sec["blocks"].append({"type": "step", "html": h})
            else:
                sec["blocks"].append({"type": "html", "html": h})
        elif wt == "icon-list":
            items = [html.unescape(re.sub(r"<[^>]+>", "", i.get("text", ""))).strip() for i in s.get("icon_list", [])]
            items = [i for i in items if i and not i.lower().startswith(("home", "college soccer recruitment", "junior prep"))]
            if items and sec["h1"] is None: sec["blocks"].append({"type": "list", "items": items})
        elif wt == "button":
            sec["buttons"].append({"text": s.get("text", "").strip(), "href": (s.get("link") or {}).get("url", "")})
        elif wt == "image":
            sec["image"] = photo((s.get("image") or {}).get("url", ""))
        elif wt == "gallery":
            sec["blocks"].append({"type": "testimonials"})
        elif wt == "nested-accordion":
            titles = [html.unescape(i.get("item_title", "")).strip() for i in s.get("items", [])]
            answers = []
            for child in el.get("elements", []):
                txt = [clean(settings(x).get("editor", "")) for x in walk([child]) if x.get("widgetType") == "text-editor"]
                for x in walk([child]): accordion_seen.add(x["id"])
                answers.append("".join(txt))
            sec["blocks"].append({"type": "faq", "items": [{"q": q, "a": a} for q, a in zip(titles, answers)]})
    if sec["heading"] == "Our Testimonials":
        h3 = next((b for b in sec["blocks"] if b["type"] == "h3"), None)
        sec["eyebrow"], sec["heading"] = "Our Testimonials", (h3["text"] if h3 else "What They Say")
        if h3: sec["blocks"].remove(h3)
    if (sec["eyebrow"] or "").upper() == "HOW IT WORKS":
        for b in sec["blocks"]:
            if b["type"] == "html": b["type"] = "step"
    # a step's buttons stay with its section; drop exact duplicate buttons
    seen = set(); sec["buttons"] = [b for b in sec["buttons"] if not (b["text"] in seen or seen.add(b["text"]))]
    out.append(sec)
json.dump(out, open(f"src/data/pages/{sys.argv[2]}.json", "w"), indent=1, ensure_ascii=False)
for i, s in enumerate(out):
    print(i, "dark" if s["dark"] else "light", "|", s["eyebrow"], "|", s["h1"] or s["heading"], "|", [b["type"] for b in s["blocks"]], "| img", s["image"], "| btn", [b["text"] for b in s["buttons"]])
