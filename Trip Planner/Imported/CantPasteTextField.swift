//
//  CantPasteTextField.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CantPasteTextField: UITextField {

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
//            return false
//        }
        
        return false
    }

}
