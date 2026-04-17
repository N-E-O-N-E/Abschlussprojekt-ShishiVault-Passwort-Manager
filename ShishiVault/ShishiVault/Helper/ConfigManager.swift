import Foundation

enum ConfigManager {
    /// Holt den Rapid-API Key aus der (lokalen/ignorierten) Secrets.swift Datei
    static var rapidAPIKey: String {
        return Secrets.rapidAPIKey
    }
}
