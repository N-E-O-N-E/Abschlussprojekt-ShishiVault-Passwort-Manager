//
//  APIhaveibeenpwned.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 28.11.24.
//

import Foundation
import CryptoKit

final class APIhaveibeenpwned {
    
    func checkPasswordPwned(password: String) async throws {
        let passwordToData = password.data(using: .utf8)!
        let hashedPasswort = Insecure.SHA1.hash(data: passwordToData).map { String(format: "%02x", $0) }.joined()
        let hashedPasswortPrefix = hashedPasswort.dropFirst(5)
        
        let baseURL = "https://api.pwnedpasswords.com/range/"
        guard let url = URL(string: baseURL + hashedPasswortPrefix) else {
            throw APIError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let response = String(data: data, encoding: .utf8) else {
            throw APIError.invalidResponse
        }
        
        let rows = response.split(separator: "\n")
        
        for row in rows {
            if row.split(separator: ":").first == hashedPasswortPrefix {
                print(" !!!! Your Password has been pwned !!!! ")
            } else {
                print("Your Password is not pwned. You can continue using it.")
            }
        }
    }
}
