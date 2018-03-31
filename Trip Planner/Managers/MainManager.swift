//
//  MainManager.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 21/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

public class MainManager
{
    public static let singleton = MainManager()
    
    private let gmsKey = "AIzaSyAI6mk3nvKebfefoMLVSCmKKk-VReFQFLY"
    
    init() {
        GMSServices.provideAPIKey(gmsKey)
        GMSPlacesClient.provideAPIKey(gmsKey)
        
        PersistenceManager.Load()
    }
}
