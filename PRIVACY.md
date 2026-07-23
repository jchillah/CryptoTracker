# Datenschutzerklärung für CryptoTracker

**Stand: 24. Juli 2026**

Diese Datenschutzerklärung beschreibt, welche personenbezogenen Daten die iOS-App CryptoTracker verarbeitet und zu welchen Zwecken dies geschieht.

## 1. Verantwortlicher

Michael Winkler  
Jchillah’s Design & Coding Forge  
E-Mail: Michael.Winkler.Developer@gmail.com

## 2. Verarbeitete Daten

### Nutzerkonto

Bei Registrierung und Anmeldung werden folgende Daten über Firebase Authentication verarbeitet:

- E-Mail-Adresse
- technische Nutzer-ID
- Authentifizierungs- und Sicherheitsinformationen

Passwörter werden nicht durch CryptoTracker selbst gespeichert. Die Authentifizierung wird durch Firebase Authentication verarbeitet.

### Favoriten und Einstellungen

Für angemeldete Nutzer werden in Cloud Firestore gespeichert:

- IDs der favorisierten Kryptowährungen
- Dark-Mode-Einstellung
- dem Nutzerkonto zugeordnete E-Mail-Adresse

Diese Daten werden unter der Firebase-Nutzer-ID gespeichert und durch Firestore-Sicherheitsregeln auf den jeweiligen Nutzer beschränkt.

### Markt-, Chart- und Nachrichtendaten

CryptoTracker ruft öffentliche Daten von externen Anbietern ab:

- CoinGecko für Kryptowährungs- und Chartdaten
- CoinDesk für Krypto-Nachrichten über RSS

Bei solchen Netzwerkaufrufen können technisch erforderliche Verbindungsdaten, insbesondere IP-Adresse, Zeitpunkt und Geräte-/Browserinformationen, durch den jeweiligen Anbieter verarbeitet werden.

### Lokale Daten

Zuletzt geladene Markt- und Chartdaten werden mit SwiftData lokal auf dem Gerät gespeichert, um einen Offline-Fallback bereitzustellen. Diese lokalen Daten enthalten keine Passwörter.

## 3. Zwecke der Verarbeitung

Die Datenverarbeitung erfolgt, um:

- Nutzerkonten bereitzustellen und abzusichern,
- Favoriten und Einstellungen geräteübergreifend zu synchronisieren,
- aktuelle Markt-, Chart- und Nachrichtendaten anzuzeigen,
- zuletzt geladene Daten bei Netzwerkproblemen bereitzustellen,
- Fehler zu vermeiden und die Sicherheit der App zu gewährleisten.

## 4. Rechtsgrundlagen

Soweit die Datenschutz-Grundverordnung anwendbar ist, erfolgt die Verarbeitung insbesondere zur Erfüllung des vom Nutzer angeforderten App-Dienstes gemäß Art. 6 Abs. 1 lit. b DSGVO sowie zur Gewährleistung eines sicheren und zuverlässigen Betriebs gemäß Art. 6 Abs. 1 lit. f DSGVO.

## 5. Eingesetzte Dienste

### Google Firebase

CryptoTracker verwendet Firebase Authentication und Cloud Firestore. Anbieter ist Google. Daten können abhängig von der Firebase-Konfiguration und den gewählten Serverstandorten außerhalb des Europäischen Wirtschaftsraums verarbeitet werden.

### CoinGecko

CoinGecko stellt öffentliche Kryptowährungs- und Chartdaten bereit. CryptoTracker übermittelt keine in der App gespeicherten Favoriten an CoinGecko.

### CoinDesk

CoinDesk stellt den verwendeten RSS-Newsfeed bereit. CryptoTracker übermittelt keine in der App gespeicherten Favoriten an CoinDesk.

Für die Verarbeitung durch diese Anbieter gelten zusätzlich deren eigene Datenschutzbestimmungen.

## 6. Speicherdauer

- Kontodaten werden gespeichert, solange das Nutzerkonto besteht oder gesetzliche beziehungsweise technische Aufbewahrungsgründe entgegenstehen.
- Favoriten und Einstellungen werden bis zur Änderung, Löschung oder Account-Löschung gespeichert.
- Lokale SwiftData-Daten bleiben auf dem Gerät, bis sie durch die App überschrieben, die App-Daten gelöscht oder die App deinstalliert wird.

## 7. Account und Daten löschen

Der Nutzer kann seinen Account in der App unter **Einstellungen → Account löschen** löschen. Dabei werden das Firebase-Nutzerkonto sowie das zugehörige Firestore-Nutzerdokument mit Favoriten und Einstellungen entfernt.

Falls eine Löschung in der App wegen einer erforderlichen erneuten Anmeldung nicht abgeschlossen werden kann, kann die Löschung nach erneuter Anmeldung wiederholt oder über die oben genannte Kontaktadresse angefordert werden.

## 8. Rechte betroffener Personen

Betroffene Personen können – soweit die gesetzlichen Voraussetzungen erfüllt sind – insbesondere Auskunft, Berichtigung, Löschung, Einschränkung der Verarbeitung, Datenübertragbarkeit und Widerspruch verlangen. Außerdem besteht das Recht, sich bei einer zuständigen Datenschutzaufsichtsbehörde zu beschweren.

## 9. Kinder

CryptoTracker richtet sich nicht gezielt an Kinder. Nutzer, die nach den anwendbaren gesetzlichen Bestimmungen nicht selbst wirksam in die Nutzung eines Online-Dienstes einwilligen können, sollen die App nur mit Zustimmung einer erziehungsberechtigten Person verwenden.

## 10. Änderungen

Diese Datenschutzerklärung kann angepasst werden, wenn sich Funktionen, eingesetzte Dienste oder rechtliche Anforderungen ändern. Das aktuelle Datum ist am Anfang dieses Dokuments angegeben.
