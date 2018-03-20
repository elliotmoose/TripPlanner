//
//  ItineraryDayCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ItineraryDayCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var addDayLabelTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var addDayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var dayNumber = -1
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
    
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ActivityTableViewCell")
    }
    
    

    public func SetDay(dayNumber : Int)
    {
        dayTitleLabel.text = "DAY \(dayNumber)"
        self.dayNumber = dayNumber
    }
    
    //==============================================================================================================================================================================
    //                                                                                ADD DAY RELATED
    //==============================================================================================================================================================================
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
    

    //==============================================================================================================================================================================
    //                                                                          TABLE DELEGATE FUNCTIONS
    //==============================================================================================================================================================================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if let day = itinerary.GetDay(index: dayNumber)
            {
                return day.GetActivitiesCount()
            }
            else
            {
                NSLog("Day \(dayNumber) does not exist")
                return 0
            }
        }
        else
        {
            NSLog("No current itinerary")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if let day = itinerary.GetDay(index: dayNumber)
            {
                //activity selected
            }
            else
            {
                NSLog("Day \(dayNumber) does not exist")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as? ActivityTableViewCell
        
        if cell == nil
        {
            cell = ActivityTableViewCell()
        }
        
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if let activity = itinerary.GetDay(index: dayNumber)?.GetActivity(index: indexPath.row)
            {
                cell?.SetName(activity.name)
            }
            else
            {
                NSLog("Could not retrieve activity with index \(indexPath.row) from day \(dayNumber)")
            }
        }
        
        
        return cell!
    }
    
    
    public func ReloadData()
    {
        tableView.reloadData()
    }
//    if let day = itinerary.GetDay(index: dayNumber)
//    {
//
//    }
//    else
//    {
//    NSLog("Day \(dayNumber) does not exist")
//    }
}
