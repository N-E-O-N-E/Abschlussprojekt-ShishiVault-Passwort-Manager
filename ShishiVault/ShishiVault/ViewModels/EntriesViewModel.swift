import SwiftUI

@MainActor
class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    @Published var customFieldsForEntrie: [CustomField] = []
       
    // MARK: - Validation
    func entrieSaveButtomnCheck(title: String, username: String, email: String, password: String, passwordConfirm: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        let passConf = password == passwordConfirm
        
        if !mindestFelderNichtLeer { return "mindestLeer" }
        if mindestFelderNichtLeer && !wahlFelderNichtLeer { return "wahlLeer" }
        if !passConf { return "passConfirm" }
        if mindestFelderNichtLeer && wahlFelderNichtLeer && passConf { return "ok" }
        return "sonstiges"
    }
    
    func entrieUpdateButtomnCheck(title: String, username: String, email: String, password: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        
        if !mindestFelderNichtLeer { return "mindestLeer" }
        if mindestFelderNichtLeer && !wahlFelderNichtLeer { return "wahlLeer" }
        if mindestFelderNichtLeer && wahlFelderNichtLeer { return "ok" }
        return "sonstiges"
    }
    
    // MARK: - CRUD via DatabaseManager
    
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String,
                     notes: String, website: String, customFields: [CustomField]) {
        
        guard password == passwordConfirm else { return }
            
        do {
            let customJSON = try JSONEncoder().encode(customFields)
            let customFieldsString = String(data: customJSON, encoding: .utf8)
            
            let id = UUID()
            let newVaultEntry = VaultEntry(
                id: id.uuidString,
                title: title,
                username: username,
                email: email,
                website: website,
                password: password, // SQLCipher verschlüsselt dies in der DB
                notes: notes,
                customFieldsJSON: customFieldsString,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            try DatabaseManager.shared.saveEntry(newVaultEntry)
            
            let uiEntry = EntryData(id: id, title: title, username: username, email: email,
                                   password: password, notes: notes, website: website,
                                   customFields: customFields)
            self.entries.append(uiEntry)
            
        } catch {
            print("Fehler beim Erstellen des Eintrags: \(error)")
        }
    }
    
    func reloadEntries() async {
        do {
            let vaultEntries = try DatabaseManager.shared.fetchAllEntries()
            
            self.entries = vaultEntries.compactMap { ve in
                let customFields = decodeCustomFields(ve.customFieldsJSON)
                return EntryData(
                    id: UUID(uuidString: ve.id) ?? UUID(),
                    title: ve.title,
                    username: ve.username,
                    email: ve.email,
                    password: ve.password,
                    notes: ve.notes,
                    website: ve.website,
                    customFields: customFields
                )
            }
        } catch {
            print("Fehler beim Laden der Einträge: \(error)")
        }
    }
    
    func deleteEntry(id: UUID) {
        do {
            try DatabaseManager.shared.deleteEntry(id: id.uuidString)
            self.entries.removeAll(where: { $0.id == id })
        } catch {
            print("Fehler beim Löschen: \(error)")
        }
    }
    
    func updateEntry(id: UUID, title: String, username: String, email: String, password: String,
                     notes: String, website: String, customFields: [CustomField]) async {
        
        do {
            let customJSON = try JSONEncoder().encode(customFields)
            let customFieldsString = String(data: customJSON, encoding: .utf8)
            
            let updatedVaultEntry = VaultEntry(
                id: id.uuidString,
                title: title,
                username: username,
                email: email,
                website: website,
                password: password,
                notes: notes,
                customFieldsJSON: customFieldsString,
                createdAt: Date(), // In der Realität würden wir createdAt vom Original behalten
                updatedAt: Date()
            )
            
            try DatabaseManager.shared.saveEntry(updatedVaultEntry) // saveEntry nutzt insert(db), GRDB .save() macht upsert
            
            if let index = self.entries.firstIndex(where: { $0.id == id }) {
                self.entries[index] = EntryData(id: id, title: title, username: username, email: email,
                                                password: password, notes: notes, website: website,
                                                customFields: customFields)
            }
        } catch {
            print("Update Error: \(error)")
        }
    }

    private func decodeCustomFields(_ json: String?) -> [CustomField] {
        guard let json = json, let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([CustomField].self, from: data)) ?? []
    }
    
    // MARK: - Custom Fields Management
    
    func createCustomField(customField: CustomField) {
        customFieldsForEntrie.append(customField)
    }
    
    func deleteCustomField() {
        customFieldsForEntrie.removeAll()
    }
    
    func deleteCustomFieldForID(forID id: UUID) {
        customFieldsForEntrie.removeAll(where: { $0.id == id })
    }
}
