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
    @Published var symmetricKeyString: String = "symmetricKey"
    
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
                print("Login successful!")
                if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                    handleSuccessfulLogin(with: appleIDCredential)
                }
            case .failure(let error):
                handleLoginError(with: error)
        }
    }
    
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        let userID = credentials.user.replacingOccurrences(of: ".", with: "")
        
        do {
            let symetricKey = try CryptHelper.shared.createSymetricKey(from: userID)
            KeychainHelper.shared.saveSymmetricKeyInKeychain(symmetricKey: symetricKey, keychainKey: symmetricKeyString)
            isLoggedIn = true
            
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
    
    // Prüft ob Daten in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    func checkLoginStatus() {
        guard KeychainHelper.shared.read(for: symmetricKeyString) != nil else {
            isLoggedIn = false
            return print("Check login status: No Data in Keychain found!")
        }
        isLoggedIn = true
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        KeychainHelper.shared.delete(for: symmetricKeyString)
        isLoggedIn = false
        print("Logout successful")
    }

}
