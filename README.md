# nextbid
JSS bid application
# NextBid

**Smarter bidding. Better rosters.**

NextBid is a BA-focused JSS bidding assistant for pilots, designed to make roster bidding faster, clearer, and more effective.  
Built by pilots, for pilots.

---

## 🎯 Vision
Pilots spend hours every month building bids in JSS or using legacy tools like iBidline. These tools don’t provide predictions, explanations, or confidence.  
NextBid changes that:
- **Pre-Process:** Credit range, leave slide, reserve visualisers
- **Build:** Guided Jeppesen-style commands, Waive/Set, Bank Protection toggle
- **Preview:** Top-3 likely rosters, satisfaction scores, quick-fix chips
- **Upload:** Exact JSS export, direct CrewBid submission, receipt capture
- **Insights (opt-in):** Anonymised peer competitiveness colour coding

Our mission: give every pilot confidence in their bid — and better work-life balance.

---

## 💷 Pricing
- **Launch (Founders):** £4.99/month  
- **Stable release:** £9.99/month  
- Free 30-day trial for new users

---

## 🛠️ Tech Stack
- **App:** Flutter (iPad/iPhone first)  
- **Backend:** FastAPI + Postgres + Celery + Playwright  
- **Infra:** Supabase/Neon (Postgres), Render/Railway (API), Redis (broker)  
- **Observability:** Sentry + UptimeRobot


---

## 🔐 Privacy & Trust
- BA login: staff number, crew code, BA email
- Consent-driven anonymised insights
- No personal information ever shared
- Opt-out anytime with "Delete my data"

---

## 🚦 Development Roadmap
- Oct–Nov 2025: MVP (end-to-end loop with Nov PDFs)
- Dec 2025: Internal test (December bids)
- Jan 2026: AI enhancements (Top-3 smarter, competitiveness chips)
- Feb–Mar 2026: Beta rollout (£4.99)
- Apr 2026: Public launch (£9.99)

---

## ✅ Acceptance Tests
- JSS bid validation (≤15 groups, ≤40 rows/group, correct grammar)
- Bank Protection toggle (injected line ON; omitted OFF)
- Calendar countdowns match JSS PDF
- Credit ranges match BidInfo front sheet
- Export = CRLF, UTF-8, correct order
- Upload stores exported text + receipt
- Privacy: consent toggle + anonymised cohorts only if k≥25

---

## 👥 For Testers
- Upload monthly BA PDFs (Calendar, BidInfo1/2, Status List, Pairings, Reserves)
- Build a bid in-app
- Preview Top-3 likely rosters
- Submit via CrewBid (receipt saved)
- Report feedback via WhatsApp/TestFlight notes


## 📂 Repo Structure## Dev quick start
- Press F5 and pick “Dev: API then Flutter” (or run tasks from Terminal → Run Task)
- Or run: .\run-dev.ps1 in PowerShell
- API health: http://127.0.0.1:8000/healthz  → should return { "status": "ok" }
