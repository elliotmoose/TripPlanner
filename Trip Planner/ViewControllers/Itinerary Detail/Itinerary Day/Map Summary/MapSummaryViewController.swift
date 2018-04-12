//
//  MapSummaryViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 11/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps


class MapSummaryViewController: UIViewController {

    public static let singleton = MapSummaryViewController(nibName: "MapSummaryViewController", bundle: Bundle.main)
    
    var markers = [GMSMarker]()
    
    @IBOutlet weak var mapView: GMSMapView!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MapSummaryViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("MapSummaryViewController", owner: self, options: nil)
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for marker in markers
        {
            marker.map = nil
        }
        
        markers.removeAll()
    }
    
    public func PresentDay(_ day : Day)
    {
        var bounds = GMSCoordinateBounds()
        
        var count = 0
        for activity in day.GetActivities()
        {
            if let location = activity.location
            {
                let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
                let marker = GMSMarker(position: coordinate)
                marker.map = mapView
                
                markers.append(marker)
                bounds = bounds.includingCoordinate(coordinate)
                
                //to make sure there is at least one location to focus to
                count = count + 1
            }
            
        }
        
        if count != 0
        {
            let gmsUpdate = GMSCameraUpdate.fit(bounds, withPadding: 45)
            mapView.animate(with: gmsUpdate)
        }
        else
        {
            
        }
    }

}
