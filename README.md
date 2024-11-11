<p>
  <img src="./images/Slide 16_9 - 1.png" width="1000">
</p>

# Shishi Vault - iOS Passwort-Manager

Willkommen zu Shishi Vault – einer sicheren und zuverlässigen Passwort-Manager-App für iOS, entwickelt mit SwiftUI. Der Name “Shishi Vault” ist inspiriert von den chinesischen Shishi-Löwen, die symbolisch als Wächter gelten, wie z.B. beim Schutz von Tempeln. Diese App soll die Sicherheit und Vertraulichkeit Ihrer Passwörter und persönlichen Daten gewährleisten.

## Inhaltsverzeichnis

- Über das Projekt
- Features
- Technologien
- Anwendung

### Über das Projekt:

Shishi Vault ist eine iOS-App zur Verwaltung und sicheren Speicherung von Passwörtern, Bankdaten und anderen sensiblen Informationen. Durch die Integration von Firebase und einer Hybrid-Speicherlösung kombiniert Shishi Vault moderne Sicherheitstechniken mit einer benutzerfreundlichen Bedienung. Die App nutzt Firebase Authentication für die Anmeldung und AES-Verschlüsselung in Verbindung mit Firebase Storage für die sichere Speicherung und Synchronisation der Backup-Daten.

### Features:

  - Passwort-Manager: Erstellen, Speichern und Verwalten von Zugangsdaten, Bankverbindungen sowie Kredit- und Girokarten.
  - Passwort-Generator: Ein flexibler Passwortgenerator, der Passwörter mit benutzerdefinierter Länge, Groß- und Kleinschreibung sowie Sonderzeichen generieren kann. Dies wird über eine eigens implementierte API abgewickelt.
  - Firebase-Integration: Benutzeranmeldung und Authentifizierung via Firebase Authentication.

### Hybride Datenspeicherung:

  - Lokale Speicherung: Sensible Daten werden lokal via AES verschlüsselt und auf dem Gerät als JSON gespeichert, was die Sicherheit erhöht.
  - Firebase-Backup: Die verschlüsselten Daten werden automatisch in Firebase Storage AES verschlüsselt gesichert und synchronisiert, um den Zugriff auf mehreren Geräten und die Datenwiederherstellung bei Geräteverlust zu ermöglichen.

### Technologien:

  - SwiftUI – für die gesamte UI und Applogik
  - Firebase Authentication – für Benutzeranmeldung und Authentifizierung
  - AES-Verschlüsselung – zur Sicherung der lokalen Daten und Firebase Backups
  - Passwort-Generator API – zur Erstellung von sicheren Passwörtern mit benutzerdefinierten Einstellungen

## Anwendung

Benutzerführung:

  1.	Anmeldung:
      - Der Benutzer meldet sich über Firebase Authentication an.
  2.	Passwort-Manager:
      - Zugangsdaten, Bankverbindungen sowie Kreditkarteninformationen können über die Benutzeroberfläche sicher gespeichert und verwaltet werden.
  3.	Passwort-Generator:
      - Der Benutzer kann im Passwortgenerator ein Passwort nach gewünschten Einstellungen (Länge, Groß- und Kleinschreibung, Sonderzeichen) generieren. Dies geschieht über eine eingebundene API, die sicherstellt, dass die erzeugten Passwörter die Anforderungen erfüllen.
  4.	Hybride Speicherung:
      - Sensible Daten werden mit AES verschlüsselt lokal gespeichert und synchronisiert als verschlüsseltes Backup in Firebase Storeage gesichert.
      - Die Daten sind nur nach Entschlüsselung über den AES-Schlüssel des Geräts lesbar bzw. importierbar.

Shishi Vault schützt Ihre Daten so zuverlässig wie die Shishi-Löwen und bietet Ihnen die Flexibilität und Sicherheit, die Sie benötigen, um Ihre sensiblen Informationen zu verwalten.

<p>
  <img src="./images/Slide 16_9 - 2.png" width="333">
   <img src="./images/Slide 16_9 - 3.png" width="333">
   <img src="./images/Slide 16_9 - 4.png" width="333">
</p>

