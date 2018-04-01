//
//  ActivityDetailViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 1/4/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    public static let singleton = ActivityDetailViewController(nibName: "ActivityDetailViewController", bundle: Bundle.main)
    
    public var selectedDayIndex : Int?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ActivityDetailViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("ActivityDetailViewController", owner: self, options: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ActivityDetailTableViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ActivityDetailTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("no implementation")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityDetailTableViewCell", for: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Sizing.ScreenWidth()
        let height = Sizing.ScreenHeight() - Sizing.tabBarHeight - Sizing.statusBarHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
    

}
