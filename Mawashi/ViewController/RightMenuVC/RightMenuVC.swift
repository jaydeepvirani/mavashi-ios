//
//  LeftMenuVC.swift
//  yump
//
//  Created by Fusion on 16/07/16.
//  Copyright © 2016 Fusion. All rights reserved.
//

import UIKit
import Social

class RightMenuVC: UIViewController
{
    var cellIdentifier = NSString()
    var arrMenuTitle : NSMutableArray = ["Preferences", "Personalize Alerts", "Messages", "Terms", "Contact us", "Login"]
    var arrMenuImages : NSMutableArray = ["person-settings-icon", "alertz_icon", "notification_icon", "terms_condition_icon", "contact_us", "Logout New"]
    var arrMenuHighlights : NSMutableArray = ["light", "dark", "dark", "light","light", "dark"]
    
    @IBOutlet var btnCallUs: UIButton!

    //MARK:- View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(RightMenuVC.reloadUserData), name: NSNotification.Name(rawValue: "reloadUserData"), object: nil)
        
        self.reloadUserData()
    }
    
    func reloadUserData()
    {
        btnCallUs.setTitle(Constants.appDelegate.strContactNumber, for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews()
    {
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        if sender.tag == 1 {
            
            let parentViewController = SlideNavigationController.sharedInstance().viewControllers.last!
            let className = NSStringFromClass(parentViewController.classForCoder)
            
            if className == "Mawashi.DashboardVC"
            {
                SlideNavigationController.sharedInstance().closeMenu(completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = (storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC)
                SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            }
            
        }else if sender.tag == 2 {
            
            let parentViewController = SlideNavigationController.sharedInstance().viewControllers.last!
            let className = NSStringFromClass(parentViewController.classForCoder)
            
            if className == "Mawashi.AboutUsVC"
            {
                SlideNavigationController.sharedInstance().closeMenu(completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = (storyboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC)
                SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            }
            
        }else if sender.tag == 3 {
            
            let parentViewController = SlideNavigationController.sharedInstance().viewControllers.last!
            let className = NSStringFromClass(parentViewController.classForCoder)
            
            if className == "Mawashi.OurVisionVC"
            {
                SlideNavigationController.sharedInstance().closeMenu(completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = (storyboard.instantiateViewController(withIdentifier: "OurVisionVC") as! OurVisionVC)
                SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            }
            
        }else if sender.tag == 4 {
            
            let parentViewController = SlideNavigationController.sharedInstance().viewControllers.last!
            let className = NSStringFromClass(parentViewController.classForCoder)
            
            if className == "Mawashi.BankAccountsVC"
            {
                SlideNavigationController.sharedInstance().closeMenu(completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = (storyboard.instantiateViewController(withIdentifier: "BankAccountsVC") as! BankAccountsVC)
                SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            }
            
        }else if sender.tag == 5 {
            
            let parentViewController = SlideNavigationController.sharedInstance().viewControllers.last!
            let className = NSStringFromClass(parentViewController.classForCoder)
            
            if className == "Mawashi.InquiryVC"
            {
                SlideNavigationController.sharedInstance().closeMenu(completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = (storyboard.instantiateViewController(withIdentifier: "InquiryVC") as! InquiryVC)
                SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            }
        }else if sender.tag == 6 {
            
            Constants.appDelegate.strContactNumber = Constants.appDelegate.strContactNumber.replacingOccurrences(of: " ", with: "")
            
            if let url = NSURL(string: "tel://\(Constants.appDelegate.strContactNumber)") , UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }else{
                ProjectUtility.displayTost(erroemessage: "لا يمكنك إجراء مكالمة")
            }
        }
    }
    
    @IBAction func btnFBShareAction(_ sender: UIButton){
        var url = URL(string: "")
        url = URL(string: "https://www.facebook.com/profile.php?id=100009996046678")
        if url != nil {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    @IBAction func btnTwitterShareAction(_ sender: UIButton){
        var url = URL(string: "")
        url = URL(string: "https://twitter.com/mawaashi?lang=ar")
        if url != nil {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    @IBAction func btnInstaShareAction(_ sender: UIButton){
        var url = URL(string: "")
        url = URL(string: "https://www.instagram.com/mawaashi/")
        if url != nil {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
}
