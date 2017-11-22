//
//  OrderConfirmVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 13/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class OrderConfirmVC: UIViewController, CLLocationManagerDelegate, SlideNavigationControllerDelegate {

    // MARK:- Outlet Decalation
    @IBOutlet var tblOrderConfirmDetail: UITableView!
    
    //MARK: Address Confirmation Popup
    @IBOutlet var viewAddressConfirmPopup: UIView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtLocation: UITextField!
    
    @IBOutlet var imgCity: UIImageView!
    @IBOutlet var imgLocation: UIImageView!
    
    @IBOutlet var constAddressViewTop: NSLayoutConstraint!
    @IBOutlet var constAddressViewBottom: NSLayoutConstraint!
    
    @IBOutlet var scrlViewAddress: UIScrollView!
    
    // MARK:Other Variable
    var dictSelectedProduct = NSMutableDictionary()
    let locationManager = CLLocationManager()
    
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    //MARK:DropDowns
    let cityDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.cityDropDown
        ]}()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dictSelectedProduct)
        
        tblOrderConfirmDetail.rowHeight = UITableViewAutomaticDimension
        tblOrderConfirmDetail.estimatedRowHeight = 487.0
        
        viewAddressConfirmPopup.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewAddressConfirmPopup)
        viewAddressConfirmPopup.isHidden = true
        
        if Constants.ScreenSize.SCREEN_HEIGHT == 568 {
            constAddressViewTop.constant = 50
            constAddressViewBottom.constant = 50
        }
        
        imgCity.layer.borderColor = UIColor.init(red: 201/255.0, green: 203/255.0, blue: 204/255.0, alpha: 1.0).cgColor
        imgCity.layer.borderWidth = 1.0
        
        imgLocation.layer.borderColor = UIColor.init(red: 201/255.0, green: 203/255.0, blue: 204/255.0, alpha: 1.0).cgColor
        imgLocation.layer.borderWidth = 1.0
        
        if UserDefaults.standard.value(forKey: "Address") != nil {
            
            let unarchivedObject = UserDefaults.standard.object(forKey: "Address") as? NSData
            
            let dictAddress = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject! as Data) as! NSMutableDictionary
            
            txtName.text = dictAddress.value(forKey: "addressName") as? String
            txtEmail.text = dictAddress.value(forKey: "addressEmail") as? String
            txtMobile.text = dictAddress.value(forKey: "addressMobile") as? String
            txtCity.text = dictAddress.value(forKey: "addressCity") as? String
            txtAddress.text = dictAddress.value(forKey: "address") as? String
            txtLocation.text = dictAddress.value(forKey: "location") as? String
            currentLatitude = Double((dictAddress.value(forKey: "latitude") as! NSString) as String)!
            currentLongitude = Double((dictAddress.value(forKey: "longitude") as! NSString) as String)!
        }
        
        ProjectUtility.loadingShow()
        self.view.endEditing(true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuRight, withCompletion: nil)
    }
    
    @IBAction func btnConfirmAction(_ sender: UIButton){
        
        if dictSelectedProduct.value(forKey: "address") == nil {
            
            viewAddressConfirmPopup.isHidden = false
            ProjectUtility.animatePopupView(viewPopup: viewAddressConfirmPopup)
        }else{
            
            self.performSegue(withIdentifier: "bankAccountsSegue", sender: nil)
        }
    }
    
    @IBAction func btnCancelOrderAction(_ sender: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Address Confirmation Popup
    
    @IBAction func btnCloseAddressPopupAction(_ sender: UIButton){
        
        viewAddressConfirmPopup.isHidden = true
    }
    
    @IBAction func btnCityDropDownAction(_ sender: UIButton){
        
        let arrDropdownList = NSMutableArray()
        arrDropdownList.add("الرياض")
        
        ActionSheetStringPicker.show(withTitle: nil, rows: (arrDropdownList as NSArray) as! [String], initialSelection: 0, doneBlock: { (picker, index, value) in
                self.txtCity.text = "الرياض"
            }, cancel: { (ActionStringCancelBlock) in
                
            }, origin: sender)
    }
    
    @IBAction func btnLocationAction(_ sender: UIButton){
        
        ProjectUtility.loadingShow()
        self.view.endEditing(true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func btnConfirmAddressPopupAction(_ sender: UIButton){
        
        if txtName.text == "" {
            
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال الاسم")
//        }else if txtEmail.text == "" {
//            
//            ProjectUtility.displayTost(erroemessage: "يرجى إدخال البريد الإلكتروني")
//        }else if ProjectUtility.validateEmail(emailStr: txtEmail.text!) == false{
//            
//            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال عنوان بريد إلكتروني صالح")
        }else if txtMobile.text == "" {
            
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال الجوال")
        }else if txtCity.text == "" {
            
            ProjectUtility.displayTost(erroemessage: "الرجاء اختيار المدينة")
        }else if txtAddress.text == "" {
            
            ProjectUtility.displayTost(erroemessage: "الرجاء إدخال عنوان")
        }else{

            dictSelectedProduct.setValue(txtName.text, forKey: "addressName")
            dictSelectedProduct.setValue(txtEmail.text, forKey: "addressEmail")
            dictSelectedProduct.setValue(txtMobile.text, forKey: "addressMobile")
            dictSelectedProduct.setValue(txtCity.text, forKey: "addressCity")
            dictSelectedProduct.setValue(txtAddress.text, forKey: "address")
            dictSelectedProduct.setValue(txtLocation.text, forKey: "location")
            dictSelectedProduct.setValue("\(currentLatitude)", forKey: "latitude")
            dictSelectedProduct.setValue("\(currentLongitude)", forKey: "longitude")
            tblOrderConfirmDetail.reloadData()
            
            viewAddressConfirmPopup.isHidden = true
            self.view.endEditing(true)
            
            let archivedUser = NSKeyedArchiver.archivedData(withRootObject: dictSelectedProduct)
            UserDefaults.standard.setValue(archivedUser, forKey: "Address")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Cell Event
    @IBAction func btnEditOrderAction(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditAddressAction(_ sender: UIButton){
        
        viewAddressConfirmPopup.isHidden = false
        ProjectUtility.animatePopupView(viewPopup: viewAddressConfirmPopup)
    }

    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell:OrderConfirmTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderConfirmTableCell", for: indexPath as IndexPath) as! OrderConfirmTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if dictSelectedProduct.value(forKey: "address") == nil {
            cell.viewAddress.isHidden = true
        }else{
            cell.viewAddress.isHidden = false
            
            let strAddress = (dictSelectedProduct.value(forKey: "addressName") as! String) + "\n" + (dictSelectedProduct.value(forKey: "addressEmail") as! String) + "\n" + (dictSelectedProduct.value(forKey: "addressMobile") as! String) + "\n" + (dictSelectedProduct.value(forKey: "addressCity") as! String) + "\n" + (dictSelectedProduct.value(forKey: "address") as! String)
            
            cell.lblAddress.text = strAddress
        }
        
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
            
//            if dictTemp.value(forKey: "selectedServices") != nil && (dictTemp.value(forKey: "selectedServices") as! NSArray).count == 1 {
//                
//                strProducts = strProducts + "\n"
//            }
            
            strProducts = strProducts + "\n"
            
            /*if dictTemp.value(forKey: "selectedServices") != nil{
                for i in 0 ..< (dictTemp.value(forKey: "selectedServices") as! NSArray).count {
                    
                    let dictTemp = (dictTemp.value(forKey: "selectedServices") as! NSArray).object(at: i) as! NSDictionary
                    
                    if dictTemp.value(forKey: "type") as! NSInteger == 1{
                        
                        for j in 0 ..< (dictTemp.value(forKey: "sub") as! NSArray).count {
                            
                            let dictIn = (dictTemp.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                            
                            if dictIn.value(forKey: "isSelected") != nil && dictIn.value(forKey: "isSelected") as! String == "true"{
                                
                                if strProducts != "" {
                                    strProducts = strProducts + "\n"
                                }
                                
                                strProducts = strProducts + (dictIn.value(forKey: "lable_option") as! String)// + " " + (dictTemp.value(forKey: "lable") as! String)
                                
                                strProducts = strProducts + "\t" + "\((dictIn.value(forKey: "lable_price") as! NSInteger))" + "ريال "
                            }
                        }
                    }else{
                        
                        if strProducts != "" {
                            strProducts = strProducts + "\n"
                        }
                        
                        strProducts = strProducts + (dictTemp.value(forKey: "selectedServiceName") as! String)// + " " + (dictTemp.value(forKey: "lable") as! String)
                        
                        strProducts = strProducts + "\t" + "\((dictTemp.value(forKey: "selectedServicePrice") as! NSInteger))" + "ريال "
                    }
                }
            }
            strProducts = strProducts + "\n"*/
        }
        
        if Constants.appDelegate.arrCartDetail.count == 1 {
            strProducts = strProducts + "\n"
        }
        
        cell.lblServices.text = strProducts
        
        cell.lblTotal.text = "\(intGrandTotal) ريال"
        
        return cell;
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc: BankAccountsVC = segue.destination as! BankAccountsVC
        vc.dictSelectedProduct = dictSelectedProduct
    }
    
    //MARK:- Setup Dropdown
    
    func setupCityDropDown(sender: UIButton) {
        cityDropDown.anchorView = sender
        cityDropDown.bottomOffset = CGPoint(x: 0, y: 40)
        
        cityDropDown.dataSource = ["الرياض"]
        
        cityDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.txtCity.text = item
        }
    }
    
    //MARK:- Location Manager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLatitude = (manager.location?.coordinate.latitude)!
        currentLongitude = (manager.location?.coordinate.longitude)!
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            ProjectUtility.loadingHide()
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        ProjectUtility.loadingHide()
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            var strAddress = ""
            
            if containsPlacemark.name != nil {
                strAddress = containsPlacemark.name! + " "
            }
            if containsPlacemark.subThoroughfare != nil {
                strAddress = strAddress + containsPlacemark.subThoroughfare! + " "
            }
            if containsPlacemark.thoroughfare != nil {
                strAddress = strAddress + containsPlacemark.thoroughfare! + " "
            }
            if containsPlacemark.locality != nil {
                strAddress = strAddress + containsPlacemark.locality! + " "
            }
            if containsPlacemark.administrativeArea != nil {
                strAddress = strAddress + containsPlacemark.administrativeArea! + " "
            }
            if containsPlacemark.postalCode != nil {
                strAddress = strAddress + containsPlacemark.postalCode! + " "
            }
            if containsPlacemark.country != nil {
                strAddress = strAddress + containsPlacemark.country! + " "
            }

            print(strAddress)
            
            txtLocation.text = strAddress
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

class OrderConfirmTableCell: UITableViewCell {
    
    //MARK: Order Detail
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblServices: UILabel!
    
    //MARK: Address
    @IBOutlet var viewAddress: UIView!
    
    @IBOutlet var lblAddress: UILabel!
}
