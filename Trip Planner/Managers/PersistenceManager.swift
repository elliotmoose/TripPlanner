//
//  PersistenceManager.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 31/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation

public class PersistenceManager
{
    public static func Save()
    {
        let defaults = UserDefaults.standard
        let outputDict = ItineraryManager.Export()
        defaults.set(outputDict, forKey: "Itineraries")
    }
    
    public static func Load()
    {
        Clear()
        let defaults = UserDefaults.standard
        
        if let data = defaults.value(forKey: "Itineraries") as? NSDictionary
        {
            ItineraryManager.Import(dict: data)
        }
    }
    
    public static func Clear()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Itineraries")
    }
}
