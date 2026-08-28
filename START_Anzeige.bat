@echo off
rem Hallenanzeige im Vollbild oeffnen (Ersatz fuer den ahlbrowser).
rem Auf dem Bahn-PC selbst reicht ein Doppelklick (die Bridge muss laufen).
rem Auf einem eigenen Anzeige-PC unten die Adresse des Bahn-PCs eintragen,
rem z. B.  set ADRESSE=192.168.1.50:8080
set ADRESSE=localhost:8080

set URL=http://%ADRESSE%/anzeige
set EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe
if exist "%EDGE%" (
  start "" "%EDGE%" --kiosk %URL% --edge-kiosk-type=fullscreen
  exit /b
)
set CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe
if exist "%CHROME%" (
  start "" "%CHROME%" --kiosk %URL%
  exit /b
)
rem Kein Edge/Chrome gefunden: Standardbrowser nehmen, dort F fuer Vollbild.
start "" %URL%
