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
        print("Auth OPEN")
        
        self.Auth(completion: { (int) -> () in
            // Done
            
            /*
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewControllerId") as! ViewController
            self.present(newViewController, animated: true, completion: nil)
            */
        })
    }
    
    // Chceck if user has registered
    func Auth(completion: @escaping (Int) -> ()) {
        completion(0)
    }
    
}
