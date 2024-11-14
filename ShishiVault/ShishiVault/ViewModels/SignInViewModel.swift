//
//  SignInViewModel.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI
import AuthenticationServices

class SignInViewModel: ObservableObject {
    // Published Variable um die View zu Steuern
    @Published var isLoggedIn = false
    @Published var userNameKeyPublic = "userNameKeyPublic"
    private let userIDKey = "userIDKey"
    private let userNameKey = "userNameKey"
    
    init() {
        // initiale Statusabfrage
        print("Check login status - is actually: \(isLoggedIn)")
        checkLoginStatus()
        print("Check again login check - is now: \(isLoggedIn)")
        print(">>> Apple Username is: \(userNameKeyPublic)")
    }
    
    // Quelle zur Umsetzung des SignInWithApple Buttons: https://www.youtube.com/watch?v=O2FVDzoAB34
    
    // SignInWithAppleID Button Funktionen (configure und handle)
    func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email] // Fordert Namen und die E-Mail-Adresse
    }
    
    // Auswertung des Ergebnisses der Anmeldung
    func handleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let auth):
                print("Login successful \(auth)")
                if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                    handleSuccessfulLogin(with: appleIDCredential)
                }
            case .failure(let error):
                handleLoginError(with: error)
        }
    }
    
    // Speichert den Userkey in die Variable und setzt den LoginStatus auf true
    private func handleSuccessfulLogin(with credentials: ASAuthorizationAppleIDCredential) {
        print("Login successful")
        
        // Speichern der ID
        KeychainHelper.shared.save(data: credentials.user, for: userIDKey)
        print("Stored User ID: \(credentials.user) under key \(userIDKey)")
        
        // Speichern des Benutzernamens, falls vorhanden
        if let givenName = credentials.fullName?.givenName {
            print("Given name is available: \(givenName)")
            KeychainHelper.shared.save(data: givenName, for: userNameKey)
            print("Stored Username: \(givenName) under key \(userNameKey)")
        } else {
            print("Given name is nil, not stored.")
        }
        
        // Benutzernamen für die Anzeige laden in eine Publicvariable
        if let username = KeychainHelper.shared.read(for: userNameKey) {
            self.userNameKeyPublic = username
            print("Retrieved username for display: \(username)")
        } else {
            print("No username found for the key \(userNameKey).")
        }
        
        // Login-Status setzen
        isLoggedIn = true
    }
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    // Prüft ob der Userkey in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    private func checkLoginStatus() {
        if KeychainHelper.shared.read(for: userIDKey) != nil {
            isLoggedIn = true
            userNameKeyPublic = KeychainHelper.shared.read(for: userNameKey) ?? ""
        } else {
            isLoggedIn = false
        }
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        KeychainHelper.shared.delete(for: userIDKey)
        KeychainHelper.shared.delete(for: userNameKey)
        self.userNameKeyPublic = ""
        isLoggedIn = false
    }
    
    
}
