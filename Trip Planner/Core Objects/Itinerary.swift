//
//  Itinerary.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation

public class Itinerary
{
    public var name = ""
    public var startDate = Date();
    private var days = [Day]()
    
    init(name : String,startDate : Date, endDate: Date) {
        self.name = name
        
        let calender = Calendar.current
        let start = calender.date(bySettingHour: 12, minute: 0, second: 0, of: startDate)!
        let end = calender.date(bySettingHour: 12, minute: 0, second: 0, of: endDate)!
        
        if let tripLength = calender.dateComponents([.day], from: start, to: end).day
        {
            for _ in 0...tripLength-1
            {
                AddDay()
            }
        }
        else
        {
            NSLog("Could not find trip length")
        }
        
        self.startDate = startDate
    }


    public func GetTripLength() -> Int
    {
        return days.count
    }
    
    public func SetStartDate(date : Date)
    {
        self.startDate = date
        RefactorDates()
    }        
    
    public func AddDay()
    {
        let date = startDate.addingTimeInterval(TimeInterval(60*60*24*days.count))
        let day = Day(date: date)
        days.append(day)
    }
    
    public func AddActivity(_ activity : Activity)
    {
        for day in days
        {
            if day.GetDate().GetDDMMYYString() == activity.startDate.GetDDMMYYString()
            {
                day.AddActivity(activity)
                PersistenceManager.Save()
                
                break
            }
        }        
    }
    
    public func EditActivityAtIndexPath(indexPath : IndexPath, newActivity : Activity)
    {
        RemoveActivityAtIndexPath(indexPath)
        AddActivity(newActivity)
    }
    
    public func RemoveActivityAtIndexPath(_ indexPath : IndexPath)
    {
        let dayIndex = indexPath.section
        let activityIndex = indexPath.row
        if dayIndex >= 0 && dayIndex < days.count
        {
            days[dayIndex].RemoveActivity(index: activityIndex)
        }
    }
    
    public func RemoveDay(index : Int)
    {
        if index >= 0 && index < days.count
        {
            days.remove(at: index)
            RefactorDates()
        }
    }
    
    public func GetDay(index : Int) -> Day?
    {
        if index >= 0 && index < days.count
        {
            return days[index]
        }
        else
        {
            NSLog("Itinerary does not have day \(index)")
            return nil
        }
    }
    
    public func RefactorDates()
    {
        for index in 0...days.count-1
        {
            let day = days[index]
            day.SetDate(date: startDate.addingTimeInterval(TimeInterval(60*60*24*index)))
        }
    }
    
    public func HasIndexPath(_ indexPath : IndexPath) -> Bool
    {
        let dayIndex = indexPath.section
        let activityIndex = indexPath.row
        
        if dayIndex < days.count && dayIndex >= 0
        {
            if activityIndex >= 0 && days[dayIndex].GetActivity(index: activityIndex) != nil
            {
                return true
            }
        }
        
        return false
    }
    
    
    init(dict : NSDictionary)
    {
        if let name = dict["name"] as? String
        {
            self.name = name
        }
        
        if let startDateInterval = dict["startDate"] as? TimeInterval
        {
            self.startDate = Date(timeIntervalSince1970: startDateInterval)
        }
        
        if let daysDict = dict["days"] as? NSDictionary
        {
            for index in 0..<daysDict.count
            {
                if let newDayDict = daysDict["\(index)"] as? NSDictionary
                {
                    let newDay = Day(dict : newDayDict)
                    self.days.append(newDay)
                }
            }
        }
    }
    
    public func Export() -> NSDictionary
    {
        let dict = NSMutableDictionary()
        
        dict["name"] = name
        dict["start_date"] = startDate.timeIntervalSince1970

        let daysDict = NSMutableDictionary()

        for index in 0...days.count-1
        {
            daysDict["\(index)"] = self.days[index].Export()
        }

        dict["days"] = daysDict
        
        return dict
    }
    
}
