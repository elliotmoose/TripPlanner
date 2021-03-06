//
//  CreateActivityViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController,ChooseLocationDelegate,UITextFieldDelegate,TimeDurationPickerDelegate {

    
    public static let singleton = CreateActivityViewController(nibName: "CreateActivityViewController", bundle: Bundle.main)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var travelTimeTextField: UITextField!
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    
    
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var dollarImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var chooseLocationButton: UIButton!

    @IBOutlet weak var emojiTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField : AnyObject?
    
    public weak var delegate : CreateActivityViewControllerDelegate?
    
    private var selectedLocation : Location?
    private var selectedTravelTime : TimeInterval = 0
    private var previousEndDate : Date?
    private var selectedStartDate : Date?
    private var selectedEndDate : Date?
    private var txtFields = [UITextField]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CreateActivityViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("CreateActivityViewController", owner: self, options: nil)
        
        containingView.clipsToBounds = true
        containingView.layer.cornerRadius = 12
        
        //travel time input view
        let travelTimeDatePicker = TimeDurationPicker()
        travelTimeDatePicker.durationPickerDelegate = self
        travelTimeTextField.inputView = travelTimeDatePicker
        
        
        //start date input view
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = UIDatePickerMode.time
        startDatePicker.addTarget(self, action: #selector(SetDate(_:)), for: .valueChanged)
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = UIDatePickerMode.time
        endDatePicker.addTarget(self, action: #selector(SetDate(_:)), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        
        
        
        
        let tintColor = UIColor.darkGray
        clockImageView.image = clockImageView.image?.withRenderingMode(.alwaysTemplate)
        clockImageView.tintColor = tintColor
        linkImageView.image = linkImageView.image?.withRenderingMode(.alwaysTemplate)
        linkImageView.tintColor = tintColor
        contactImageView.image = contactImageView.image?.withRenderingMode(.alwaysTemplate)
        contactImageView.tintColor = tintColor
        dollarImageView.image = dollarImageView.image?.withRenderingMode(.alwaysTemplate)
        dollarImageView.tintColor = tintColor
        locationImageView.image = locationImageView.image?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = tintColor
        
        txtFields.append(nameTextField)
        txtFields.append(travelTimeTextField)
        txtFields.append(startDateTextField)
        txtFields.append(endDateTextField)
        txtFields.append(websiteTextField)
        txtFields.append(budgetTextField)
        txtFields.append(contactTextField)
        txtFields.append(emojiTextField)
        
        travelTimeTextField.layer.cornerRadius = 5
        travelTimeTextField.layer.borderWidth = 1
        travelTimeTextField.layer.borderColor = UIColor.gray.cgColor
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
        startDateTextField.layer.cornerRadius = 5
        startDateTextField.layer.borderWidth = 1
        startDateTextField.layer.borderColor = UIColor.gray.cgColor
        endDateTextField.layer.cornerRadius = 5
        endDateTextField.layer.borderWidth = 1
        endDateTextField.layer.borderColor = UIColor.gray.cgColor
        chooseLocationButton.layer.cornerRadius = 5
        chooseLocationButton.layer.borderWidth = 1
        chooseLocationButton.layer.borderColor = UIColor.gray.cgColor
        
        ChooseLocationViewController.singleton.modalPresentationStyle = .overCurrentContext
        ChooseLocationViewController.singleton.modalTransitionStyle = .crossDissolve
        
        SetTextViewDelegates()
        AddKeyboardToolBar()
        
        UpdateEmoji()
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
        //ResetScene()
    }
    
    func ResetScene()
    {
        
        chooseLocationButton.setTitle("Choose Location", for: .normal)
        selectedStartDate = nil
        selectedLocation = nil
        selectedEndDate = nil
        previousEndDate = nil
        
        selectedTravelTime = 0
        
        titleLabel.text = "ADD ACTIVITY"
        travelTimeTextField.text = ""
        nameTextField.text = ""
        contactTextField.text = ""
        websiteTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        
        if let current = ItineraryManager.GetCurrent()
        {
            budgetTextField.text = current.currency[1] + "0.00"
        }
        
        emojiIndex = 0
        UpdateEmoji()
    }
    
    public func UpdateDatePickerLimits(dayIndex : Int)
    {
        //Get date for this day
        if let day = ItineraryManager.GetCurrent()?.GetDay(index: dayIndex)
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
    
    public func SetTitle(_ previousActivityName : String)
    {
        titleLabel.text = "ADD ACTIVITY AFTER: ( \(previousActivityName))"
    }
    
    public func SetPreviousEndTime(date : Date)
    {
        previousEndDate = date
        selectedStartDate = date
        startDateTextField.text = date.Get24hString()
    }
    
    //textfield change function
    @objc private func SetDate(_ sender : UIDatePicker)
    {
        if startDateTextField.isFirstResponder
        {
            selectedStartDate = sender.date
        }
        
        if endDateTextField.isFirstResponder
        {
            selectedEndDate = sender.date
        }
        
        UpdateDateTextField()
    }
    
    //travel duration
    func DidSelectDuration(_ duration: TimeInterval) {
        
        selectedTravelTime = duration
        
        travelTimeTextField.text = duration.GetPresentable()
        
        //adjust start date
        if selectedEndDate == nil && previousEndDate != nil
        {
            selectedStartDate = Date(timeInterval: (duration), since: previousEndDate!)
            UpdateDateTextField()
        }
    }
    
    private func UpdateDateTextField()
    {
        if let start = selectedStartDate
        {
            startDateTextField.text = start.Get24hString()
        }
        else
        {
            startDateTextField.text = ""
        }
        
        if let end = selectedEndDate
        {
            endDateTextField.text = end.Get24hString()
        }
        else
        {
            endDateTextField.text = ""
        }
    }
    
    //@CHOOSE LOCATION DELEGATE FUNCTION
    func DidChooseLocation(location: Location?) {
        if let location = location
        {
            selectedLocation = location
            chooseLocationButton.setTitle(location.name, for: .normal)
            
            //automate name if choosing location was first action
            if nameTextField.text == ""
            {
                nameTextField.text = location.name
            }
        }
        else
        {
            selectedLocation = nil
            chooseLocationButton.setTitle("Choose Location", for: .normal)
        }
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        if nameTextField.text == ""
        {
            PopupManager.singleton.Popup(title: "Oops!", body: "Your activity has no name", presentationViewCont: self)
            return
        }
        
        if selectedStartDate == nil || selectedEndDate == nil
        {
            PopupManager.singleton.Popup(title: "Oops!", body: "Please choose the activity timing", presentationViewCont: self)
            return
        }

        
        let activity = Activity()
        activity.name = nameTextField.text!
        activity.travelTime = selectedTravelTime
        activity.startDate = selectedStartDate!
        activity.endDate = selectedEndDate!
        activity.link = websiteTextField.text!
        activity.budget = budgetTextField.text!.CurrencyToValue()
        activity.location = selectedLocation
        activity.icon = emojiTextField.text!
        activity.contact = contactTextField.text!
        ItineraryManager.GetCurrent()?.AddActivity(activity)
        
        self.delegate?.DidCreateActivity()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ChooseLocationButtonPressed(_ sender: Any) {
        ChooseLocationViewController.singleton.PresentWithLocation(location: selectedLocation)
        ChooseLocationViewController.singleton.delegate = self
        self.present(ChooseLocationViewController.singleton, animated: true, completion: nil)
    }
    
    
    let emojis = ["🍽","☕️","🍻","✈️","🚗","🚌","🚢","😴","🏖","🌊","⛰","🎭"]
    var emojiIndex = 0
    @IBAction func PrevEmoji(_ sender: Any) {
        emojiIndex = emojiIndex - 1
        if emojiIndex < 0
        {
            emojiIndex = emojis.count-1
        }
        
        UpdateEmoji()
    }
    @IBAction func NextEmoji(_ sender: Any) {
        emojiIndex = emojiIndex + 1
        if emojiIndex >= emojis.count
        {
            emojiIndex = 0
        }
        
        UpdateEmoji()
    }
    
    func UpdateEmoji()
    {
        emojiTextField.text = emojis[emojiIndex]
    }
    
    //==============================================================================================================
    //                                     PUSH UP SCROLL VIEW WHEN EDITING TEXT
    //==============================================================================================================
    //push up scroll
    func SetTextViewDelegates()
    {
        travelTimeTextField.delegate = self
        nameTextField.delegate = self
        websiteTextField.delegate = self
        contactTextField.delegate = self
        budgetTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        emojiTextField.delegate = self
    }
    
    //textfield delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        
        if textField == emojiTextField
        {
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        }
        
        if textField == startDateTextField
        {
            if let datePicker = textField.inputView as? UIDatePicker
            {
                if let date = selectedStartDate
                {
                    datePicker.date = date
                }
            }
        }
        
        if textField == endDateTextField
        {
            if let datePicker = textField.inputView as? UIDatePicker
            {
                if let date = selectedEndDate
                {
                    datePicker.date = date
                }
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == budgetTextField
        {
            let text = textField.text!
            var result : Double = 0
            
            if string.length > 0
            {
                result = text.CurrencyToValue()*1000 + string.CurrencyToValue()*100
            }
            else
            {
                result = text.CurrencyToValue()*1000/100
            }
            
            let nf = NumberFormatter()

            nf.numberStyle = .currency
            nf.currencySymbol = ItineraryManager.GetCurrent()?.currency[1]
            textField.text = nf.string(from: NSNumber(value: result/100))
            
            return false
        }
        else if textField == emojiTextField
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 1
        }
        else
        {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneWithNumberPad()
        return false
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func AddKeyboardToolBar()
    {
        let textFieldToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: 30))
        textFieldToolBar.barStyle = UIBarStyle.default
        textFieldToolBar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneWithNumberPad))]
        textFieldToolBar.sizeToFit()
        
        
        for txtField in txtFields
        {
            txtField.inputAccessoryView = textFieldToolBar
        }
        
//        nameTextField.inputAccessoryView = textFieldToolBar
//        websiteTextField.inputAccessoryView = numberToolbar
//        contactTextField.inputAccessoryView = numberToolbar
//        budgetTextField.inputAccessoryView = numberToolbar
//        startDateTextField.inputAccessoryView = numberToolbar
//        endDateTextField.inputAccessoryView = numberToolbar
//        emojiTextField.inputAccessoryView = numberToolbar
    }
    
    @objc func cancelNumberPad()
    {
        let txtfield = FirstResponder()
        let _ = txtfield.endEditing(true)
        
    }
    
    @objc func doneWithNumberPad()
    {
        if let txtfield = FirstResponder() as? UITextField
        {
            if let currentIndex = txtFields.index(of: txtfield)
            {
                let nextIndex = currentIndex + 1
                if nextIndex > 0 && nextIndex < txtFields.count
                {
                    txtFields[nextIndex].becomeFirstResponder()
                    return
                }
            }
            
            txtfield.resignFirstResponder()
            return
        }
        
        resignFirstResponder()
    }
    
    
    func FirstResponder() -> AnyObject
    {
        if travelTimeTextField.isFirstResponder
        {
            return travelTimeTextField
        }
        else if nameTextField.isFirstResponder
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
        else if endDateTextField.isFirstResponder
        {
            return endDateTextField
        }
        else
        {
            return emojiTextField
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

