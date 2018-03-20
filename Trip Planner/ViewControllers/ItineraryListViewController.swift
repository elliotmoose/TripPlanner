//
//  ItineraryListViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ItineraryListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
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
            cell = UITableViewCell()
        }
        
        cell?.textLabel?.text = ItineraryManager.singleton.GetItineraries()[indexPath.row].name
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ItineraryManager.SetCurrent(index: indexPath.row)
        self.navigationController?.pushViewController(ItineraryDetailViewController.singleton, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func AddItineraryButtonPressed()
    {
        self.navigationController?.pushViewController(CreateItineraryViewController.singleton, animated: true)
    }


}
