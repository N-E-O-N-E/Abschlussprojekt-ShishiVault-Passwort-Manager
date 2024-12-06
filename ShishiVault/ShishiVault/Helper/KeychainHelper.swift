//
//  KeychainHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import Foundation
import Security
import CryptoKit

// Quelle zur Umsetzung: https://www.advancedswift.com/secure-private-data-keychain-swift/#save-data-to-keychain
// Quelle zur Umsetzung: https://peerdh.com/blogs/programming-insights/secure-data-storage-in-swiftui-with-keychain

class KeychainHelper {
    // Singleton-Instanz um global darauf zureifen zu können - privat initialisiert
    static let shared = KeychainHelper()
    private init() {}
    
    func saveCombinedSymmetricKeyInKeychain(symmetricKey: Data, userSaltKey: Data, keychainKey: String) {
        let data = SHA256.hash(data: symmetricKey + userSaltKey)
        let symmetricKey = Data(data)
        
        save(data: symmetricKey, for: keychainKey)
        print("Combined SymmetricKey successfully saved in Keychain.")
    }
    
    func loadCombinedSymmetricKeyFromKeychain(keychainKey: String) -> SymmetricKey? {
        guard let data = read(for: keychainKey) else {
            print("SymmetricKey not found in Keychain.")
            return nil
        }
        print("SymmetricKey successfully loaded from Keychain.")
        return SymmetricKey(data: data)
    }
    
    // Diese Funktion speichert Daten im Keychain
    func save(data: Data, for key: String) {
        // Löscht zuerst Daten im Keychain,
        // sodass kein doppelter Eintrag für denselben Schlüssel existiert
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        
        // Speichert die Daten
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        } else {
            print("Data successfully saved in Keychain for the first time.")
        }
    }
    
    // Diese Funktion liest die Daten für einen bestimmten Key
    func read(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true, // Fordert die Rückgabe der Daten
            kSecMatchLimit as String: kSecMatchLimitOne // Gibt an, dass nur ein Element zurückgegeben wird
        ]
        
        var data: AnyObject? // Datenvariable für zurückgegebene daten
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        if status == errSecSuccess {
            let dataToResult = data as? Data
            return dataToResult
        } else {
            return nil
        }
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
        } else {
            print("Data successfully deleted from Keychain.")
        }
    }
}
