//
//  JSONHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 19.11.24.
//

import SwiftUI
import CryptoKit

class JSONHelper {
    static let shared = JSONHelper()
    private init() {}
    
    func getJSONFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("entries.json")
    }
    
    // Konvertiere Entries in JSON
    func convertToJSON(entries: [EntryData]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(entries)
            return jsonData
        } catch {
            print("Failed to encode JSON: \(error)")
            return nil
        }
    }
    
    // Lädt verschlüsseltes JSON und entschlüsselt es
    func loadEntriesFromJSON(key: SymmetricKey) -> [EntryData] {
        let path = getJSONFilePath()
        do {
            let encryptData = try Data(contentsOf: path)
            let decryptData = try CryptHelper.shared.decrypt(cipherText: encryptData, key: key)
            let entries = try JSONDecoder().decode([EntryData].self, from: decryptData)
            return entries
        } catch {
            print("Failed to load entries from JSON: \(error)")
            return []
        }
    }
    
    func saveEntriesToJSON(key: SymmetricKey, entries: [EntryData]) {
        let path = getJSONFilePath()
        do {
            guard let jsonData = convertToJSON(entries: entries) else { return }
            let encryptData = try CryptHelper.shared.encrypt(data: jsonData, key: key)
            try encryptData.write(to: path)
            print("Entries saved to JSON")
        } catch {
            print("Faild to save entries to JSON: \(error)")
        }
    }
    
}
