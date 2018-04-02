//
//  ItineraryListViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit
//import WWCalendarTimeSelector

class ItineraryListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,WWCalendarTimeSelectorProtocol{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 8
        //tableView.clipsToBounds = true
        
        self.title = "My Itineraries"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddItineraryButtonPressed))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItineraryManager.singleton.GetItineraries().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if(cell == nil)
        {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        
        let itinerary = ItineraryManager.singleton.GetItineraries()[indexPath.row]
        cell?.textLabel?.text = itinerary.name
        cell?.detailTextLabel?.text = itinerary.GetTripDateRangeText()
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ItineraryManager.SetCurrent(index: indexPath.row)
        self.navigationController?.pushViewController(ItineraryDetailViewController.singleton, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            ItineraryManager.singleton.RemoveItineraryAtIndex(index: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })]
    }
    
    @objc func AddItineraryButtonPressed()
    {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionMultipleSelectionGrouping = .pill
        selector.optionSelectionType = .range
        self.present(selector, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date],name : String,currency : [String]?) {
        
        guard dates.count != 0 else {return}
        let _ = ItineraryManager.singleton.AddItinerary(name: name,currency : currency,startDate: dates.first!, endDate: dates.last!)
        self.tableView.reloadData()
    }


}
