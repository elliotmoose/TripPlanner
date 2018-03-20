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
    
    init(name : String, type : ActivityType) {
        self.name = name
        self.type = type
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
