//
//  ItemCheckoutChart.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-14.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import Foundation

final class ItemCheckoutChart {
    
    static let shared = ItemCheckoutChart()
    
    private init() {
        // private
    }
    
    private var items: [Item] = []
    
    var cart: [Item] {
        return items
    }
    
    var canPay: Bool {
        return !items.isEmpty
    }
    
    var total: Int {
        return items.reduce(0) { (result, item) -> Int in
            return result + item.price
        }
    }
    
    func addItem(_ item: Item) {
        guard !items.contains(item) else {
            return
        }
        items.append(item)
    }
    
    func removeItem(_ item: Item) -> Bool {
        guard let index = items.index(of: item) else {
            return false
        }
        items.remove(at: index)
        return true
    }
    
}

