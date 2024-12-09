//
//  LoginTest.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI
import AuthenticationServices

// Quellen für die Umsetzung: https://developer.apple.com/documentation/authenticationservices/signinwithapplebutton
// Quellen für die Umsetzung: https://www.createwithswift.com/sign-in-with-apple-on-a-swiftui-application/

struct SignInView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea(.all)
            VStack {
                Image("ShishiLogo_600")
                    .resizable().scaledToFit().frame(width: 300).clipShape(RoundedRectangle(cornerRadius: 20))
                
                // SignIn Button (SignUp) > je nach LoginStatus wird dieser angezeigt
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
