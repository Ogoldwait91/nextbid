from fastapi import APIRouter, Body
from pydantic import BaseModel
from datetime import date
from starlette.responses import FileResponse
import tempfile, os

router = APIRouter()

class BidText(BaseModel):
    text: str

@router.post("/bid/export", summary="Export bid as .jss (UTF-8 + CRLF)")
def bid_export(payload: BidText):
    text = payload.text if payload and payload.text is not None else ""
    # normalise to LF first, then write with Windows newlines
    lf = text.replace("\r\n","\n").replace("\r","\n")

    # write to a temp file with newline=\r\n to guarantee CRLF on disk
    fname = f"nextbid_{date.today():%Y-%m}.jss"
    tmp = tempfile.NamedTemporaryFile(prefix="nextbid_", suffix=".jss", delete=False)
    path = tmp.name
    tmp.close()

    with open(path, "w", encoding="utf-8", newline="\r\n") as f:
        f.write(lf)

    # use FileResponse so bytes are streamed as-written
    return FileResponse(
        path,
        media_type="text/plain; charset=utf-8",
        filename=fname,
        headers={"Cache-Control": "no-store"}
    )
# --- added: raw JSS text endpoint (safe alongside existing JSON one) ---
from fastapi import Body, Response

@router.post("/bid/export.txt", summary="Export bid as raw .jss (text/plain, CRLF, UTF-8)")
def bid_export_txt(payload: BidText = Body(..., media_type="application/json")):
    jss_text = payload.text or ""
    # Normalise to CRLF and ensure trailing CRLF
    lf = jss_text.replace("\r\n", "\n").replace("\r", "\n")
    crlf = lf.replace("\n", "\r\n")
    if crlf and not crlf.endswith("\r\n"):
        crlf += "\r\n"
    return Response(content=crlf, media_type="text/plain; charset=utf-8")
