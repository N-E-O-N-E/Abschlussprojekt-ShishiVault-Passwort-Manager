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
    @StateObject private var shishiViewModel = ShishiViewModel()
    
    var body: some View {
        ZStack {
            Color.ShishiColorRed_.ignoresSafeArea()
            
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
