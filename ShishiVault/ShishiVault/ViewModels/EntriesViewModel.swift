//
//  EntriesViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.
//

import SwiftUI

class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    @Published var customFieldsForEntrie: [CustomField] = []
    @Published var customFieldsForEntrieToSave: [CustomField] = []
    
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
    
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) {
        guard password == passwordConfirm else {
            return print("Fehler beim angelegen der Daten")
        }
            
        let newEntrie = EntryData(title: title, username: username, email: email, password: password,
                                  notes: notes, website: website, customFields: customFields)
        entries.append(newEntrie)
    }
    
    func readEntry() {
        
    }
    
    func updateEntry() {
        
    }
    
    func deleteEntry(entrie: EntryData) {
        entries.removeAll(where: { $0.id == entrie.id })
        print("Der Eintrag wurde gelöscht")
    }
    
    // ------------------------------------------------------------------------------------
    
    func createCustomField(customField: CustomField) {
        customFieldsForEntrie.append(customField)
        print("Neues CustomFeld zwischengespeichert")
    }
    
    func editCustomField() {
        
    }
    
    func updateCustomField() {
        
    }
    
    func deleteCustomField() {
        customFieldsForEntrie.removeAll()
        print("CustomFeld gelöscht")
    }
    
    // -------------------------------------------------------------------------------------
    
    func createCustomFieldToSave() {
        customFieldsForEntrieToSave.append(contentsOf: customFieldsForEntrie)
        print("CustomFeld für Speichering in Eintrag zwischengespeichert")
    }
    
    func readCustomFieldToSave() {
        
    }
    
    func updateCustomFieldToSave() {
        
    }
    
    func deleteCustomFieldToSave() {
        customFieldsForEntrieToSave.removeAll()
        print("CustomFeld für Speichering in Eintrag gelöscht")
    }
    
    
}
