//
//  NewDayCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class NewDayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    private let border = CAShapeLayer()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textLabel.layer.cornerRadius = 8
        textLabel.clipsToBounds = true
        //border
        border.strokeColor = UIColor.gray.cgColor
        border.lineDashPattern = [16, 8]
        border.fillColor = nil
        textLabel.layer.addSublayer(border)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = self.bounds
        border.lineWidth = 5
        border.path = UIBezierPath(roundedRect: CGRect(x: 2.5, y: 2.5, width: self.bounds.width - 5, height: self.bounds.height - 5), cornerRadius: 8).cgPath
    }
    
}
