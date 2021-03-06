//
//  ChooseLocationViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 21/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ChooseLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    public static let singleton = ChooseLocationViewController(nibName: "ChooseLocationViewController", bundle: Bundle.main)

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chooseLocationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chooseLocationBottomConstraint: NSLayoutConstraint!
    @IBAction func cancelChooseLocationPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private let marker = GMSMarker()
    

    //variables
    public weak var delegate : ChooseLocationDelegate?
    private var searchResults = [GMSAutocompletePrediction]()
    private var previousLocation : Location?
    private var selectedLocation : Location?
    private var selectedTravelTime : Double = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ChooseLocationViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ChooseLocationViewController", owner: self, options: nil)
        
        
        marker.map = mapView
        
        searchTextField.addTarget(self, action: #selector(Search), for: .editingChanged)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.alpha = 0
        //searchResults.append(Location(name:"Kuta Beach"))
        
        searchTextField.delegate = self
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.RegisterForKeyboardNotifications(show: #selector(keyboardWasShown(notification:)),hide: #selector(keyboardWillBeHidden))
    }
    override func viewDidAppear(_ animated: Bool) {
        self.modalTransitionStyle = .coverVertical
        
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        self.DeregisterFromKeyboardNotifications()
        self.modalTransitionStyle = .crossDissolve
        ResetScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    public func PresentWithLocation(location : Location?)
    {
        if let location = location
        {
            self.searchTextField.text = location.name
            self.selectedLocation = location
            
            chooseLocationButton.setTitle(location.name, for: .normal)
            self.FocusLocation(location.lat, location.long)
        }
    }
    
    
    @objc private func Search()
    {
        
        //query googlemaps
        let placeClient = GMSPlacesClient.shared()
        let search = searchTextField.text!
        
        if search == ""
        {
            searchResults.removeAll()
            tableView.reloadData()
            tableView.alpha = 0
            selectedLocation = nil
            chooseLocationButton.setTitle("Choose Location", for: .normal)
            marker.map = nil
        }
        
        
        
        placeClient.autocompleteQuery(search, bounds: nil, filter: nil, callback: {
            (results,error) -> Void in
            
            self.searchResults.removeAll()
            
            guard results != nil else {print("ERROR:" + error.debugDescription);return}
            
            for result in results!
            {
                self.searchResults.append(result)
                
            }
            
            //update search result dropdown list
            
            DispatchQueue.main
            do {
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
        })
        
    }
    
    @IBAction func ChooseLocationPressed(_ sender: Any) {
        
        if let selection = self.selectedLocation
        {
            if let delegate = self.delegate
            {
                delegate.DidChooseLocation(location: selection)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            //PopupManager.singleton.Popup(title: "Oops!", body: "You did not choose a location", presentationViewCont: self)
            if let delegate = self.delegate
            {
                delegate.DidChooseLocation(location: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = searchResults[indexPath.row].attributedPrimaryText.string
        
        if let secondaryString = searchResults[indexPath.row].attributedSecondaryText?.string
        {
            cell?.detailTextLabel?.text = secondaryString
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.alpha = 0

        let gmsSearchResult = searchResults[indexPath.row]
        self.searchTextField.text = gmsSearchResult.attributedPrimaryText.string
        
        if let placeID = gmsSearchResult.placeID
        {
            //look up selected location information
            GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: {
                (result,error) -> Void in
                
                if let result = result {
                    let lat = Double(result.coordinate.latitude)
                    let long = Double(result.coordinate.longitude)
                    
                    //LOCATION INITIALIZATION======================================================================================================
                    var newLocation = Location(name: gmsSearchResult.attributedPrimaryText.string, lat: lat, long : long)
                    
                    if let formattedAdd = result.formattedAddress
                    {
                        newLocation.addressFormatted = formattedAdd
                    }
                    
                    newLocation.addressPrimary = gmsSearchResult.attributedPrimaryText.string
                    
                    if let secondaryAddress = gmsSearchResult.attributedSecondaryText?.string
                    {
                        newLocation.addressSecondary = secondaryAddress
                    }
                    
                    self.selectedLocation = newLocation
                    
                    //travel time
                    self.GetTravelTime()
                    
                    //
                    //ui
                    //
                    self.searchResults.removeAll()
                    tableView.reloadData()
                    self.FocusLocation(lat, long)
                    self.chooseLocationButton.setTitle(self.selectedLocation!.name, for: .normal)
                }
                
            })
        }
    }
        
    private func GetTravelTime()
    {
        guard let prev = previousLocation else {return}
        guard let next = selectedLocation else {return}
        
        //look up travel time
        let origin = prev.name
        let destination = next.name
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origin)&destinations=\(destination)&key=\(MainManager.singleton.GetGMSKey())"
        Network.singleton.DataFromUrl(url, handler: {
            (success,output)-> Void in
            do
            {
                if let dict = try JSONSerialization.jsonObject(with: output!, options: .allowFragments) as? NSDictionary
                {
                    if let error = dict["error_message"] as? String
                    {
                        NSLog(error)
                    }
                    
                    if let rowsArr = dict["rows"] as? NSArray
                    {
                        
                        guard rowsArr.count > 0 else {return}
                        if let row = rowsArr[0] as? NSDictionary
                        {
                            if let elementsArr = row["elements"] as? NSArray
                            {
                                if let element = elementsArr[0] as? NSDictionary
                                {
                                    //                                        //UPDATE DATA
                                    //                                        if let distance = element["distance"] as? NSDictionary
                                    //                                        {
                                    //                                            if let text = distance["text"] as? String
                                    //                                            {
                                    //                                            }
                                    //
                                    //                                            if let value = distance["value"] as? Float
                                    //                                            {
                                    //
                                    //                                            }
                                    //                                        }
                                    
                                    if let duration = element["duration"] as? NSDictionary
                                    {
                                        //                                            if let text = duration["text"] as? String
                                        //                                            {
                                        //
                                        //                                            }
                                        
                                        if let value = duration["value"] as? Double
                                        {
                                            self.selectedTravelTime = value
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                let outString = String(data: output!, encoding: .utf8)!
                print(outString)
                
            }
            catch let error as NSError
            {
                NSLog("\(error)")
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func ResetScene()
    {
        searchTextField.text = ""
        searchResults.removeAll()
        tableView.alpha = 0
        tableView.reloadData()
        previousLocation = nil
        selectedLocation = nil
        selectedTravelTime = 0
        chooseLocationButton.setTitle("Choose Location", for: .normal)
    }
    
    func FocusLocation(_ lat : CLLocationDegrees, _ long : CLLocationDegrees)
    {
        DispatchQueue.main.async {
            //add marker
            self.SetMarker(lat,long)
            
            //move to location
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat,
                                                           longitude: long,
                                                           zoom: 15)
        }
    }
    
    func SetMarker(_ lat : CLLocationDegrees, _ long : CLLocationDegrees)
    {
        // Creates a marker in the center of the map.
        marker.map = mapView
        marker.position = CLLocationCoordinate2D(latitude: lat,longitude: long)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Search()
        return true
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        
        chooseLocationBottomConstraint.constant = keyboardHeight!
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    
        
        
        
    }
    
    @objc func keyboardWillBeHidden(){

        chooseLocationBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

public protocol ChooseLocationDelegate : class
{
    func DidChooseLocation(location : Location?)
}

public struct Location
{
    var name : String = ""
    var addressFormatted : String = ""
    var addressPrimary : String = ""
    var addressSecondary : String = ""
    var lat : Double = 0
    var long : Double = 0
    
    init(name : String, lat : Double, long : Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    init(dict : NSDictionary)
    {
        if let name = dict["name"] as? String
        {
            self.name = name
        }
        if let addressFormatted = dict["addressFormatted"] as? String
        {
            self.addressFormatted = addressFormatted
        }
        if let addressPrimary = dict["addressPrimary"] as? String
        {
            self.addressPrimary = addressPrimary
        }
        if let addressSecondary = dict["addressSecondary"] as? String
        {
            self.addressSecondary = addressSecondary
        }
        if let lat = dict["lat"] as? Double
        {
            self.lat = lat
        }
        if let long = dict["long"] as? Double
        {
            self.long = long
        }
        
    }
    
    public func Export() -> NSDictionary
    {
        let dict = NSMutableDictionary()
        dict["name"] = self.name
        dict["addressFormatted"] = self.addressFormatted
        dict["addressPrimary"] = self.addressPrimary
        dict["addressSecondary"] = self.addressSecondary
        dict["lat"] = self.lat
        dict["long"] = self.long
        
        return dict
    }
}
