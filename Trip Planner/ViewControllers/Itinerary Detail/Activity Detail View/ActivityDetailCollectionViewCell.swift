//
//  ActivityDetailCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 2/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

public class ActivityDetailCollectionViewCell: UICollectionViewCell,UITextViewDelegate {

    public weak var delegate : ActivityDetailCollectionViewCellDelegate?
    
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
        
        notesTextView.delegate = self
    }

    @IBAction func EditButtonPressed(_ sender: Any) {
        self.delegate?.DidPressEdit(self)
    }
    
    @IBAction func DeleteButtonPressd(_ sender: Any) {
        self.delegate?.DidPressDelete(self)
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
        
        locationTextView.sizeToFit()
        textViewHeight.constant = locationTextView.frame.height
        locationTextView.isScrollEnabled = false
        
        timeLabel.text = activity.startDate.Get24hString() + " - " + activity.endDate.Get24hString()
        
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
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "tap to enter notes"
        {
            textView.text = ""
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = "tap to enter notes"
        }
        else
        {
            
        }
    }
}



public protocol ActivityDetailCollectionViewCellDelegate : class
{
    func DidPressDelete(_ sender : ActivityDetailCollectionViewCell)
    func DidPressEdit(_ sender : ActivityDetailCollectionViewCell)
    func DidFinishEditingNotes(_ sender : ActivityDetailCollectionViewCell, newNote : String)
}

