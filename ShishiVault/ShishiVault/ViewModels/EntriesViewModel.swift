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
    @Published var customFieldsForEntrieToSave: [CustomField] = []
    
    private let jsonHelper = JSONHelper.shared
    private let key: SymmetricKey?
    
    init(key: SymmetricKey?) {
        self.key = key
        
        if let key = key {
            print("Key loaded \(key)")
        } else {
            print("Key not loaded")
        }
    }
    
    func reloadEntries() async {
        guard let key else { return }
        self.entries = await jsonHelper.loadEntriesFromJSON(key: key)
        print("Fetch data")
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
    
    // Erstellt ein Entrie
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) {
        guard password == passwordConfirm else {
            return print("Fehler beim angelegen der Daten")
        }
            
        let newEntrie = EntryData(title: title, username: username, email: email, password: password,
                                  notes: notes, website: website, customFields: customFields)
        entries.append(newEntrie)
    }
    
    // Löscht ein EntrieObjekt
    func deleteEntry(entrie: EntryData) {
        entries.removeAll(where: { $0.id == entrie.id })
        print("Der Eintrag wurde gelöscht")
    }
    
    // Erstellt ein CustomField für die Speicherung im Entrie
    func createCustomField(customField: CustomField) {
        customFieldsForEntrie.append(customField)
        print("Neues CustomFeld zwischengespeichert")
    }
    
    // Löscht ein Entrie aus der Liste
    func deleteCustomField() {
        customFieldsForEntrie.removeAll()
        print("CustomFeld gelöscht")
    }
    
    // Erstellt ein ZwischenArray an CustomFields zur temporären Weitergabe
    func createCustomFieldToSave() {
        customFieldsForEntrieToSave.append(contentsOf: customFieldsForEntrie)
        print("CustomFeld für Speichering in Eintrag zwischengespeichert")
    }
    
    // Löscht das ZwischenArray
    func deleteCustomFieldToSave() {
        customFieldsForEntrieToSave.removeAll()
        print("CustomFeld für Speichering in Eintrag gelöscht")
    }
    
}
