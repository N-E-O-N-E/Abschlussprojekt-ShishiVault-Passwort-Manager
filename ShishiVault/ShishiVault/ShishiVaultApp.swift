//
//  ShishiVaultApp.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI
import SwiftData

@main
struct ShishiVaultApp: App {
    // Instanz des ViewModels zur Authentifizierung
    @StateObject private var signInViewModel = SignInViewModel()
    
    // Anlegen eines ModelContainers mit einer Configuration und Fehlerabfang
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([EntryData.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SignInView()
            }
            .environmentObject(signInViewModel) // übergibt das ViewModel an die View(s)
            .environment(\.modelContext, sharedModelContainer.mainContext) // übergibt den ModelContainer
        }
    }
}
