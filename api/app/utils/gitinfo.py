import subprocess

def _run(args: list[str]) -> str:
    try:
        out = subprocess.check_output(args, stderr=subprocess.DEVNULL).decode("utf-8", "ignore").strip()
        return out
    except Exception:
        return ""

def get_build_info() -> dict:
    sha = _run(["git", "rev-parse", "HEAD"])
    short = sha[:7] if sha else ""
    date = _run(["git", "log", "-1", "--date=iso-strict", "--format=%ad"])
    branch = _run(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    return {"commit": sha, "short": short, "date": date, "branch": branch}
