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
