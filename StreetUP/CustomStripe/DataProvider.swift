//
//  DataProvider.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-14.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import Foundation

final class DataProvider {
    
    static let shared = DataProvider()
    
    private init() {
        // private
    }
    
    var allItems: [Item] {
        guard let jsonData = read(from: "exampleItem") else {
            fatalError("The app cannot work without puppies")
        }
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode([Item].self, from: jsonData) else {
            fatalError("Invalid JSON data")
        }
        return decoded
    }
    
    var featuredItem: Item {
        let randomIndex = Int(arc4random_uniform(UInt32(allItems.count)))
        return allItems[randomIndex]
    }
    
    private func read(from path: String) -> Data? {
        guard let path = Bundle.main.path(forResource: path, ofType: "json") else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}

