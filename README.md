<p>
  <img src="./images/Slide 16_9 - 1.png" width="1000">
</p>

# Shishi Vault - iOS Passwort-Manager "Modul Abschlussarbeit"

Shishi Vault ist ein Passwort-Manager für iOS, entwickelt mit SwiftUI iOS 18 unter XCode 16. Der Name "Shishi" bedeutet Wächterlöwe und ist inspiriert von den chinesischen Shishi-Löwen, die symbolisch als Schutzwächter vor vielen Hauseingängen, speziell vor den Eingängen traditioneller Gebäude und Tempeln wachen. Diese App soll die Sicherheit und Vertraulichkeit Ihrer Passwörter und persönlichen Daten gewährleisten indem sie sensible Daten sicher speichert und so vor Datenmissbrauch schüzt. 

Die APP wird aktuell zunächst im Rahmen einer Prüfungsarbeit geschrieben und erfüllt die Mindestanforderungen als Basis für die spätere Weiterentwicklung. Über die Mindestanforderungen hinaus wird die App auch alle Grundfunktionen bieten um Zugangsdaten sicher zu verwalten.
Nach der Prüfungphase ist das Ziel, die App weiter zu entwickeln und zum einen die Usability aber auch den Funktionsumfang zu steigern und sie im AppStore final zu veröffentlichen.

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

Shishi Vault ist eine iOS-App zur Verwaltung und sicheren Speicherung von Passwörtern, Bankdaten und anderen sensiblen Informationen. Shishi Vault nutzt ausschließlich native Apple-Technologien für die Benutzeranmeldung, Datenspeicherung und -synchronisation, um maximale Sicherheit und Datenschutz ohne Drittanbieter-Dienste zu gewährleisten. Die App verwendet Keychain und das CryptKit für die sichere Anmeldung und Speicherung der Daten auf dem Gerät des Benutzers. Für die Anmeldung kommt der AppleSignInButton zum Einsatz, wodurch die App nahtlos in das Apple-Ökosystem integriert ist. Über ein zusätzliches Master-Passwort "salt" wird die Verschlüsselung der Daten zusätzlich verschleiert.

### Features:

  - Erstellen, Speichern und Verwalten von Zugangsdaten, Bankverbindungen sowie Kredit- und Girokarten. Dynamisch erweiterbar mittels weiterer Custom-Fields pro Eintrag
  - Apple ID-Anmeldung: Sichere und bequeme Authentifizierung über die Apple ID des Benutzers, ohne zusätzliche Konten erstellen zu müssen
  - Vergabe eines Master-Passwortes für die maximale Sicherheit bei der Datenverschlüsselung
  - Passwort-Generator: Ein flexibler Passwortgenerator, der Passwörter mit benutzerdefinierter Länge, Groß- und Kleinschreibung sowie Sonderzeichen generieren kann. Dies wird über eine implementierte API abgewickelt
  - Passwort-Prüfung: Jedes Passwort wird über die API von https://haveibeenpwned.com/ auf seine Sicherheit verifiziert
  
  - Lokale Speicherung: Daten werden lokal als JSON-Datei via AES verschlüsselt gespeichert, um maximale Sicherheit zu gewährleisten
  - Der AES Schlüssel bildet sich aus einem HASH der Apple-ID in Kombination mit dem Hash des Master-Passwortes
  - Der User hat die Möglichkeit diese Daten auch als Klartext in eine unverschlüsselte JSON zu exportieren.
  - Der User ist selbst für die Verwaltung seines Master-Passwortes verantwortlich um jederzeit an seine Daten zu gelangen.
    
### Technologien:

  - SwiftUI, Keychain, CryptKit (SHA256, AES-GCM), (CloudKit)
  - AppleSignInButton – AuthenticationServices von Apple
  - JSON-Datenformat
  - Passwort-Generator API
  - Passwort verifikation API

## Anwendung

Benutzerführung:

  1.	Anmeldung:
      - Der Benutzer meldet sich sicher mit seiner Apple ID an
    	- Der Benutzer vergibt ein Master-Passwort welches die Verschlüsselung um einem sog. "salt" ergänzt
  3.	Passwort-Manager:
      - Zugangsdaten, Bankverbindungen sowie Kreditkarteninformationen können über die Benutzeroberfläche sicher gespeichert und verwaltet werden.
    	Die Daten werden dabei lokal verschlüsselt als JSON im Libary-Verzeichniss gesichert. Unverschlüsselte Exports der Daten sind im Download-Ordner zu finden.
  5.	Passwort-Generator:
      - Der Benutzer kann im Passwortgenerator ein Passwort nach gewünschten Einstellungen (Länge, Groß- und Kleinschreibung, Sonderzeichen) generieren.
    	Dies geschieht über eine eingebundene API, die sicherstellt, dass die erzeugten Passwörter den Anforderungen entsprechen.
    	- Jedes Passwort wird über eine API auf seinen Kompromitierungsstatus geprüft.
     
--- 

Aussicht für die Zukunft:

  -  iCloud-Backup: Die JSON verschlüsselten Daten können zukünftig automatisch in der iCloud gesichert und so auf allen Geräte des Benutzers synchronisiert werden die mit derselben Apple ID angemeldet sind.


App-Download und fehlende Daten:

  - Damit die App funktioniert müssen die Dateien "API-Keys.swift und KeyChainKeys.swift" immer anlegegt werden! Diese enthalten die Keys der API und der Keychain intern.
  - - APIKeys: Enthält den API Schlüssel der API von "Random Password Generator" by apipigu (https://rapidapi.com/apipigu/api/random-password-generator5)
  - - KeyChainKeys: Enthällt die spezifischen Key-Strings unter denen die KeyChain die Werte speichern.

  ## In dieser Git-Version im Rahmen der Projektarbeit werden diese beiden Dateien angezeigt und mit einem gültigen API-Key befüllt. 
  Diese Keys werden nach der Projektarbeit gelöscht! Aus Sicherheitsgründen sollten die beiden Dateien auch in die .gitignore Datei aufgenommen werden!

---

<p>
  <img src="./images/Slide 16_9 - 2.png" width="333">
   <img src="./images/Slide 16_9 - 3.png" width="333">
</p>

