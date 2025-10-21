from fastapi import APIRouter, Body
from pydantic import BaseModel
from datetime import date
from starlette.responses import StreamingResponse
import io

router = APIRouter()

class BidText(BaseModel):
    text: str  # matches /bid/validate schema

@router.post("/bid/export", summary="Export bid as .jss (UTF-8 + CRLF)")
def bid_export(payload: BidText = Body(..., media_type="application/json")):
    # normalise -> CRLF
    text = payload.text.replace("\r\n", "\n").replace("\r", "\n")
    jss  = text.replace("\n", "\r\n")

    fname = f"nextbid_{date.today():%Y-%m}.jss"
    buf = io.BytesIO(jss.encode("utf-8"))
    headers = {"Content-Disposition": f'attachment; filename="{fname}"'}
    return StreamingResponse(buf, media_type="text/plain; charset=utf-8", headers=headers)
