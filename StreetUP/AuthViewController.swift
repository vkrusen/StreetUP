//
//  AuthViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-07.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Auth(completion: { (int) -> () in
            // Done
        })
    }
    
    func Auth(completion: @escaping (Int) -> ()) {
        completion(0)
    }
    
}
