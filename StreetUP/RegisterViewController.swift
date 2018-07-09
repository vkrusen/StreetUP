//
//  RegisterViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-09.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Auth(completion: { (int) -> () in
            // Done
        })
    }
    
    // Chceck if user has registered
    func Auth(completion: @escaping (Int) -> ()) {
        let phoneNumber = "+46735456702"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            completion(0)
        }
    }
    
}
