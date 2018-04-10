//
//  CurrencyUIPicker.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class TimeDurationPicker: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource{
    
    weak var durationPickerDelegate : TimeDurationPickerDelegate?
    
    
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
        
        self.selectRow(100_00/2, inComponent: 0, animated: false)
        self.selectRow(100_00/2, inComponent: 1, animated: false)
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100_000
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let view = UILabel(frame: CGRect.zero)
        view.textAlignment = .center

        if component == 0
        {
            view.text = "\(row % 49)"
        }
        else
        {
            view.text = "\(row % 60)"
        }
        
        return view
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hours = pickerView.selectedRow(inComponent: 0) % 49
        let mins = pickerView.selectedRow(inComponent: 1) % 60
        
        let duration : TimeInterval = TimeInterval(mins) * 60 + TimeInterval(hours)*3600
        durationPickerDelegate?.DidSelectDuration(duration)
    }
    
}

protocol TimeDurationPickerDelegate : class
{
    func DidSelectDuration(_ duration : TimeInterval)
}

