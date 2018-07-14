//
//  ListItemViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-14.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import Alamofire

class DetailItemViewController: UIViewController {
    
    var item: Item!
    
    private var items: [Item] = []
    
    var id: Int = Int()
    var name: String = String()
    var size: String = String()
    
    @IBOutlet var binButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(item)
        
        items = DataProvider.shared.allItems
        item = items[0]
        
        id = item.id
        name = item.name
        size = item.size
    }
    @IBAction func binAction(_ sender: Any) {
        ItemCheckoutChart.shared.addItem(item)
    }
    
}
