//
//  CardViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-08-20.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Stripe
import FormTextField
import SVProgressHUD

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

class CardViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var cardNameTextField: FormTextField!
    @IBOutlet var cardNumberTextField: FormTextField!
    @IBOutlet var MonthYearTextField: FormTextField!
    @IBOutlet var CVCTextField: FormTextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Betalnings metod"
        styleTextfield(textField: cardNameTextField, label: "Namn på kort")
        styleTextfield(textField: cardNumberTextField, label: "Kortnummer")
        styleTextfield(textField: MonthYearTextField, label: "Utgångsdatum (MM/YY)")
        styleTextfield(textField: CVCTextField, label: "CVC")
        
        setupGradient(item: nextButton, colors: [hexStringToUIColorWithAlpha(hex: "D0D1D0", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "B1B3B0", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "B1B3B0")
        nextButton.layer.cornerRadius = 7
        
        setupTextFields()
    }
    
    // TextField formatting
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            let maxLength = 19
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == MonthYearTextField {
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == CVCTextField {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
           return true
        }
    }
    
    func setupTextFields() {
        setupNumberTextField()
        setupMonthYearTextField()
        setupCVCTextField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupNumberTextField() {
        // CardNumber
        cardNumberTextField.inputType = .integer
        cardNumberTextField.formatter = CardNumberFormatter()
        cardNumberTextField.placeholder = "Kortnummer"
        
        var validation = Validation()
        validation.maximumLength = "1234 1234 1234 1234".count
        validation.minimumLength = "1234 1234 1234 1234".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        cardNumberTextField.inputValidator = inputValidator
    }
    
    func setupMonthYearTextField() {
        // MM/YY
        MonthYearTextField.inputType = .integer
        MonthYearTextField.formatter = CardExpirationDateFormatter()
        MonthYearTextField.placeholder = "Utgångsdatum (MM/YY)"
        
        var validation = Validation()
        validation.maximumLength = "MM/YY".count
        validation.minimumLength = "MM/YY".count
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        MonthYearTextField.inputValidator = inputValidator
    }
    
    func setupCVCTextField() {
        // CVC
        CVCTextField.inputType = .integer
        CVCTextField.placeholder = "CVC"
        
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        CVCTextField.inputValidator = inputValidator
    }
    
    // Other
    
    @IBAction func nextButtonAction(_ sender: Any) {
        // The following should happen when everything is verified
        setupGradient(item: nextButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
        nextButton.layer.cornerRadius = 7
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Kontrollerar kort")
        
        stripe()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Stripe
    func stripe() {
        let cardParams = STPCardParams()
            cardParams.name = cardNameTextField.text
            cardParams.number = cardNumberTextField.text
            cardParams.expMonth = 12 // Will be provided by textfield
            cardParams.expYear = 2018 // Will be provided by textfield
            cardParams.cvc = CVCTextField.text
        
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                SVProgressHUD.showError(withStatus: "Något gick snett, kontrollera att allt stämmer.")
                return
            }
            
            print(token)
            StripeClient.shared.completeCharge(with: token, amount: CheckoutCart.shared.total) { result in
                switch result {
                // 1
                case .success:
                    SVProgressHUD.showSuccess(withStatus: "Din betalning är bekräftad!")
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseSuccessfulViewControllerId") as! PurchaseSuccessfulViewController
                    self.present(newViewController, animated: true, completion: nil)
                    
                // 2
                case .failure(let error):
                    print(error)
                    SVProgressHUD.showError(withStatus: "\(error)")
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
