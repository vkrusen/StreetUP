//
//  PurchaseSuccessfulViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-08-20.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Stripe

class PurchaseSuccessfulViewController: BaseViewController {
    
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genomfört"
        setupGradient(item: sendButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: sendButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
        sendButton.layer.cornerRadius = 7
    }
    
    @IBAction func sendAction(_ sender: Any) {
    }
    
    @IBAction func dismiss(_ sender: Any) {
    }
    
}
