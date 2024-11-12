//
//  Item.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//
import Foundation
import SwiftData

// Standardfelder der APP zum Anlegen der Einträge und der Möglichkeit für individuelle Felder

@Model
class EntryData: Identifiable {
    var id: UUID
    var titel: String
    var username: String
    var password: String
    var website: String
    var notes: String
    var created: Date
    
    
    // Feld für die Speicherung der Custom-Fields (!) -> für JSON speicherung anpassen nicht vergessen!
    var customFields: [CustomField] = []
    
    init(id: UUID = UUID(), titel: String, username: String, password: String, website: String, notes: String, created: Date = Date()) {
        self.id = id
        self.titel = titel
        self.username = username
        self.password = password
        self.website = website
        self.notes = notes
        self.created = created
    }
    
    // Mit dieser Funkto werden neue Einträge zu customFields hinzugefügt
    func addCustomField(name: String, value: String) {
        let field = CustomField(name: name, value: value)
        customFields.append(field)
    }
    
    // Mit dieser Funkto werden Einträge aus customFields gelöscht
    func removeCustomField(field: CustomField) {
        if let index = customFields.firstIndex(where: { $0.id == field.id }) {
            customFields.remove(at: index)
        }
    }
}

// Hilfsklasse zum Anlegen neuer Felder -> Codable da diese Daten später in JSON gespeichert werden müssen
class CustomField: Identifiable, Codable {
    var id: UUID
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.id = UUID()
        self.name = name
        self.value = value
    }
}
