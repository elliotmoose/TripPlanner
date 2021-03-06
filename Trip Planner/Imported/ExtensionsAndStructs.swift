//
//  ExtensionsAndStructs.swift
//  AfterDark Merchant
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 16/12/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

import Foundation
import UIKit

enum TravelMode
{
    case Transit
    case Drive
    case Walk
}


extension String{
    public func AddPercentEncodingForURL(plusForSpace : Bool = false) -> String?
    {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace
        {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        
        if plusForSpace
        {
            encoded = encoded?.replacingOccurrences(of: " ", with: "%20")
        }
        
        
        
        return encoded
    }
    
    public func CurrencyToValue() -> Double //assuming with 2 d.p (e.g. $0.00)
    {
        var output = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if output == ""
        {
            output = "0"
        }
        return Double(output)!/100
    }
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
}

extension UIImage
{
    public func newImageWithSize(_ size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension Date
{
    
    func GetPresentable() -> String
    {
        let df = DateFormatter()
        df.dateFormat = "EEEE, dd LLLL YYYY"
        return df.string(from: self)
    }
    func GetDDMMYYString() -> String
    {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YY"
        return df.string(from: self)
    }
    
    func Get24hString() -> String
    {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
}

extension UIViewController
{
    
    //notifications for pushing up keyboard
    func RegisterForKeyboardNotifications(show : Selector, hide : Selector){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: show, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: hide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func DeregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
}

extension TimeInterval
{
    func GetPresentable() -> String
    {
        let hours = floor(self/3600)
        
        var mins : Double = 0
        if hours != 0
        {
            mins = (self.truncatingRemainder(dividingBy: (hours*3600)))/60
        }
        else
        {
            mins = self/60
        }
        
        
        let hoursString = "\(Int(hours))"
        let minsString = "\(Int(mins))"
        
        return "\(hoursString)h \(minsString)m"
    }
}

extension Float
{
    func GetCurrencyPresentable() -> String
    {
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = true
        nf.groupingSeparator = ","
        nf.groupingSize = 3
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        return nf.string(for: self)!
    }
}

extension Double
{
    func GetCurrencyPresentable() -> String
    {
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = true
        nf.groupingSeparator = ","
        nf.groupingSize = 3
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        
        
        return nf.string(for: self)!
    }
}
