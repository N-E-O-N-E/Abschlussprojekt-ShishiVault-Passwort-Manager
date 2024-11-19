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
class SignInViewModel: ObservableObject {
    // Published Variable um die View zu Steuern
    @Published var isLoggedIn = false
    @Published var userNameKeyPublic = "userNameKeyPublic"
    @Published var userKeyPublic = "userKeyPublic"
    @Published var userKeyPublicHashed = "userKeyPublicHashed"
    
    private var userIDKey = "userIDKey"
    private var userIDKeyHashed = "userIDKeyHashed"
    private var userNameKey = "userNameKey"
    
    init() {
        checkLoginStatus()
        print("Login Status: \(isLoggedIn)")
        print("Apple UserName: \(userNameKeyPublic)")
        print("Hashed Key: \(userKeyPublicHashed)")
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
                }
            case .failure(let error):
                handleLoginError(with: error)
        }
    }
    
    // Speichert den Userkey in die Variable und setzt den LoginStatus auf true
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        // Speichern der ID
        KeychainHelper.shared.save(data: credentials.user, for: userIDKey)
        userKeyPublicHashed = HashHelper.shared.hashData(key: userIDKey)
        
        // Speichern des Benutzernamens, falls vorhanden
        if let givenName = credentials.fullName?.givenName {
            KeychainHelper.shared.save(data: givenName, for: userNameKey)
            print("Stored Username: \(givenName) under key \(userNameKey)")
        } else {
            print("Given name is nil, not stored.")
        }
        // Login-Status setzen
        isLoggedIn = true
    }
    
    // Prüft ob der Userkey in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    private func checkLoginStatus() {
        if KeychainHelper.shared.read(for: userIDKey) != nil &&
            KeychainHelper.shared.read(for: userNameKey) != nil {
            
            isLoggedIn = true
            
            if let getKeyForPublic = KeychainHelper.shared.read(for: userIDKey) {
                userKeyPublic = getKeyForPublic
                print("Public Key: \(userKeyPublic)")
            }
                
            if let getNameForPublic = KeychainHelper.shared.read(for: userNameKey) {
                userNameKeyPublic = getNameForPublic
                print("Public Name: \(userNameKeyPublic)")
            }
            
        } else {
            isLoggedIn = false
        }
    }
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    // Logout durch setzten des LoginStatus und löschen der Daten aus der Keychain für den aktuelle UserKey
    func logout() {
        KeychainHelper.shared.delete(for: userIDKey)
        KeychainHelper.shared.delete(for: userNameKey)
        self.userNameKeyPublic = ""
        isLoggedIn = false
    }
    
}
