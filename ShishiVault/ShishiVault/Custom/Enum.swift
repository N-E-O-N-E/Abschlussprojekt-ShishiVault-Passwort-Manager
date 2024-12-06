//
//  API Error.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case dataNotFound
    case invalidResponse
}

enum AppState {
    case login
    case saltKey
    case home
}

enum NetworkState {
    case connected
    case disconnected
}

enum EncryptionError: Error {
    case emptyClipboard, emptyUserID,
         encryptionFailed(reason: String),
         decryptionFailed(reason: String)
}
