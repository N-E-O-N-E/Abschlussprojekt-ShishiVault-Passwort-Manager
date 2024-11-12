//
//  LoginTest.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    // Bindet das ViewModel zur Authentifizierung ein
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // SignIn Button (SignUp) > je nach LoginStatus wird dieser angezeigt
                if !signInViewModel.isLoggedIn {
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.fullName, .email] // Fordert Namen und die E-Mail-Adresse
                        request.requestedOperation = .operationLogin // Gibt an, dass der Anmeldevorgang ein Login-Vorgang ist
                    } onCompletion: { result in
                        signInViewModel.handleLogin(result: result)
                        // Wird ausgeführt, wenn der Anmeldevorgang abgeschlossen ist auch wenn er einen Fehle hat
                    }
                    .frame(height: 50)
                    .padding()
                } else {
                    Text("User angemeldet")
                }
            }
            .navigationDestination(isPresented: $signInViewModel.isLoggedIn) {
                ComponentsExampleView() // ist der LoginStatus true wird die View aufgerufen
                    .environmentObject(signInViewModel) // Hängt das ViewModel an die View
            }
        }
    }
}

#Preview {
    SignInView()
}
