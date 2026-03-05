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
    
}
