import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .home
    @Published var loginKey: Data?
  
    func logout() {
        loginKey = nil
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
