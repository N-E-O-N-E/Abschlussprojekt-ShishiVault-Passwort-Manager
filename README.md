<p>
  <img src="./images/Slide 16_9 - 2.png" width="1000">
</p>

# Shishi Vault - iOS Passwort-Manager "Modul Abschlussarbeit"

Shishi Vault ist ein Passwort-Manager für iOS, entwickelt mit SwiftUI für iOS 18 und Xcode 16. Der Name “Shishi” bedeutet sinngemäß “Wächterlöwe” und ist inspiriert von den chinesischen Shishi-Löwen, die traditionell als Schutzwächter vor Hauseingängen, insbesondere vor den Eingängen traditioneller Gebäude und Tempel, stehen. Shishi Vault ist eine App, die Sicherheit und Vertraulichkeit Ihrer Passwörter und persönlichen Daten gewährleistet, indem sie sensible Informationen sicher speichert und so vor Datenmissbrauch durch Dritte schützt.

Die App wird aktuell im Rahmen einer Prüfungsarbeit entwickelt und erfüllt neben den prüfungsrelevanten Mindestanforderungen alle wesentlichen Funktionen, um sensible Daten sicher und effizient zu verwalten. Nach der Prüfungsphase im Dezember 2024 ist es das erklärte Ziel, die App kontinuierlich weiterzuentwickeln, sowohl die Usability als auch den Funktionsumfang dauerhaft zu verbessern.

Eine veröffentlichung der APP ist 2025 geplant.

Formale Prüfungskriterien sind: 
  -  Ausarbeiten einer Readme Datei
  -  3 Views umsetzen Design und Logik
  -  SwiftData/Firebase oder andere persistente Datenspeicherung nutzen
  -  mind. ein API Call (mit URL Session asynchron) einbinden
  -  MVVM Architektur anwenden
  -  Fehler abfangen und für den Benutzer anzeigen

## Inhaltsverzeichnis

- Über das Projekt
- Features
- Technologien
- Anwendung

### Über das Projekt:

Verwalten Sie Ihre Passwörter, Bankdaten und anderen sensiblen Informationen sicher und zuverlässig mit Shishi Vault. Die App nutzt ausschließlich native Apple-Technologien, wie die Keychain und das CryptKit, um maximale Sicherheit ohne den Einsatz von Drittanbieter-Diensten zu gewährleisten. Ihre Daten werden direkt auf dem Gerät sicher verschlüsselt gespeichert. Für die Benutzeranmeldung wird der “Sign in with Apple”-Button verwendet, wodurch die Anmeldung nahtlos in das Apple-Ökosystem integriert ist. Zusätzlich sorgt ein Master-Passwort (“Salt”) für eine erweiterte Verschleierung und erhöht damit den Schutz Ihrer sensiblen Daten.

### Features:

- Erstellen, Speichern und Verwalten:
Zugangsdaten, Bankverbindungen sowie Kredit- und Girokarten können sicher verwaltet und bei Bedarf durch benutzerdefinierte Custom-Fields dynamisch erweitert werden.

- Apple ID-Anmeldung:
Eine sichere und bequeme Authentifizierung erfolgt über die Apple ID des Benutzers, ohne dass zusätzliche Konten erstellt werden müssen.

- Master-Passwort für maximale Sicherheit:
Durch die Vergabe eines Master-Passworts wird die Datenverschlüsselung mittels eines zusätzlichen “Salt”-Mechanismus verstärkt.

- Passwort-Generator:
Ein flexibler Passwortgenerator erstellt sichere Passwörter mit benutzerdefinierter Länge, Groß- und Kleinschreibung sowie Sonderzeichen. Diese Funktion wird über eine implementierte externe API bereitgestellt.

- Passwort-Prüfung:
Passwörter werden über eine externe API auf Sicherheit geprüft. Dabei werden nur die ersten fünf Ziffern des zuvor in der App generierten Hashwerts übertragen, um mögliche Kompromittierungen zu identifizieren.

- Lokale Speicherung:
Alle Daten werden lokal als verschlüsselte JSON-Datei gespeichert. Die Verschlüsselung erfolgt mittels AES-GCM, um maximale Datensicherheit zu gewährleisten.

- Schlüsselableitung:
Der AES-Schlüssel wird aus einem intern generierten Hashwert abgeleitet, der sich aus der Apple-ID und dem Hashwert des Master-Passworts zusammensetzt.

- Datenexport:
Benutzer haben die Möglichkeit, ihre Daten als Klartext in eine unverschlüsselte JSON-Datei zu exportieren.

- Verantwortung des Benutzers:
Der Benutzer ist selbst für die Verwaltung seines Master-Passworts verantwortlich, um jederzeit Zugang zu seinen Daten sicherzustellen.
    
### Technologien:

- SwiftUI für die Benutzeroberfläche, entwickelt mit modernsten Frameworks von Apple.
- Keychain und CryptKit (SHA-256, AES-GCM) für sichere Datenspeicherung und Verschlüsselung.
- AppleSignInButton – Nahtlose Integration der Authentifizierungsdienste von Apple.
- Verwendung des JSON-Datenformats für die persistente und strukturierte Datenspeicherung.
- Passwort-Generator über eine externe API zur Erstellung sicherer Passwörter.
- Passwort-Verifikation mithilfe einer API, die Hashwerte überträgt und sicher verifiziert.

## Anwendung

Benutzerführung:

  1.	Anmeldung:
      - Anmeldung mittels der Apple ID über den SignInButton
    	- Vergabe eines Master-Passworts "salt"

  2.  Einträge verwalten:
      - Über den FAB-Button auf dem Homescreen lassen sich neue Einträge hinzufügen
      - Durch Klick auf einen Eintrag gelangt man in die Eintragsvorschau
      --  Dort kann der User Werte direkt in die Zwischenablage kopieren
      --  Der User kann von hier aus Einträge löschen oder bearbeiten

  3.	Datenspeicherung lokal:
      - Alle Einträge werden nach dem Speichern lokal verschlüsselt als JSON im Libary-Verzeichniss gesichert. Unverschlüsselte Exports der Daten sind im Download-Ordner zu finden. Die Dateien enthalten die ersten Stellen des UserID-Hashwertes um welcher in der Keychain gesoeichert wurde um so auf Basis der eingegebenen Anmeldetdaten (Hashwert der AppleID und des Master-Passwortes) die Daten für jeden User zu laden.

### !!! ACHTUNG !!! Lokale Daten sind nur zugänglich solange sich die UserID nicht ändert und das Master-Passwort vorliegt.

  4.	Passwort-Generator:
      - Der Benutzer kann im Passwortgenerator ein Passwort nach gewünschten Einstellungen (Länge, Groß- und Kleinschreibung, Sonderzeichen) generieren.
    	Dies geschieht über eine eingebundene API, die sicherstellt, dass die erzeugten Passwörter den Anforderungen entsprechen.
    	- Jedes Passwort wird über eine API auf seinen Kompromitierungsstatus geprüft.

  5.	Abmeldung:
      - Wenn sie sich von der App abmelden werden nur die Anmeldedaten gelöscht. Die verschlüsselten JSON dateien werden nur gelöscht wenn sie die APP deinstallieren oder in den Einstellungen der APP bei aktiver Anmeldung die Daten über den "Löschen" Button direkt löschen!
     
--- 

### Aussicht für die Zukunft:

- Der Fokus der aktuellen Weiterentwicklung liegt auf der Integration eines iCloud-Backups. Die verschlüsselten JSON-Daten werden künftig automatisch in der iCloud gesichert. Dadurch können die Daten nahtlos auf alle Geräte des Benutzers synchronisiert werden, die mit derselben Apple ID verbunden sind.

---

App-Download und fehlende Daten:

  - Damit die App funktioniert müssen die Dateien "API-Keys.swift und KeyChainKeys.swift" immer anlegegt werden! Diese enthalten die Keys der API und der Keychain intern.
  - - APIKeys: Enthält den API Schlüssel der API von "Random Password Generator" by apipigu (https://rapidapi.com/apipigu/api/random-password-generator5)
  - - KeyChainKeys: Enthällt die spezifischen Key-Strings unter denen die KeyChain die Werte speichern.

  ## In dieser Git-Version im Rahmen der Projektarbeit werden diese beiden Dateien angezeigt und mit einem gültigen API-Key befüllt. 
  Diese Keys werden nach der Projektarbeit gelöscht! Aus Sicherheitsgründen sollten die beiden Dateien auch in die .gitignore Datei aufgenommen werden!

---

<p>
  <img src="./images/Slide 16_9 - 1.png" width="333">
   <img src="./images/Slide 16_9 - 3.png" width="333">
</p>

