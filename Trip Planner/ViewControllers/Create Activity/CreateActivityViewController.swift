//
//  CreateActivityViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController,ChooseLocationDelegate,UITextFieldDelegate {

    
    public static let singleton = CreateActivityViewController(nibName: "CreateActivityViewController", bundle: Bundle.main)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var dollarImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var chooseLocationButton: UIButton!

    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    var activeField : AnyObject?
    
    public weak var delegate : CreateActivityViewControllerDelegate?
    
    private var selectedLocation : Location?
    private var selectedStartDate : Date?
    private var selectedEndDate : Date?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CreateActivityViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("CreateActivityViewController", owner: self, options: nil)
        
        containingView.clipsToBounds = true
        containingView.layer.cornerRadius = 12
        
        
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = UIDatePickerMode.time
        startDatePicker.addTarget(self, action: #selector(SetDate(_:)), for: .valueChanged)
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = UIDatePickerMode.time
        endDatePicker.addTarget(self, action: #selector(SetDate(_:)), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        
        linkImageView.image = linkImageView.image?.withRenderingMode(.alwaysTemplate)
        linkImageView.tintColor = UIColor.darkGray
        contactImageView.image = contactImageView.image?.withRenderingMode(.alwaysTemplate)
        contactImageView.tintColor = UIColor.darkGray
        dollarImageView.image = dollarImageView.image?.withRenderingMode(.alwaysTemplate)
        dollarImageView.tintColor = UIColor.darkGray
        locationImageView.image = locationImageView.image?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor.darkGray
        
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        websiteTextField.layer.cornerRadius = 5
        websiteTextField.layer.borderWidth = 1
        websiteTextField.layer.borderColor = UIColor.gray.cgColor
        contactTextField.layer.cornerRadius = 5
        contactTextField.layer.borderWidth = 1
        contactTextField.layer.borderColor = UIColor.gray.cgColor
        budgetTextField.layer.cornerRadius = 5
        budgetTextField.layer.borderWidth = 1
        budgetTextField.layer.borderColor = UIColor.gray.cgColor
        chooseLocationButton.layer.cornerRadius = 5
        chooseLocationButton.layer.borderWidth = 1
        chooseLocationButton.layer.borderColor = UIColor.gray.cgColor
        
        ChooseLocationViewController.singleton.modalPresentationStyle = .overCurrentContext
        ChooseLocationViewController.singleton.modalTransitionStyle = .crossDissolve
        
        SetTextViewDelegates()
        AddKeyboardToolBar()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
        ResetScene()
    }
    
    public func SetDay(index : Int)
    {
        //Get date for this day
        if let day = ItineraryManager.GetCurrent()?.GetDay(index: index)
        {
            let startDatePicker = startDateTextField.inputView as! UIDatePicker
            let endDatePicker = endDateTextField.inputView as! UIDatePicker
            let calender = Calendar.current
            let minDate = calender.date(bySettingHour: 0, minute: 0, second: 0, of: day.GetDate())!
            let maxDate = calender.date(bySettingHour: 23, minute: 59, second: 59, of: day.GetDate())!
            startDatePicker.minimumDate = minDate
            startDatePicker.maximumDate = maxDate
            endDatePicker.minimumDate = minDate
            endDatePicker.maximumDate = maxDate
            
        }
    }
    
    @objc private func SetDate(_ sender : UIDatePicker)
    {
        if startDateTextField.isFirstResponder
        {
            startDateTextField.text = sender.date.Get24hString()
            
            //end date cannot be earlier than start
            let startDatePicker = startDateTextField.inputView as! UIDatePicker
            let endDatePicker = endDateTextField.inputView as! UIDatePicker
            endDatePicker.minimumDate = startDatePicker.date
        }
        if endDateTextField.isFirstResponder
        {
            endDateTextField.text = sender.date.Get24hString()
        }
    }
    
    func DidChooseLocation(location: Location) {
        selectedLocation = location
        chooseLocationButton.setTitle(location.name, for: .normal)
    }
    
    func ResetScene()
    {
        chooseLocationButton.setTitle("Choose Location", for: .normal)
        selectedStartDate = nil
        selectedLocation = nil
        selectedEndDate = nil
        
        nameTextField.text = ""
        budgetTextField.text = ""
        contactTextField.text = ""
        websiteTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        if nameTextField.text != ""
        {
            let activity = Activity()
            activity.name = nameTextField.text!
            activity.budget = budgetTextField.text!
            activity.location = selectedLocation
            
            ItineraryManager.GetCurrent()?.AddActivity(activity)
            
            self.delegate?.DidCreateActivity()
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            PopupManager.singleton.Popup(title: "Oops!", body: "Your activity has no name", presentationViewCont: self)
        }
    }
    
    @IBAction func ChooseLocationButtonPressed(_ sender: Any) {
        ChooseLocationViewController.singleton.delegate = self
        self.present(ChooseLocationViewController.singleton, animated: true, completion: nil)
    }
    
    //==============================================================================================================
    //                                     PUSH UP SCROLL VIEW WHEN EDITING TEXT
    //==============================================================================================================
    //push up scroll
    func SetTextViewDelegates()
    {
        nameTextField.delegate = self
        websiteTextField.delegate = self
        contactTextField.delegate = self
        budgetTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    
    //textfield delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    //notifications for pushing up keyboard
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardHeight = keyboardSize?.height
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight!-32-40 , 0.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.scrollView.isScrollEnabled = true

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        

    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        //var info = notification.userInfo!
        //let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        containerViewBottomConstraint.constant = 32
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func AddKeyboardToolBar()
    {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: 30))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        nameTextField.inputAccessoryView = numberToolbar
        websiteTextField.inputAccessoryView = numberToolbar
        contactTextField.inputAccessoryView = numberToolbar
        budgetTextField.inputAccessoryView = numberToolbar
        startDateTextField.inputAccessoryView = numberToolbar
        endDateTextField.inputAccessoryView = numberToolbar
        
    }
    
    @objc func cancelNumberPad()
    {
        let txtfield = FirstResponder()
        let _ = txtfield.endEditing(true)
        
    }
    
    @objc func doneWithNumberPad()
    {
        let txtfield = FirstResponder()
        
        if txtfield as! NSObject == nameTextField
        {
            websiteTextField.becomeFirstResponder()
        }
        else if txtfield as! NSObject == websiteTextField
        {
            contactTextField.becomeFirstResponder()
        }
        else if txtfield as! NSObject == contactTextField
        {
            budgetTextField.becomeFirstResponder()
        }
        else if txtfield as! NSObject == budgetTextField
        {
            startDateTextField.becomeFirstResponder()
        }
        else if txtfield as! NSObject == startDateTextField
        {
            endDateTextField.becomeFirstResponder()
        }
        else
        {
            txtfield.resignFirstResponder()
        }
        
        let _ = txtfield.endEditing(true)
    }
    
    
    func FirstResponder() -> AnyObject
    {
        if nameTextField.isFirstResponder
        {
            return nameTextField
        }
        else if websiteTextField.isFirstResponder
        {
            return websiteTextField
        }
        else if contactTextField.isFirstResponder
        {
            return contactTextField
        }
        else if budgetTextField.isFirstResponder
        {
            return budgetTextField
        }
        else if startDateTextField.isFirstResponder
        {
            return startDateTextField
        }
        else
        {
            return  endDateTextField
        }
    }
    
    func EnableTapToDismissKeyboard()
    {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard)))
    }
    
    @objc func DismissKeyboard()
    {
        resignFirstResponder()
    }
    
    
}

public protocol CreateActivityViewControllerDelegate : class
{
    func DidCreateActivity()
}

