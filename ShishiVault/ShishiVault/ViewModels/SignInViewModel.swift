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
        print("Check login status - is actually \(isLoggedIn)")
        checkLoginStatus()
        print("Check again login status - is now \(isLoggedIn)")
        print("UserKey is \(userNameKey)")
    }
    
    // SignInWithAppleID Button Funktionen (configure und handle)
    func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email] // Fordert Namen und die E-Mail-Adresse
    }
    
    // Auswertung des Ergebnisses der Anmeldung
    func handleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let auth):
                print(auth)
                switch auth.credential {
                    case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                        print(appleIdCredentials)
                        handleSuccessfulLogin(with: auth)
                    default:
                        print(auth.credential)
                }

            case .failure(let error):
                handleLoginError(with: error)
        }
    }
    
    // Speichert den Userkey in die Variable und setzt den LoginStatus auf true
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        print("Login successful")
        
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Speichert die Apple ID aus userCredentials
            KeychainHelper.shared.save(data: userCredential.user, for: userIDKey)
            print("Stored User ID: \(userCredential.user) under Key \(userIDKey)")
            
            // Speichert den Namen aus userCredentials
            if let getName = userCredential.fullName?.givenName {
                KeychainHelper.shared.save(data: getName, for: userNameKey)
                print("Stored Username: \(getName) under key \(userNameKey)")
            }
        }
        // Ließt den Namen aus und speichert ihn in eine Public Variable
        if let username = KeychainHelper.shared.read(for: userNameKey) {
            self.userNameKeyPublic = username  // wird in die @Published Variable gespeichert
            print("Retrieved username: \(username)")
        } else {
            print("No username found for the key.")
        }
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
        } else {
            isLoggedIn = false
        }
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        KeychainHelper.shared.delete(for: userIDKey)
        isLoggedIn = false
    }
    
    
}
