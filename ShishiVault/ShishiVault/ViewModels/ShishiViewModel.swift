import SwiftUI
import AuthenticationServices
import CryptoKit

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .login
    @Published var symmetricKeychainString: String = KeyChainKeys().symmetricKeychainString
    @Published var userSaltString: String = KeyChainKeys().userSaltString
    @Published var handleLoginFailure: Bool = false
    @Published var isLocked: Bool = false
    
    private let installHelper = InstallationHelper()
    private let keychainHelper = KeychainHelper.shared
    private let cryptHelper = CryptHelper.shared
    private var keychainUserIDHash: Data?
    private var keychainUserSaltHash: Data?
    
    init() {
        if installHelper.isFirstLaunch() {
            keychainHelper.delete(for: symmetricKeychainString)
            keychainHelper.delete(for: userSaltString)
            keychainHelper.delete(for: symmetricKeychainString)
        }
        
        if keychainHelper.readPin() != nil {
            isLocked = true
        } else {
            isLocked = false
        }
        checkLoginStatus()
    }
    
    func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let auth):
                if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                    handleSuccessfulLogin(with: appleIDCredential)
                    print("SignInWithAppleID successful!")
                }
            case .failure(let error):
                handleLoginFailure.toggle()
                handleLoginError(with: error)
        }
    }
    
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        do {
            let userID = credentials.user.replacingOccurrences(of: ".", with: "")
            let userIDHashed = try cryptHelper.generateUserIDHash(from: userID)
            self.keychainUserIDHash = userIDHashed
            
            if keychainUserSaltHash != nil {
                print("SaltKey found, symmetric key will be generated.")
                
                keychainHelper.saveCombinedSymmetricKeyInKeychain(
                    symmetricKey: keychainUserIDHash!,
                    userSaltKey: keychainUserSaltHash!,
                    keychainKey: symmetricKeychainString)
                appState = .home
            } else {
                print("SaltKey not found, no symmetric key will be generated.")
                appState = .saltKey
            }
        } catch {
            print("UserLogin cannot be completed: \(error.localizedDescription) ")
            appState = .login
        }
    }
    
    private func handleLoginError(with error: Error) {
        appState = .login
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    func saveTempUserSalt(data: Data) {
        keychainHelper.save(data: data, for: userSaltString)
        self.keychainUserSaltHash = data
        print("SaltData successful saved")
        
        if keychainUserIDHash != nil {
            keychainHelper.saveCombinedSymmetricKeyInKeychain(
                symmetricKey: keychainUserIDHash!,
                userSaltKey: keychainUserSaltHash!,
                keychainKey: symmetricKeychainString)
            
            print("Symmetric Key successfully saved")
            appState = .home
        } else {
            print("Cannont save Symmetric Key")
            appState = .login
        }
    }
    
    func checkLoginStatus() {
        if !isLocked {
            if keychainHelper.read(for: symmetricKeychainString) != nil &&
                keychainHelper.read(for: userSaltString) != nil {
                appState = .home
            } else {
                print("No Symmetric Key and SaltData found in Keychain")
                appState = .login
            }
        } else {
            appState = .pin
        }
    }
    
    func logout() {
        keychainHelper.delete(for: symmetricKeychainString)
        keychainHelper.delete(for: userSaltString)
        keychainUserIDHash = nil
        keychainUserSaltHash = nil
        
        print("Logout successful - KeyData deleted from Keychain!")
        appState = .login
    }
    
    func lockApp() {
        isLocked = true
        appState = .pin
    }
    
    func unlockApp(with pin: String) -> Bool {
        if let savedPIN = keychainHelper.readPin(), savedPIN == pin {
            isLocked = false
            appState = .home
            checkLoginStatus()
            return true
            
        } else {
            print("Falscher PIN!")
            return false
        }
    }
}
