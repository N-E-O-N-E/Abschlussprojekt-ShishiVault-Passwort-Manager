//
//  SignInViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

// Quelle zur Umsetzung des SignInWithApple Buttons:
// https://www.youtube.com/watch?v=O2FVDzoAB34 - https://developer.apple.com/documentation/swift/result

@MainActor
class ShishiViewModel: ObservableObject {
    @Published var appState: AppState = .login
    @Published var symmetricKeychainString: String = "shishiVault_symm_key_data"
    @Published var userSaltString: String = "shishiVault_salt_input_data"
    
    private var keychainUserIDHash: Data?
    private var keychainUserSaltHash: Data?
    
    init() {
        checkLoginStatus()
    }
    
    // SignInWithAppleID Button Funktion (configure)
    func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email] // Fordert Namen und die E-Mail-Adresse
    }
    
    // SignInWithAppleID Button Funktion (handle)
    func handleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let auth):
                if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                    handleSuccessfulLogin(with: appleIDCredential)
                    print("SignInWithAppleID successful!")
                }
            case .failure(let error):
                handleLoginError(with: error)
        }
    }
      
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        do {
            let userID = credentials.user.replacingOccurrences(of: ".", with: "")
            let userIDHashed = try CryptHelper.shared.generateUserIDHash(from: userID)
            self.keychainUserIDHash = userIDHashed
            
            if keychainUserSaltHash != nil {
                print("SaltKey found, symmetric key will be generated.")
                
                KeychainHelper.shared.saveCombinedSymmetricKeyInKeychain(
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
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        appState = .login
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    func saveTempUserSalt(data: Data) {
        KeychainHelper.shared.save(data: data, for: userSaltString)
        self.keychainUserSaltHash = data
        print("SaltData successful saved")
        
        if keychainUserIDHash != nil {
            KeychainHelper.shared.saveCombinedSymmetricKeyInKeychain(
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
    
    // Prüft ob Daten in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    func checkLoginStatus() {
        if KeychainHelper.shared.read(for: symmetricKeychainString) != nil &&
            KeychainHelper.shared.read(for: userSaltString) != nil {
            print("Symmetric Key and SaltData found in Keychain)")
            appState = .home
        } else {
            print("No Symmetric Key and SaltData found in Keychain")
            appState = .login
        }
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        // KeychainHelper.shared.delete(for: symmetricKeyString)
        KeychainHelper.shared.delete(for: symmetricKeychainString)
        KeychainHelper.shared.delete(for: userSaltString)
        keychainUserIDHash = nil
        keychainUserSaltHash = nil

        print("Logout successful - KeyData deleted from Keychain!")
        appState = .login
    }

}
