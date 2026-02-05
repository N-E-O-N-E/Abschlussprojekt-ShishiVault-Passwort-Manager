import Foundation

enum APIError: Error {
    case invalidUrl
    case dataNotFound
    case invalidResponse
}

enum AppState {
    case login
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
