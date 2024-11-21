//
//  KeychainHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import Foundation
import Security

// Quelle zur Umsetzung: https://www.advancedswift.com/secure-private-data-keychain-swift/#save-data-to-keychain
// Quelle zur Umsetzung: https://developer.apple.com/documentation/security/storing-keys-in-the-keychain
// Quelle zur Umsetzung: https://developer.apple.com/documentation/security/using-the-keychain-to-manage-user-secrets
// Quelle zur Umsetzung: https://developer.apple.com/documentation/security/updating-and-deleting-keychain-items

class KeychainHelper {
    // Singleton-Instanz um global darauf zureifen zu können - privat initialisiert
    static let shared = KeychainHelper()
    private init() {}
    
    // Diese Funktion speichert Daten im Keychain
    func save(data: String, for key: String) {
        // Wandelt in UTF-8 Daten um
        let data = Data(data.utf8)
        
        // Löscht zuerst Daten im Keychain,
        // sodass kein doppelter Eintrag für denselben Schlüssel existiert
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        
        // Attribute für den Keychain
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data // Die Daten
        ]
        // Speichert die Daten
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }
    
    // Diese Funktion liest die Daten für einen bestimmten Key
    func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true, // Fordert die Rückgabe der Daten
            kSecMatchLimit as String: kSecMatchLimitOne // Gibt an, dass nur ein Element zurückgegeben wird
        ]
        
        var data: AnyObject? // Datenvariable für zurückgegebene daten
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        // Wenn die Suche erfolgreich war werden sie in einen String umgewandelt
        if status == errSecSuccess,
           let dataToResult = data as? Data,
           let result = String(data: dataToResult, encoding: .utf8) {
            return result
        }
        return nil
    }
    
    func update(data: String, for key: String) -> Bool {
        let data = Data(data.utf8) // Konvertierung der String in daten
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key]
        
        let attributeUpdate: [String: Any] = [
            kSecValueData as String: data]
        
        let status = SecItemUpdate(query as CFDictionary, attributeUpdate as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else if  status == errSecItemNotFound {
            print("Keychain item not found!")
        } else {
            print("Update failed: \(status)")
        }
       return false
    }
    
    // Löscht die Daten für einen Key
    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key]
        
        let status = SecItemDelete(query as CFDictionary)
        print("KeychainData deleted")
        if status != errSecSuccess {
            print("The Keychain could not be deleted")
        }
    }
}
