//
//  BankAccountsVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 13/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class BankAccountsVC: UIViewController {

    // MARK:- Outlet Decalation
    @IBOutlet var tblBankList: UITableView!
    
    @IBOutlet var btnBack: UIButton!
    
    // MARK: BankDetail Popup
    @IBOutlet var viewBankDetailPopup: UIView!
    
    @IBOutlet var imgBankIcon: UIImageView!
    @IBOutlet var lblBankName: UILabel!
    @IBOutlet var txtViewBankAccountNumber: UITextView!
    
    // MARK: OrderNumber Popup
    @IBOutlet var viewOrderNumberPopup: UIView!
    @IBOutlet var viewOrderNumberPopupIn: UIView!
    @IBOutlet var lblOrderNumber: UILabel!
    
    // MARK: PaymentOption Popup
    @IBOutlet var viewPaymentOptionPopup: UIView!
    @IBOutlet var tblOrderDetail: UITableView!
    @IBOutlet var btnViaBank: UIButton!
    @IBOutlet var btnCashOnDelivery: UIButton!
    
    @IBOutlet var imgViaBank: UIImageView!
    @IBOutlet var imgCashOnDelivery: UIImageView!
    
    // MARK:Other Variable
    var arrBankList = NSMutableArray()
    var dictSelectedProduct = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dictSelectedProduct)
        
        tblOrderDetail.rowHeight = UITableViewAutomaticDimension
        tblOrderDetail.estimatedRowHeight = 195.0
        
        if Constants.DeviceLanguage.deviceLanguage == "ar-US" || Constants.DeviceLanguage.deviceLanguage == "ar" {
            btnBack.setImage(UIImage(named: "next_icon"), for: .normal)
        }
        
        viewBankDetailPopup.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewBankDetailPopup)
        viewBankDetailPopup.isHidden = true
        
        viewOrderNumberPopup.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewOrderNumberPopup)
        viewOrderNumberPopup.isHidden = true
        
        viewPaymentOptionPopup.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewPaymentOptionPopup)
        viewPaymentOptionPopup.isHidden = true
        
        
        imgBankIcon.layer.cornerRadius = 43.0
        imgBankIcon.clipsToBounds = true
        
        if dictSelectedProduct.value(forKey: "address") == nil{
            self.bankListJson()
        }else{
            viewPaymentOptionPopup.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Webservice Call
    
    func bankListJson()
    {
        ProjectUtility.loadingShow()
        
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/banklist"
        print("\(strUrl)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.get(NSURL(string: strUrl) as URL!, parameters: nil as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    print("response = ",dictData)
                    
                    if dictData.value(forKey: "status") as! NSString == "1"{
                        
                        self.arrBankList = (dictData.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        self.tblBankList.reloadData()
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
    
    func orderInfoJson()
    {
        ProjectUtility.loadingShow()
        
        var strProductId = ""
        var strOptions = ""
        var strSheepType = ""
        var strProductSize = ""
        var intGrandTotal = 0
        var strQuantity = ""
        
        for i in 0 ..< Constants.appDelegate.arrCartDetail.count {
            
            let dictProductDetail = Constants.appDelegate.arrCartDetail.object(at: i) as! NSMutableDictionary
            
            //Product Id
            if strProductId != "" {
                strProductId = strProductId + ","
            }
            strProductId = strProductId + ("\(dictProductDetail.value(forKey: "product_id")!)")
            
            //Sheep Type
            if strSheepType != "" {
                strSheepType = strSheepType + ","
            }
            strSheepType = strSheepType + ("\(dictProductDetail.value(forKey: "product_name")!)")
            
            //Product Size
            if strProductSize != "" {
                strProductSize = strSheepType + ","
            }
            strProductSize = strSheepType + ("\(dictProductDetail.value(forKey: "size_name")!)")
            
            //Grand Total
            intGrandTotal = intGrandTotal + (dictProductDetail.value(forKey: "grandTotal") as! NSInteger)
            
            //Quantity
            if strQuantity != "" {
                strQuantity = strQuantity + ","
            }
            strQuantity = strQuantity + ("\(dictProductDetail.value(forKey: "quantity")!)")
            
            //Options
            if dictProductDetail.value(forKey: "selectedServices") != nil{
                strOptions = strOptions + "["
                
                for j in 0 ..< (dictProductDetail.value(forKey: "selectedServices") as! NSArray).count {
                    
                    let dictSelectedServices = (dictProductDetail.value(forKey: "selectedServices") as! NSArray).object(at: j) as! NSDictionary
                    
                    if j != 0 {
                        strOptions = strOptions + ","
                    }
                    
                    if dictSelectedServices.value(forKey: "type") as! NSInteger == 1{
                        
                        for j in 0 ..< (dictSelectedServices.value(forKey: "sub") as! NSArray).count {
                            
                            let dictSub = (dictSelectedServices.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                            
                            if dictSub.value(forKey: "isSelected") != nil && dictSub.value(forKey: "isSelected") as! String == "true"{
                                
                                strOptions = strOptions + "{\"lable\":\"\(dictSelectedServices.value(forKey: "lable")!)\",\"option\":\"\(dictSub.value(forKey: "lable_option")!)\",\"price\":\"\(dictSub.value(forKey: "lable_price")!)\"}"
                            }
                        }
                    }else{
                        strOptions = strOptions + "{\"lable\":\"\(dictSelectedServices.value(forKey: "lable")!)\",\"option\":\"\(dictSelectedServices.value(forKey: "selectedServiceName")!)\",\"price\":\"\(dictSelectedServices.value(forKey: "selectedServicePrice")!)\"}"
                    }
                }
                strOptions = strOptions + "]"
            }
            
            if i < Constants.appDelegate.arrCartDetail.count - 1{
                strOptions = strOptions + "#"
            }
        }
        
        let strBankDetail = ""
        var strPaymentType = "2"
        
        if btnViaBank.isSelected == true {
//            strBankDetail = (arrBankList.object(at: viewBankDetailPopup.tag) as! NSDictionary).value(forKey: "id") as! String
            strPaymentType = "1"
        }
        
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/orderinfo"
        let dict = ["product_id":strProductId, "name":dictSelectedProduct.value(forKey: "addressName")!, "city":dictSelectedProduct.value(forKey: "addressCity")!, "email":dictSelectedProduct.value(forKey: "addressEmail")!, "number":dictSelectedProduct.value(forKey: "addressMobile")!, "address":dictSelectedProduct.value(forKey: "address")!, "grand_total":intGrandTotal, "sheep_type":strSheepType, "product_size":strProductSize, "bank_detail":strBankDetail, "options":strOptions, "location":dictSelectedProduct.value(forKey: "location") as! String, "quantity":strQuantity, "payment_type":strPaymentType, "latitude":dictSelectedProduct.value(forKey: "latitude")!, "longitude":dictSelectedProduct.value(forKey: "longitude")!]
        print("\(strUrl) == \(dict)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.post(NSURL(string: strUrl) as URL!, parameters: dict as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    print("response = ",dictData)
                    
                    if dictData.value(forKey: "success") as! Bool == true{
                        
                        ProjectUtility.displayTost(erroemessage: "شكرا لطلبكم ، وسنتواصل معكم في اقرب فرصة")
                        
                        self.viewOrderNumberPopup.isHidden = false
//                        ProjectUtility.animatePopupView(viewPopup: self.viewOrderNumberPopup)
                        
                        self.lblOrderNumber.text = "\(dictData.value(forKey: "data") as! NSInteger)"
                        
                        Constants.appDelegate.arrCartDetail.removeAllObjects()
                        UserDefaults.standard.removeObject(forKey: "CartDetail")
                        UserDefaults.standard.synchronize()
                        
                        return
                    }
                }
            }
            ProjectUtility.displayTost(erroemessage: "نحن نواجه بعض المشاكل")
            
        }) { (error) -> Void in
            
            print("error = ",error)
            ProjectUtility.loadingHide()
            ProjectUtility.displayTost(erroemessage: "نحن نواجه بعض المشاكل")
        }
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnBackAction(_ sender: UIButton){
        
//        _ = self.navigationController?.popViewController(animated: true)
        
        for controller: Any in (self.navigationController?.viewControllers)! {
            if (controller is DashboardVC) {
                self.navigationController?.popToViewController(controller as! DashboardVC, animated: true)
                return
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC)
        SlideNavigationController.sharedInstance().pushViewController(controller, animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(Menu(rawValue: UInt32(Constants.appDelegate.menuType)), withCompletion: nil)
    }
    
    //MARK: BankDetail Popup
    
    @IBAction func btnCloseBankDetailPopupAction(_ sender: UIButton){
        
        viewBankDetailPopup.isHidden = true
    }
    
    @IBAction func btnOkAction(_ sender: UIButton){
        
        viewBankDetailPopup.isHidden = true
        
//        if dictSelectedProduct.value(forKey: "address") != nil{
//            
//            if btnViaBank.isSelected == true {
//                self.orderInfoJson()
//            }
//        }
    }
    
    //MARK: OrderNumber Popup
    
    @IBAction func btnOkOrderNumberAction(_ sender: UIButton){
        
        viewBankDetailPopup.isHidden = true
        viewOrderNumberPopup.isHidden = true
        dictSelectedProduct = NSMutableDictionary()
        if sender.tag == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = (storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC)
            SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
        }else{
            self.bankListJson()
        }
    }
    
    // MARK: PaymentOption Popup
    @IBAction func btnPaymentOptionsAction(_ sender: UIButton){
        
        btnViaBank.isSelected = false
        btnCashOnDelivery.isSelected = false
        
        imgViaBank.image = UIImage.init(named: "unchecked")
        imgCashOnDelivery.image = UIImage.init(named: "unchecked")
        
        if sender.tag == 1{
            btnViaBank.isSelected = true
            imgViaBank.image = UIImage.init(named: "checked")
        }else{
            btnCashOnDelivery.isSelected = true
            imgCashOnDelivery.image = UIImage.init(named: "checked")
        }
    }
    
    @IBAction func btnOkPaymentOptionPopupAction(_ sender: UIButton){
        
        viewPaymentOptionPopup.isHidden = true
        
        if dictSelectedProduct.value(forKey: "address") != nil{
            
//            if btnViaBank.isSelected == true {
//                self.bankListJson()
//            }else{
                self.orderInfoJson()
//            }
        }
    }
    
    @IBAction func btnClosePaymentOptionPopupAction(_ sender: UIButton){
        
        viewPaymentOptionPopup.isHidden = true
    }
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView == tblBankList{
            return arrBankList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == tblBankList{
            let cell:BankAccountTableCell = tableView.dequeueReusableCell(withIdentifier: "BankAccountTableCell", for: indexPath as IndexPath) as! BankAccountTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblBankName.text = (arrBankList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
            
            cell.imgBankIcon.sd_setImage(with: NSURL(string: (arrBankList.object(at: indexPath.row) as! NSDictionary).value(forKey: "bank_logo") as! String) as URL!)
            
            if Constants.DeviceLanguage.deviceLanguage == "ar-US" || Constants.DeviceLanguage.deviceLanguage == "ar" {
                
                cell.imgArrow.image = UIImage(named: "previous_icon_gray")
            }
            
            return cell;
        }else{
            
            let cell:OrderConfirmTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderConfirmTableCell", for: indexPath as IndexPath) as! OrderConfirmTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            var strProducts = ""
            var intGrandTotal = 0
            
            for i in 0 ..< Constants.appDelegate.arrCartDetail.count {
                
                let dictTemp = Constants.appDelegate.arrCartDetail.object(at: i) as! NSMutableDictionary
                
                
                
                if strProducts != "" {
                    strProducts = strProducts + "\n"
                }
                
                strProducts = strProducts + (dictTemp.value(forKey: "product_name") as! String)
                
                intGrandTotal = intGrandTotal + ((Constants.appDelegate.arrCartDetail.object(at: i) as! NSMutableDictionary).value(forKey: "grandTotal") as! NSInteger)
                
                if dictTemp.value(forKey: "selectedServices") != nil{
                    for i in 0 ..< (dictTemp.value(forKey: "selectedServices") as! NSArray).count {
                        
                        
                        let dictTemp = (dictTemp.value(forKey: "selectedServices") as! NSArray).object(at: i) as! NSDictionary
                        
                        if dictTemp.value(forKey: "type") as! NSInteger == 1{
                            
                            for j in 0 ..< (dictTemp.value(forKey: "sub") as! NSArray).count {
                                
                                let dictIn = (dictTemp.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                                
                                if dictIn.value(forKey: "isSelected") != nil && dictIn.value(forKey: "isSelected") as! String == "true"{
                                    
                                    if strProducts != "" {
                                        strProducts = strProducts + "\n"
                                    }
                                    
                                    strProducts = strProducts + (dictTemp.value(forKey: "lable") as! String + " " + (dictIn.value(forKey: "lable_option") as! String))
                                }
                            }
                        }else{
                            
                            if strProducts != "" {
                                strProducts = strProducts + "\n"
                            }
                            
                            strProducts = strProducts + (dictTemp.value(forKey: "lable") as! String) + " " + (dictTemp.value(forKey: "selectedServiceName") as! String)
                        }
                    }
                }
                
                if strProducts != "" {
                    strProducts = strProducts + "\n"
                }
                
                strProducts = strProducts + "\(dictTemp.value(forKey: "quantity")!) كمية"
                
                strProducts = strProducts + "\n"
            }
            
            if Constants.appDelegate.arrCartDetail.count == 1 {
                strProducts = strProducts + "\n"
            }
            
            cell.lblServices.text = strProducts
            
            cell.lblTotal.text = "\(intGrandTotal) ريال"
            
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if tableView == tblBankList {
            viewBankDetailPopup.isHidden = false
            
            lblBankName.text = (arrBankList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
            txtViewBankAccountNumber.text = (arrBankList.object(at: indexPath.row) as! NSDictionary).value(forKey: "number") as? String
            imgBankIcon.sd_setImage(with: NSURL(string: (arrBankList.object(at: indexPath.row) as! NSDictionary).value(forKey: "bank_logo") as! String) as URL!)
            
            ProjectUtility.animatePopupView(viewPopup: viewBankDetailPopup)
            
            viewBankDetailPopup.tag = indexPath.row
        }
    }
}

class BankAccountTableCell: UITableViewCell {
    
    @IBOutlet var imgBankIcon: UIImageView!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var lblBankName: UILabel!
}
