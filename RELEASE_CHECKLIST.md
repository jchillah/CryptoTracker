# CryptoTracker – iOS Release Checklist

Diese Checkliste trennt technische Code-Reife von den kontobezogenen Schritten, die nur im eigenen Apple- und Firebase-Konto durchgeführt werden können.

## 1. Code und Qualität

- [ ] Pull Request vollständig geprüft und gemergt
- [ ] GitHub Action **iOS CI** erfolgreich
- [ ] Keine Zertifikate, Provisioning-Profile oder `GoogleService-Info.plist` versioniert
- [ ] Debug-Ausgaben und temporäre Kommentare entfernt
- [ ] App auf mindestens einem realen iPhone getestet
- [ ] Login, Registrierung, Passwort-Reset und Logout getestet
- [ ] Account-Löschung einschließlich Firestore-Daten getestet
- [ ] Favoriten mit zwei verschiedenen Nutzerkonten getestet
- [ ] Offline-Fallback für Markt- und Chartdaten getestet
- [ ] Dark Mode, Dynamic Type und VoiceOver-Stichprobe getestet
- [ ] Fehlerzustände bei deaktiviertem Netzwerk getestet

## 2. Firebase-Produktion

- [ ] Eigenes Produktionsprojekt angelegt oder bestätigt
- [ ] Bundle Identifier entspricht exakt der registrierten Firebase-iOS-App
- [ ] Lokale `GoogleService-Info.plist` dem App-Target zugeordnet
- [ ] E-Mail/Passwort in Firebase Authentication aktiviert
- [ ] E-Mail-Vorlagen und Absenderdaten geprüft
- [ ] Firestore-Region und Aufbewahrung geprüft
- [ ] `firestore.rules` in das Produktionsprojekt deployed
- [ ] Firestore Rules mit angemeldetem und fremdem Nutzer getestet
- [ ] Firebase App Check für die iOS-App eingerichtet
- [ ] Budget-/Nutzungswarnungen in Google Cloud beziehungsweise Firebase eingerichtet

## 3. Apple Developer und Signing

- [ ] Eigenen, gültigen Bundle Identifier festgelegt
- [ ] App ID im Apple Developer Portal registriert
- [ ] Xcode-Target dem richtigen Apple-Developer-Team zugeordnet
- [ ] Automatisches Signing für Debug und Release geprüft
- [ ] Marketing Version und Build Number erhöht
- [ ] Release-Build mit `Any iOS Device` archiviert
- [ ] Archiv in Xcode Organizer validiert

## 4. App Store Connect

- [ ] App-Eintrag mit identischem Bundle Identifier erstellt
- [ ] App-Name, Untertitel, Beschreibung und Keywords eingetragen
- [ ] Support-URL und Datenschutz-URL veröffentlicht
- [ ] Screenshots für alle erforderlichen Displaygrößen hochgeladen
- [ ] App-Icon und Altersfreigabe geprüft
- [ ] Kategorie **Finance** oder passende Alternative geprüft
- [ ] Hinweis aufgenommen, dass keine Finanzberatung erfolgt
- [ ] App Privacy Angaben entsprechend `PRIVACY.md` ausgefüllt
- [ ] Angaben zu Drittanbieter-Inhalten und Datenquellen geprüft
- [ ] Export-Compliance-Fragen beantwortet
- [ ] Account-Löschung im Review-Hinweis beschrieben
- [ ] Testaccount für App Review bereitgestellt, sofern erforderlich

## 5. TestFlight

- [ ] Build zu App Store Connect hochgeladen
- [ ] Interne TestFlight-Gruppe eingerichtet
- [ ] Clean Install getestet
- [ ] Upgrade von einer vorherigen Testversion getestet
- [ ] Firebase Auth und Firestore im Release-Build getestet
- [ ] CoinGecko- und RSS-Daten im Release-Build getestet
- [ ] Absturz- und Performance-Stichprobe durchgeführt
- [ ] Tester-Feedback dokumentiert und kritische Probleme behoben

## 6. Freigabe

- [ ] Keine offenen Blocker-Issues
- [ ] Versionshinweise erstellt
- [ ] Git-Tag im Format `v1.0.0` erstellt
- [ ] Organisationsspiegel auf denselben Commit synchronisiert
- [ ] README, Pitchdeck und Company-Site entsprechen dem veröffentlichten Funktionsumfang
- [ ] App zur Prüfung eingereicht
