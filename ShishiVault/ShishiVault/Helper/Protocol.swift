//
//  Protocol.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 29.11.24.
//

import Foundation

protocol KeyChainKeysProtocol {
    var symmetricKeychainString: String { get }
    var userSaltString: String { get }
}
