# run-dev.ps1 — starts API then Flutter (best effort)
Start-Process powershell -ArgumentList '-NoLogo','-NoExit','-Command','cd api; python -m uvicorn app.main:app --reload --port 8000'
Start-Sleep -Seconds 2
flutter pub get
flutter run -d windows
