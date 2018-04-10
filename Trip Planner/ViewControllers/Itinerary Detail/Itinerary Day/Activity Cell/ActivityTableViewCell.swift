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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetImageView: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var travelDurationLabel: UILabel!
    @IBOutlet weak var travelDurationImageView: UIImageView!
    
    
    @IBOutlet weak var eye: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow1LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrow2LayoutConstraint: NSLayoutConstraint!
    
    public weak var delegate : ActivityCellDelegate?
    private var activity : Activity = Activity()
    
    
    
    
    @IBAction func DetailButtonPressed(_ sender: Any) {
        if let delegate = self.delegate
        {
            delegate.DidRequestDetail(self)
        }
    }
    
    @IBAction func expandCollapseButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate
        {
            delegate.DidToggleExpand(self)
        }
    }

    @IBAction func contactButtonPressed(_ sender: Any) {
    }
    @IBAction func linkButtonPressed(_ sender: Any) {
        
        if activity.link != ""
        {
            self.delegate?.DidOpenLink(activity.link)
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.arrow2.transform = CGAffineTransform(rotationAngle: -(.pi))
        
        //ui init
        let tintColor = UIColor.darkGray
        locationImageView.image = locationImageView.image?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = tintColor
        timeImageView.image = timeImageView.image?.withRenderingMode(.alwaysTemplate)
        timeImageView.tintColor = tintColor
        linkImageView.image = linkImageView.image?.withRenderingMode(.alwaysTemplate)
        linkImageView.tintColor = tintColor
        budgetImageView.image = budgetImageView.image?.withRenderingMode(.alwaysTemplate)
        budgetImageView.tintColor = tintColor
        contactImageView.image = contactImageView.image?.withRenderingMode(.alwaysTemplate)
        contactImageView.tintColor = tintColor
        travelDurationImageView.image = travelDurationImageView.image?.withRenderingMode(.alwaysTemplate)
        travelDurationImageView.tintColor = tintColor
        
        arrow1.image = arrow1.image?.withRenderingMode(.alwaysTemplate)
        arrow1.tintColor = UIColor.gray
        arrow2.image = arrow2.image?.withRenderingMode(.alwaysTemplate)
        arrow2.tintColor = UIColor.gray
        eye.image = eye.image?.withRenderingMode(.alwaysTemplate)
        eye.tintColor = tintColor
        
        SetLabelsAlpha(0)
        
        self.selectionStyle = .none

        
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public func DisplayActivity(_ activity : Activity)
    {
        self.activity = activity;
        
        nameLabel.text = activity.name
        
        if let location = activity.location
        {
            locationLabel.text = location.addressPrimary
        }
        else
        {
            locationLabel.text = ""
        }
        
        timeLabel.text = activity.startDate.Get24hString() + " - " + activity.endDate.Get24hString()
        
        if activity.link == ""
        {
            linkButton.setTitle("", for: .normal)
        }
        else
        {
            linkButton.setTitle("tap to visit", for: .normal)
        }
        
        if activity.budget == ""
        {
            budgetLabel.text = "0.00"
        }
        else
        {
            budgetLabel.text = activity.budget
        }
        
        if activity.contact == ""
        {
            contactButton.setTitle("", for: .normal)
        }
        else
        {
            contactButton.setTitle(activity.contact, for: .normal)
        }
        
        if activity.icon == ""
        {
            emojiLabel.text = "😊"
        }
        else
        {
            emojiLabel.text = activity.icon.substring(to: 1)
        }
        
        travelDurationLabel.text = activity.travelTime.GetPresentable()
        
        
        
        
    }
    
    public func Expand()
    {
        arrow1LayoutConstraint.constant = 20
        arrow2LayoutConstraint.constant = -20
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            //self.toggleExpandButton.transform = CGAffineTransform(rotationAngle: (.pi/2))
            self.SetLabelsAlpha(1)
        })
    }
    
    public func Collapse()
    {
        arrow1LayoutConstraint.constant = -12
        arrow2LayoutConstraint.constant = 12
        
        UIView.animate(withDuration: 0.3, animations: {
            //self.toggleExpandButton.transform = CGAffineTransform(rotationAngle: -(.pi/2))
            self.layoutIfNeeded()
            
            self.SetLabelsAlpha(0)
        })

//        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
//        }, completion: nil)
    }
    
    private func SetLabelsAlpha(_ alpha : CGFloat)
    {
        self.budgetLabel.alpha = alpha
        self.budgetImageView.alpha = alpha
        self.contactButton.alpha = alpha
        self.contactImageView.alpha = alpha
        self.linkButton.alpha = alpha
        self.linkImageView.alpha = alpha
        self.travelDurationLabel.alpha = alpha
        self.travelDurationImageView.alpha = alpha
    }
    
    
}

public protocol ActivityCellDelegate : class
{
    func DidToggleExpand(_ sender : ActivityTableViewCell)
    func DidOpenLink(_ link : String)
    func DidRequestEdit(_ sender :ActivityTableViewCell)
    func DidRequestDetail(_ sender :ActivityTableViewCell)
}
