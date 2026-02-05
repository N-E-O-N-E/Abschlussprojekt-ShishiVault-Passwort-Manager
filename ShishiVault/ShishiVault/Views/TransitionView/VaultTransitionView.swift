import SwiftUI

struct VaultTransitionView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .tint(.white)
                .scaleEffect(1.5)
            
            Text("Sicherheits-Check...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ShishiColorRed_) // Dein Branding
        .onAppear {
            // Kurze Verzögerung für eine flüssige Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    shishiViewModel.appState = .login
                }
            }
        }
    }
}