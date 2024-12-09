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
    private let keychainHelper = KeychainHelper.shared
    private let cryptHelper = CryptHelper.shared
    private init() {}
    
    // Liefert den GerätePfad zur JSON datei
    private func getJSONFilePath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Error: Could not find Library directory.")
            return nil
        }
        
        let passwordFolder = documentDirectory.appendingPathComponent("shishiVaultData")
        
        do {
            try FileManager.default.createDirectory(at: passwordFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
        
        guard let userSalt = keychainHelper.read(for: KeyChainKeys().userSaltString) else {
            print("Error: No userSalt found")
            return nil
        }
        
        // Wandelt die Daten wieder in SHA256 lesbaren String
        let stringPrefix = userSalt.map { String(format: "%02x", $0) }.joined().prefix(10)
        
        let filePath = passwordFolder.appendingPathComponent("shishiDataAES_\(stringPrefix).json")
        return filePath
    }
    
    // Liefert den Geräte DokumentPfad zur (un)verschlüsselten JSON datei
    private func getJSONFilePathForDecrypted() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Error: Could not find Document directory.")
                return nil
            }
        
        let passwordFolder = documentDirectory.appendingPathComponent("export_shishiVault_Klartext")
        
        do {
            try FileManager.default.createDirectory(at: passwordFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
        
        guard let userSalt = keychainHelper.read(for: KeyChainKeys().userSaltString) else {
            print("Error: No userSalt found")
            return nil
        }
        
        // Wandelt die Daten wieder in SHA256 lesbaren String
        let stringPrefix = userSalt.map { String(format: "%02x", $0) }.joined().prefix(10)
        
        let filePath = passwordFolder.appendingPathComponent("/shishiData_klartext_\(stringPrefix).json")
        return filePath
        
    }
    
    // Lädt verschlüsseltes JSON und entschlüsselt es
    func loadEntriesFromJSON(key: SymmetricKey) async -> [EntryData] {
        guard let path = getJSONFilePath() else {
            print("Path not found for loading entries from JSON")
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        
        guard FileManager.default.fileExists(atPath: path.path) else {
            print("No JSON file found at \(path.path)")
            return []
        }
        do {
            let encryptData = try Data(contentsOf: path)
            let decryptData = try cryptHelper.decrypt(cipherText: encryptData, key: key)
            let entries = try decoder.decode([EntryData].self, from: decryptData)
            return entries
            
        } catch {
            print("Failed to load entries from JSON: \(error)")
            return []
        }
    }
    
    // Speichert die Daten verschlüsselt in JSON
    func saveEntriesToJSON(key: SymmetricKey, entries: [EntryData]) {
        guard let path = getJSONFilePath() else {
            print("Path not found for saving entries to JSON")
            return
        }
        
        do {
            if let jsonData = setDateToJSON(entries: entries) {
                let encryptData = try cryptHelper.encrypt(data: jsonData, key: key)
                try encryptData.write(to: path)
                print("Entries saved to JSON")
            }
        } catch {
            print("Faild to save entries to JSON: \(error.localizedDescription)")
        }
    }
    
    // Speichert die Daten (un)verschlüsselt in JSON !!!!!!!!!
    func saveEntriesToJSONDecrypted(key: SymmetricKey, entries: [EntryData]) {
        guard let path = getJSONFilePathForDecrypted() else {
            print("Path not found for saving entries to JSON")
            return
        }
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
        guard let path = getJSONFilePath() else {
            print("Path not found for deleting entries from JSON")
            return
        }
        
        do {
            let encryptData = try Data(contentsOf: path)
            let decryptData = try cryptHelper.decrypt(cipherText: encryptData, key: key)
            var decryptedEntries = try JSONDecoder().decode([EntryData].self, from: decryptData)
            
            decryptedEntries.removeAll { $0.id == entrie.id }
            
            if let jsonData = setDateToJSON(entries: decryptedEntries) {
                let encryptedData = try cryptHelper.encrypt(data: jsonData, key: key)
                try encryptedData.write(to: path)
            }
        } catch {
            print("Failed to delete entries from JSON: \(error)")
        }
    }
    
    func eraseJSONFile() {
        guard let path = getJSONFilePath() else {
            print("Path not found for erasing JSON File")
            return
        }
        
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
    
    func backupToiCloud() {
        let fileManager = FileManager.default
        guard let cloudDirectory = fileManager.url(forUbiquityContainerIdentifier: nil)?
                .appendingPathComponent("Documents") else {
            print("iCloud nicht verfügbar")
            return
        }
        
        let localFilePath = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("shishiVaultData/shishiDataAES_.json")
        let cloudFilePath = cloudDirectory.appendingPathComponent("shishiVaultData/shishiDataAES_.json")

        do {
            if fileManager.fileExists(atPath: cloudFilePath.path) {
                try fileManager.removeItem(at: cloudFilePath)
            }
            try fileManager.copyItem(at: localFilePath, to: cloudFilePath)
            print("Backup in iCloud erfolgreich.")
        } catch {
            print("Fehler beim Backup: \(error)")
        }
    }
    
    func restoreFromiCloud() {
        let fileManager = FileManager.default
        guard let cloudDirectory = fileManager.url(forUbiquityContainerIdentifier: nil)?
                .appendingPathComponent("Documents") else {
            print("iCloud nicht verfügbar")
            return
        }
        
        guard let userSalt = keychainHelper.read(for: KeyChainKeys().userSaltString) else {
            print("Error: No userSalt found")
            return
        }
        
        // Wandelt die Daten wieder in SHA256 lesbaren String
        let stringPrefix = userSalt.map { String(format: "%02x", $0) }.joined().prefix(10)

        let cloudFilePath = cloudDirectory.appendingPathComponent("shishiVaultData/shishiDataAES_.json")
        let localFilePath = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("shishiVaultData/shishiDataAES_\(stringPrefix).json")

        do {
            if fileManager.fileExists(atPath: cloudFilePath.path) {
                try fileManager.copyItem(at: cloudFilePath, to: localFilePath)
                print("Daten erfolgreich wiederhergestellt.")
            } else {
                print("Keine Backup-Datei gefunden.")
            }
        } catch {
            print("Fehler beim Wiederherstellen: \(error)")
        }
    }

}
