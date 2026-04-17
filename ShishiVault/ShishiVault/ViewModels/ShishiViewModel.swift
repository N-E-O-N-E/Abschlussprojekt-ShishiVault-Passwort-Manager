import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .home
    @Published var loginKey: Data?
    
    @AppStorage("useBiometry") var useBiometry: Bool = false
    @AppStorage("isCloudSyncEnabled") var isCloudSyncEnabled: Bool = false
  
    func logout() {
        loginKey = nil
    }
    
    /// Startet oder stoppt die Cloud-Synchronisation
    func toggleCloudSync(enabled: Bool) {
        isCloudSyncEnabled = enabled
        if enabled {
            print("☁️ Cloud-Sync aktiviert.")
            // Hier könnte man einen initialen Upload aller lokalen Daten anstoßen
        }
    }
    
    /// Löscht alle Daten aus CloudKit
    func wipeCloudData() async {
        do {
            try await CloudKitManager.shared.wipeCloudDatabase()
            print("☁️ Cloud-Daten erfolgreich gelöscht.")
        } catch {
            print("❌ Fehler beim Löschen der Cloud-Daten: \(error)")
        }
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
