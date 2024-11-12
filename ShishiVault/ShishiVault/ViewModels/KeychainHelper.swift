//
//  KeychainHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import Foundation
import Security

// KeychainHelper ist Boilerplate-Code aus dem Internet den ich hier verwendet habe für
// unterschiedliche Methoden

class KeychainHelper {
    // Singleton-Instanz um global darauf zureifen zu können
    static let shared = KeychainHelper()
    
    // Diese Funktion speichert (data) unter (key) im Keychain
    func save(data: String, for key: String) {
        // Wandelt den zu String in UTF-8 Daten um
        let data = Data(data.utf8)
        
        // Löscht zuerst Daten für diesen Schlüssel im Keychain,
        // sodass kein doppelter Eintrag für denselben Schlüssel existiert
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as [String: Any]
        SecItemDelete(query as CFDictionary)
        
        // Attribute für den Keychain
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data // Die Daten
        ] as [String: Any]
        SecItemAdd(attributes as CFDictionary, nil)
    }
    
    // Diese Funktion liest die Daten für einen bestimmten Key
    func read(for key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true, // Fordert die Rückgabe der Daten
            kSecMatchLimit: kSecMatchLimitOne // Gibt an, dass nur ein Element zurückgegeben wird
        ] as [String: Any]
        
        var dataTypeRef: AnyObject? // Datenvariable für zurückgegebene daten
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Wenn die Suche erfolgreich war werden sie in einen String umgewandelt
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // Löscht die Daten für einen Key
    func delete(for key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as [String: Any]
        SecItemDelete(query as CFDictionary)
    }
}
