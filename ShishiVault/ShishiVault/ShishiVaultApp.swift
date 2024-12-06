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
                switch shishiViewModel.appState {
                    case .login:
                        SignInView()
                            .environmentObject(shishiViewModel)
                    case .pin:
                        PinView()
                            .environmentObject(shishiViewModel)
                    case .saltKey:
                        SetSaltKeyView(shishiViewModel: shishiViewModel)
                            .environmentObject(shishiViewModel)
                    case .home:
                        HomeView()
                            .environmentObject(shishiViewModel)
                }
            }
        }
    }
}
