//
//  ActivityDetailCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

public class ActivityDetailCollectionViewCell: UICollectionViewCell {

    public weak var delegate : ActivityDetailCollectionViewCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func EditButtonPressed(_ sender: Any) {
        self.delegate?.DidPressEdit(self)
    }
    @IBAction func DeleteButtonPressd(_ sender: Any) {
        self.delegate?.DidPressDelete(self)
    }
}

public protocol ActivityDetailCollectionViewCellDelegate : class
{
    func DidPressDelete(_ sender : ActivityDetailCollectionViewCell)
    func DidPressEdit(_ sender : ActivityDetailCollectionViewCell)
}

