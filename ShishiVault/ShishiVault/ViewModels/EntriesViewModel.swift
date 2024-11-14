//
//  EntriesViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.
//

import SwiftUI

class EntriesViewModel: ObservableObject {
    @Published var entries: [EntryData] = []
    
    init() {
        
    }
    
    func addEntry(titel: String, username: String?, email: String, password: String, notes: String?, website: String?, customFields: [EntryData.CustomField]) {
        let newEntry = EntryData(titel: titel, username: username, email: email, password: password, created: Date(), notes: notes, website: website, customFields: customFields)
        entries.append(newEntry)
        saveEntryInJSON()
    }
    
    func saveEntryInJSON() {
        let encoder = JSONEncoder()
        
    }
    
    func loadEntriesFromJSON() {
        
    }
    
    
    
    
}
