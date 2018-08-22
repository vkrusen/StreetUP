//
//  CardViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-08-20.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Stripe

class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class CardViewController: BaseViewController {
    
    @IBOutlet var cardNumberTextField: CustomTextField!
    @IBOutlet var MonthYearTextField: CustomTextField!
    @IBOutlet var CVCTextField: CustomTextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Betalnings metod"
        styleTextfield(textField: cardNumberTextField, label: "Kortnummer")
        styleTextfield(textField: MonthYearTextField, label: "MM/YY")
        styleTextfield(textField: CVCTextField, label: "CVC")
        
        setupGradient(item: nextButton, colors: [hexStringToUIColorWithAlpha(hex: "D0D1D0", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "B1B3B0", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "B1B3B0")
        nextButton.layer.cornerRadius = 7
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        // The following should happen when everything is verified
        setupGradient(item: nextButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
        nextButton.layer.cornerRadius = 7
        
        stripe()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Stripe
    func stripe() {
        let cardParams = STPCardParams()
            cardParams.name = "Victor Krusenstråhle" // Should be provided by textfield
            cardParams.number = "4242424242424242" // Should be provided by textfield
            cardParams.expMonth = 12 // Should be provided by textfield
            cardParams.expYear = 2018 // Should be provided by textfield
            cardParams.cvc = "123" // Should be provided by textfield
        
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                return
            }
            
            print(token)
            StripeClient.shared.completeCharge(with: token, amount: CheckoutCart.shared.total) { result in
                switch result {
                // 1
                case .success:
                    
                    let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Do this when user clicked "OK"- button
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseSuccessfulViewControllerId") as! PurchaseSuccessfulViewController
                        self.present(newViewController, animated: true, completion: nil)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                // 2
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // Factory
    func styleTextfield(textField: UITextField, label: String) {
        textField.layer.cornerRadius = 10
        textField.backgroundColor = hexStringToUIColor(hex: "F5F5F5")
        textField.placeholder = label
        textField.textColor = hexStringToUIColor(hex: "CCCCCC")
    }
}
