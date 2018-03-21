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
    
    private var searchResults = [String]()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ChooseLocationViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ChooseLocationViewController", owner: self, options: nil)
        
        
        searchTextField.addTarget(self, action: #selector(Search), for: .valueChanged)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchResults.append("Kuta Beach")
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
    }        
    
    
    @objc private func Search()
    {
        tableView.reloadData()
    }
    
    @IBAction func ChooseLocationPressed(_ sender: Any) {
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
        
        cell?.textLabel?.text = searchResults[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        chooseLocationButton.setTitle(searchResults[indexPath.row], for: .normal)
        searchResults.removeAll()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
