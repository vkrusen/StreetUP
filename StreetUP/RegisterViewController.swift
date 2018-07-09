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
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5);
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Register OPEN")
        
        hideshowDigitTextfields(ishidden: true)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    // Register new user
    
    // ** FIRST STEP
    func SendSMS(completion: @escaping (Int) -> ()) {
        let phoneNumber = numberTextField.text
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
         if (textField == numberTextField) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
         
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            
            if length == 11 {
                self.SendSMS(completion: { (int) -> () in
                    print("SMS sent! Moving on to the next step")
                    self.hideshowDigitTextfields(ishidden: false)
                })
            }
            
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
         
            if length == 0 || (length > 11 && !hasLeadingOne) || length > 11 {
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
                formattedString.appendFormat("(+%@)", areaCode)
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
        } else if textField == textField.superview?.viewWithTag(6){
            print("All digits filled, moving on to next step!")
            self.SignIn(completion: { (int) -> () in
                print("Done! User signed in, should segue to main ViewController now...")
            })
        } else if textField.text!.count < 1  && string.count > 0{
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
    
    // ** THIRD STEP
    func SignIn(completion: @escaping (Int) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let verificationCode = "\(OneDigitTextField.text!)\(TwoDigitTextField.text!)\(ThreeDigitTextField.text!)\(FourDigitTextField.text!)\(FiveDigitTextField.text!)\(SixDigitTextField.text!)"
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
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
    
    /*
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == numberTextField {
            self.SendSMS(completion: { (int) -> () in
                // Done
                print("SMS sent!")
                self.hideshowDigitTextfields(ishidden: false)
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performAction(textField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.count < 1  && string.count > 0{
            let nextTag = textField.tag + 1
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            
            if (nextResponder == nil){
                
                nextResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = string
            nextResponder?.becomeFirstResponder()
            return false
        }
        else if textField.text!.count >= 1  && string.count == 0{
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
    
    func performAction(textField: UITextField) {
        if textField == numberTextField {
            // Should check for right amount of digits and should look for right format
            self.SendSMS(completion: { (int) -> () in
                // Done
                print("SMS sent!")
                self.hideshowDigitTextfields(ishidden: false)
                //self.dismiss(animated: true, completion: nil)
            })
        } else if textField == OneDigitTextField {
            TwoDigitTextField.becomeFirstResponder()
        } else if textField == TwoDigitTextField {
            ThreeDigitTextField.becomeFirstResponder()
        } else if textField == ThreeDigitTextField {
            FourDigitTextField.becomeFirstResponder()
        } else if textField == FourDigitTextField {
            FiveDigitTextField.becomeFirstResponder()
        } else if textField == FiveDigitTextField {
            SixDigitTextField.becomeFirstResponder()
        } else if textField == SixDigitTextField {
            self.SignIn(completion: { (int) -> () in
                //Done - Should segue to main ViewController
            })
        }
    }
    
    //Anteckingar
    /*
    Bör checka så om nummert är formaterat rätt (och med rätt antal siffror) ska den automatiskt köra igång en auth
    - Går auth igenom --> Logga in
    - Blir det fel --> Gör om (?)
    */
    
    // Chceck if user has registered
    func SendSMS(completion: @escaping (Int) -> ()) {
        let phoneNumber = numberTextField.text
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(0)
        }
    }
    
    func SignIn(completion: @escaping (Int) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let verificationCode = "\(OneDigitTextField.text!)\(TwoDigitTextField.text!)\(ThreeDigitTextField.text!)\(FourDigitTextField.text!)\(FiveDigitTextField.text!)\(SixDigitTextField.text!)"
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print(error)
                return
            }
            // User is signed in
            completion(0)
        }
    }
    */
    
}
