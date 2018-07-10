//
//  RegisterViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-07-09.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Firebase

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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var OneDigitTextField: UITextField!
    @IBOutlet var TwoDigitTextField: UITextField!
    @IBOutlet var ThreeDigitTextField: UITextField!
    @IBOutlet var FourDigitTextField: UITextField!
    @IBOutlet var FiveDigitTextField: UITextField!
    @IBOutlet var SixDigitTextField: UITextField!
    @IBOutlet var numberTextField: TextField!
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Register OPEN")
        
        hideshowDigitTextfields(ishidden: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        SixDigitTextField.addTarget(self, action: #selector(lastDigitEntered), for: .editingDidEnd)
    }
    
    // Factories
    func hideshowDigitTextfields(ishidden: Bool) {
        OneDigitTextField.isHidden = ishidden
        TwoDigitTextField.isHidden = ishidden
        ThreeDigitTextField.isHidden = ishidden
        FourDigitTextField.isHidden = ishidden
        FiveDigitTextField.isHidden = ishidden
        SixDigitTextField.isHidden = ishidden
    }
    
    // Keyboard delegate
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // ** FIRST STEP
    func SendSMS(completion: @escaping (Int) -> ()) {
        let phoneNumber = UserDefaults.standard.string(forKey: "number")!
        print(phoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
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
        self.SendSMS(completion: { (int) -> () in
            print("SMS sent! Moving on to the next step")
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
                formattedString.appendFormat("(+%@) ", areaCode)
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
            nextResponder?.becomeFirstResponder()
            return false
         } else if textField.text!.count >= 1  && string.count == 0{
            // on deleting value from Textfield
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
    
    func lastDigitEntered() {
        if OneDigitTextField.text?.isEmpty == false || TwoDigitTextField.text?.isEmpty == false || ThreeDigitTextField.text?.isEmpty == false || FourDigitTextField.text?.isEmpty == false || FiveDigitTextField.text?.isEmpty == false || SixDigitTextField.text?.isEmpty == false {
            
            print("All digits filled, moving on to next step!")
            dismissKeyboard()
            UserDefaults.standard.set("\(OneDigitTextField.text!)\(TwoDigitTextField.text!)\(ThreeDigitTextField.text!)\(FourDigitTextField.text!)\(FiveDigitTextField.text!)\(SixDigitTextField.text!)", forKey: "digits")
            self.SignIn(completion: { (int) -> () in
                print("Done! User signed in, should segue to main ViewController now...")
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
                return
            }
            // User is signed in
            completion(0)
        }
    }
}
