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
}
