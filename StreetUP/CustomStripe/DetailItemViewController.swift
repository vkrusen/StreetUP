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
    
    let settingsVC = SettingsViewController()
    
    private var items: [Item] = []
    
    var id: Int = Int()
    var name: String = String()
    var price: Int = Int()
    
    @IBOutlet var binButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(item)
        
        items = DataProvider.shared.allItems
        item = items[0]
        
        id = item.id
        name = item.name
        price = item.price
        
        self.navigationItem.title = "Emoji Apparel"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Products", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let theme = self.settingsVC.settings.theme
        self.view.backgroundColor = theme.primaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.accentColor
        let titleAttributes = [
            NSAttributedStringKey.foregroundColor: theme.primaryForegroundColor,
            NSAttributedStringKey.font: theme.font,
            ] as [NSAttributedStringKey : Any]
        let buttonAttributes = [
            NSAttributedStringKey.foregroundColor: theme.accentColor,
            NSAttributedStringKey.font: theme.font,
            ] as [NSAttributedStringKey : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
    }
    
    @objc func showSettings() {
        let navController = UINavigationController(rootViewController: settingsVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func binAction(_ sender: Any) {
        ItemCheckoutChart.shared.addItem(item)
        let checkoutViewController = CheckoutViewController(product: name,
                                                            price: price,
                                                            settings: self.settingsVC.settings)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
}
