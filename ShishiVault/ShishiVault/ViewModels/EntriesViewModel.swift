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
    @Published var customFields: [CustomField] = []
    
    init() {
        
    }
    
    func createEntry(title: String, username: String, email: String, password: String, passwordConfirm: String, notes: String, website: String, customFields: [CustomField]) -> Bool {
        if password == passwordConfirm {
            entries.append(EntryData(title: title, username: username, email: email, password: password, customFields: customFields))
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
    
    func createCustomField() {
        
    }
    
    func editCustomField() {
        
    }
    
    func updateCustomField() {
        
    }
    
    func deleteCustomField() {
        
    }
    
    
}
