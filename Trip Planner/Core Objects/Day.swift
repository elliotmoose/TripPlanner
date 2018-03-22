//
//  Day.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation

public class Day
{
    private var date = Date()
    private var activities = [Activity]()
    
    init(date : Date) {
        self.date = date;
    }
    
    
    public func AddActivity(_ activity : Activity)
    {
        activities.append(activity)
        activities.sort { (a, b) -> Bool in
            return a.startDate > b.startDate
        }
    }
    
    public func RemoveActivity(index : Int)
    {
        if index < 0 || index >= activities.count
        {
            NSLog("remove activity error; index out of range")
        }
        else
        {
            activities.remove(at: index)
        }
    }
    
    public func GetActivity( index: Int) -> Activity?
    {
        if index >= 0 && index < activities.count
        {
            return activities[index]
        }
        else
        {
            NSLog("Day does not have activity at index \(index)")
            return nil
        }
    }
    
    public func GetDate() -> Date
    {
        return date
    }
    
    public func SetDate(date : Date)
    {
        self.date = date
    }
    
    public func GetActivitiesCount() -> Int
    {
        return activities.count
    }
}
