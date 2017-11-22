//
//  OurVisionVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 22/05/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class OurVisionVC: UIViewController, SlideNavigationControllerDelegate {

    // MARK:- Outlet Decalation
    @IBOutlet var txtViewOurVision: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        
                        self.txtViewOurVision.text = (dictData.value(forKey: "data") as! NSDictionary).value(forKey: "our_vision") as? String
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
    
    //MARK: - SlideNavigationController Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return true
    }
}
