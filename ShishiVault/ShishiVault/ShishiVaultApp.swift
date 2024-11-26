//
//  ShishiVaultApp.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI

@main
struct ShishiVaultApp: App {
    @StateObject private var shishiViewModel = ShishiViewModel() // im Init wird der Status des Logins geprüft
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if shishiViewModel.isLoggedIn {
                    HomeView()
                        .environmentObject(shishiViewModel)
                } else {
                    SignInView()
                        .environmentObject(shishiViewModel)
                }
            }
        }
    }
}
