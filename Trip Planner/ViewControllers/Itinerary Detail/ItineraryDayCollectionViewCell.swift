//
//  ItineraryDayCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ItineraryDayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var addDayLabelTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var addDayLabel: UILabel!
 
    private let border = CAShapeLayer()    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //corner radius
        self.layer.cornerRadius = 8
        addDayLabel.layer.cornerRadius = 8
        addDayLabel.clipsToBounds = true
        
        //shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 3.5, height: 3.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        
        //border
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [16, 8]
        border.fillColor = nil
        addDayLabel.layer.addSublayer(border)
    }

    public func SetTitle(dayNumber : Int)
    {
        dayTitleLabel.text = "DAY \(dayNumber)"
    }
    
    public func SetAddDayButton(isButton : Bool)
    {
        if isButton
        {
            addDayLabelTopLayoutConstraint.constant = 0
        }
        else
        {
            addDayLabelTopLayoutConstraint.constant = Sizing.ScreenHeight()
        }
    }
    
    public func SetDayAnimated(_ callback : @escaping ()->Void)
    {
        addDayLabelTopLayoutConstraint.constant = Sizing.ScreenHeight()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: {
            (success) -> Void in
            callback()
        })
    }
        
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = self.bounds
        border.lineWidth = 5
        border.path = UIBezierPath(roundedRect: CGRect(x: 2.5, y: 2.5, width: self.bounds.width - 5, height: self.bounds.height - 5), cornerRadius: 8).cgPath
    }
    
}
