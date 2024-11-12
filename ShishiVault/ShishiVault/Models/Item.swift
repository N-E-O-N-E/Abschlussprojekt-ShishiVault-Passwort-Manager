//
//  Item.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
