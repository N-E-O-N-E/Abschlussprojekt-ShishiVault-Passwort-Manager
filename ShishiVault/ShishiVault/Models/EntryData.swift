//
//  Item.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//
import Foundation

// Standardfelder der APP zum Anlegen der Einträge und der Möglichkeit für individuelle Felder

struct EntryData: Identifiable, Codable {
    
    var id: UUID
    var title: String
    var username: String?
    var email: String
    var password: String
    var created: Date
    var notes: String?
    var website: String?
    var customFields: [CustomField] = []
    
    init(title: String, username: String? = nil, email: String, password: String, notes: String? = nil, website: String? = nil, customFields: [CustomField] = []) {
        self.id = UUID()
        self.title = title
        self.username = username
        self.email = email
        self.password = password
        self.created = Date()
        self.notes = notes
        self.website = website
        self.customFields = customFields
    }
    
    
}

struct CustomField: Identifiable, Codable {
    var id = UUID()
    var name: String
    var value: String
}
