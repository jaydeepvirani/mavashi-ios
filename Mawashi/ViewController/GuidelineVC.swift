//
//  GuidelineVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 11/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class GuidelineVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var colGuideline: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue("true", forKey: "isFirstTime")
        UserDefaults.standard.synchronize()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnNextAction(_ sender: UIButton){
        
        for cell in colGuideline.visibleCells {
            let currentIndex = colGuideline.indexPath(for: cell)
            
            if currentIndex?.row != 2 {
                let nextIndex = IndexPath.init(item: (currentIndex?.row)!+1, section: 0)
                self.colGuideline.scrollToItem(at: nextIndex as IndexPath, at: UICollectionViewScrollPosition.right, animated: true)
                
                pageControl.currentPage = nextIndex.row
            }else{
                self.performSegue(withIdentifier: "dashboard", sender: nil)
            }
        }
    }
    
    @IBAction func btnSkipAction(_ sender: UIButton){
        self.performSegue(withIdentifier: "dashboard", sender: nil)
    }
    
    //MARK:- Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: GuidelineCollectionCell = colGuideline.dequeueReusableCell(withReuseIdentifier: "GuidelineCollectionCell", for: indexPath as IndexPath) as! GuidelineCollectionCell
        
        if indexPath.row == 0 || indexPath.row == 2{
            cell.imgMain.image = UIImage(named: "guideline_1")
        }else{
            cell.imgMain.image = UIImage(named: "guideline_2")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT - 214)
    }
    
    //MARK:- ScrollView
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == colGuideline {
            
            for cell in colGuideline.visibleCells {
                
                let indexPath = colGuideline.indexPath(for: cell)
                pageControl.currentPage = (indexPath?.row)!
            }
        }
    }
}


class GuidelineCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgMain: UIImageView!
}
