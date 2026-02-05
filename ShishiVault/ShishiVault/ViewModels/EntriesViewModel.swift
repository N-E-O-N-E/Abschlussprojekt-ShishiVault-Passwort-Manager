import SwiftUI
import CryptoKit
import SwiftData

@MainActor
class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    @Published var customFieldsForEntrie: [CustomField] = []
       
    func entrieSaveButtomnCheck(title: String, username: String, email: String, password: String, passwordConfirm: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        let passConf = password == passwordConfirm
        
        if !mindestFelderNichtLeer {
            return "mindestLeer"
        }
        if mindestFelderNichtLeer && !wahlFelderNichtLeer {
            return "wahlLeer"
        }
        if !passConf {
            return "passConfirm"
        }
        if mindestFelderNichtLeer && wahlFelderNichtLeer && passConf {
            return "ok"
        }
        return "sonstiges"
    }
    
    func entrieUpdateButtomnCheck(title: String, username: String, email: String, password: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        
        if !mindestFelderNichtLeer {
            return "mindestLeer"
        }
        if mindestFelderNichtLeer && !wahlFelderNichtLeer {
            return "wahlLeer"
        }
        if mindestFelderNichtLeer && wahlFelderNichtLeer {
            return "ok"
        }
        return "sonstiges"
    }
    
    func createEntry(title: String, username: String, email: String, password: String,passwordConfirm: String,
                     notes: String, website: String, customFields: [CustomField],
                     modelContext: ModelContext, vaultContext: VaultContext) {
        
        let key = SymmetricKey(data: vaultContext.loginKey)
        
        guard password == passwordConfirm else {
            return print("Entrie has not been created. Password does not match")
        }
            
        do {
                // 1. Einzelne Felder verschlüsseln
                let encPass = try CryptHelper.shared.encrypt(data: Data(password.utf8), key: key)
                let encNotes = try CryptHelper.shared.encrypt(data: Data(notes.utf8), key: key)
                
                // 2. CustomFields (Array) in JSON umwandeln und DANN verschlüsseln
                let customJSON = try JSONEncoder().encode(customFields)
                let encCustom = try CryptHelper.shared.encrypt(data: customJSON, key: key)
                
                // 3. Das vollständige Modell für SwiftData erstellen
            let newModel = EntryModel(
                title: title,
                username: username,
                email: email,
                website: website,
                encryptedPassword: encPass,
                encryptedNotes: encNotes,
                encryptedCustomFields: encCustom
            )
                
                // 4. In die Datenbank schreiben
                modelContext.insert(newModel)
                try modelContext.save()
                
                // 5. UI-Liste & JSON-Backup synchronisieren
                let plainEntry = EntryData(id: newModel.id, title: title, username: username,
                                           email: email, password: password, notes: notes,
                                           website: website, customFields: customFields)
                self.entries.append(plainEntry)
                JSONHelper.shared.saveEntriesToJSON(key: key, entries: self.entries)
                
            } catch {
                print("Kritischer Fehler beim Speichern aller Felder: \(error)")
            }
    }
    
    func reloadEntries(modelContext: ModelContext, vaultContext: VaultContext) async {
        let descriptor = FetchDescriptor<EntryModel>(sortBy: [SortDescriptor(\.title)])
        
        do {
            let storedModels = try modelContext.fetch(descriptor)
            let key = SymmetricKey(data: vaultContext.loginKey)
            
            self.entries = storedModels.compactMap { model in
                decryptModel(model, using: key)
            }
            print("\(entries.count) Einträge aus SwiftData geladen.")
        }catch {
            print("Failed to fetch Entries: \(error)")
        }
    }
    
    func deleteEntry(id: UUID, modelContext: ModelContext, vaultContext: VaultContext) {
        let key = SymmetricKey(data: vaultContext.loginKey)
        let descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.id == id })
        
        do {
            if let model = try modelContext.fetch(descriptor).first {
                // 1. Aus SwiftData löschen
                modelContext.delete(model)
                try modelContext.save()
                
                // 2. Aus UI-Liste entfernen
                self.entries.removeAll(where: { $0.id == id })
                
                // 3. JSON-Backup synchronisieren
                JSONHelper.shared.saveEntriesToJSON(key: key, entries: self.entries)
            }
        } catch {
            print("Löschfehler: \(error)")
        }
    }
    
    private func decryptModel(_ model: EntryModel, using key: SymmetricKey) -> EntryData? {
        do {
            let passData = try CryptHelper.shared.decrypt(cipherText: model.encryptedPassword, key: key)
            let notesData = try CryptHelper.shared.decrypt(cipherText: model.encryptedNotes, key: key)
            let customData = try CryptHelper.shared.decrypt(cipherText: model.encryptedCustomFields, key: key)
            let customFields = try JSONDecoder().decode([CustomField].self, from: customData)
            
            return EntryData(
                id: model.id,
                title: model.title,
                username: model.username,
                email: model.email,
                password: String(data: passData, encoding: .utf8) ?? "",
                notes: String(data: notesData, encoding: .utf8),
                website: model.website,
                customFields: customFields
            )
        } catch {
            print("❌ Entschlüsselung fehlgeschlagen für: \(model.title)")
            return nil
        }
    }
    
    func updateEntry(id: UUID, title: String, username: String, email: String, password: String,
                     notes: String, website: String, customFields: [CustomField],
                     modelContext: ModelContext, vaultContext: VaultContext) async {
        
        let key = SymmetricKey(data: vaultContext.loginKey)
        
        // 1. Das bestehende Modell suchen
        let descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.id == id })
        
        do {
            if let model = try modelContext.fetch(descriptor).first {
                // 2. Felder aktualisieren
                model.title = title
                model.username = username
                model.email = email
                model.website = website
                model.created = Date() // Zeitstempel der Änderung
                
                // 3. Sensible Daten neu verschlüsseln
                model.encryptedPassword = try CryptHelper.shared.encrypt(data: Data(password.utf8), key: key)
                model.encryptedNotes = try CryptHelper.shared.encrypt(data: Data(notes.utf8), key: key)
                let customData = try JSONEncoder().encode(customFields)
                model.encryptedCustomFields = try CryptHelper.shared.encrypt(data: customData, key: key)
                
                try modelContext.save()
                if let index = self.entries.firstIndex(where: { $0.id == id }) {
                    self.entries[index] = EntryData(id: id, title: title, username: username, email: email,
                                                    password: password, notes: notes, website: website,
                                                    customFields: customFields)
                }
                
                // 4. JSON-Backup synchronisieren
                JSONHelper.shared.saveEntriesToJSON(key: key, entries: self.entries)
            }
        } catch {
            print("Update Error: \(error)")
        }
    }


    
    
    func createCustomField(customField: CustomField) {
        customFieldsForEntrie.append(customField)
        print("New CustomField with ID \(customField.id) added")
    }
    
    func deleteCustomField() {
        customFieldsForEntrie.removeAll()
        print("CustomFeld deleted")
    }
    
    func deleteCustomFieldForID(forID id: UUID) {
        customFieldsForEntrie.removeAll(where: { $0.id == id })
        print("CustomFeld for ID \(id.uuidString) deleted")
    }
}
