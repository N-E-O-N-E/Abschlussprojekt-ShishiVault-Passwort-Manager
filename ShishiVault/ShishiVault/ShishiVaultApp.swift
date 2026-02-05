import SwiftUI
import SwiftData

@main
struct ShishiVaultApp: App {
    @StateObject private var shishiViewModel = ShishiViewModel()
    @StateObject private var entrieViewModel = EntriesViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    
    
    var body: some Scene {
        WindowGroup {
                switch shishiViewModel.appState {
                case .login:
                    SignInView(onUnlock: { context in
                        self.shishiViewModel.loginKey = context.loginKey
                        withAnimation {
                            shishiViewModel.appState = .home
                        }
                    })
                    .environmentObject(shishiViewModel)
                case .home:
                    if let key = shishiViewModel.loginKey {
                        NavigationStack {
                            HomeView(vaultContext: .init(loginKey: key))
                                .environmentObject(shishiViewModel)
                                .environmentObject(entrieViewModel)
                        }
                    } else {
                        VaultTransitionView()
                            .environmentObject(shishiViewModel)
                    }
                }
        }
        .modelContainer(for: EntryModel.self)
        
        .onChange(of: scenePhase) { newPhase, _ in
            if newPhase == .inactive || newPhase == .background {
                shishiViewModel.loginKey = nil
                shishiViewModel.appState = .login
            }
        }
    }
}
