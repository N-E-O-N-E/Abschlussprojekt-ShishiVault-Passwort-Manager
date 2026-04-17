import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .home
    @Published var loginKey: Data?
    
    @AppStorage("useBiometry") var useBiometry: Bool = false
  
    func logout() {
        loginKey = nil
    }
    
    func toggleBiometry(enabled: Bool) {
        if enabled {
            // Speichere den aktuellen Key in der Keychain
            if let key = loginKey {
                try? SecurityManager.shared.saveAppKey(key)
                useBiometry = true
            }
        } else {
            // Lösche den Key aus der Keychain
            SecurityManager.shared.deleteMasterKey()
            useBiometry = false
        }
    }
    
    func performFullReset() {
        // 1. Keychain löschen
        SecurityManager.shared.deleteMasterKey()
        
        // 2. Datenbank löschen
        try? DatabaseManager.shared.resetDatabase()
        
        // 3. UserDefaults (Salt/Validator) löschen
        ArgonCryptoService.shared.clearAll()
        
        // 4. Logout & UI Reset
        loginKey = nil
        withAnimation {
            appState = .login
        }
    }
    
}
