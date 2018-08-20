//
//  RegisterViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-09.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
    
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

class RegisterViewController: BaseViewController, UITextFieldDelegate {
    

    @IBOutlet var OneDigitTextField: UITextField!
    @IBOutlet var TwoDigitTextField: UITextField!
    @IBOutlet var ThreeDigitTextField: UITextField!
    @IBOutlet var FourDigitTextField: UITextField!
    @IBOutlet var FiveDigitTextField: UITextField!
    @IBOutlet var SixDigitTextField: UITextField!
    @IBOutlet var numberTextField: TextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var digitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Register OPEN")
        roundedCorners()
        
        hideshowDigitTextfields(ishidden: true)
        setupGradient(item: numberTextField, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: Int(numberTextField.bounds.height / 2))
        setupShadow(UIItem: numberTextField, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
        numberTextField.attributedPlaceholder = NSAttributedString(string: "(+46) xx-xxx xx xx", attributes:[NSAttributedStringKey.foregroundColor: hexStringToUIColor(hex: "FFFFFF")])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        SixDigitTextField.addTarget(self, action: #selector(lastDigitEntered), for: .editingDidEnd)
        
        templogin()
    }
    
    // Factories
    func templogin() {
        let phoneNumber = "+1 0123456789"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.doneButton.isUserInteractionEnabled = true
                self.numberTextField.isUserInteractionEnabled = true
                return
            }
            // Sign in using the verificationID and the code sent to the user
            let verificationCode = "123456"
            
            print(verificationCode)
            print(phoneNumber)
            print(verificationID!)
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            
            print("CREDENTIAL \(credential)")
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    return
                }
                // User is signed in
                SVProgressHUD.showSuccess(withStatus: "Klart!")
            }
        }
    }
    
    func roundedCorners() {
        OneDigitTextField.layer.cornerRadius = 4
        TwoDigitTextField.layer.cornerRadius = 4
        ThreeDigitTextField.layer.cornerRadius = 4
        FourDigitTextField.layer.cornerRadius = 4
        FiveDigitTextField.layer.cornerRadius = 4
        SixDigitTextField.layer.cornerRadius = 4
        numberTextField.layer.cornerRadius = 20
    }
    
    func hideshowDigitTextfields(ishidden: Bool) {
        OneDigitTextField.isHidden = ishidden
        TwoDigitTextField.isHidden = ishidden
        ThreeDigitTextField.isHidden = ishidden
        FourDigitTextField.isHidden = ishidden
        FiveDigitTextField.isHidden = ishidden
        SixDigitTextField.isHidden = ishidden
        digitLabel.isHidden = ishidden
    }
    
    // Keyboard delegate
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // ** FIRST STEP
    func SendSMS(completion: @escaping (Int) -> ()) {
        let phoneNumber = UserDefaults.standard.string(forKey: "number")!
        print(phoneNumber)
        SVProgressHUD.dismiss(withDelay: 5)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.doneButton.isUserInteractionEnabled = true
                self.numberTextField.isUserInteractionEnabled = true
                return
            }
            // Sign in using the verificationID and the code sent to the user
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(0)
        }
    }
    
    // ** SECOND STEP
    @IBAction func doneAction(_ sender: Any) {
        UserDefaults.standard.set(numberTextField.text!, forKey: "number")
        dismissKeyboard()
        SVProgressHUD.show(withStatus: "Verifierar mobilnummer")
        self.numberTextField.isUserInteractionEnabled = false
        self.doneButton.isUserInteractionEnabled = false
        self.SendSMS(completion: { (int) -> () in
            print("SMS sent! Moving on to the next step")
            self.numberTextField.isUserInteractionEnabled = false
            self.doneButton.isUserInteractionEnabled = false
            SVProgressHUD.showSuccess(withStatus: "Vänta på SMS med din 6-siffriga kod")
            self.hideshowDigitTextfields(ishidden: false)
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if (textField == numberTextField) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
         
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length >= 12 && !hasLeadingOne) || length > 12 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    
                return (newLength > 10) ? false : true
            }
            
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            
            if (length - index) > 2 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
                if decimalString.substring(from: 0).hasPrefix("07") == true {
                    formattedString.appendFormat("(+46) 7", areaCode)
                } else {
                    formattedString.appendFormat("(+%@) ", areaCode)
                }
                index += 2
            }
         
            if length - index > 2 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("%@-", prefix)
                index += 2
            }
            
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@ ", prefix)
                index += 3
            }
            
            if length - index > 2 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("%@ ", prefix)
                index += 2
            }
         
            if length - index > 2 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("%@ ", prefix)
                index += 2
            }
            
            let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
            
            return false
        } else if textField.text!.count < 1  && string.count > 0 {
            let nextTag = textField.tag + 1
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            
            if (nextResponder == nil){
                
                nextResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = string
            
            if (textField.text!.count > 0  && string.count > 0) && textField == textField.superview?.viewWithTag(6) {
                UserDefaults.standard.set(string, forKey: "lastDigit")
                dismissKeyboard()
            } else {
                nextResponder?.becomeFirstResponder()
            }
            
            return false
         } else if textField.text!.count >= 1  && string.count == 0{
            // on deleting value from Textfield
            dismissKeyboard()
            let previousTag = textField.tag - 1
            
            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
        }
        return true
        
    }
    
    @objc func lastDigitEntered() {
        dismissKeyboard()
        if OneDigitTextField.text?.isEmpty == false || TwoDigitTextField.text?.isEmpty == false || ThreeDigitTextField.text?.isEmpty == false || FourDigitTextField.text?.isEmpty == false || FiveDigitTextField.text?.isEmpty == false || SixDigitTextField.text?.isEmpty == false {
            
            SVProgressHUD.show(withStatus: "Kontrollerar verifieringskoden")
            
            print("All digits filled, moving on to next step!")
            
            UserDefaults.standard.set("\(OneDigitTextField.text!)\(TwoDigitTextField.text!)\(ThreeDigitTextField.text!)\(FourDigitTextField.text!)\(FiveDigitTextField.text!)\(SixDigitTextField.text!)", forKey: "digits")
            self.SignIn(completion: { (int) -> () in
                print("Done! User signed in, should segue to main ViewController now...")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "first")
                self.present(newViewController, animated: true, completion: nil)
            })
        }
    }
    
    // ** THIRD STEP
    func SignIn(completion: @escaping (Int) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        let verificationCode = UserDefaults.standard.string(forKey: "digits")!
        
        print(verificationCode)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        print("CREDENTIAL \(credential)")
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                return
            }
            // User is signed in
            SVProgressHUD.showSuccess(withStatus: "Klart!")
            completion(0)
        }
    }
}
