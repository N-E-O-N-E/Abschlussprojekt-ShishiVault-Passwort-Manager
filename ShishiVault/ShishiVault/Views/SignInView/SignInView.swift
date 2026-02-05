import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isFirstRegistration = ArgonCryptoService.shared.isFirstStart
    
    var onUnlock: (VaultContext) -> Void
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                
                if isFirstRegistration {
                    registrationNotice
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(isFirstRegistration ? "Neues Masterpasswort setzen" : "Tresor entsperren")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SecureField("Masterpasswort", text: $password)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .disabled(isLoading)
                        .textContentType(.password)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .bold()
                    }
                    
                    Button(action: deriveKey) {
                        HStack {
                            Text(isFirstRegistration ? "Tresor sicher erstellen..." : "Entsperren")
                            if isLoading { ProgressView().tint(.white) }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading || password.isEmpty)
                }
                .padding(.horizontal, 40)
            }
        }
        
        
        // Fehler-Handling für falsches Passwort oder Crypto-Fehler
        .alert("Krypto-Fehler", isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Ein unbekannter Fehler ist aufgetreten.")
        }
        .onAppear {
            if let existingSalt = UserDefaults.standard.data(forKey: "user_salt") {
                print("Salt gespeichert: \(existingSalt.base64EncodedString())")
            }
        }
    }
    
    var registrationNotice: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Wichtiger Hinweis", systemImage: "shield.auth.titled.fill")
                .font(.headline)
            
            Text("Dies ist Ihre Erstanmeldung. Wir generieren einen einzigartigen **lokalen Salt**, der fest mit Ihrem Passwort verknüpft wird.")
                .font(.footnote)
            
            Text("Ohne Ihr Passwort und diesen Salt sind Ihre Daten **unwiderruflich verloren**. Es gibt keine 'Passwort vergessen' Funktion.")
                .font(.footnote).bold()
        }
        .padding()
        .background(Color.yellow.opacity(0.9))
        .cornerRadius(12)
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    
    private func deriveKey() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 1. Salt holen (immer dasselbe für diesen User)
            let salt = ArgonCryptoService.shared.getSalt()
            
            // 2. Key berechnen (geht immer, auch bei falschem PW)
            if let derivedKey = ArgonCryptoService.shared.deriveKey(password: password, salt: salt) {
                
                // 3. JETZT PRÜFEN: Passt der Key zum Schloss?
                let success = ArgonCryptoService.shared.checkMasterPassword(with: derivedKey)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if success {
                        // NUR HIER springen wir in die HomeView
                        onUnlock(VaultContext(loginKey: derivedKey))
                    } else {
                        // Hier bleiben wir im Login-Screen
                        self.errorMessage = "Falsches Masterpasswort. Zugriff verweigert."
                    }
                }
            }
        }
    }
}
