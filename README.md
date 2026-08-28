# Hallenanzeige

Vollbild-Anzeige für die Bildschirme in der Kegel-Halle — der Ersatz für
den bisherigen `ahlbrowser2`. Die Daten kommen live von der
[Kegelbahn-Bridge](https://github.com/Kegel-Revolution/Kegelbahn-Bridge)
(Push per Server-Sent Events): **jeder Wurf ist sofort im Bild** statt
alle 10 Sekunden.

Aufbau und Gestaltung folgen dem Pausen-Screen des
[Livestream-Overlays](https://github.com/Kegel-Revolution/Overlay)
(Navy/Gold, Oswald + Source Sans 3) — Halle und Stream sprechen dasselbe
Bild. Ein Stream-PC ist nicht nötig.

```
Kegelbahn ──seriell──► CC2 ──► Kegelbahn-Bridge      läuft auf dem BAHN-PC
                                     │  HTTP im LAN
                                     ▼
                              Hallenanzeige          Browser im Vollbild
                                     │               (Kiosk-Modus)
                                     ▼
                           Bildschirme in der Halle
```

---

## Was sie zeigt

Oben stehen dauerhaft **Heim links, Gast rechts** mit dem Gesamtholz in
Groß, dazwischen die **Mannschaftspunkte** — sie laufen während des
Spiels nach derselben Regel live mit wie im Stream-Overlay (je begonnenem
Duell 1 Punkt für den Führenden, 2 Punkte für die Holz-Führung), nach
Spielende gilt die Rechnung der Bridge. Darunter Satzpunkte und
Durchgang/Satz.

Zwei Tafeln wechseln sich automatisch ab (Takt einstellbar):

| Tafel | Inhalt |
|---|---|
| **Aufstellung** | alle Paarungen mit den Satzergebnissen Satz für Satz (der laufende Satz zählt gold mit) und den Satzpunkten — Sieger hell, Holz des Führenden gold, kommende Durchgänge grau |
| **Statistik** | Team-Vergleich als Balken: Volle, Abräumen, Fehlwürfe, Neuner, Ø Würfe pro Abräumbild, Satzpunkte, Ø Holz pro Satz |

Vor dem ersten Wurf steht die Startaufstellung, nach dem Spiel der
Endstand. Bricht die Verbindung ab, bleibt der letzte Stand stehen und
eine rote Warnung erscheint — die Anzeige verbindet sich von selbst
wieder.

---

## Betrieb — drei Wege

**1. Eingebettet in der Bridge (Normalfall).** Die Bridge liefert eine
eingebettete Kopie dieser Seite unter `http://<Bahn-PC>:8080/anzeige`
aus — an der Bahn reicht eine einzelne .exe, dieses Repository muss dort
nicht liegen.

**2. Von der Bridge ausgeliefert.** Diesen Ordner auf den Bahn-PC legen
und die Bridge damit starten:

```
cc2bridge.exe -web "C:\Hallenanzeige"
```

Erreichbar unter `http://<Bahn-PC>:8080/anzeige.html` — praktisch, um
eine neue Fassung zu zeigen, ohne die Bridge neu zu bauen.

**3. Direkt von der Festplatte.** `anzeige.html` doppelklicken. Ohne
weitere Angabe holt sie die Daten von `http://localhost:8080` (dem
Bahn-PC selbst); auf einem anderen Rechner die Adresse mitgeben:
`anzeige.html?quelle=192.168.1.50:8080`.

**Einrichten am Bildschirm:** `START_Anzeige.bat` doppelklicken — sie
öffnet Edge im Kiosk-Modus (beenden mit Alt+F4). Ist es nicht der
Bahn-PC selbst, vorher in der .bat die Adresse eintragen
(`set ADRESSE=192.168.1.50:8080`). Ohne Kiosk-Modus schaltet die Taste
`F` in den Vollbildmodus.

---

## Parameter und Tasten

An die Adresse anhängen, kombinierbar mit `&`:

| Parameter | Wirkung |
|---|---|
| `?ansicht=aufstellung` \| `statistik` | eine Tafel fest einstellen — so können die Bildschirme Verschiedenes zeigen |
| `?ansicht=auto` | automatischer Wechsel (Vorgabe) |
| `?wechselsek=20` | Standzeit je Tafel in Sekunden |
| `?heim=2563BC&gast=D8232E` | Teamfarben (Hex ohne `#`) |
| `?quelle=192.168.1.50:8080` | Bridge-Adresse, falls die Datei nicht von der Bridge selbst kommt |

| Taste | Wirkung |
|---|---|
| `1` | Aufstellung fest |
| `2` | Statistik fest |
| `0` | zurück zur Automatik |
| `F` | Vollbild an/aus |

---

## Testen ohne Kegelbahn

`tools/cc2-replay.js` aus dem
[Overlay-Repository](https://github.com/Kegel-Revolution/Overlay) spielt
ein aufgezeichnetes Spiel im Format der Bridge nach:

```bash
node tools/cc2-replay.js 8097 <pfad-zum-CC2-Daten-Ordner>
```

Dann `anzeige.html?quelle=localhost:8097` im Browser öffnen und mit
`http://localhost:8097/sim/wuerfe?n=50` Würfe abspielen.

---

## Mitarbeiten

Die Anzeige ist bewusst **eine einzelne HTML-Datei ohne Abhängigkeiten**
(plus Schriften). Prüfung ohne Zusatzpakete:

```bash
node tools/pruefen.js
```

Das läuft bei jedem Pull Request auch automatisch
(`.github/workflows/pruefen.yml`) — ein Syntaxfehler fiele sonst erst am
Spieltag als schwarzer Bildschirm in der Halle auf.

Änderungen gehen über einen Branch und einen Pull Request; in
`.githooks` liegt ein `pre-push`, der direkte Pushes auf `main` abweist.
Einmal je Arbeitskopie einrichten:

```bash
git config core.hooksPath .githooks
```

**Kopie in der Bridge:** Die Kegelbahn-Bridge bettet `anzeige.html` und
`fonts/` als `web/anzeige.html` bzw. `web/fonts/` in ihre .exe ein.
Nach einer Änderung hier die Kopie dort nachziehen (und umgekehrt) —
führend ist dieses Repository.

Die Schriften stehen unter der SIL Open Font License 1.1
(`fonts/LIZENZ.txt`).

---

## Stand

Version 1.0. Im Einsatz beim SKK Chambtalkegler Raindorf.
