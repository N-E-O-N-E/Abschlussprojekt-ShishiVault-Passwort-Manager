//
//  AppleUser.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 13.11.24.
//

import SwiftUI
import AuthenticationServices

struct AppleUser: Codable {
    
    let userId: String
    let firstName: String
    let lastName: String
    let email: String

    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstname = credentials.fullName?.givenName,
            let lastname = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstname
        self.lastName = lastname
        self.email = email
    }
}
