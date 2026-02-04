import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea(.all)
            VStack {
                Image("ShishiLogo_600")
                    .resizable().scaledToFit().frame(width: 300).clipShape(RoundedRectangle(cornerRadius: 20))

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            shishiViewModel.configure(request: request)
                        },
                        onCompletion: { completion in
                            shishiViewModel.handleLogin(result: completion)
                        }
                    )
                    .frame(height: 50).padding()
            }
        }
        
        .alert("Probleme mit der Anmeldung\n", isPresented: $shishiViewModel.handleLoginFailure, actions: {
            Button("OK", role: .cancel) {}
        }, message: { Text("Die Anmeldung konnte nicht durchgeführt werden.\nBitte prüfen Sie die Anmeldedaten und die Verbindung zu dem Internet!") })
    }
}
