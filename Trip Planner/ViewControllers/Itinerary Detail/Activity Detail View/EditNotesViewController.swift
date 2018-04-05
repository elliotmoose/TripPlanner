//
//  EditNotesViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class EditNotesViewController: UIViewController {

    public static let singleton = EditNotesViewController(nibName: "EditNotesViewController", bundle: Bundle.main)
    
    public weak var delegate : EditNotesViewControllerDelegate?
    
    public var selectedIndexPath : IndexPath?
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "EditNotesViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("EditNotesViewController", owner: self, options: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        
        textView.layer.cornerRadius = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    public func SetIndexPath(_ indexPath : IndexPath)
    {
        self.selectedIndexPath = indexPath
        
        if let activity = ItineraryManager.GetCurrent()?.GetDay(index: indexPath.section)?.GetActivity(index: indexPath.row)
        {
            self.textView.text = activity.notes
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //show keyboard
        
        textView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ResetScene()
    }
    
    func ResetScene()
    {
        selectedIndexPath = nil
        textView.text = ""
        buttonBottomConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        RegisterForKeyboardNotifications(show: #selector(keyboardWasShown(notification:)), hide: #selector(keyboardWillBeHidden(notification:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DeregisterFromKeyboardNotifications()
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardHeight = keyboardSize?.height
        buttonBottomConstraint.constant = -(keyboardHeight!)
        
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        buttonBottomConstraint.constant = 32

        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        
        textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        textView.resignFirstResponder()
        
        let newNote = textView.text!
        
        if newNote == "" || newNote == "tap to enter notes"
        {
            return
        }
        
        if let indexPath = self.selectedIndexPath
        {
            
            if let itinerary = ItineraryManager.GetCurrent()
            {
                if let activity = itinerary.GetDay(index: indexPath.section)?.GetActivity(index: indexPath.row)
                {
                    activity.SetNote(newNote)
                    
                    self.delegate?.DidFinishEditNotes()
                }
            }
            else
            {
                NSLog("No activity for requested day and activity index")
            }
            
        }
        else
        {
            NSLog("No Day selected for activity detail view")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

protocol EditNotesViewControllerDelegate : class
{
    func DidFinishEditNotes()
}
