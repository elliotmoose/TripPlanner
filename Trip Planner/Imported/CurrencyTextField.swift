//
//  CurrencyTextField.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 13/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField,UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var symbol = "$"
    private var value : Double = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Initialize()
    }
    
    public func Initialize()
    {
        self.delegate = self
    }

    
    public func SetCurrency(_ symbol : String)
    {
        self.symbol = symbol
    }
    
    public func GetCurrency() -> String
    {
        return self.symbol
    }
    
    
    public func SetValue(_ value : Double)
    {
        self.value = value
        
        let nf = NumberFormatter()
        
        nf.numberStyle = .currency
        nf.currencySymbol = self.symbol
        self.text = nf.string(from: NSNumber(value: value/100))
    }
    public func GetValue()
    {
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let text = textField.text!
            var result : Double = 0
            
            if string.length > 0
            {
                result = text.CurrencyToValue()*1000 + string.CurrencyToValue()*100
            }
            else
            {
                result = text.CurrencyToValue()*1000/100
            }
        
            self.SetValue(result/100)
        
            
            return false
    }

}


//extension String
//{
//    public func CurrencyToValue() -> Double //assuming with 2 d.p (e.g. $0.00)
//    {
//        var output = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        if output == ""
//        {
//            output = "0"
//        }
//        return Double(output)!/100
//    }
//}

