//
//  CryptHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 19.11.24.
//

import SwiftUI
import CryptoKit
import UniformTypeIdentifiers

class CryptHelper {
    // Singleton-Instanz um global darauf zureifen zu können - privat initialisiert
    static let shared = CryptHelper()
    private init() {}
    
    // Fügt einen String in die Zwischenablage
    // Ouelle: https://stackoverflow.com/questions/61772282/swiftui-how-to-copy-text-to-clipboard
    func copyToClipboard(input: String) throws {
        guard !input.isEmpty else {
            throw EncryptionError.emptyClipboard
        }
        let clipboard = UIPasteboard.general
        clipboard.string = input
    }
    
    // Funktion zur erstellung eines zufälligen Passwortes
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
    
    // Erstellt ein SymetricKey auf Basis eines Strings der gehasht wird
    func createSymetricKey(from userID: String, userSalt: Data) throws -> SymmetricKey {
        guard !userID.isEmpty else {
            throw EncryptionError.emptyUserID
        }
        let hashedData = SHA256.hash(data: Data(userID.utf8))
        return SymmetricKey(data: Data(hashedData))
    }
    
    // Quelle: https://medium.com/@garg.vivek/a-comprehensive-guide-to-using-the-crypto-framework-with-swift-341a2ccfc08f
    // AES Verschlüsselung
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
    
    // AES Entschlüsselung
    func decrypt(cipherText: Data, key: SymmetricKey) throws -> Data {
        do {
            let blackBox = try AES.GCM.SealedBox(combined: cipherText)
            return try AES.GCM.open(blackBox, using: key)
        } catch {
            throw EncryptionError.decryptionFailed(reason: error.localizedDescription)
        }
    }
    
    //    let inputData = "Sensitive data".data(using: .utf8)!
    //    let key = SymmetricKey(size: .bits256)
    //    let encryptedData = try encryptData(data: inputData, key: key)
    //    let decryptedData = try decryptData(ciphertext: encryptedData, key: key)
    //    let decryptedString = String(data: decryptedData, encoding: .utf8)
    
}
