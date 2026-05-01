import Foundation
import GRDB

class DatabaseManager {
    static let shared = DatabaseManager()
    private var dbQueue: DatabaseQueue?
    
    private init() {}
    
    /// Initialisiert die verschlüsselte Datenbank
    /// - Parameter key: Der abgeleitete Master-Key (Argon2)
    func setupDatabase(with key: Data) throws {
        let fileManager = FileManager.default
        let appSupportURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbURL = appSupportURL.appendingPathComponent("shishivault.sqlite")
        
        // SQLCipher Konfiguration
        var config = Configuration()
        config.prepareDatabase { data in
            // Aktiviert SQLCipher mit dem Key
            let hexKey = key.map { String(format: "%02hhx", $0) }.joined()
            try data.usePassphrase(hexKey)
            // print("SQLCIPHER PASSWORT: \(hexKey)")
        }
        
        // Verbindung herstellen
        dbQueue = try DatabaseQueue(path: dbURL.path, configuration: config)
        
        // Migrationen ausführen
        try migrator.migrate(dbQueue!)
    }
    
    /// Datenbank-Migrator (für Schema-Updates und CloudKit-Vorbereitung)
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1_create_entries") { data in
            try data.create(table: "vaultEntry") { table in
                table.column("id", .text).primaryKey() // UUID als String für CloudKit
                table.column("title", .text).notNull()
                table.column("username", .text)
                table.column("email", .text).notNull()
                table.column("website", .text)
                table.column("password", .text).notNull() // SQLCipher verschlüsselt dies automatisch
                table.column("notes", .text)
                table.column("customFieldsJSON", .text) // Flexibilität für Zusatzfelder
                table.column("createdAt", .datetime).notNull()
                table.column("updatedAt", .datetime).notNull()
            }
        }
        
        return migrator
    }
    
    // MARK: - CRUD Operationen
    
    func saveEntry(_ entry: VaultEntry) throws {
        try dbQueue?.write { data in
            try entry.save(data)
        }
    }
    
    func fetchAllEntries() throws -> [VaultEntry] {
        guard let dbQueue = dbQueue else { return [] }
        return try dbQueue.read { data in
            try VaultEntry.fetchAll(data)
        }
    }
    
    func deleteEntry(id: String) throws {
        try dbQueue?.write { data in
            _ = try VaultEntry.deleteOne(data, key: id)
        }
    }
    
    /// Löscht die gesamte Datenbankdatei und schließt die Verbindung
    func resetDatabase() throws {
        dbQueue = nil
        let fileManager = FileManager.default
        let appSupportURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbURL = appSupportURL.appendingPathComponent("shishivault.sqlite")
        
        if fileManager.fileExists(atPath: dbURL.path) {
            try fileManager.removeItem(atPath: dbURL.path)
            print("Datenbankdatei gelöscht.")
        }
    }
}

// MARK: - Database Record
struct VaultEntry: Codable, FetchableRecord, PersistableRecord {
    let id: String
    var title: String
    var username: String?
    var email: String
    var website: String?
    var password: String
    var notes: String?
    var customFieldsJSON: String?
    let createdAt: Date
    var updatedAt: Date
    
    static var databaseTableName = "vaultEntry"
    
    enum CodingKeys: String, CodingKey {
        case id, title, username, email, website, password, notes, customFieldsJSON, createdAt, updatedAt
    }
    
    static var databaseSelection: [SQLSelectable] = [AllColumns()]
    
    static func primaryKey(_ data: Database) throws -> [String] {
        ["id"]
    }
}
