//
//  APIhaveibeenpwned.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 28.11.24.
//

import Foundation
import CryptoKit

final class APIhaveibeenpwned {
    
    func checkPasswordPwned(password: String) async throws -> Int {
        // Password wird ind SHA1 gehasht und über das .map wird jedes Element
        // iteriert und in eine Hex Zeichenkette umgewandelt
        let sha1Password = Insecure.SHA1.hash(data: password.data(using: .utf8)!)
            .map { String(format: "%02x", $0) }.joined().uppercased()
        // Prefix für den API Aufruf
        let sha1PasswortPrefix = sha1Password.prefix(5).uppercased()
        let sha1PasswortSuffix = sha1Password.suffix(sha1Password.count - 5)
        
        // Url zusammenstellung
        let urlString = "https://api.pwnedpasswords.com/range/\(sha1PasswortPrefix)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidUrl
        }
        
        // Liefert ein Datenobjekt welches über die URL zurückgeliefert wird
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Die Daten werden in einen String umgewandelt und am Ende gesplittet
        // \r\n signalisiert das Ende der ersten Zeile und den Beginn der nächsten
        let response = String(data: data, encoding: .utf8)!
        let splittedResponse = response.split(separator: "\r\n")
        
        // Es wird durch die String.Subsequenz iteriert und am : gesplittet
        // Dann wird geschaut on es zwei SplittParts gibt und ob der erste [0]
        // dem suffix des userpassworrtes entspricht
        for line in splittedResponse {
            let part = line.split(separator: ":")
            if part.count == 2, part[0] == sha1PasswortSuffix {
                let count = Int(part[1])!
                print("Warning - Password is pwned for \(count) times !!!")
                return 1
            }
        }
        print("Great - Password is not pwned")
        return 2
    }
}
