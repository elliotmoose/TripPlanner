//
//  CreateActivityViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController {

    
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
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
    }
    
    @IBAction func ChooseLocationButtonPressed(_ sender: Any) {
        self.present(ChooseLocationViewController.singleton, animated: true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CreateActivityViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("CreateActivityViewController", owner: self, options: nil)
        
        containingView.clipsToBounds = true
        containingView.layer.cornerRadius = 12
        
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(SetDate(_:)), for: .valueChanged)
        startDateTextField.inputView = datePicker
        endDateTextField.inputView = datePicker
        
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
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    @objc private func SetDate(_ sender : UIDatePicker)
    {
        if startDateTextField.isFirstResponder
        {
            startDateTextField.text = sender.date.Get24hString()
        }
        if endDateTextField.isFirstResponder
        {
            endDateTextField.text = sender.date.Get24hString()
        }
    }
}

