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
    public var icon = ""
    public var notes = ""
    public var type = ActivityType.others
    public var budget = ""
    public var link = ""
    public var contact = ""
    public var location : Location?
    
    
    public var startDate = Date()
    public var endDate = Date()
    
    init(name : String, type : ActivityType) {
        self.name = name
        self.type = type
    }
    
    init() {
        
    }
    
    init(dict : NSDictionary) {
        if let name = dict["name"] as? String
        {
            self.name = name
        }
        
        if let icon = dict["icon"] as? String
        {
            self.icon = icon
        }
        
        if let notes = dict["notes"] as? String
        {
            self.notes = notes
        }
        
        if let budget = dict["budget"] as? String
        {
            self.budget = budget
        }
        
        if let link = dict["link"] as? String
        {
            self.link = link
        }
        
        if let contact = dict["contact"] as? String
        {
            self.contact = contact
        }
        
        if let startDateInterval = dict["startDate"] as? TimeInterval
        {
            self.startDate = Date(timeIntervalSince1970: startDateInterval)
        }
        
        if let endDateInterval = dict["endDate"] as? TimeInterval
        {
            self.endDate = Date(timeIntervalSince1970: endDateInterval)
        }
        
        if let locationDict = dict["location"] as? NSDictionary
        {
            let newLocation = Location(dict: locationDict)
            self.location = newLocation
        }
    }
    
    public func GetBudget() -> Float
    {
        if budget.substring(to: 0) != "$"
        {
            if let output = Float(budget)
            {
                return output
            }
        }
        else
        {
            if let output = Float(budget.substring(from: 1))
            {
                return output
            }
        }
        
        
        return 0
    }
    
    public func SetNote(_ note : String)
    {
        if note != "tap to enter notes"
        {
            self.notes = note
            
            PersistenceManager.Save()
        }
    }
    
    public func Export() -> NSDictionary
    {
        let dict = NSMutableDictionary()
        
        dict["name"] = name
        dict["icon"] = icon
        dict["notes"] = notes
        dict["budget"] = budget
        dict["link"] = link
        dict["contact"] = contact
        dict["startDate"] = startDate.timeIntervalSince1970
        dict["endDate"] = endDate.timeIntervalSince1970
        
        if let location = self.location
        {
            dict["location"] = location.Export()
        }
        
        return dict
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
