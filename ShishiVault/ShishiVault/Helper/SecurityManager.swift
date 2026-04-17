import Foundation
import LocalAuthentication
import Security

enum SecurityError: Error, LocalizedError {
    case authFailed
    case biometricsNotAvailable
    case keychainError(OSStatus)
    case dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .authFailed: return "Authentifizierung fehlgeschlagen."
        case .biometricsNotAvailable: return "Biometrie ist auf diesem Gerät nicht verfügbar oder nicht eingerichtet."
        case .keychainError(let status): return "Keychain-Fehler: \(status)"
        case .dataNotFound: return "Kein Schlüssel im Tresor gefunden."
        }
    }
}

class SecurityManager {
    static let shared = SecurityManager()
    private let appKeyAccount = "com.shishivault.masterkey"
    
    private init() {}
    
    /// Prüft, ob Biometrie (FaceID/TouchID) verfügbar ist
    var isBiometryAvailable: Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    /// Speichert den abgeleiteten Argon2-Key sicher in der Keychain
    /// Der Key wird durch FaceID/TouchID geschützt (.biometryAny oder .userPresence)
    func saveAppKey(_ key: Data) throws {
        // AccessControl: Hardware-Schutz via Secure Enclave
        // .biometryAny: Jede registrierte Biometrie reicht aus. 
        // .or: Passwort-Fallback erlauben, falls Biometrie fehlschlägt.
        guard let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .biometryAny,
            nil
        ) else {
            throw SecurityError.keychainError(errSecBadReq)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: appKeyAccount,
            kSecValueData as String: key,
            kSecAttrAccessControl as String: accessControl
        ]
        
        // Vorherigen Eintrag löschen, falls vorhanden
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecurityError.keychainError(status)
        }
    }
    
    /// Holt den Key aus der Keychain mittels FaceID/TouchID
    func loadAppKey(completion: @escaping (Result<Data, SecurityError>) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = "Passwort verwenden"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: appKeyAccount,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context, // Nutzt FaceID-Abfrage automatisch
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            
            DispatchQueue.main.async {
                if status == errSecSuccess, let data = dataTypeRef as? Data {
                    completion(.success(data))
                } else if status == errSecUserCanceled {
                    completion(.failure(.authFailed))
                } else if status == errSecItemNotFound {
                    completion(.failure(.dataNotFound))
                } else {
                    completion(.failure(.keychainError(status)))
                }
            }
        }
    }
    
    /// Löscht den Master-Key (z.B. bei Logout oder Reset)
    func deleteMasterKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: appKeyAccount
        ]
        SecItemDelete(query as CFDictionary)
    }
}
