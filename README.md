<p>
  <img src="./images/Slide 16_9 - 1.png" width="1000">
</p>

# Shishi Vault - iOS Passwort-Manager "Projektarbeit"

Willkommen zu Shishi Vault – einer sicheren und zuverlässigen Passwort-Manager-App für iOS, entwickelt mit SwiftUI. Der Name “Shishi Vault” ist inspiriert von den chinesischen Shishi-Löwen, die symbolisch als Wächter gelten, wie z.B. beim Schutz von Tempeln. Diese App soll die Sicherheit und Vertraulichkeit Ihrer Passwörter und persönlichen Daten gewährleisten.

Die APP wird zunächst im Rahmen einer Prüfungsarbeit geschrieben und erfüllt die Mindestanforderungen als Basis für die spätere Weiterentwicklung. 
Formale Kriterien sind: 
  -  Ausarbeiten einer Readme Datei
  -  mindestens drei Views
  -  SwiftData oder Firebase bzw. persistente Datenspeicherung
  -  ein API Call (mit URL Session asynchron)
  -  MVVM Architektur
  -  Fehler abfangen und für den benutzer anzeigen.

## Inhaltsverzeichnis

- Über das Projekt
- Features
- Technologien
- Anwendung

### Über das Projekt:

Shishi Vault ist eine iOS-App zur Verwaltung und sicheren Speicherung von Passwörtern, Bankdaten und anderen sensiblen Informationen. Shishi Vault nutzt ausschließlich native Apple-Technologien für die Benutzeranmeldung, Datenspeicherung und -synchronisation, um maximale Sicherheit und Datenschutz ohne Drittanbieter-Dienste zu gewährleisten. Die App verwendet Keychain und CloudKit für die sichere Speicherung und Synchronisation der Daten auf allen Geräten des Benutzers. Für die Anmeldung kommt die Apple ID-Authentifizierung zum Einsatz, wodurch die App nahtlos in das Apple-Ökosystem integriert ist.

### Features:

  - Erstellen, Speichern und Verwalten von Zugangsdaten, Bankverbindungen sowie Kredit- und Girokarten oder weiteren Custom-Fields
  - Apple ID-Anmeldung: Sichere und bequeme Authentifizierung über die Apple ID des Benutzers, ohne zusätzliche Konten erstellen zu müssen.
  - Passwort-Generator: Ein flexibler Passwortgenerator, der Passwörter mit benutzerdefinierter Länge, Groß- und Kleinschreibung sowie Sonderzeichen generieren kann. Dies wird über eine implementierte API abgewickelt.
  
  - Lokale Speicherung: Daten werden lokal als JSON verschlüsselt gespeichert, um maximale Sicherheit zu gewährleisten.
  - iCloud-Backup: Die JSON verschlüsselten Daten werden automatisch in der iCloud gesichert und auf alle Geräte des Benutzers synchronisiert, die mit derselben Apple ID verbunden sind.
    
### Technologien:

  - SwiftUI, Keychain, CryptKit, CloudKit
  - Apple ID-Anmeldung – AuthenticationServices für Benutzeranmeldung und Authentifizierung
  - iCloud – zur Sicherung der lokalen Daten und Synchronisation auf mehreren Geräten
  - Passwort-Generator API – zur Erstellung von sicheren Passwörtern mit benutzerdefinierten Einstellungen

## Anwendung

Benutzerführung:

  1.	Anmeldung:
      - Der Benutzer meldet sich sicher über seine Apple ID an, ohne ein neues Konto erstellen zu müssen.
  2.	Passwort-Manager:
      - Zugangsdaten, Bankverbindungen sowie Kreditkarteninformationen können über die Benutzeroberfläche sicher gespeichert und verwaltet werden. Die Daten werden dabei lokal verschlüsselt als JSON im APP Verzeichniss und in der iCloud gesichert, um geräteübergreifend verfügbar zu sein.
  3.	Passwort-Generator:
       - Der Benutzer kann im Passwortgenerator ein Passwort nach gewünschten Einstellungen (Länge, Groß- und Kleinschreibung, Sonderzeichen) generieren. Dies geschieht über eine eingebundene API, die sicherstellt, dass die erzeugten Passwörter den Anforderungen entsprechen.

--- 

Aussicht für die Zukunft:

  -  Eine Passwort verification API zur prüfung der Passwortintegrität
  -  Implementierung eines eigenen Passwort-Generators ohne API

Shishi Vault schützt Ihre Daten so zuverlässig wie die Shishi-Löwen und bietet Ihnen die Flexibilität und Sicherheit, die Sie benötigen, um Ihre sensiblen Informationen zu verwalten.

<p>
  <img src="./images/Slide 16_9 - 2.png" width="333">
   <img src="./images/Slide 16_9 - 3.png" width="333">
   <img src="./images/Slide 16_9 - 4.png" width="333">
</p>

