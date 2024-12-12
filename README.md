<p>
  <img src="./images/Slide 16_9 - 2.png" width="1000">
</p>

# Shishi Vault - iOS Passwort-Manager "Abschlussarbeit"

### [Besuche Shishi Vault im Web](https://shishivault.de)

ShishiVault ist ein Passwort-Manager für iOS, entwickelt mit SwiftUI für iOS 17+ unter Xcode 16. Der Name „Shishi“ bedeutet sinngemäß „Wächterlöwe“ und ist inspiriert von den chinesischen Shishi-Löwen, die traditionell als Schutzwächter vor Hauseingängen, insbesondere vor den Eingängen traditioneller Gebäude und Tempel, stehen.

Shishi Vault ist eine App, die ausschließlich im Rahmen eines Abschlussprojekts entwickelt wurde. Sie dient aktuell der Demonstration meiner Fähigkeiten als Entwickler und der Präsentation meiner Kenntnisse im Umgang mit modernen Technologien und Frameworks. Die App gewährleistet in ihrer Funktionalität die Sicherheit und Vertraulichkeit von Passwörtern und persönlichen Daten, indem sie sensible Informationen sicher speichert und vor unbefugtem Zugriff schützt.

### Wichtige Hinweise:

  - Meine App wird derzeit ausschließlich für Bildungs- und Präsentationszwecke entwickelt und verfolgt noch keine kommerziellen Absichten.
  - Die Veröffentlichung im App Store oder anderen Plattformen ist frühestens ab Mitte 2025 geplant.
  - Der Fokus liegt auf der Erfüllung der prüfungsrelevanten Mindestanforderungen sowie der Demonstration einer soliden und zukunftsfähigen Code-Basis.

Nach Abschluss der Prüfungsphase im Dezember 2024 werde ich das Projekt privat weiterentwickeln, um meine Kenntnisse und Erfahrungen in den Bereichen Benutzerfreundlichkeit, Sicherheit und Funktionsvielfalt zu vertiefen. Eine nebenberufliche Selbstständigkeit als "Freelancer oder Gewerbetreibender" wird angemeldet, sobald eine veröffentlichbare Betaversion den Status des Abschlussprojekts verliert.

---

### Formale Prüfungskriterien sind: 

  -  Ausarbeiten einer Readme Datei
  -  Mind. 3 Views umsetzen Design und Logik
  -  Persistente Datenspeicherung nutzen
  -  Mind. ein API Call (mit URL Session asynchron) einbinden
  -  MVVM Architektur anwenden
  -  Fehler abfangen und für den Benutzer anzeigen

---

## Inhaltsverzeichnis

- Über das Projekt
- Features
- Technologien
- Anwendung


### Über das Projekt:

Verwalten Sie Ihre Passwörter, Bankdaten und anderen sensiblen Informationen sicher und zuverlässig mit Shishi Vault.

Die App nutzt ausschließlich native Apple-Technologien wie die Keychain und CryptoKit, um maximale Sicherheit ohne den Einsatz von Diensten Dritter zu gewährleisten. Ihre Daten werden direkt auf dem Gerät sicher verschlüsselt gespeichert.

Für die Benutzeranmeldung wird der ‘Mit Apple anmelden’-Button verwendet, wodurch die Anmeldung nahtlos in das Apple-Ökosystem integriert ist.

Zusätzlich sorgt ein Master-Passwort (“Salt”) für eine erweiterte Verschleierung und erhöht damit den Schutz Ihrer sensiblen Daten.

### Features:

  - Erstellen, Speichern und Verwalten:
Zugangsdaten, Bankverbindungen sowie Kredit- und Girokarten können sicher verwaltet und bei Bedarf durch benutzerdefinierte Eingabefelder dynamisch erweitert werden.

  - Apple-ID Anmeldung:
Eine sichere und bequeme Authentifizierung erfolgt über die Apple ID des Benutzers, ohne dass zusätzliche Konten erstellt werden müssen.

  - Master-Passwort für maximale Sicherheit:
Durch die Vergabe eines Master-Passworts wird die Datenverschlüsselung mittels eines zusätzlichen “Salt”-Mechanismus verstärkt.

  - PIN Sperre der App für flexible Sicherheit: 
Durch das Vergeben eines PIN über die Einstellungen ist es möglich die APP zu sperren.

  - Passwort-Generator:
Ein flexibler Passwortgenerator erstellt sichere Passwörter mit benutzerdefinierter Länge, Groß- und Kleinschreibung sowie Sonderzeichen. Diese Funktion wird über eine implementierte externe API bereitgestellt.

  - Passwort-Prüfung:
Passwörter werden über eine externe API auf Sicherheit geprüft. Dabei werden nur die ersten fünf Ziffern des zuvor in der App generierten Hashwerts übertragen, um mögliche Kompromittierungen zu identifizieren.

  - Lokale Speicherung:
Alle Daten werden lokal als verschlüsselte JSON-Datei gespeichert. Die Verschlüsselung erfolgt mittels AES-GCM, um maximale Datensicherheit zu gewährleisten.

  - iCloud Speicherung:
Alle Daten können mittels Datenupload bzw. -download geräteübergreifend gesichert werden. Hierbei werden die Daten über das CloudKit gehandelt.

  - Schlüsselableitung:
Der AES-Schlüssel wird aus einem intern generierten Hashwert abgeleitet, der sich aus der Apple-ID und dem Hashwert des Master-Passworts zusammensetzt.

  - Datenexport:
Benutzer haben die Möglichkeit, ihre Daten als Klartext in eine unverschlüsselte JSON-Datei zu exportieren.
    
### Technologien:

  - SwiftUI für die Benutzeroberfläche, entwickelt mit modernsten Frameworks von Apple.
  - Keychain und CryptKit (SHA-256, AES-GCM) für sichere Datenspeicherung und Verschlüsselung.
  - AppleSignInButton – Nahtlose Integration der Authentifizierungsdienste von Apple.
  - PIN Sperre - für den smarten Zugriff auf die App
  - Verwendung des JSON-Datenformats für die persistente und strukturierte Datenspeicherung.
  - Verwendung des CloudKit für die sichere und geräteübergreifende Speicherung der Daten.
  - Passwort-Generator über eine externe API zur Erstellung sicherer Passwörter.
  - Passwort-Verifikation mithilfe einer API, die Hashwerte überträgt und sicher verifiziert.

---

## Anwendung

### Benutzerführung:

  1.	Anmeldung:
      - Anmeldung mittels der Apple-ID über den SignInButton und Vergabe eines Master-Passworts "salt".

  2.  Einträge verwalten:
      - Über den FAB-Button auf dem Homescreen lassen sich neue Einträge hinzufügen.
      - Durch Klick auf einen Eintrag gelangt man in die Eintragsvorschau.
      --  Dort kann der Benutzer Werte direkt in die Zwischenablage kopieren.
      --  Von hier aus können Einträge nachträglich bearbeitet oder gelöscht werden.

  3.	Datenspeicherung lokal:
      - Alle Einträge werden nach dem Speichern lokal verschlüsselt als JSON im APP-Verzeichniss gesichert. Unverschlüsselte Exports der Daten sind im Documents-Ordner des Benutzers zu finden. Die Dateien enthalten die ersten Stellen des UserID-Hashwertes welcher in der Keychain gespeichert wurde, um so auf Basis der eingegebenen Anmeldetdaten (Hashwert der AppleID und des Master-Passwortes) die Daten für jeden Benutzer identifizieren zu können.
      
  4.    Datenspeicherung iCloud:
      - Über die Einstellungen können alls Daten in die iCloud übermittelt bzw. heruntergeladen werden
        !!! ACHTUNG !!! Daten sind nur zugänglich solange das gültige Master-Passwort vorliegt.

  4.	Passwort-Generator:
      - Der Benutzer kann im Passwortgenerator ein Passwort nach gewünschten Einstellungen (Länge, Groß- und Kleinschreibung, Sonderzeichen) generieren.
    	Dies geschieht über eine eingebundene API, die sicherstellt, dass die erzeugten Passwörter den Anforderungen entsprechen.
    	- Jedes Passwort wird über weitere API auf seinen Kompromitierungsstatus geprüft.

  5.	Abmeldung:
      - Wenn der Benutzer sich von der App abmeldet, werden nur die Anmeldedaten gelöscht. Die verschlüsselten JSON Dateien werden nur gelöscht wenn der Benutzer die APP deinstalliert oder in den Einstellungen der APP bei aktiver Anmeldung die Daten über den "Löschen" Button explizit löscht! 
      Bei einer Neuanmeldung gibt der Benutzer einfach sein Master-Passwort an und schon kann er seine Daten (bei gleicher Apple ID) laden.
     
--- 

### Aussicht für die Zukunft:

- Der Fokus der aktuellen Weiterentwicklung liegt auf der Verbesserung der Benutzerfreundlichkeit und dem Design. Stetiges Anpassen des Codes ist natürlich selbstverständilich.

---

### App-Download und fehlende Daten:

  - Damit die App funktioniert müssen die Dateien "API-Keys.swift und KeyChainKeys.swift" immer anlegegt werden! Diese enthalten die Keys der API und der Keychain intern.
  - - APIKeys: Enthält den API Schlüssel der API von "Random Password Generator" by apipigu (https://rapidapi.com/apipigu/api/random-password-generator5)
  - - KeyChainKeys: Enthällt die spezifischen Key-Strings unter denen die KeyChain die Werte speichert.

  ## In dieser Git-Version im Rahmen der Projektarbeit werden diese beiden Dateien angezeigt und mit einem gültigen API-Key befüllt. 
  Diese Keys werden nach der Projektarbeit gelöscht! Aus Sicherheitsgründen sollten die beiden Dateien auch in die .gitignore Datei aufgenommen werden!

---

<p>
  <img src="./images/Slide 16_9 - 1.png" width="333">
   <img src="./images/Slide 16_9 - 3.png" width="333">
</p>

