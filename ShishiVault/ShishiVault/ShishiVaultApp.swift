//
//  ShishiVaultApp.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI

@main
struct ShishiVaultApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SignInView()
            }
        }
    }
}
