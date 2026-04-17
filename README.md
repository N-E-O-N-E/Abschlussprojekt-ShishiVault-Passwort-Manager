
<p align="center">
  <img src="./images/Slide 16_9 - 2.png" width="800">
</p>

# Shishi Vault - iOS Passwort-Manager

### [Besuche Shishi Vault im Web](https://shishivault.de)

**ShishiVault** ist ein hochsicherer Passwort-Manager für iOS, entwickelt mit **SwiftUI** und einem starken Fokus auf moderne kryptographische Standards. Der Name „Shishi“ (wörtlich: „Wächterlöwe“) steht für die traditionellen chinesischen Schutzwächter – ein Symbol für die Sicherheit, die diese App Ihren Daten bietet. Dieses Projekt wurde als Abschlussarbeit entwickelt und demonstriert die Implementierung einer professionellen, zukunftssicheren Code-Basis unter Verwendung des **MVVM-Entwurfsmusters**.

---

## 🔐 Sicherheits-Architektur

In der aktuellen Version (**maxRefactoring Update**) wurde die Sicherheitsarchitektur massiv verstärkt. Shishi Vault setzt auf eine mehrschichtige Verschlüsselung („Defense in Depth“):

- **Mastercode & Argon2id**: Ihr Master-Passwort wird niemals im Klartext gespeichert. Zur Ableitung des Hauptschlüssels verwenden wir **Argon2id** (via Sodium), den aktuellen Goldstandard für Key Derivation Functions (KDF), ergänzt durch ein individuelles Benutzer-Salt.
- **Biometrischer Schutz (FaceID/TouchID)**: Nach der Erstanmeldung kann der abgeleitete Schlüssel sicher in der **iOS Keychain** (Secure Enclave) abgelegt werden. Der Zugriff darauf ist strikt an eine erfolgreiche biometrische Authentifizierung gebunden.
- **Datenbank-Verschlüsselung (SQLCipher)**: Alle Einträge werden in einer lokalen SQLite-Datenbank gespeichert, die mittels **256-Bit AES (SQLCipher)** verschlüsselt ist.
- **ChaChaPoly-Validierung**: Die Integrität des Mastercodes wird über einen ChaCha20-Poly1305 versiegelten Validator geprüft.

---

## ✨ Neue Features & Refactoring (v2.0)

Mit dem letzten großen Merge wurden folgende Verbesserungen implementiert:

- **🚀 FaceID & Biometrie-Login**: Nahtloser und sicherer Zugriff auf den Tresor ohne ständige Mastercode-Eingabe.
- **🛠 Refactored Architecture**: Migration zu einem modularen `SecurityManager` und `ArgonCryptoService` für saubere Trennung von Logik und UI.
- **🔑 ConfigManager & Secrets**: API-Schlüssel (z.B. für den Passwort-Check) werden jetzt sicher über einen dedizierten `ConfigManager` verwaltet und sind nicht mehr in der `Info.plist` exponiert.
- **☁️ CloudKit Sync 2.0**: Verbesserte Synchronisation der verschlüsselten Daten über das persönliche iCloud-Konto des Benutzers. ( in finaler Version, noch nicht komplett implementiert)
- **🎨 UI/UX Performance**: Behebung von Layout-Instabilitäten und Optimierung der View-Transitions für ein flüssigeres Erlebnis.

---

## 🛠 Technologien

- **Sprache**: Swift 6.0+
- **UI-Framework**: SwiftUI (Native Apple Look & Feel)
- **Persistenz**: SQLCipher & GRDB (Verschlüsseltes SQLite)
- **Kryptographie**: LiquidSodium (Argon2id), CryptoKit (ChaChaPoly), AES-GCM
- **Synchronisation**: CloudKit (Apple native Cloud-Lösung)
- **Authentifizierung**: LocalAuthentication (FaceID/TouchID) & Apple Sign-In
- **Networking**: URLSession (asynchrone API-Calls für Passwort-Generator & Check)

---

## 🚀 Setup für Entwickler

Um das Projekt lokal zu bauen, ist eine manuelle Konfiguration der geheimen Keys notwendig (aus Sicherheitsgründen nicht im Git):

1. Erstellen Sie eine Datei `Secrets.swift` im Helper-Verzeichnis.
2. Implementieren Sie das `Secrets`-Enum:
   ```swift
   enum Secrets {
       static let rapidAPIKey = "DEIN_API_KEY"
   }
   ```
3. Der `ConfigManager` greift automatisch auf diese Werte zu, um z.B. die Passwort-Einstufungs-API zu bedienen.

---

## 📅 Roadmap & Zukunft

- **Design der App**: Die App bekommt nochmal ein großes Designupdate welches nach der technischen Umsetllung stattfinden wird. 
- **App Store Release**: Geplant nach einer geschlossenen Beta-Phase.

---


<p align="center">
  <img src="./images/Slide 16_9 - 1.png" width="400">
  <img src="./images/Slide 16_9 - 3.png" width="400">
</p>
