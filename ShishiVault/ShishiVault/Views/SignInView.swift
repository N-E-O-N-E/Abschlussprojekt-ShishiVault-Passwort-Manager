//
//  LoginTest.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI
import AuthenticationServices

// Quellen für die Umsetzung: https://developer.apple.com/documentation/authenticationservices/signinwithapplebutton
// Quellen für die Umsetzung: https://developer.apple.com/documentation/authenticationservices/signinwithapplebutton/init(_:onrequest:oncompletion:)


struct SignInView: View {
    // Bindet das ViewModel zur Authentifizierung ein
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed.ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    
                    Image("ShishiLogo_600")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // SignIn Button (SignUp) > je nach LoginStatus wird dieser angezeigt
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            Task {
                                await signInViewModel.configure(request: request)
                            }
                        },
                        onCompletion: { completion in
                            Task {
                                await signInViewModel.handleLogin(result: completion)
                            }
                        }
                    )
                    .frame(height: 50)
                    .padding()
                    
                    .navigationDestination(isPresented: $signInViewModel.isLoggedIn) {
                        ComponentsExampleView() // ist der LoginStatus true wird die View aufgerufen
                            .environmentObject(signInViewModel) // Hängt das ViewModel an die View
                    }
                }
            }
        }
    }
}


#Preview {
    SignInView()
}
