//
//  ItineraryDayCollectionViewCell.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource,ActivityCellDelegate{

    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UIButton!
    
    public var dayNumber = -1
    private var selectedRows = [Int]()
    
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
    
    public func Initialize()
    {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    

    public func SetDay(dayNumber : Int)
    {
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if let day = itinerary.GetDay(index: dayNumber)
            {
                dayTitleLabel.text = "DAY \(dayNumber)"
                dateLabel.setTitle(day.GetDateString(), for: UIControlState.normal)
                self.dayNumber = dayNumber
            }

        }
        else
        {
            
        }

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
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedRows.contains(indexPath.row)
        {
            return 100
        }
        else
        {
            return 60
        }
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
                cell?.delegate = self
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
    
    
    public func DidToggleExpand(_ sender : ActivityTableViewCell) {
        
        let indexPath = tableView.indexPath(for: sender)!
        //activity selection
        if selectedRows.contains(indexPath.row)
        {
            selectedRows.remove(at: selectedRows.index(of: indexPath.row)!)
            sender.Collapse()
        }
        else
        {
            selectedRows.append(indexPath.row)
            sender.Expand()
        }
        
        //tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.beginUpdates()
        tableView.endUpdates()
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
