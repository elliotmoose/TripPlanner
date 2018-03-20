//
//  ItineraryManager.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation

public class ItineraryManager
{
    public static let singleton = ItineraryManager();
    
    public static var itineraries = [Itinerary]()
    public static var current : Itinerary? = nil
    
    init() {
        let test = AddItinerary(name: "test", startDate: Date(), endDate: Date(timeIntervalSinceNow: TimeInterval(60*60*24*1)))
        test.GetDay(index: 0)?.AddActivity(name: "Flight", type: .travel)
        test.GetDay(index: 0)?.AddActivity(name: "Lunch", type: .meal)
    }
    
    func AddItinerary(name : String, startDate : Date, endDate : Date) -> Itinerary
    {
        let itinerary = Itinerary(name: name,startDate : startDate, endDate : endDate)
        ItineraryManager.itineraries.append(itinerary)
        return itinerary
    }
    
    func RemoveItineraryAtIndex(index : Int)
    {
        if(index < ItineraryManager.itineraries.count)
        {
            ItineraryManager.itineraries.remove(at: index)
        }
        else
        {
            NSLog("remove itinerary error; index out of range")
        }
    }
    
    public static func SetCurrent(index : Int)
    {
        if(index < 0 || index >= ItineraryManager.itineraries.count)
        {
            NSLog("Invalid current index")
            return
        }
        
        ItineraryManager.current = ItineraryManager.itineraries[index]
    }
    
    public static func GetCurrent() -> Itinerary?
    {
        return ItineraryManager.current
    }
    
    func GetItineraries() -> [Itinerary]
    {
        return ItineraryManager.itineraries
    }
    
    
}
