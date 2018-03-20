//
//  CreateItineraryViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 20/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class CreateItineraryViewController: UIViewController {

    public static let singleton = CreateItineraryViewController(nibName: "CreateItineraryViewController", bundle: Bundle.main)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CreateItineraryViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("CreateItineraryViewController", owner: self, options: nil)
        
        self.title = "New Itinerary"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }

    

}
