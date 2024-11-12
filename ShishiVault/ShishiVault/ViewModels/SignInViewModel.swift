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
    private let userKey = ""
    
    init() {
        //initiale Statusabfrage
        checkLoginStatus()
    }
    
    // Auswertung des Ergebnisses der Anmeldung
    func handleLogin(result: Result<ASAuthorization, Error>) {
        
        switch result {
            case .success(let authorization):
                handleSuccessfulLogin(with: authorization)
                isLoggedIn = true
                //print(userKey)
                
            case .failure(let error):
                handleLoginError(with: error)
        }
    }
    
    // Speichert den Userkey in die Variable und setzt den LoginStatus auf true
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            KeychainHelper.shared.save(data: userCredential.user, for: userKey)
            isLoggedIn = true
        }
    }
    
    // Printet ein Error aus
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
    
    // Prüft ob der Userkey in der Keychain vorhanden ist und nicht nil um den
    // LoginStatus beim start der App über den init() gleich auf true zu setzen
    private func checkLoginStatus() {
        if KeychainHelper.shared.read(for: userKey) != nil {
            isLoggedIn = true
        }
    }
    
    // Logout durch setzten des LoginStatus und löschen der Dateb aus der Keychain für den aktuelle UserKey
    func logout() {
        KeychainHelper.shared.delete(for: userKey)
        isLoggedIn = false
    }
    
    
}
