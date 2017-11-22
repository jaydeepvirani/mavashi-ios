//
//  AboutUsVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 13/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit
import Social

class AboutUsVC: UIViewController, SlideNavigationControllerDelegate {

    // MARK:- Outlet Decalation
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var txtViewAboutUs: UITextView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constants.DeviceLanguage.deviceLanguage == "ar-US" || Constants.DeviceLanguage.deviceLanguage == "ar" {
            
            btnBack.setImage(UIImage(named: "next_icon"), for: .normal)
        }
        
        self.getContentJson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Webservice Call
    
    func getContentJson()
    {
        ProjectUtility.loadingShow()
        
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/contents"
        print("\(strUrl)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.get(NSURL(string: strUrl) as URL!, parameters: nil as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            print("response = ",response?.webserviceResponse)
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    if dictData.value(forKey: "status") as! NSInteger == 1 {
                        
                        self.txtViewAboutUs.text = (dictData.value(forKey: "data") as! NSDictionary).value(forKey: "about_us") as? String
                    }
                    
                    return
                }
            }
            
            ProjectUtility.displayTost(erroemessage: "Product list is not available.")
        }) { (error) -> Void in
            
            print("error = ",error)
            ProjectUtility.loadingHide()
            ProjectUtility.displayTost(erroemessage: "We are having some problem")
        }
    }
    

    //MARK:- Button TouchUp
    
    @IBAction func btnBackAction(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuRight, withCompletion: nil)
    }
    
    @IBAction func btnSocialMediaAction(_ sender: UIButton){
        if sender.tag == 1 {
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                
                var strAppstoreURL = "الان حمل تطبيق مواشي واطلب ذبيحتك بالطريقة التي تفضلها"
                strAppstoreURL = strAppstoreURL + "https://itunes.apple.com/sa/app/%D9%85%D9%88%D8%A7%D8%B4%D9%8A/id1064952301?mt=8"
                
                vc.setInitialText(strAppstoreURL)
                present(vc, animated: true)
            }
        }else if sender.tag == 2{
            
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                
                var strAppstoreURL = "الان حمل تطبيق مواشي واطلب ذبيحتك بالطريقة التي تفضلها"
                strAppstoreURL = strAppstoreURL + "https://itunes.apple.com/sa/app/%D9%85%D9%88%D8%A7%D8%B4%D9%8A/id1064952301?mt=8"
                
                vc.setInitialText(strAppstoreURL)
                present(vc, animated: true)
            }
            
        }else if sender.tag == 3{
            
            var strAppstoreURL = "الان حمل تطبيق مواشي واطلب ذبيحتك بالطريقة التي تفضلها"
            strAppstoreURL = strAppstoreURL + "https://itunes.apple.com/sa/app/%D9%85%D9%88%D8%A7%D8%B4%D9%8A/id1064952301?mt=8"
            
            let textToShare:Array = [strAppstoreURL] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - SlideNavigationController Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return true
    }
}
