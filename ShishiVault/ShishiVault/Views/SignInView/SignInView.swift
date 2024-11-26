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
    @StateObject private var shishiViewModel = ShishiViewModel() // im Init wird der Status des Logins geprüft
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.ShishiColorRed_.ignoresSafeArea(.all)
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
                            shishiViewModel.configure(request: request)
                        },
                        onCompletion: { completion in
                            shishiViewModel.handleLogin(result: completion)
                        }
                    )
                    .frame(height: 50)
                    .padding()
                    
                    .navigationDestination(isPresented: $shishiViewModel.isLoggedIn) {
                        HomeView()
                            .environmentObject(shishiViewModel)
                    }
                }
            }
        }
    }
}
