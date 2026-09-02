@echo off
setlocal enableextensions enabledelayedexpansion
title Hallenanzeige

rem =================================================================
rem  HALLENANZEIGE OEFFNEN  (Ersatz fuer den ahlbrowser)
rem
rem  Auf dem Bahn-PC selbst genuegt ein Doppelklick - die Bridge muss
rem  laufen (START_Bridge.bat).
rem
rem  Bespielt ein EIGENER PC die Hallen-Bildschirme, unten bei ADRESSE
rem  die des Bahn-PCs eintragen. Sie steht beim Start der Bridge in
rem  deren schwarzem Fenster:  "Im Netzwerk: http://192.168.x.x:8080"
rem =================================================================

rem --- Adresse des Bahn-PCs samt Port ------------------------------
rem     Beispiel:  set "ADRESSE=192.168.1.50:8080"
set "ADRESSE=localhost:8080"

rem --- Welche Tafel?  auto | aufstellung | statistik ---------------
rem     Mehrere Bildschirme koennen so Verschiedenes zeigen.
set "ANSICHT=auto"

rem --- Teamfarben vom Stream-Rechner holen (leer = eigene Liste) ---
rem     Beispiel:  set "OVERLAY=192.168.1.60:4750"
set "OVERLAY="

rem --- Fenstermodus: Groesse und Startposition ---------------------
rem     Wer weiss, wo der zweite Bildschirm anfaengt, traegt es hier
rem     ein und spart das Schieben. Ein zweiter Bildschirm rechts
rem     neben einem Full-HD-Hauptbildschirm beginnt bei 1920,0.
set "GROESSE=1280,800"
set "POSITION=80,80"

rem =================================================================

set "URL=http://%ADRESSE%/anzeige?ansicht=%ANSICHT%"
if not "%OVERLAY%"=="" set "URL=%URL%&overlay=%OVERLAY%"

set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"

echo.
rem !URL! statt %URL%: Sonst versteht cmd das & in der Adresse als
rem Befehlstrenner und meldet "overlay ist kein Befehl".
echo    Hallenanzeige:  !URL!
echo.
echo    [1] FENSTER    erst auf den richtigen Bildschirm ziehen,
echo                   dann mit der Taste F auf Vollbild schalten
echo    [2] VOLLBILD   sofort bildschirmfuellend (beenden: Alt+F4)
echo.
choice /c 12 /n /t 20 /d 1 /m "   Auswahl [1/2] - ohne Eingabe nach 20 s: Fenster  "
echo.
if errorlevel 2 goto vollbild

:fenster
echo    Fenster wird geoeffnet.
echo    Auf den gewuenschten Bildschirm ziehen, hineinklicken und
echo    F druecken (F11 geht auch). Zurueck mit F oder Escape.
if exist "%EDGE%" (
  start "" "%EDGE%" --app="%URL%" --window-size=%GROESSE% --window-position=%POSITION%
  goto ende
)
if exist "%CHROME%" (
  start "" "%CHROME%" --app="%URL%" --window-size=%GROESSE% --window-position=%POSITION%
  goto ende
)
echo    Kein Edge/Chrome gefunden - Standardbrowser wird geoeffnet.
start "" "%URL%"
goto ende

:vollbild
echo    Vollbild wird geoeffnet (beenden mit Alt+F4).
if exist "%EDGE%" (
  start "" "%EDGE%" --kiosk "%URL%" --edge-kiosk-type=fullscreen
  goto ende
)
if exist "%CHROME%" (
  start "" "%CHROME%" --kiosk "%URL%"
  goto ende
)
echo    Kein Edge/Chrome gefunden - Standardbrowser wird geoeffnet,
echo    dort mit der Taste F auf Vollbild schalten.
start "" "%URL%"

:ende
rem Kurz stehen lassen, damit die Hinweise lesbar bleiben.
rem timeout braucht eine echte Tastatur; wird die .bat aus einem Skript
rem heraus gestartet, springt ping als Wartepause ein.
timeout /t 4 >nul 2>&1 || ping -n 5 127.0.0.1 >nul
endlocal
