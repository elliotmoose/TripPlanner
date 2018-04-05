//
//  ActivityDetailViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 1/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ActivityDetailCollectionViewCellDelegate,EditActivityViewControllerDelegate {

    public static let singleton = ActivityDetailViewController(nibName: "ActivityDetailViewController", bundle: Bundle.main)
    
    private var selectedDayIndex : Int?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ActivityDetailViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ActivityDetailViewController", owner: self, options: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ActivityDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ActivityDetailCollectionViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("no implementation")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //ResetScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ReloadData()
    }
    
    func ResetScene()
    {
        //self.selectedDayIndex = nil
    }
    
    func ReloadData()
    {
        self.collectionView.reloadData()
    }
    
    func SelectDay(_ index : Int)
    {
        selectedDayIndex = index
    }
    
    func ScrollToActivity(_ index : Int)
    {
        let indexPath = IndexPath(row: index, section: 0)
        
        if collectionView.cellForItem(at: indexPath) != nil
        {
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let index = selectedDayIndex
        {
            if let day = ItineraryManager.GetCurrent()?.GetDay(index: index)
            {
                return day.GetActivitiesCount()
            }
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityDetailCollectionViewCell", for: indexPath) as! ActivityDetailCollectionViewCell

        cell.delegate = self
        
        if let activity = ItineraryManager.GetCurrent()?.GetDay(index: selectedDayIndex!)?.GetActivity(index: indexPath.row)
        {
            cell.DisplayActivity(activity)
        }
        else
        {
            NSLog("No activity for index path \(indexPath)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Sizing.ScreenWidth() - 32
        let height = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight - 24
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    
    //DELEGATE FUNCTIONS
    func DidPressEdit(_ sender: ActivityDetailCollectionViewCell) {
        if let dayIndex = selectedDayIndex
        {
            let activityIndex = collectionView.indexPath(for: sender)!.row
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
        else
        {
            NSLog("No Day selected for activity detail view")
        }
    }
    
    func DidPressDelete(_ sender: ActivityDetailCollectionViewCell) {
        if let dayIndex = selectedDayIndex
        {
            let activityIndex = collectionView.indexPath(for: sender)!.row
            let indexPath = IndexPath(row: activityIndex, section: dayIndex)
            
            if ItineraryManager.HasCurrent() && ItineraryManager.GetCurrent()!.HasIndexPath(indexPath)
            {
                let activityname = ItineraryManager.GetCurrent()!.GetDay(index: dayIndex)!.GetActivity(index: activityIndex)!.name
                PopupManager.singleton.PopupWithCancel(title: "Confirm", body: "Are you sure you want to delete activity: \(activityname)", presentationViewCont: self, handler: {
                    ItineraryManager.GetCurrent()?.RemoveActivityAtIndexPath(indexPath)
                    self.ReloadData()
                })
            }
            else
            {
                NSLog("No activity for requested day and activity index")
            }
        }
        else
        {
            NSLog("No Day selected for activity detail view")
        }
    }
    
    func DidFinishEditingNotes(_ sender: ActivityDetailCollectionViewCell,newNote : String) {
        if newNote == "" || newNote == "tap to enter notes"
        {
            return
        }
        
        if let dayIndex = selectedDayIndex
        {
            let activityIndex = collectionView.indexPath(for: sender)!.row
            let indexPath = IndexPath(row: activityIndex, section: dayIndex)
            
            if let itinerary = ItineraryManager.GetCurrent()
            {
                if let activity = itinerary.GetDay(index: indexPath.section)?.GetActivity(index: indexPath.row)
                {
                    activity.SetNote(newNote)
                }
            }
            else
            {
                NSLog("No activity for requested day and activity index")
            }

        }
        else
        {
            NSLog("No Day selected for activity detail view")
        }
    }
    
    func DidFinishEditActivity() {
        ReloadData()
    }
    
    
    
    
}
