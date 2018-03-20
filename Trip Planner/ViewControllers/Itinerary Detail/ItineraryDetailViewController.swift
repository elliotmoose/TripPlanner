//
//  ItineraryDetailViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ItineraryDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


    public static let singleton = ItineraryDetailViewController(nibName: "ItineraryDetailViewController", bundle: Bundle.main)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ItineraryDetailViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ItineraryDetailViewController", owner: self, options: nil)
        
        //collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ItineraryDayCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "itineraryDayCell")
        
        //export button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ShareButtonPressed))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = ItineraryManager.GetCurrent()?.name
        
        ReloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let itinerary = ItineraryManager.GetCurrent()
        {
            return itinerary.GetTripLength() + 1
        }
        else
        {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if indexPath.row == itinerary.GetTripLength() //if its the last cell (which is a button)
            {
                //add day
                itinerary.AddDay()
                
                //ui
                let cell = collectionView.cellForItem(at: indexPath) as! ItineraryDayCollectionViewCell
                cell.SetDayAnimated()
                    {
                        
                }
                
                //put this in the above closure to enable animations
                ReloadData()
            }
        }
        else
        {
            NSLog("No current Itinerary")
        }
        
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itineraryDayCell", for: indexPath) as! ItineraryDayCollectionViewCell
        cell.SetDay(dayNumber: indexPath.row)

        if let itinerary = ItineraryManager.GetCurrent()
        {
            if indexPath.row == itinerary.GetTripLength() //if is last cell
            {
                cell.SetAddDayButton(isButton: true)
            }
            else
            {
                cell.SetAddDayButton(isButton: false)
                cell.ReloadData()
            }
        }
        else
        {
            NSLog("No current Itinerary")
        }
        
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Sizing.ScreenWidth() - 64
        let height = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - 64
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 64
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
    }
    
    @objc func ShareButtonPressed()
    {
        
    }


    func ReloadData()
    {
        collectionView.reloadData()
    }
}
