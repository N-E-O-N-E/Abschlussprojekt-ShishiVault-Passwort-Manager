//
//  ShishiVaultApp.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI

@main
struct ShishiVaultApp: App {
    // Instanz des ViewModels zur Authentifizierung
    @StateObject private var signInViewModel = ShishiViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SignInView()
                    .environmentObject(signInViewModel) // übergibt das ViewModel an die View(s)
            }
        }
    }
}
