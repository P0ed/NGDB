//
//  Item.swift
//  NGDB
//
//  Created by Konstantin Sukharev on 09.03.26.
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
