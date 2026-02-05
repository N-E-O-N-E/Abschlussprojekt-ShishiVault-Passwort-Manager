import Foundation
import Sodium

class ArgonCryptoService {
    static let shared = ArgonCryptoService()
    private let sodium = Sodium()
    
    private let opsLimit = 5
    private let memLimit = 128 * 1024 * 1024
    private let keyLength = 32
    
    func deriveKey(password: String, salt: String) -> Data? {
        guard let passwordBytes = password.bytes,
              let derivedKey = sodium.pwHash.hash(
                outputLength: keyLength,
                passwd: passwordBytes,
                salt: salt.bytes,
                opsLimit: opsLimit,
                memLimit: memLimit,
                algorithm: .argon2ID13
              ) else {
            return nil
        }
        return Data(derivedKey)
    }
    
    func generateRandomSalt() -> Data {
            return Data(sodium.randomBytes.buf(length: 16)!)
    }
}
