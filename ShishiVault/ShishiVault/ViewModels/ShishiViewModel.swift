import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .home
    @Published var symmetricKeychainString: String = KeyChainKeys().symmetricKeychainString
    @Published var userSaltString: String = KeyChainKeys().userSaltString
    @Published var handleLoginFailure: Bool = false
    @Published var isLocked: Bool = false
    
    @Published var loginKey: Data?
    
    private let cryptHelper = CryptHelper.shared
    private var keychainUserIDHash: Data?
    private var keychainUserSaltHash: Data?
    
    init() {
        
    }
    
    func logout() {
        loginKey = nil
    }
    
}
