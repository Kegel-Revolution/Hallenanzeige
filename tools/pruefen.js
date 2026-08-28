// Prüft die Hallenanzeige ohne Zusatzpakete: der <script>-Block in
// anzeige.html muss syntaktisch gültig sein und die Schriften müssen
// liegen, wo die Seite sie erwartet — ein Tippfehler fiele sonst erst
// am Spieltag als schwarzer Bildschirm in der Halle auf.
'use strict';
const fs = require('fs');
const path = require('path');

const wurzel = path.join(__dirname, '..');
const html = fs.readFileSync(path.join(wurzel, 'anzeige.html'), 'utf8');

const m = html.match(/<script>([\s\S]*?)<\/script>/);
if (!m) {
  console.error('anzeige.html: kein <script>-Block gefunden');
  process.exit(1);
}
try {
  new Function(m[1]); // parst nur, führt nichts aus
} catch (e) {
  console.error('anzeige.html: Syntaxfehler im Skript – ' + e.message);
  process.exit(1);
}

let fehler = 0;
for (const datei of ['fonts/oswald.woff2', 'fonts/source-sans-3.woff2', 'fonts/LIZENZ.txt']) {
  if (!fs.existsSync(path.join(wurzel, datei))) {
    console.error('fehlt: ' + datei);
    fehler = 1;
  }
}
if (fehler) process.exit(1);

console.log('anzeige.html: Syntax in Ordnung, Schriften vorhanden.');
