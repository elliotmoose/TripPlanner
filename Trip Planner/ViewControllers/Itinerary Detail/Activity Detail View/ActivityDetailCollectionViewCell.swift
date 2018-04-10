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
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
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
        nameLabel.text = activity.name
        
        if let location = activity.location
        {
            locationTextView.text = "\(location.addressFormatted)"
        }
        else
        {
            locationTextView.text = "No address"
        }
        
        //locationTextView.sizeToFit()
        //textViewHeight.constant = locationTextView.frame.height
        //locationTextView.isScrollEnabled = false
        
        timeLabel.text = activity.startDate.Get24hString() + " - " + activity.endDate.Get24hString()
        
        if activity.notes == ""
        {
            notesTextView.text = "tap to enter notes"
        }
        else
        {
            notesTextView.text = activity.notes
        }
        
        if activity.link == ""
        {
            websiteLabel.text = "No website"
        }
        else
        {
            websiteLabel.text = activity.link
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
            contactLabel.text = "No contact"
        }
        else
        {
            contactLabel.text = activity.contact
        }
        
        if activity.icon == ""
        {
            iconLabel.text = "😊"
        }
        else
        {
            iconLabel.text = activity.icon.substring(to: 1)
        }
        
        travelTimeLabel.text = activity.travelTime.GetPresentable()
        
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

