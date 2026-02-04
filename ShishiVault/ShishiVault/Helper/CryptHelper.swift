import SwiftUI
import CryptoKit
import UniformTypeIdentifiers

class CryptHelper {
    static let shared = CryptHelper()
    private init() {}

    func copyToClipboard(input: String) throws {
        guard !input.isEmpty else {
            throw EncryptionError.emptyClipboard
        }
        let clipboard = UIPasteboard.general
        clipboard.string = input
    }

    func randomPasswordMaker() -> String {
        let length = 12
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%&()0123456789"
        var password = ""
        for _ in 0..<length {
            password.append(letters.randomElement()!)
        }
        return password
    }
    
    func generateSaltedHash(from userInput: String) throws -> Data {
        let hashedData = SHA256.hash(data: Data(userInput.utf8))
        return Data(hashedData)
    }
    
    func generateUserIDHash(from userID: String) throws -> Data {
        let hashedData = SHA256.hash(data: Data(userID.utf8))
        return Data(hashedData)
    }

    func encrypt(data: Data, key: SymmetricKey) throws -> Data {
        do {
            let blackBox = try AES.GCM.seal(data, using: key)
            guard let combined = blackBox.combined else {
                throw EncryptionError.encryptionFailed(reason: "Failed to combine ciphertext")
            }
            return combined
        } catch {
            throw EncryptionError.encryptionFailed(reason: error.localizedDescription)
        }
    }
    
    func decrypt(cipherText: Data, key: SymmetricKey) throws -> Data {
        do {
            let blackBox = try AES.GCM.SealedBox(combined: cipherText)
            return try AES.GCM.open(blackBox, using: key)
        } catch {
            throw EncryptionError.decryptionFailed(reason: error.localizedDescription)
        }
    }
}
