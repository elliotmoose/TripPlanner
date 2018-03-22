//
//  Activity.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation

public class Activity
{
    public var name = ""
    public var type = ActivityType.meal
    public var budget = 0
    public var timeSpent = 0
    public var timeToTravel = 0
    public var location = Location()
    
    init(name : String, type : ActivityType) {
        self.name = name
        self.type = type
    }
    
    init() {
        
    }
}


public enum ActivityType
{
    case meal
    case travel
    case tour
    case rest
    case relax
    case others
}
