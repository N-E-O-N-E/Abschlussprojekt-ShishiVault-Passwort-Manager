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
    @Published var symetricKey: SymmetricKey?
    private let userIDKey: String = "userIDKey"
    
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
    
    // Speichert den Userkey in die Variable und setzt den LoginStatus auf true
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        // Speichern der ID
        KeychainHelper.shared.save(data: credentials.user, for: userIDKey)
        print("UserID saved in Keychain")
        // symetricKey = CryptHelper.shared.createSymetricKey(from: credentials.user)
        isLoggedIn = true
    }
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    // Prüft ob der Userkey in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    func checkLoginStatus() {
        // Auslesen der Dateb
        guard KeychainHelper.shared.read(for: userIDKey) != nil else {
            isLoggedIn = false
            return print("Check login status: No UserID in Keychain found!")
        }
        // Symetric KEy soeichern
        symetricKey = CryptHelper.shared.createSymetricKey(from: userIDKey)
        isLoggedIn = true
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        // Lösche die Daten
        KeychainHelper.shared.delete(for: userIDKey)
        isLoggedIn = false
        print("Logout successful")
    }

}
