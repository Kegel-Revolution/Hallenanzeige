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

Zwei Tafeln wechseln sich automatisch ab — **die Duelle drei Minuten, die
Statistik zwanzig Sekunden**. Die Ergebnisse sind das, wofür die Leute in
der Halle hinschauen; vorher standen beide Tafeln gleich lang, und die
Ergebnisse waren gerade dann weg, wenn jemand hinsah.

| Tafel | Standzeit | Inhalt |
|---|---|---|
| **Aufstellung** | 180 s | alle Paarungen mit den Satzergebnissen Satz für Satz und den Satzpunkten |
| **Statistik** | 20 s | Team-Vergleich als Balken: Volle, Abräumen, Fehlwürfe, Neuner, Ø Würfe pro Abräumbild, Satzpunkte, Ø Holz pro Satz |

**Farben sagen, wer wo gewonnen hat** — und zwar nur an den Satzzahlen:
Der gewonnene Satz ist in der Teamfarbe ausgefüllt. Gold heißt immer
„läuft gerade": der laufende Satz und die Satzpunkte des laufenden Duells.
Zwei Bedeutungen, zwei Farben, damit nichts durcheinandergeht.

In der **Mitte der Zeile** steht der Satzpunktstand des Duells in einem
ruhigen Feld — dort gehört bewusst keine Teamfarbe hin: Die Farbe liegt
links und rechts an den Satzfeldern, und zwischen den beiden Reihen soll
nichts mit ihnen konkurrieren. Läuft das Duell noch, ist das Feld gold;
der Stand ist dann vorläufig.

Ohne Farbe bleiben ebenso die **Namen** und die **Satzpunkte oben im
Kopf** — sonst liegt auf einer Zeile mehr Farbe als Information.

**Die Namen** stehen am äußeren Rand der Zeile, deutlich abgesetzt von den
Satzzahlen — vorher klebten sie daran, und aus zehn Metern war nicht zu
erkennen, wo der Name aufhört und die Zahlen anfangen. Sie stehen
**ausgeschrieben** und so groß wie möglich: 44 px, und wenn ein besonders
langer Name das Feld sprengt, geht nur diese eine Zeile in Zweierschritten
herunter, bis er passt (bis 24 px). Eine feste Größe für den längsten
Namen würde bei allen anderen die halbe Höhe verschenken. Der Duellsieger
steht weiß und fett.

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

### Bundesliga oder DKBC-Pokal — die Tafel merkt es selbst

Im **Pauly DKBC Pokal** trägt die Anzeige das Design des Wettbewerbs:
DKBC-Rot statt Gold, den etwas dunkleren Grund, das Pokal-Zeichen oben
rechts und die Runde („VIERTELFINALE") links, wo in der Liga der Spieltag
steht. Umgestellt wird **nichts von Hand** — bestimmt wird der Wettbewerb
in derselben Reihenfolge wie die Teamfarben:

| Woher | Was |
|---|---|
| `?wettbewerb=pokal` \| `bundesliga` | von Hand festgelegt, schlägt alles |
| `?overlay=<IP>:4750` | was die Regie am Stream-PC eingestellt hat — samt Runde |
| Spielstand | steht „Pokal" in Spielklasse, Bezeichnung oder Altersklasse des Wettkampfs |
| sonst | Bundesliga |

Die Erkennung am Spielstand ist absichtlich weit gefasst: Den Namen des
Wettkampfs tippt jemand in CC2 von Hand, und niemand weiß vorher, ob dort
„DKBC-Pokal", „Pokal 2026" oder „Pokalrunde 1" steht — getroffen wird
alles, was „Pokal" oder „Cup" enthält. Ein Treffer zu viel ist besser als
eine Tafel, die im Pokal aussieht wie ein Ligaspiel; liegt sie doch
falsch, stellt `?wettbewerb=` es fest.

Die **Runde** kann kein Bahn-Rechner wissen — die pflegt die Regie im
Panel des Overlays, und die Halle holt sie über `?overlay=` ab. Ohne
Stream-PC bleibt links die Spielklasse stehen (die sagt im Pokal ohnehin
„Pokal"). Dasselbe gilt für die **Farbvariante** des Pokals (Navy/Rot oder
Graphit/Gelb, per `?variante=` auch von Hand).

**Der Pokal wird anders gewertet.** Gerechnet werden die
Mannschaftspunkte gleich wie in der Liga (6 Duelle + 2 für das bessere
Gesamtholz), aber ab **4,5 Punkten** ist eine Mannschaft weiter; bei 4:4
entscheidet das Gesamtholz, bei 4:4 mit gleichem Holz ein Stechen. Die
Zeile unter der Duell-Tafel sagt das während des Spiels und nach dem
letzten Wurf, wer weiter ist — im K.-o. ist das die einzige Zahl, die
zählt, und sie steht in keiner Spalte.

Ein Hinweis zur Farbe: „Läuft gerade" ist im Pokal **gelb**, nicht rot.
Der Akzent ist dort Rot, und eine Gastmannschaft spielt sehr oft in Rot —
ein rotes Feld hieße dann gleichzeitig „Satz gewonnen" und „Satz läuft".
Gelb ist die zweite Farbe des Pokals, also keine erfundene.

| Parameter | Wirkung |
|---|---|
| `?ansicht=aufstellung` \| `statistik` | eine Tafel fest einstellen — so können die Bildschirme Verschiedenes zeigen |
| `?ansicht=auto` | automatischer Wechsel (Vorgabe) |
| `?duellesek=180` | Standzeit der Duelle in Sekunden |
| `?statistiksek=20` | Standzeit der Team-Statistik |
| `?wechselsek=30` | beide Tafeln gleich lang (setzt die beiden oberen außer Kraft) |
| `?heim=2563BC&gast=D8232E` | Teamfarben fest vorgeben (Hex ohne `#`) |
| `?overlay=192.168.1.60:4750` | Teamfarben vom Stream-Rechner holen, damit Halle und Stream gleich aussehen |
| `?quelle=192.168.1.50:8080` | Bridge-Adresse, falls die Datei nicht von der Bridge selbst kommt |
| `?wettbewerb=pokal` \| `bundesliga` | Wettbewerb fest vorgeben (sonst automatisch, siehe oben) |
| `?variante=navy` \| `graphit` | Farbvariante des Pokals fest vorgeben |

### Starten: erst Fenster, dann Vollbild

`START_Anzeige.bat` fragt beim Doppelklick, wie geöffnet werden soll:

- **`[1] Fenster`** — ein normales Fenster. Auf den Bildschirm ziehen, der
  in der Halle hängt, hineinklicken und `F` drücken: Vollbild auf dem
  richtigen Schirm. Der Weg, wenn mehrere Bildschirme im Spiel sind. Ohne
  Eingabe startet nach 20 Sekunden dieser Modus.
- **`[2] Vollbild`** — sofort bildschirmfüllend (Kiosk, Ende mit `Alt+F4`).

Oben in der Datei stehen die Schalter: `ADRESSE` (Bahn-PC samt Port),
`ANSICHT` (welche Tafel), `OVERLAY` (Teamfarben vom Stream-Rechner) sowie
`GROESSE` und `POSITION` für den Fenstermodus — wer immer denselben
Bildschirm bespielt, trägt dort z. B. `1920,0` ein und spart sich das
Schieben.

### Teamfarben

Die Farben der beiden Mannschaftsbalken bestimmt die Anzeige in dieser
Reihenfolge:

1. **`?heim=` / `?gast=`** — fest vorgegeben, schlägt alles andere.
2. **Stream-Rechner** — steht `?overlay=<IP>:4750` in der Adresse, fragt die
   Anzeige alle 15 Sekunden `/api/farben` des Overlay-Servers ab und
   übernimmt, was im Stream eingestellt ist. Damit reicht ein Klick im
   Control-Panel, und Halle wie Stream zeigen dasselbe.
3. **Vereinsliste** — die Konstante `VEREINE` im Skript von `anzeige.html`
   ordnet dem Vereinsnamen aus CC2 eine Farbe zu (Teilstring, längster
   Treffer gewinnt — genau wie die Wappen im Overlay). Sie ist die Kopie von
   `data/vereine.json` aus dem Overlay-Repository und muss von Hand
   synchron gehalten werden; dafür stimmen die Farben auch dann, wenn am
   Spieltag gar nicht gestreamt wird und der Stream-Rechner aus ist.
4. **Vorgabe** — Heim `#2563BC`, Gast `#D8232E`.

Ein unbekannter Verein bekommt also die Vorgabe und nicht die Farbe des
letzten Gegners.

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
