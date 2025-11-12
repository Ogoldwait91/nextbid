# Starts API and Flutter app in split consoles (Windows)
# Adjust paths if your folders differ.
$apiCmd     = 'python -m uvicorn app.main:app --reload --port 8000'
$flutterCmd = 'flutter run -d windows'

Start-Process powershell -ArgumentList "-NoExit","-Command","$apiCmd" -WindowStyle Normal
Start-Process powershell -ArgumentList "-NoExit","-Command","$flutterCmd" -WindowStyle Normal
