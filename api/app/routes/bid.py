from fastapi import APIRouter, Body, Response
from pydantic import BaseModel
from datetime import date
from starlette.responses import StreamingResponse
import io

router = APIRouter()

class BidText(BaseModel):
    text: str  # matches /bid/validate schema

def _to_crlf(s: str) -> str:
    lf = s.replace("\r\n", "\n").replace("\r", "\n")
    crlf = lf.replace("\n", "\r\n")
    if crlf and not crlf.endswith("\r\n"):
        crlf += "\r\n"
    return crlf

@router.post("/bid/export", summary="Export bid as .jss (download attachment)")
def bid_export(payload: BidText = Body(..., media_type="application/json")):
    jss = _to_crlf(payload.text or "")
    fname = f"nextbid_{date.today():%Y-%m}.jss"
    buf = io.BytesIO(jss.encode("utf-8"))
    headers = {
        "Content-Disposition": f'attachment; filename="{fname}"',
        "Cache-Control": "no-store",
    }
    return StreamingResponse(buf, media_type="text/plain; charset=utf-8", headers=headers)

@router.post("/bid/export.txt", summary="Export bid as raw .jss (text/plain, CRLF, UTF-8)")
def bid_export_txt(payload: BidText = Body(..., media_type="application/json")):
    jss = _to_crlf(payload.text or "")
    return Response(content=jss, media_type="text/plain; charset=utf-8")
from fastapi import Body
from typing import List, Dict

@router.post("/bid/validate", summary="Validate JSS text and basic constraints")
def bid_validate(payload: BidText = Body(..., media_type="application/json")) -> Dict:
    text = payload.text or ""
    # Normalize once to LF for parsing; we won't mutate the input
    lf = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [ln.rstrip() for ln in lf.split("\n") if ln.strip() != ""]
    errors: List[str] = []
    warnings: List[str] = []

    # Parse simple !GROUP / !END GROUP blocks
    groups: List[List[str]] = []
    current: List[str] | None = None
    for ln in lines:
        u = ln.strip()
        if u.upper().startswith("!GROUP"):
            if current is not None:
                errors.append("Nested !GROUP detected (missing !END GROUP).")
            current = []
            groups.append(current)
        elif u.upper().startswith("!END GROUP"):
            if current is None:
                errors.append("!END GROUP without matching !GROUP.")
            current = None
        else:
            if current is None:
                # global header lines allowed; treat as group 0
                if not groups:
                    groups.append([])
                groups[0].append(u)
            else:
                current.append(u)

    if current is not None:
        errors.append("Unclosed !GROUP (missing !END GROUP).")

    # Metrics
    group_count = max(0, len(groups))
    line_counts = [len(g) for g in groups] if groups else []
    total_lines = sum(line_counts)

    # Limits
    if group_count > 15:
        errors.append(f"Too many groups: {group_count} (max 15).")
    for i, n in enumerate(line_counts, start=1):
        if n > 40:
            errors.append(f"Group {i} has {n} lines (max 40).")

    # Line ending hint
    if "\r\n" not in text and len(text) > 0:
        warnings.append("Input did not use CRLF; export will normalize to CRLF.")

    return {
        "ok": len(errors) == 0,
        "groups": group_count,
        "total_lines": total_lines,
        "line_counts": line_counts,
        "errors": errors,
        "warnings": warnings,
    }
