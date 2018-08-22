//
//  ShippingViewController.swift
//  StreetUP
//
//  Created by Victor Krusenstråhle on 2018-08-20.
//  Copyright © 2018 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Stripe

class ShippingViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var streedTextfield: CustomTextField!
    @IBOutlet var postalcodeTextfield: CustomTextField!
    @IBOutlet var cityTextfield: CustomTextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Frakt detajler"
        
        styleTextfield(textField: streedTextfield, label: "Gata och husnummer")
        styleTextfield(textField: postalcodeTextfield, label: "Postnummer")
        styleTextfield(textField: cityTextfield, label: "Ort")
        
        setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "B1B3B0")
        nextButton.layer.cornerRadius = 7
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if streedTextfield.text == "" || postalcodeTextfield.text == "" || cityTextfield.text == "" {
             nextButton.isEnabled = false
        } else {
            setupGradient(item: nextButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
            setupShadow(UIItem: nextButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
            nextButton.layer.cornerRadius = 7
            nextButton.isEnabled = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // Factory
    func styleTextfield(textField: UITextField, label: String) {
        textField.layer.cornerRadius = 10
        textField.backgroundColor = hexStringToUIColor(hex: "F5F5F5")
        textField.placeholder = label
        textField.textColor = hexStringToUIColor(hex: "CCCCCC")
    }
}
