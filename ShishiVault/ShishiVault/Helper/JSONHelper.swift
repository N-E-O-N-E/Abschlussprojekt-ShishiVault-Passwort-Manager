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
    
    // Liefert den GerätePfad zur JSON datei
    private func getJSONFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let passwordFolder = documentDirectory.appendingPathComponent("shishiVaultData")
       
        do {
            try FileManager.default.createDirectory(at: passwordFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return documentDirectory.appendingPathComponent("shishiVaultData/shishiDataAES_.json")
    }
    
    // Liefert den Geräte DokumentPfad zur (un)verschlüsselten JSON datei
    private func getJSONFilePathForDecrypted() -> URL {
        let documentDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let passwordFolder = documentDirectory.appendingPathComponent("export_shishiVaultData")
        
        do {
            try FileManager.default.createDirectory(at: passwordFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return documentDirectory.appendingPathComponent("export_shishiVault_Passwortliste_Klartext/shishiData_klartext_.json")
    }
    
    // Lädt verschlüsseltes JSON und entschlüsselt es
    func loadEntriesFromJSON(key: SymmetricKey) async -> [EntryData] {
        let path = getJSONFilePath()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        guard FileManager.default.fileExists(atPath: path.path) else {
            print("No JSON file found at \(path.path)")
            return []
        }
        do {
            let encryptData = try Data(contentsOf: path)
            let decryptData = try CryptHelper.shared.decrypt(cipherText: encryptData, key: key)
            let entries = try decoder.decode([EntryData].self, from: decryptData)
            return entries
            
        } catch {
            print("Failed to load entries from JSON: \(error)")
            return []
        }
    }
    
    // Speichert die Daten verschlüsselt in JSON
    func saveEntriesToJSON(key: SymmetricKey, entries: [EntryData]) {
        let path = getJSONFilePath()
        do {
            if let jsonData = setDateToJSON(entries: entries) {
                let encryptData = try CryptHelper.shared.encrypt(data: jsonData, key: key)
                try encryptData.write(to: path)
                print("Entries saved to JSON")
            }
        } catch {
            print("Faild to save entries to JSON: \(error.localizedDescription)")
        }
    }
    
    // Speichert die Daten (un)verschlüsselt in JSON !!!!!!!!!
    func saveEntriesToJSONDecrypted(key: SymmetricKey, entries: [EntryData]) {
        let path = getJSONFilePathForDecrypted()
        do {
            if let jsonData = setDateToJSON(entries: entries) {
                try jsonData.write(to: path)
                print("Entries saved to JSON")
            }
        } catch {
            print("Faild to save entries to JSON: \(error)")
        }
    }
    
    func deleteEntiresFromJSON(key: SymmetricKey, entrie: EntryData) {
        let path = getJSONFilePath()
        do {
            let encryptData = try Data(contentsOf: path)
            let decryptData = try CryptHelper.shared.decrypt(cipherText: encryptData, key: key)
            var decryptedEntries = try JSONDecoder().decode([EntryData].self, from: decryptData)
            
            decryptedEntries.removeAll { $0.id == entrie.id }
            
            if let jsonData = setDateToJSON(entries: decryptedEntries) {
                let encryptedData = try CryptHelper.shared.encrypt(data: jsonData, key: key)
                try encryptedData.write(to: path)
            }
        } catch {
            print("Failed to delete entries from JSON: \(error)")
        }
    }
    
    func eraseJSONFile() {
        let path = getJSONFilePath()
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("Failed to erase JSON file: \(error)")
        }
    }
    
    // Konvertiere Entries in JSON
    func setDateToJSON(entries: [EntryData]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let jsonData = try encoder.encode(entries)
            return jsonData
        } catch {
            print("Failed to encode JSON: \(error)")
            return nil
        }
    }
    
}
