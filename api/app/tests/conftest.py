import sys
from pathlib import Path

# tests live at: api/app/tests
# repo root is three parents up from this file
ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
