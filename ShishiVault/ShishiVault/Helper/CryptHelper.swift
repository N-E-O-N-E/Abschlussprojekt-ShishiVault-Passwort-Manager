//
//  CryptHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 19.11.24.
//

import SwiftUI
import CryptoKit

class CryptHelper {
    // Singleton-Instanz um global darauf zureifen zu können - privat initialisiert
    static let shared = CryptHelper()
    private init() {}
    
    enum EncryptionError: Error {
        case message(reason: String)
    }
    
    func createSymetricKey(from userID: String) -> SymmetricKey {
        let hashedData = SHA256.hash(data: Data(userID.utf8))
        return SymmetricKey(data: Data(hashedData))
    }
    
    // Quelle: https://medium.com/@garg.vivek/a-comprehensive-guide-to-using-the-crypto-framework-with-swift-341a2ccfc08f
    func encrypt(data: Data, key: SymmetricKey) throws -> Data {
        do {
            let blackBox = try AES.GCM.seal(data, using: key)
            guard let combined = blackBox.combined else {
                throw EncryptionError.message(reason: "Failed to combine ciphertext")
            }
            return combined
        } catch {
            throw EncryptionError.message(reason: error.localizedDescription)
        }
    }
    
    func decrypt(cipherText: Data, key: SymmetricKey) throws -> Data {
        do {
            let blackBox = try AES.GCM.SealedBox(combined: cipherText)
            return try AES.GCM.open(blackBox, using: key)
        } catch {
            throw EncryptionError.message(reason: error.localizedDescription)
        }
    }
    
    //    let inputData = "Sensitive data".data(using: .utf8)!
    //    let key = SymmetricKey(size: .bits256)
    
    //    let encryptedData = try encryptData(data: inputData, key: key)
    //    let decryptedData = try decryptData(ciphertext: encryptedData, key: key)
    //    let decryptedString = String(data: decryptedData, encoding: .utf8)
    
}
