//
//  HashHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 19.11.24.
//

import Foundation
import CryptoKit


class HashHelper {
    static let shared = HashHelper()
    
    func hashData(key: String) -> String {
        let keyToData = Data(key.utf8)
        let hashedData = SHA256.hash(data: keyToData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
}
