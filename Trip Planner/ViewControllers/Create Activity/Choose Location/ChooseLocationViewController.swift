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

class ChooseLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    public static let singleton = ChooseLocationViewController(nibName: "ChooseLocationViewController", bundle: Bundle.main)

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chooseLocationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancelChooseLocationPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //variables
    public weak var delegate : ChooseLocationDelegate?
    private var searchResults = [Location]()
    private var selectedLocation : Location?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ChooseLocationViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ChooseLocationViewController", owner: self, options: nil)
        
        searchTextField.addTarget(self, action: #selector(Search), for: .valueChanged)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchResults.append(Location(name:"Kuta Beach"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.modalTransitionStyle = .coverVertical
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.modalTransitionStyle = .crossDissolve
        ResetScene()
    }        
    
    
    @objc private func Search()
    {
        tableView.reloadData()
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
            PopupManager.singleton.Popup(title: "Oops!", body: "You did not choose a location", presentationViewCont: self)
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
            cell = UITableViewCell()
        }
        
        cell?.textLabel?.text = searchResults[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedLocation = searchResults[indexPath.row]
        chooseLocationButton.setTitle(selectedLocation!.name, for: .normal)
        searchResults.removeAll()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func ResetScene()
    {
        searchResults.removeAll()
        tableView.reloadData()
        selectedLocation = nil
        chooseLocationButton.setTitle("Choose Location", for: .normal)
    }
}

public protocol ChooseLocationDelegate : class
{
    func DidChooseLocation(location : Location)
}

public struct Location
{
    var name : String = ""
    var address : String = ""
    var lat : Double = 0
    var long : Double = 0
    
    init(name : String) {
        self.name = name
    }
    
    init()
    {
        
    }
}
