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
    public var date = Date()
    private var activities = [Activity]()
    
    init(date : Date) {
        self.date = date;
    }
    
    
    public func AddActivity(name : String,type : ActivityType)
    {
        let activity = Activity(name: name, type: type)
        
        activities.append(activity)
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
    
    public func GetDateString() -> String
    {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YY"
        return df.string(from: date)
        
    }
    
    public func GetActivitiesCount() -> Int
    {
        return activities.count
    }
}
