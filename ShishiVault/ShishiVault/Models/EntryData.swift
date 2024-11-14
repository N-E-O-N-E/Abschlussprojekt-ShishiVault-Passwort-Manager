//
//  Item.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//
import Foundation
import SwiftData

// Standardfelder der APP zum Anlegen der Einträge und der Möglichkeit für individuelle Felder

struct EntryData: Identifiable {
    
    var id = UUID()
    var titel: String
    var username: String?
    var email: String
    var password: String
    var created: Date
    var notes: String?
    var website: String?
    var customFields: [CustomField] = []
    
    mutating func editCustomFieldName(id: UUID, newName: String) {
        if let result = customFields.firstIndex(where: { $0.id == id }) {
            customFields[result].name = newName
        }
    }
    
    // Mit dieser Funkto werden neue Einträge zu customFields hinzugefügt
    mutating func addCustomField(name: String, value: String) {
        customFields.append(CustomField(name: name, value: value))
    }
    
    // Mit dieser Funkto werden Einträge aus customFields gelöscht
    mutating func removeCustomField(id: UUID) {
        if let index = customFields.firstIndex(where: { $0.id == id }) {
            customFields.remove(at: index)
        }
    }
    
    struct CustomField: Identifiable {
        let id = UUID()
        var name: String
        var value: String
    }
}
