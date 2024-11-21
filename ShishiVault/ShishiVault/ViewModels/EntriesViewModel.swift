//
//  EntriesViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.
//

import SwiftUI
import CryptoKit

@MainActor
class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    @Published var customFieldsForEntrie: [CustomField] = []
    
    private let jsonHelper = JSONHelper.shared
    private let key: SymmetricKey?
    
    init(key: SymmetricKey?) {
        self.key = key
        
        if let key = key {
            print("SymmetricKey loaded \(key)")
        } else {
            print("SymmetricKey not loaded")
        }
    }
    
    func reloadEntries() async {
        guard let key else { return }
        self.entries = await jsonHelper.loadEntriesFromJSON(key: key)
        print("Entries reloaded")
    }
    
    // Prüft ob die mindestFelder und eins der optionalen Felder ausgefüllt sind und den PasswortConfirm
    func entrieSaveButtomnCheck(title: String, username: String, email: String, password: String, passwordConfirm: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        let passConf = password == passwordConfirm
        
        // sind wahlfelder leer
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
    
    // Prüft ob die mindestFelder und eins der optionalen Felder ausgefüllt
    func entrieUpdateButtomnCheck(title: String, username: String, email: String, password: String) -> String {
        let mindestFelderNichtLeer = !title.isEmpty && !password.isEmpty
        let wahlFelderNichtLeer = (!username.isEmpty || !email.isEmpty)
        
        // sind wahlfelder leer
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
    
    
    // Erstellt ein Entrie
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) {
        guard password == passwordConfirm else {
            return print("Entrie has not been created. Password does not match")
        }
            
        let newEntrie = EntryData(title: title, username: username, email: email, password: password,
                                  notes: notes, website: website, customFields: customFields)
        entries.append(newEntrie)
    }
    
    // Updatet ein Entrie
    func updateEntry(newEntrie: EntryData) {
        if let index = entries.firstIndex(where: { $0.id == newEntrie.id }) {
            entries[index] = newEntrie
            print("Entrie updated")
        }
    }
    
    // Löscht ein EntrieObjekt
    func deleteEntry(entrie: EntryData) {
        entries.removeAll(where: { $0.id == entrie.id })
        print("Entrie deleted")
    }
    
    
    
    // Erstellt ein CustomField für die Speicherung im Entrie
    func createCustomField(customField: CustomField) {
        customFieldsForEntrie.append(customField)
        print("New CustomField added")
    }
    
    // Löscht ein Entrie aus der Liste
    func deleteCustomField() {
        customFieldsForEntrie.removeAll()
        print("CustomFeld deleted")
    }
    
}
