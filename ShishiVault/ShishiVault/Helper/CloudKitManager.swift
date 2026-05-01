import Foundation
import CloudKit
import Combine

class CloudKitManager: ObservableObject {
    static let shared = CloudKitManager()
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase
    
    private let recordType = "VaultEntry"
    
    private init() {}
    
    /// Speichert oder aktualisiert einen Eintrag in CloudKit
    func saveToCloud(entry: VaultEntry) async throws {
        let recordID = CKRecord.ID(recordName: entry.id)
        
        do {
            // Versuchen, den existierenden Record zu laden (für Update)
            let record: CKRecord
            do {
                record = try await privateDatabase.record(for: recordID)
            } catch {
                record = CKRecord(recordType: recordType, recordID: recordID)
            }
            
            // Felder setzen
            record["title"] = entry.title as CKRecordValue
            record["username"] = (entry.username ?? "") as CKRecordValue
            record["email"] = entry.email as CKRecordValue
            record["website"] = (entry.website ?? "") as CKRecordValue
            record["password"] = entry.password as CKRecordValue
            record["notes"] = (entry.notes ?? "") as CKRecordValue
            record["customFieldsJSON"] = (entry.customFieldsJSON ?? "") as CKRecordValue
            record["updatedAt"] = entry.updatedAt as CKRecordValue
            
            try await privateDatabase.save(record)
            print("CloudKit: Eintrag '\(entry.title)' erfolgreich synchronisiert.")
        } catch let error as CKError {
            handleCloudKitError(error, operation: "Speichern")
            throw error
        } catch {
            print("Unbekannter CloudKit Fehler beim Speichern: \(error)")
            throw error
        }
    }
    
    /// Löscht einen einzelnen Eintrag aus CloudKit
    func deleteFromCloud(id: String) async throws {
        let recordID = CKRecord.ID(recordName: id)
        do {
            try await privateDatabase.deleteRecord(withID: recordID)
            print("CloudKit: Eintrag \(id) gelöscht.")
        } catch let error as CKError {
            handleCloudKitError(error, operation: "Löschen")
        } catch {
            print("Unbekannter Fehler beim Löschen aus der Cloud.")
        }
    }
    
    private func handleCloudKitError(_ error: CKError, operation: String) {
        switch error.code {
        case .notAuthenticated:
            print("Fehler (\(operation)): Nutzer ist nicht bei iCloud angemeldet.")
        case .networkUnavailable, .networkFailure:
            print("Fehler (\(operation)): Keine Netzwerkverbindung.")
        case .quotaExceeded:
            print("Fehler (\(operation)): iCloud Speicher ist voll.")
        case .permissionFailure:
            print("Fehler (\(operation)): Berechtigung verweigert. Prüfe deine CloudKit-Container ID.")
        default:
            print("CloudKit Fehler (\(operation)): \(error.localizedDescription) (Code: \(error.code.rawValue))")
        }
    }
    
    /// Löscht ALLES aus der Cloud Datenbank
    func wipeCloudDatabase() async throws {
        // Da es in CloudKit kein "Delete All" für Privat-DBs gibt, müssen wir alle IDs holen und löschen
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        // 1. Alle Rekord-IDs finden
        let (results, _) = try await privateDatabase.records(matching: query)
        let recordIDs = results.map { $0.0 }
        
        guard !recordIDs.isEmpty else { return }
        
        // 2. Alle Rekords löschen (Modernes Async API ab iOS 15)
        _ = try await privateDatabase.modifyRecords(saving: [], deleting: recordIDs)
        print("Datenbank-Wipe abgeschlossen.")
    }
    
    /// Überprüft, ob CloudKit verfügbar ist (iCloud Login)
    func checkAccountStatus() async -> CKAccountStatus {
        do {
            return try await container.accountStatus()
        } catch {
            print("CloudKit Status Fehler: \(error)")
            return .couldNotDetermine
        }
    }
}
