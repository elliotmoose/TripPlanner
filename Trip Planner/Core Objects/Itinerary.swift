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
    public var tripLength = 0;
    public var activities = [Activity]()
    
    init(name : String) {
        self.name = name
    }
    
    public func AddActivity(name : String,type : ActivityType)
    {
        let activity = Activity(name: name, type: type)
        
        activities.append(activity)
    }
    
    public func AddDay()
    {
        tripLength = tripLength + 1
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
}
