import Foundation

protocol KeyChainKeysProtocol {
    var symmetricKeychainString: String { get }
    var userSaltString: String { get }
}
