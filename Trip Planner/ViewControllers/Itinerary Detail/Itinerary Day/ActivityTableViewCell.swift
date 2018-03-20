//
//  ActivityTableViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

public class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    public weak var delegate : ActivityCellDelegate?
    
    @IBOutlet weak var toggleExpandButton: UIButton!
    
    @IBAction func expandCollapseButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.DidToggleExpand(self)
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.toggleExpandButton.transform = CGAffineTransform(rotationAngle: -(.pi)/2)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public func SetName(_ name : String)
    {
        nameLabel.text = name
    }
    
    public func Expand()
    {
        UIView.animate(withDuration: 0.3, animations: {
                self.toggleExpandButton.transform = CGAffineTransform(rotationAngle: (.pi/2))
        })
    }
    
    public func Collapse()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.toggleExpandButton.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        })

//        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
//        }, completion: nil)
    }
    
    
}

public protocol ActivityCellDelegate : class
{
    func DidToggleExpand(_ sender : ActivityTableViewCell)
}
