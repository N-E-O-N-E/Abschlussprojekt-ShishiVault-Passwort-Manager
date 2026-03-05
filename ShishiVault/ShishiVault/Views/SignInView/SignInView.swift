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
            VStack(spacing: 25) {
                
                if isFirstRegistration {
                    registrationNotice
                }
                
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                    
                    Text(isFirstRegistration ? "Neues Masterpasswort setzen" : "Vault entsperren")
                    
                    PWLevelColorView(password: $password)
                    
                    SecureField("Masterpasswort", text: $password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                        
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.ShishiColorRed_)
                            .font(.caption)
                            .bold()
                    }
                    
                    Button(action: deriveKey) {
                        HStack(spacing: 10) {
                            Text(isFirstRegistration ? "Verschlüsselten Vault erstellen..." : "Vault entsperren")
                            
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity) // Macht ihn "flexible"
                        .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large) // Macht den Button schön "griffig"
                    .tint(Color.ShishiColorBlue) // Nutzt deine Markenfarbe
                    .disabled(isLoading || password.isEmpty)
                    
                    
                }
                .padding()
            }
        
        
        
        // Fehler-Handling für falsches Passwort oder Crypto-Fehler
        .alert("Passwort-Fehler", isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Es gab ein Problem mit dem Passwort!")
        }
        .onAppear {
            if let existingSalt = UserDefaults.standard.data(forKey: "user_salt") {
                print("Salt gefunden: \(existingSalt.base64EncodedString())")
            }
        }
    }
    
    var registrationNotice: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Wichtiger Hinweis")
                .font(.headline)
            
            Text("Dies ist Ihre Erstanmeldung. Wir generieren einen einzigartigen **lokalen Salt**, der fest mit Ihrem Passwort verknüpft wird.")
                .font(.footnote)
            
            Text("Ohne Ihr Passwort und diesen Salt sind Ihre Daten **unwiderruflich verloren**. Es gibt keine 'Passwort vergessen' Funktion.")
                .font(.footnote).bold()
        }
        .padding()
        .background(Color.ShishiColorRed.opacity(0.5))
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
                let success = ArgonCryptoService.shared.checkAppPassword(with: derivedKey)
                
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

#Preview {
    let mockViewModel = ShishiViewModel()
    SignInView(onUnlock: {_ in })
        .environmentObject(mockViewModel)
}
