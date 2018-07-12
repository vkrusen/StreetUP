//
//  BaseViewController.swift
//  EagerPartner
//
//  Created by Victor Krusenstråhle on 2017-04-21.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit

extension String {
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "kr"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(for: self) ?? ""
    }
}

extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 0.45, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIImage {
    class func imageFromLabelSlider(text: String, text_color: UIColor, background_color: UIColor) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        label.font = UIFont(name: "FontAwesome", size: 10)
        label.backgroundColor = background_color
        label.textColor = text_color
        label.text = text
        label.layer.backgroundColor  = UIColor.white.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    class func imageFromLabelSmall(text: String, text_color: UIColor, background_color: UIColor) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        label.font = UIFont(name: "FontAwesome", size: 18)
        label.backgroundColor = background_color
        label.textColor = text_color
        label.text = text
        label.layer.backgroundColor  = UIColor.white.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 18
        label.textAlignment = .center
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    class func imageFromLabelLarge(text: String, text_color: UIColor, background_color: UIColor) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        label.font = UIFont(name: "FontAwesome", size: 20)
        label.backgroundColor = background_color
        label.textColor = text_color
        label.text = text
        label.layer.backgroundColor  = UIColor.white.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 21
        label.textAlignment = .center
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    class func imageLarge(imageName: String, background_color: UIColor) -> UIImage {
        let image =  UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        image.image = UIImage(named: imageName)
        image.backgroundColor = background_color
        image.contentMode = .scaleAspectFit
        image.layer.backgroundColor  = background_color.cgColor
        image.image = image.image!.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.white
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 21
        UIGraphicsBeginImageContextWithOptions(image.bounds.size, false, 0.0)
        image.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

class BaseViewController: UIViewController {
    
    // MARK: - Essentials
    var currentTime: Date = Date()
    
    // Arrays
    //..
    
    // MARK: - Factories
    
    // Download
    func _DATASERVICE_GET_STATS(completion: @escaping (Int) -> ()) {
        /*
        let startedWork = UserDefaults.standard
        if let startedWorkString = startedWork.string(forKey: "started_work") {
            print(startedWorkString) // Print string value
            
            if startedWorkString == "true" {
                let timeString = startedWork.string(forKey: "start_time")
                let time2 = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let time1 = dateFormatter.date(from: timeString!)
                
                let seconds = time2.seconds(from: time1!)
                
                // - Return this
                completion(seconds)
            } else {
                // - Return this
                print("USER ISN'T WORKING")
                completion(0)
            }
        } else {
            // - Return this
            print("SOMETHING WENT WRONG")
        }
        */
    }
    
    // Publish
    func _DATASERVICE_START_WORKING() {
        /*
        let time = Date()
        let start_time = "\(time)"
        
        let defaults = UserDefaults.standard
        defaults.set("true", forKey: "started_work") // Bool
        defaults.set(start_time, forKey: "start_time") // String
        
        print("USER STARTED WORKING")
        */
    }
    
    func _DATASERVICE_STOPWORKNG(completion: @escaping (Int) -> ()) {
        /*
        let UID = FIRAuth.auth()?.currentUser?.uid
        
        let startedWork = UserDefaults.standard
        if let startedWorkString = startedWork.string(forKey: "started_work") {
            print(startedWorkString) // Print string value
            
            if startedWorkString == "true" {
                let timeString = startedWork.string(forKey: "start_time")
                let time2 = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let time1 = dateFormatter.date(from: timeString!)
                
                print("NOW : \(time2), THEN : \(time1!)")
                
                let hours = time2.hours(from: time1!)
                let minutes = time2.minutes(from: time1!)
                let seconds = time2.seconds(from: time1!)
                
                let timeOffset = time2.offset(from: time1!)
                print("TIMEOFFSET: \(timeOffset)")
                print("SECONDS: \(seconds) seconds")
                print("MINUTES: \(minutes) minutes")
                print("HOURS: \(hours) hours")
                
                // - Change work status
                let defaults = UserDefaults.standard
                defaults.set("false", forKey: "started_work") // Bool
                defaults.set("\(time1!)", forKey: "start_time") // String
                defaults.set("\(time2)", forKey: "stop_time") // String
                print("USER STOPPED WORKING")
                
                // - Add to history
                let userdataHistory = ["start_time": "\(time1!)",
                    "stop_time": "\(time2)",
                    "total_worktime": "\(seconds)"]
                
                let DatabaseRefHistory = FIRDatabase.database().reference().child("users").child("\(UID!)").child("history").childByAutoId()
                DatabaseRefHistory.setValue(userdataHistory)
                
                // - Return this
                completion(seconds)
            } else {
                // - Return this
                print("USER ISN'T WORKING")
                completion(0)
            }
        } else {
            // - Return this
            print("SOMETHING WENT WRONG")
            completion(0)
        }
        */
    }
    
    func _DATASERVICE_NEW_PASSWORD() {
        /*
        let UID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child("\(UID!)").child("userdata").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let email = value?["email"] as? String
            FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
                print("MAIL HAS BEEN SENT")
            }
        })
        */
    }
    
    func _DATASERVICE_SET_STATS() {
        // - Publish stats
    }
    
    func _DATASERVICE_CREATE_GOAL() {
        // - Create goal
    }
    
    func _DATASERVICE_DELETE_GOAL() {
        // - Delete goal
    }
    
    func _DATASERVICE_LOGOUT() {
        /*
        try! FIRAuth.auth()!.signOut()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AuthenticationViewControllerId") as! AuthenticationViewController
        self.present(newViewController, animated: true, completion: nil)
        */
    }
    
    // Money string -> Öre
    func StringToPenny(String: String) -> Int {
        let str = String
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ","
        let number = formatter.number(from: str)
        let amount = Int(Int(number!) * 100)
        return amount
    }
    
    // Öre -> KR
    func PennyToDollar(penny: Int) -> String {
        let number = Int(penny / 100) as NSNumber
        
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        
        let rtrn = formatter.string(from: number)!
        
        return rtrn
    }
    
    // MARK: - Functions
    func setupButton(button: UIButton, imageSize: CGFloat, image: UIImage, color: String) {
        let size = button.bounds
        let y = CGFloat(size.height - imageSize)
        let x = CGFloat(size.width - imageSize)
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(imageSize, imageSize, size.height - (size.height - imageSize), size.width - (size.width - imageSize))
        button.imageView?.image = button.imageView?.image?.withRenderingMode(.alwaysTemplate)
        button.tintColor = hexStringToUIColor(hex: color)
    }
    
    // MARK - Imagepicker
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveImageDocumentDirectory(image: UIImage, name: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    // MARK: - Factories
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func setupShadow(UIItem: AnyObject, offsetX: CGFloat, offsetY: CGFloat, spread: CGFloat, alpha: Float, HEXColor: String) {
        UIItem.layer.shadowColor = hexStringToUIColor(hex: HEXColor).cgColor
        UIItem.layer.shadowOpacity = alpha
        UIItem.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        UIItem.layer.shadowRadius = spread
    }
    
    func setupLabel(label: UILabel, spacing: CGFloat, name: String) {
        let stringValue = name.uppercased()
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.lineHeightMultiple = spacing
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: stringValue.characters.count))
        label.numberOfLines = 2
        label.attributedText = attrString
    }
    
    func setupGradient(item: AnyObject, colors: [UIColor], alpha: [CGFloat], locations: [NSNumber], roundedCorners: Bool) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = item.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        if roundedCorners == true {
            gradient.cornerRadius = item.bounds.height / 2
        } else {
            
        }
        
        item.layer.insertSublayer(gradient, at: 0)
    }
    
    // Convert hexvalue to UIColor
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func hexStringToUIColorWithAlpha(hex:String, alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    // Image buttons
    func imageButton(imageName: UIImage, buttonName: UIButton, color: String) {
        buttonName.imageView?.image?.withRenderingMode(.alwaysTemplate)
        buttonName.tintColor = hexStringToUIColor(hex: color)
        buttonName.setImage(imageName, for: .normal)
        buttonName.imageView?.contentMode = .scaleAspectFit
    }
}


