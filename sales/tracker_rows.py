#!/usr/bin/env python3
"""List rows from the sales call tracker export on or after a date, as JSON lines.

Usage: python3 sales/tracker_rows.py <export> [since yyyy-mm-dd]

<export> is an .xlsx file, or the JSON file ({"content": "<base64>"}) the Drive connector
saves when it exports the sheet as xlsx. Standard library only. Columns are found by header
name because their order changes between month tabs. NOTES is printed for hold dates only -
it holds prices, so never copy from it into a message.
"""
import base64
import io
import json
import re
import sys
import zipfile
import xml.etree.ElementTree as ET
from datetime import date, datetime, timedelta

M = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
R = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"
FIELDS = ["DATE", "NAME", "EMAIL", "PHONE", "RECORDING", "OUTCOME", "NOTES"]


def load_zip(path):
    with open(path, "rb") as f:
        raw = f.read()
    if raw[:2] != b"PK":
        raw = base64.b64decode(json.loads(raw)["content"])
    return zipfile.ZipFile(io.BytesIO(raw))


def shared_strings(z):
    if "xl/sharedStrings.xml" not in z.namelist():
        return []
    root = ET.fromstring(z.read("xl/sharedStrings.xml"))
    return ["".join(t.text or "" for t in si.iter(M + "t")) for si in root.findall(M + "si")]


def sheets(z):
    wb = ET.fromstring(z.read("xl/workbook.xml"))
    rels = ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))
    targets = {r.get("Id"): r.get("Target") for r in rels}
    for s in wb.find(M + "sheets"):
        target = targets[s.get(R + "id")].lstrip("/")
        yield s.get("name"), target if target.startswith("xl/") else "xl/" + target


def cell_value(c, strs):
    kind = c.get("t")
    if kind == "inlineStr":
        return "".join(t.text or "" for t in c.iter(M + "t"))
    v = c.find(M + "v")
    if v is None or v.text is None:
        return ""
    return strs[int(v.text)] if kind == "s" else v.text


def to_date(v):
    v = str(v).strip()
    if re.fullmatch(r"\d+(\.\d+)?", v):
        return date(1899, 12, 30) + timedelta(days=int(float(v)))
    for fmt in ("%m/%d/%Y", "%Y-%m-%d", "%m/%d/%y"):
        try:
            return datetime.strptime(v, fmt).date()
        except ValueError:
            pass
    return None


def to_phone(v):
    digits = re.sub(r"\D", "", str(v))
    if len(digits) == 10:
        return "+1" + digits
    if len(digits) == 11 and digits[0] == "1":
        return "+" + digits
    return ""


def rows(z, since):
    strs = shared_strings(z)
    for tab, part in sheets(z):
        if tab.strip().upper() == "TOTALS":
            continue
        cols = None
        for row in ET.fromstring(z.read(part)).iter(M + "row"):
            vals = {re.sub(r"\d", "", c.get("r")): cell_value(c, strs) for c in row}
            if cols is None:
                heads = {str(v).strip().upper(): k for k, v in vals.items() if v}
                if "OUTCOME" in heads:
                    cols = {}
                    for field in FIELDS:
                        match = [h for h in heads if h.startswith(field)]
                        if match:
                            cols[field] = heads[match[0]]
                continue
            get = lambda field: str(vals.get(cols.get(field), "")).strip()
            when = to_date(get("DATE"))
            if when is None or when < since:
                continue
            yield {
                "tab": tab,
                "date": when.isoformat(),
                "name": get("NAME"),
                "email": get("EMAIL").lower(),
                "phone": to_phone(get("PHONE")),
                "phone_raw": get("PHONE"),
                "outcome": get("OUTCOME").upper(),
                "recording": get("RECORDING"),
                "notes": get("NOTES"),
            }


if __name__ == "__main__":
    start = date.fromisoformat(sys.argv[2]) if len(sys.argv) > 2 else date(2026, 10, 22)
    for r in rows(load_zip(sys.argv[1]), start):
        print(json.dumps(r, ensure_ascii=False))
