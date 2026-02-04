import SwiftUI

@main
struct ShishiVaultApp: App {
    @StateObject private var shishiViewModel = ShishiViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch shishiViewModel.appState {
                    case .login:
                        HomeView()
                            .environmentObject(shishiViewModel)
                    case .pin:
                        PinView()
                            .environmentObject(shishiViewModel)
                    case .saltKey:
                        SetSaltKeyView()
                            .environmentObject(shishiViewModel)
                    case .home:
                        HomeView()
                            .environmentObject(shishiViewModel)
                }
            }
        }
    }
}
