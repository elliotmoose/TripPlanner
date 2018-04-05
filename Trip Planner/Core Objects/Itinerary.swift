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
    public var currency : [String]
    public var startDate = Date();
    private var days = [Day]()
    
    init(name : String,currency : [String]?,startDate : Date, endDate: Date) {
        self.name = name
        
        if let curr = currency
        {
            self.currency = curr
        }
        else
        {
            self.currency = ["United States","USD","$","United States: $ (USD)"]
        }

        
        
        self.startDate = startDate
        let calender = Calendar.current
        let start = calender.date(bySettingHour: 12, minute: 0, second: 0, of: startDate)!
        let end = calender.date(bySettingHour: 12, minute: 0, second: 0, of: endDate)!
        
        if let tripLength = calender.dateComponents([.day], from: start, to: end).day
        {
            for _ in 0...tripLength
            {
                AddDay()
            }
        }
        else
        {
            NSLog("Could not find trip length")
        }
        
        
        RefactorDates()
    }


    public func GetTripLength() -> Int
    {
        return days.count
    }
    
    public func GetTripDateRangeText() -> String
    {
        let endDate = Date(timeIntervalSince1970: startDate.timeIntervalSince1970 + TimeInterval(60*60*24*(days.count-1)))
        return "\(startDate.GetDDMMYYString()) - \(endDate.GetDDMMYYString())"
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
        
        PersistenceManager.Save()
    }
    
    public func AddActivity(_ activity : Activity)
    {
        var hasAdded = false
        
        for day in days
        {
            if day.GetDate().GetDDMMYYString() == activity.startDate.GetDDMMYYString()
            {
                hasAdded = true
                day.AddActivity(activity)
                PersistenceManager.Save()
                
                break
            }
        }
        
        if !hasAdded
        {
            NSLog("Could not find a day for activity with name \(activity.name)")
        }
    }
    
    public func EditActivityAtIndexPath(indexPath : IndexPath, newActivity : Activity)
    {
        if HasIndexPath(indexPath)
        {
            RemoveActivityAtIndexPath(indexPath)
            AddActivity(newActivity)
        }
        else
        {
            NSLog("Failed at editing activity at indexpath \(indexPath)")
        }
    }
    
    public func RemoveActivityAtIndexPath(_ indexPath : IndexPath)
    {
        let dayIndex = indexPath.section
        let activityIndex = indexPath.row
        if dayIndex >= 0 && dayIndex < days.count
        {
            days[dayIndex].RemoveActivity(index: activityIndex)
            PersistenceManager.Save()
        }
        

    }
    
    public func RemoveDay(index : Int)
    {
        if index >= 0 && index < days.count
        {
            days.remove(at: index)
            RefactorDates()
            
            PersistenceManager.Save()
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
    
    public func GetBudget() -> Float
    {
        var sum : Float = 0
        
        for day in days
        {
            sum = sum + day.GetBudget()
        }
        
        return sum
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
        
        if let currency = dict["currency"] as? [String]
        {
            self.currency = currency
        }
        else
        {
            self.currency = ["United States","USD","$","United States: $ (USD)"]
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
        dict["currency"] = currency
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
