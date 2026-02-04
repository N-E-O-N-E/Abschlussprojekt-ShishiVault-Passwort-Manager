import SwiftUI
import CryptoKit

@MainActor
class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    @Published var customFieldsForEntrie: [CustomField] = []
    
    private let jsonHelper = JSONHelper.shared
    private let keychainHelper = KeychainHelper.shared
    private let keychainString: String?
    
    init(symmetricKeyString: String?) {
        self.keychainString = symmetricKeyString
    }
    
    func reloadEntries() async {
        guard let symmetricKeyString = keychainString,
              let symmetricKey = keychainHelper.loadCombinedSymmetricKeyFromKeychain(keychainKey: symmetricKeyString) else {
            print("Failed to reload entries. Symmetric key not found")
            return
        }
        self.entries = await jsonHelper.loadEntriesFromJSON(key: symmetricKey)
        print("\(entries.count) Entries from JSON reloaded")
    }
    
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
    
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) {
        guard password == passwordConfirm else {
            return print("Entrie has not been created. Password does not match")
        }
            
        let newEntrie = EntryData(title: title, username: username, email: email, password: password,
                                  notes: notes, website: website, customFields: customFields)
        entries.append(newEntrie)
    }
    
    func updateEntry(newEntrie: EntryData) {
        if let index = entries.firstIndex(where: { $0.id == newEntrie.id }) {
            entries[index] = newEntrie
            print("Entrie with ID \(newEntrie.id) updated")
        }
    }
    
    func deleteEntry(entrie: EntryData) {
        entries.removeAll(where: { $0.id == entrie.id })
        print("Entrie with ID \(entrie.id) deleted")
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
