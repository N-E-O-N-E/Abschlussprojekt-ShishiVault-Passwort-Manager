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
