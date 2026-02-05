import SwiftUI

struct VaultTransitionView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea() // Hintergrundfarbe erzwingen
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Sicherheits-Check...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .onAppear {
            // Erhöhe die Zeit auf 1.5 Sekunden zum Testen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut) {
                    shishiViewModel.appState = .login
                }
            }
        }
    }
}
