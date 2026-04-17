import Foundation
import CryptoKit
import Sodium

class ArgonCryptoService {
    var isFirstStart: Bool {
        UserDefaults.standard.data(forKey: "user_salt") == nil
    }
    
    static let shared = ArgonCryptoService()
    private let sodium = Sodium()
    
    private let opsLimit = 5
    private let memLimit = 64 * 1024 * 1024
    private let keyLength = 32
    
    func getSalt() -> Data {
        let key = "user_salt"
        
        // 1. Schauen, ob es bereits in den UserDefaults liegt
        if let existingSalt = UserDefaults.standard.data(forKey: key) {
            return existingSalt
        } else {
            // 2. Falls nicht (Erstanmeldung), neues Salt generieren
            let newSalt = self.generateRandomSalt()
            
            // 3. Für die Zukunft speichern
            UserDefaults.standard.set(newSalt, forKey: key)
            print("✨ Neues Salt \(newSalt.base64EncodedString()) generiert und gespeichert.")
            return newSalt
        }
    }
    
    func deriveKey(password: String, salt: Data) -> Data? {
        let passwordBytes = Array(password.utf8)
        let saltBytes = Array(salt)
        
        guard let derivedKey = sodium.pwHash.hash(
                outputLength: keyLength,
                passwd: passwordBytes,
                salt: saltBytes,
                opsLimit: opsLimit,
                memLimit: memLimit
              ) else {
            return nil
        }
        return Data(derivedKey)
    }
    
    func generateRandomSalt() -> Data {
        let length = sodium.pwHash.SaltBytes
            return Data(sodium.randomBytes.buf(length: length)!)
    }
    
    func checkAppPassword(with key: Data) -> Bool {
        let defaults = UserDefaults.standard
        let symmetricKey = SymmetricKey(data: key)
        
        if let validatorData = defaults.data(forKey: "key_validator") {
            // Wir haben ein Schloss -> Versuche es zu öffnen
            do {
                let sealedBox = try ChaChaPoly.SealedBox(combined: validatorData)
                let decrypted = try ChaChaPoly.open(sealedBox, using: symmetricKey)
                return String(data: decrypted, encoding: .utf8) == "SHISHI_VALID"
            } catch {
                return false // PW falsch -> Entschlüsselung unmöglich
            }
        } else {
            // Erstmalige Einrichtung: Wir erstellen das Schloss
            let secret = "SHISHI_VALID".data(using: .utf8)!
            if let sealedBox = try? ChaChaPoly.seal(secret, using: symmetricKey) {
                defaults.set(sealedBox.combined, forKey: "key_validator")
                return true
            }
            return false
        }
    }
    
    /// Ändert das Masterpasswort.
    /// Gibt true zurück, wenn die Änderung erfolgreich war.
    func changeAppPassword(oldPassword: String, newPassword: String) -> Bool {
        let salt = getSalt() // Wir behalten das gleiche Salt (üblich bei Passwortänderung)
        
        // 1. Altes Passwort prüfen
        guard let oldKey = deriveKey(password: oldPassword, salt: salt),
              checkAppPassword(with: oldKey) else {
            return false // Altes Passwort war falsch
        }
        
        // 2. Neuen Key aus neuem Passwort ableiten
        guard let newKey = deriveKey(password: newPassword, salt: salt) else {
            return false
        }
        
        // 3. Neues Schloss (Validator) erstellen
        let symmetricKey = SymmetricKey(data: newKey)
        let secret = "SHISHI_VALID".data(using: .utf8)!
        
        do {
            let sealedBox = try ChaChaPoly.seal(secret, using: symmetricKey)
            
            // 4. In UserDefaults überschreiben
            UserDefaults.standard.set(sealedBox.combined, forKey: "key_validator")
            
            print("✅ Masterpasswort erfolgreich geändert.")
            return true
        } catch {
            print("❌ Fehler beim Versiegeln des neuen Passworts.")
            return false
        }
    }
    
    /// Löscht alle sicherheitsrelevanten Daten aus den UserDefaults
    func clearAll() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_salt")
        defaults.removeObject(forKey: "key_validator")
        print("🧹 UserDefaults bereinigt (Salt & Validator).")
    }
    
}
