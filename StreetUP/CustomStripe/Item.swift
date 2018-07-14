//
//  Item.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-14.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import Foundation

struct Item: Codable {
    let id: Int
    let name: String
    let price: Int
    let photoUrl: URL
    let size: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case size = "size"
        case photoUrl = "photo_large"
    }
}

// MARK: - Equatable
extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
