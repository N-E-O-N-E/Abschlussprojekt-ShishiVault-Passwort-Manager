import SwiftUI


struct VaultTransitionView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.9)
            
            VStack(spacing: 20) {
                Image("ShishiLogo_600")
                    .resizable().scaledToFit().frame(width: 250).clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
                
                Text("Sicherheits-Check läuft...")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut) {
                    shishiViewModel.appState = .login
                }
            }
        }
    }
}

#Preview {
    let mockViewModel = ShishiViewModel()
    
    return VaultTransitionView()
        .environmentObject(mockViewModel)
}
