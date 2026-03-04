import SwiftUI

@main
struct ShishiVaultApp: App {
    @StateObject private var shishiViewModel = ShishiViewModel()
    @StateObject private var entrieViewModel = EntriesViewModel()
    @Environment(\.scenePhase) var scenePhase
    @State private var isBlurred = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    switch shishiViewModel.appState {
                    case .login:
                        SignInView(onUnlock: { context in
                            self.shishiViewModel.loginKey = context.loginKey
                            
                            // 1. Key für FaceID speichern
                            try? SecurityManager.shared.saveAppKey(context.loginKey)
                            
                            // 2. SQLCipher Datenbank öffnen
                            do {
                                try DatabaseManager.shared.setupDatabase(with: context.loginKey)
                                withAnimation {
                                    shishiViewModel.appState = .home
                                }
                            } catch {
                                // Fehler beim Öffnen der DB (sollte bei korrektem Key nicht passieren)
                                print("DB Setup Error: \(error)")
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
                .blur(radius: isBlurred ? 20 : 0)
                .disabled(isBlurred)
                
                if isBlurred {
                    PrivacyOverlayView()
                        .transition(.opacity)
                }
            }
        }
        
        .onChange(of: scenePhase) { _, newPhase in
            handleScenePhaseChange(newPhase)
        }
    }
    
    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .inactive, .background:
            withAnimation { isBlurred = true }
        case .active:
            if isBlurred && shishiViewModel.loginKey != nil {
                // Versuche FaceID, wenn wir schon eingeloggt waren
                SecurityManager.shared.loadAppKey { result in
                    switch result {
                    case .success(let key):
                        // DB mit dem Key wieder öffnen/sicherstellen
                        try? DatabaseManager.shared.setupDatabase(with: key)
                        shishiViewModel.loginKey = key
                        withAnimation { isBlurred = false }
                    case .failure:
                        // Bei Fehler (z.B. Abbruch): Zurück zum Login
                        shishiViewModel.logout()
                        shishiViewModel.appState = .login
                        withAnimation { isBlurred = false }
                    }
                }
            } else {

                withAnimation { isBlurred = false }
            }
        @unknown default:
            break
        }
    }
}

struct PrivacyOverlayView: View {
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea()
            VStack(spacing: 20) {
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                Text("Tresor geschützt")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ProgressView()
                    .tint(.white)
            }
        }
    }
}
