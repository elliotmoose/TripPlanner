//
//  CurrencyUIPicker.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CurrencyUIPicker: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource{
    
    var currencies = [Array<String>]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        Initialize()
        
    }
    
    private func Initialize()
    {
        
        self.delegate = self
        self.dataSource = self
        
        let path = Bundle.main.path(forResource: "CurrencyList", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)!
        let keys = dict.allKeys.sorted(by: { (a, b) -> Bool in
            return String(describing: a) < String(describing: b)
        }) as! [String]
        
        for key in keys
        {
            currencies.append(dict.value(forKey: key) as! [String])
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel(frame: CGRect.zero)
        
        view.text = currencies[row][0]
        
        return view
    }
    
    
}
