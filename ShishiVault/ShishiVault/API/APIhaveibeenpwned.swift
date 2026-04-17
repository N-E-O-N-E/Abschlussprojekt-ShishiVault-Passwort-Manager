import Foundation
import CryptoKit

final class APIhaveibeenpwned {
    
    func checkPasswordPwned(password: String) async throws -> Int {
       let sha1Password = Insecure.SHA1.hash(data: password.data(using: .utf8)!)
            .map { String(format: "%02x", $0) }.joined().uppercased()
        
        let sha1PasswortPrefix = sha1Password.prefix(5).uppercased()
        let sha1PasswortSuffix = sha1Password.suffix(sha1Password.count - 5)
        
        let urlString = "https://api.pwnedpasswords.com/range/\(sha1PasswortPrefix)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidUrl
        }
 
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = String(data: data, encoding: .utf8)!
        let splittedResponse = response.split(separator: "\r\n")
        
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
