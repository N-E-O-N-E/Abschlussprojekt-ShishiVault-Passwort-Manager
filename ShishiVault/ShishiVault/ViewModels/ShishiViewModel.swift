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
    // Published Variable um die View zu Steuern
    @Published var isLoggedIn = false
    @Published var symmetricDataSaved = false
    @Published var saltDataIsSaved = false
    @Published var symmetricKeychainString: String = "shishiVault_symm_key_data"
    private var keychainUserIDString: Data?
    private var keychainUserSaltString: Data?
    
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
            self.keychainUserIDString = userIDHashed
            
            guard keychainUserIDString != nil, keychainUserSaltString != nil else {
                print("String UserID or UserSalt is nil in handleSuccessfulLogin")
                return
            }
            
            KeychainHelper.shared.saveCombinedSymmetricKeyInKeychain(
                symmetricKey: keychainUserIDString!,
                userSaltKey: keychainUserSaltString!,
                keychainKey: symmetricKeychainString)
            
            checkLoginStatus()
            
        } catch {
            print("Cannot create symetric key: \(error.localizedDescription)")
            isLoggedIn = false
        }
    }
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        isLoggedIn = false
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    func saveTempUserSalt(data: Data) {
        self.keychainUserSaltString = data
        saltDataIsSaved = true
    }
    
    // Prüft ob Daten in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    func checkLoginStatus() {
        
        if KeychainHelper.shared.read(for: symmetricKeychainString) != nil {
            if saltDataIsSaved {
                isLoggedIn = true
            } else {
                print("Check SaltData: No UserSalt in Keychain found!")
            }
        } else {
            print("Check login status: No SymmetricKey in Keychain found!")
        }
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        // KeychainHelper.shared.delete(for: symmetricKeyString)
        KeychainHelper.shared.delete(for: symmetricKeychainString)
        isLoggedIn = false
        print("Logout successful - Salt deleted from Keychain!")
    }

}
