//
//  InquiryVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 13/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class InquiryVC: UIViewController, SlideNavigationControllerDelegate {

    // MARK:- Outlet Decalation
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtContactNumber: UITextField!
    @IBOutlet var txtViewMessage: UITextView!
    
    @IBOutlet var constButtonSendBottom: NSLayoutConstraint!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if Constants.DeviceLanguage.deviceLanguage == "ar-US" || Constants.DeviceLanguage.deviceLanguage == "ar" {
            
            btnBack.setImage(UIImage(named: "next_icon"), for: .normal)
        }
        
        constButtonSendBottom.constant = Constants.ScreenSize.SCREEN_WIDTH * 0.2458770615
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func inquiryJson()
    {
        ProjectUtility.loadingShow()
        
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/inquery"
        let dict = ["name":txtName.text!, "email":txtEmail.text!, "contact_num":txtContactNumber.text!, "message":txtViewMessage.text!]
        print("\(strUrl) == \(dict)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.post(NSURL(string: strUrl) as URL!, parameters: dict as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            ProjectUtility.displayTost(erroemessage: "تم إرسال استفسارك")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = (storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC)
            SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
            
        }) { (error) -> Void in
            
            print("error = ",error)
            ProjectUtility.loadingHide()
            ProjectUtility.displayTost(erroemessage: "نحن نواجه بعض المشاكل")
        }
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnBackAction(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuRight, withCompletion: nil)
    }
    
    @IBAction func btnSubmitInquiry(_ sender: UIButton){
        
        if txtName.text == ""{
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال الاسم")
        }else if txtEmail.text == ""{
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال عنوان البريد الإلكتروني")
        }else if txtViewMessage.text == ""{
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال رسالة")
        }else{
            self.inquiryJson()
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
