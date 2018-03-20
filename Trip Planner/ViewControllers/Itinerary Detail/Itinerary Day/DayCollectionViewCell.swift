//
//  ItineraryDayCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var dayNumber = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //corner radius
        self.layer.cornerRadius = 8

        //shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 3.5, height: 3.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        
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
