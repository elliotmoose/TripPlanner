//
//  ItineraryDetailViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 19/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit
import SafariServices

class ItineraryDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,DayCollectionViewCellDelegate,CreateActivityViewControllerDelegate,EditActivityViewControllerDelegate{


    public static let singleton = ItineraryDetailViewController(nibName: "ItineraryDetailViewController", bundle: Bundle.main)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var budgetDayLabel: UILabel!
    @IBOutlet weak var budgetTotalLabel: UILabel!
    
    @IBOutlet weak var revealSummaryButton: UIButton!
    @IBAction func RevealSummaryPressed(_ sender: Any) {
        if collectionViewTopConstraint.constant == 120
        {
            UIView.animate(withDuration: 0.4, animations: {
                self.revealSummaryButton.transform = CGAffineTransform(rotationAngle: (.pi))
            })
            collectionViewTopConstraint.constant = 0
            collectionViewBottomConstraint.constant = 0
        }
        else
        {
            UIView.animate(withDuration: 0.4, animations: {
                self.revealSummaryButton.transform = CGAffineTransform(rotationAngle: 0)
            })
            collectionViewTopConstraint.constant = 120
            collectionViewBottomConstraint.constant = 120
        }
        
        UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func ViewMapSummaryPressed(_ sender: Any) {
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ItineraryDetailViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ItineraryDetailViewController", owner: self, options: nil)
        
        //collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "DayCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "itineraryDayCell")
        collectionView.register(UINib(nibName: "NewDayCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "newDayCell")
        
        //export button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ShareButtonPressed))
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.revealSummaryButton.transform = CGAffineTransform(rotationAngle: (.pi))        
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
        
        if let itinerary = ItineraryManager.GetCurrent()
        {
            if indexPath.row == itinerary.GetTripLength()
            {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "newDayCell", for: indexPath) as! NewDayCollectionViewCell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itineraryDayCell", for: indexPath) as! DayCollectionViewCell
                cell.SetDay(dayNumber: indexPath.row)
                cell.Initialize(delegate : self)
                cell.ReloadData()
                return cell
            }
        }
        else
        {
            NSLog("No current Itinerary")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Sizing.ScreenWidth() - 64
        let height = Sizing.ScreenHeight() - Sizing.navBarHeight - Sizing.statusBarHeight - 64
        //let height = self.view.frame.height - Sizing.navBarHeight - Sizing.statusBarHeight - 64
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UpdateSummaryForCurrentPage()
    }
    
    @objc func ShareButtonPressed()
    {
        let _ = ItineraryManager.ExportCurrentItinerary()
    }


    func ReloadData()
    {
        collectionView.reloadData()
        
        UpdateSummaryForCurrentPage()
    }
    
    func UpdateSummaryForCurrentPage()
    {
        let pageWidth = collectionView.frame.size.width
        let pageNumber = Int(ceil(collectionView.contentOffset.x / pageWidth))
        
        if let itinerary = ItineraryManager.GetCurrent()
        {
            var budgetForDay :Float = 0
            if let dayBudget = itinerary.GetDay(index: pageNumber)?.GetBudget()
            {
                budgetForDay = dayBudget
            }
 
            let budgetForItinerary = itinerary.GetBudget()
            
//            var dayPerc = budgetForDay/budgetForItinerary * 100
//            if budgetForItinerary == 0
//            {
//                dayPerc = 0
//            }
            
            budgetDayLabel.text = itinerary.currency[1] + String(format: "%.2f", budgetForDay) + "  (" + itinerary.currency[2] + ")"
            budgetTotalLabel.text = itinerary.currency[1] + String(format: "%.2f", budgetForItinerary) + "  (" + itinerary.currency[2] + ")"
        }
        
    }
    
    //delegate functions
    func AddActivityRequest(_ sender: DayCollectionViewCell, dayIndex : Int) {        
        CreateActivityViewController.singleton.UpdateDatePickerLimits(dayIndex : dayIndex)
        CreateActivityViewController.singleton.delegate = self
        CreateActivityViewController.singleton.modalPresentationStyle = .overCurrentContext
        self.present(CreateActivityViewController.singleton, animated: true, completion: {})
    }
    
    func AddActivityAtIndexPathRequest(_ sender : DayCollectionViewCell, indexPath : IndexPath)
    {
        CreateActivityViewController.singleton.UpdateDatePickerLimits(dayIndex : indexPath.section)
                
        if let activity = ItineraryManager.GetCurrent()?.GetActivity(indexPath: indexPath)
        {
            CreateActivityViewController.singleton.SetPreviousEndTime(date : activity.startDate)
        }
        
        CreateActivityViewController.singleton.delegate = self
        CreateActivityViewController.singleton.modalPresentationStyle = .overCurrentContext
        self.present(CreateActivityViewController.singleton, animated: true, completion: {})
    }
    
    func EditActivityRequest(_ sender: DayCollectionViewCell, dayIndex: Int, activityIndex: Int) {
        
        let indexPath = IndexPath(row: activityIndex, section: dayIndex)
        
        if ItineraryManager.HasCurrent() && ItineraryManager.GetCurrent()!.HasIndexPath(indexPath)
        {
            EditActivityViewController.singleton.SelectActivityAtIndexPath(indexPath)
            EditActivityViewController.singleton.delegate = self
            EditActivityViewController.singleton.modalPresentationStyle = .overCurrentContext
            self.present(EditActivityViewController.singleton, animated: true, completion: {})
        }
        else
        {
            NSLog("No activity for requested day and activity index")
        }

    }
    
    func DetailActivityRequest(_ sender: DayCollectionViewCell, dayIndex: Int, activityIndex: Int) {
        let indexPath = IndexPath(row: activityIndex, section: dayIndex)
        
        if ItineraryManager.HasCurrent() && ItineraryManager.GetCurrent()!.HasIndexPath(indexPath)
        {
            ActivityDetailViewController.singleton.SelectDay(dayIndex)
            ActivityDetailViewController.singleton.ScrollToActivity(activityIndex)
            self.navigationController?.pushViewController(ActivityDetailViewController.singleton, animated: true)
        }
        else
        {
            NSLog("No activity for requested day and activity index")
        }
    }
    
    func DidCreateActivity() {
        ReloadData()
    }
    
    func DidFinishEditActivity() {
        ReloadData()
    }
    
    
    func DidOpenLink(_ link: String) {
//
//        self.navigationController?.navigationBar.isTranslucent = false
//        WebViewController.singleton.LoadPage(urlString: link)
//        self.navigationController?.pushViewController(WebViewController.singleton, animated: true)
//        let svc = SFSafariViewController(url: URL(string: link)!)
//        self.present(svc, animated: true, completion: nil)
            guard var url = NSURL(string: link) else {
                print("INVALID URL")
                return
            }
            
            /// Test for valid scheme & append "http" if needed
        if url.scheme == nil || !(["http", "https"].contains(url.scheme!.lowercased())) {
                let appendedLink = "http://" + link
                
                url = NSURL(string: appendedLink)!
            }
            
        let safariViewController = SFSafariViewController(url: url as URL)
            //presentViewController(safariViewController, animated: true, completion: nil)
        self.navigationController?.present(safariViewController, animated: true, completion: nil)

    }
}
