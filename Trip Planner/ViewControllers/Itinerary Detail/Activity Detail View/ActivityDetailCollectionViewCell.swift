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
    
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    
    
    //@IBOutlet weak var textViewHeight: NSLayoutConstraint!
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 12
        //notesTextView.layer.cornerRadius = 12
        AddKeyboardToolBar()
    }

    @IBAction func EditButtonPressed(_ sender: Any) {
        self.delegate?.DidPressEdit(self)
    }
    
    @IBAction func DeleteButtonPressd(_ sender: Any) {
        self.delegate?.DidPressDelete(self)
    }
    
    @IBAction func LocationButtonPressed(_ sender: Any) {
        self.delegate?.DidOpenLocation(self)
    }
    
    @IBAction func LinkButtonPressed(_ sender: Any) {
        self.delegate?.DidOpenLink(self)
    }
    
    @IBAction func ContactButtonPressed(_ sender: Any) {
        self.delegate?.DidCallContact(self)
    }
    
    public func DisplayActivity(_ activity : Activity)
    {
        guard let itinerary = ItineraryManager.GetCurrent() else
        {
            NSLog("No current itinerary")
            return
        }
        
        //underline string attribute
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)] as [NSAttributedStringKey : Any]

        
        
        nameLabel.text = activity.name
        
        
        timeLabel.text = activity.startDate.Get24hString() + " - " + activity.endDate.Get24hString()
        budgetLabel.text = itinerary.currency[1] + activity.budget.GetCurrencyPresentable() + " (" + itinerary.currency[2] + ")"
        travelTimeLabel.text = activity.travelTime.GetPresentable()
        
        
        locationButton.titleLabel?.numberOfLines = 2
        
        if let location = activity.location
        {
            locationButton.setAttributedTitle(NSMutableAttributedString(string: location.addressFormatted, attributes: underlineAttribute), for: .normal)
            locationButton.titleLabel?.textColor = self.tintColor
            locationButton.isEnabled = true
        }
        else
        {
            locationButton.setAttributedTitle(NSMutableAttributedString(string: "No Address", attributes: underlineAttribute), for: .normal)
            locationButton.titleLabel?.textColor = UIColor.gray
            locationButton.isEnabled = false
        }
        
        if activity.link == ""
        {
            websiteButton.setAttributedTitle(NSMutableAttributedString(string: "No website", attributes: underlineAttribute), for: .normal)
            websiteButton.titleLabel?.textColor = UIColor.gray
            websiteButton.isEnabled = false
        }
        else
        {
            websiteButton.setAttributedTitle(NSMutableAttributedString(string: activity.link, attributes: underlineAttribute), for: .normal)
            websiteButton.titleLabel?.textColor = self.tintColor
            websiteButton.isEnabled = true
        }
        
        if activity.contact == ""
        {
            contactButton.setAttributedTitle(NSMutableAttributedString(string: "No Contact", attributes: underlineAttribute), for: .normal)
            contactButton.titleLabel?.textColor = UIColor.gray
            contactButton.isEnabled = false
        }
        else
        {
            contactButton.setAttributedTitle(NSMutableAttributedString(string: activity.contact, attributes: underlineAttribute), for: .normal)
            contactButton.titleLabel?.textColor = self.tintColor
            contactButton.isEnabled = true
        }
        
        if activity.notes == ""
        {
            notesTextView.text = "tap to enter notes"
        }
        else
        {
            notesTextView.text = activity.notes
        }
        
        if activity.icon == ""
        {
            iconLabel.text = "😊"
        }
        else
        {
            iconLabel.text = activity.icon.substring(to: 1)
        }
        

        
    }

    @IBAction func EditNotesButtonPressed(_ sender: Any) {
        self.delegate?.DidRequestEditNotes(self)
    }
    
    
    func AddKeyboardToolBar()
    {
        let finishedToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: 30))
        finishedToolBar.barStyle = UIBarStyle.default
        finishedToolBar.items = [
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TextViewDone))]
        finishedToolBar.sizeToFit()
        notesTextView.inputAccessoryView = finishedToolBar
    }
    
    @objc func TextViewDone()
    {
        notesTextView.resignFirstResponder()
    }
}



public protocol ActivityDetailCollectionViewCellDelegate : class
{
    func DidPressDelete(_ sender : ActivityDetailCollectionViewCell)
    func DidPressEdit(_ sender : ActivityDetailCollectionViewCell)
    func DidRequestEditNotes(_ sender : ActivityDetailCollectionViewCell)
    func DidOpenLink(_ sender : ActivityDetailCollectionViewCell)
    func DidCallContact(_ sender : ActivityDetailCollectionViewCell)
    func DidOpenLocation(_ sender : ActivityDetailCollectionViewCell)
}
