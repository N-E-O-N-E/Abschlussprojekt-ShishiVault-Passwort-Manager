//
//  EntriesViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.
//

import SwiftUI

@MainActor
class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    
    init() {
        
    }
    
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
    
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) -> Bool {
        if password == passwordConfirm {
            let newEntrie = EntryData(title: title, username: username, email: email, password: password, customFields: customFields)
            entries.append(newEntrie)
            return true
        } else {
            return false
        }
        
    }
    
    func readEntry() {
        
    }
    
    func updateEntry() {
        
    }
    
    func deleteEntry() {
        
    }
    
    // ------------------------------------------------------------------------------------
    
    func createCustomField(id: UUID, name: String, value: String) {

    }
    
    func editCustomField() {
        
    }
    
    func updateCustomField() {
        
    }
    
    func deleteCustomField() {
        
    }
    
    
}
