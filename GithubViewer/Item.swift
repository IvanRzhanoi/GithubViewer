//
//  Item.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
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
