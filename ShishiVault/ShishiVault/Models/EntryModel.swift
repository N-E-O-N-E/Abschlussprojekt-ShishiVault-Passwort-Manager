import Foundation
import SwiftData

@Model
final class EntryModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var username: String?
    var email: String
    var website: String?
    var created: Date
    
    // Sensible Daten werden verschlüsselt gespeichert
    var encryptedPassword: Data
    var encryptedNotes: Data
    var encryptedCustomFields: Data // CustomFields als verschlüsseltes JSON
    
    init(id: UUID = UUID(),
         title: String,
         username: String?,
         email: String,
         website: String?,
         created: Date = Date(),
         encryptedPassword: Data,
         encryptedNotes: Data,
         encryptedCustomFields: Data) {
        self.id = id
        self.title = title
        self.username = username
        self.email = email
        self.website = website
        self.created = created
        self.encryptedPassword = encryptedPassword
        self.encryptedNotes = encryptedNotes
        self.encryptedCustomFields = encryptedCustomFields
    }
}
