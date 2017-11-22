//
//  OrderDetailVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 11/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SlideNavigationControllerDelegate {

    // MARK:- Outlet Decalation
    
    @IBOutlet var lblProductName: UILabel!
    
    @IBOutlet var tblOrderDetail: UITableView!
    
    // MARK:Other Variable
    var arrProductDetail = NSMutableArray()
    var dictSelectedProduct = NSMutableDictionary()
    
    var isServiceDropDownSelcted = false
    
    var intQuantity = 1
    
    //MARK:DropDowns
    let serviceDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.serviceDropDown
        ]}()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dictSelectedProduct)
        
        tblOrderDetail.rowHeight = UITableViewAutomaticDimension
        tblOrderDetail.estimatedRowHeight = 53//636.0
        
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    
    func initialization() {
        
        lblProductName.text = dictSelectedProduct.value(forKey: "product_name") as? String
        
        self.productInfoJson()
    }
    
    func calculateTotal() -> NSInteger {
        
        var intTotalPrice = 0
        
        if let intValue = dictSelectedProduct.value(forKey: "size_price") as? NSInteger {
            intTotalPrice = NSInteger(dictSelectedProduct.value(forKey: "price") as! String)! + intValue
        }else{
            intTotalPrice = NSInteger(dictSelectedProduct.value(forKey: "price") as! String)! + NSInteger(dictSelectedProduct.value(forKey: "size_price") as! String)!
        }
        
        for i in 0 ..< arrProductDetail.count {
            
            let dict = arrProductDetail.object(at: i) as! NSDictionary
            
            if dict.value(forKey: "selectedServiceName") != nil{
                
                if dict.value(forKey: "type") as! NSInteger == 1{
                    
                    if dict.value(forKey: "isSelected") != nil && dict.value(forKey: "isSelected") as! String == "true"{
                        
                        for j in 0 ..< (dict.value(forKey: "sub") as! NSArray).count {
                            
                            let dictIn = (dict.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                            
                            if dictIn.value(forKey: "isSelected") != nil && dictIn.value(forKey: "isSelected") as! String == "true"{
                                
                                intTotalPrice = intTotalPrice + (dictIn.value(forKey: "lable_price") as! NSInteger)
                            }
                        }
                    }
                }else{
                    
                    intTotalPrice = intTotalPrice + (dict.value(forKey: "selectedServicePrice") as! NSInteger)
                }
            }
        }
        return intTotalPrice * intQuantity
    }
    
    //MARK:- Webservice Call
    
    func productInfoJson()
    {
        ProjectUtility.loadingShow()
        
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/productinfo"
        let dict = ["product_id":dictSelectedProduct.value(forKey: "product_id")!]
        print("\(strUrl) == \(dict)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.post(NSURL(string: strUrl) as URL!, parameters: dict as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    print("response = ",dictData)
                    
                    if dictData.value(forKey: "success") as! Bool == true{
                        
                        self.arrProductDetail = (dictData.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        /*if self.dictSelectedProduct.value(forKey: "selectedServices") != nil {
                            
                            for i in 0 ..< self.arrProductDetail.count{
                                
                                let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                    
                                for j in 0 ..< (dictTemp.value(forKey: "sub") as! NSArray).count{
                                    
                                    let dictTempSub = (dictTemp.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                                    
                                    let index = ((self.dictSelectedProduct.value(forKey: "selectedServices") as! NSArray).value(forKey: "selectedServiceName") as AnyObject).index(of: (dictTempSub.value(forKey: "lable_option"))!)
                                    
                                    if index != NSNotFound{
                                        
                                        let intLableOption = dictTempSub.value(forKey: "lable_option") as? NSInteger
                                        
                                        if intLableOption != nil{
                                            dictTemp.setValue("\(dictTempSub.value(forKey: "lable_option")!)", forKey: "selectedServiceName")
                                        }else{
                                            dictTemp.setValue(dictTempSub.value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                                        }
                                        
                                        dictTemp.setValue(dictTempSub.value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
                                        
                                        dictTemp.setValue(Int(index), forKey: "selectedIndex")
                                        
                                        if dictTemp.value(forKey: "type") as! NSInteger == 1{
                                            
                                            dictTemp.setValue("true", forKey: "isSelected")
                                        }
                                    }else{
                                        let dictTempSub1 = (dictTemp.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                                        
                                        let intLableOption = dictTempSub1.value(forKey: "lable_option") as? NSInteger
                                        
                                        if intLableOption != nil{
                                            dictTemp.setValue("\(dictTempSub1.value(forKey: "lable_option")!)", forKey: "selectedServiceName")
                                        }else{
                                            dictTemp.setValue(dictTempSub1.value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                                        }
                                        
                                        dictTemp.setValue(dictTempSub1.value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
                                        
                                        dictTemp.setValue(0, forKey: "selectedIndex")
                                        
                                        if dictTemp.value(forKey: "type") as! NSInteger == 1{
                                            
                                            dictTemp.setValue("false", forKey: "isSelected")
                                        }
                                    }
                                }
                                
                                self.arrProductDetail.replaceObject(at: i, with: dictTemp)
                            }
                            
                        }else{*/
                        
                            for i in 0 ..< self.arrProductDetail.count{
                                
                                let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                
                                if (dictTemp.value(forKey: "sub") as! NSArray).count != 0{
                                        
                                    let intLableOption = ((dictTemp.value(forKey: "sub") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
                                    
                                    if intLableOption != nil{
                                        dictTemp.setValue("\(((dictTemp.value(forKey: "sub") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "lable_option")!)", forKey: "selectedServiceName")
                                    }else{
                                        dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                                    }
                                    
                                    dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
                                    
                                    dictTemp.setValue(0, forKey: "selectedIndex")
                                    
                                    if dictTemp.value(forKey: "type") as! NSInteger == 1{
                                        
                                        dictTemp.setValue("false", forKey: "isSelected")
                                    }
                                }
                                self.arrProductDetail.replaceObject(at: i, with: dictTemp)
                            }
                        
                        print("Product Detail = ",self.arrProductDetail)
                        
                        self.tblOrderDetail.reloadData()
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
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuLeft, withCompletion: nil)
    }
    
    @IBAction func btnCancelOrderAction(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirmOrderAction(_ sender: UIButton){
        
        let arrSelectedService = NSMutableArray()
        
        for i in 0 ..< arrProductDetail.count {
            
            let dict = arrProductDetail.object(at: i) as! NSDictionary
            
            if dict.value(forKey: "type") as! NSInteger == 1{
                
                if dict.value(forKey: "isSelected") != nil && dict.value(forKey: "isSelected") as! String == "true"{
                    
                    arrSelectedService.add(arrProductDetail.object(at: i))
                }
            }else if dict.value(forKey: "selectedServiceName") != nil {
                
                arrSelectedService.add(arrProductDetail.object(at: i))
            }
        }
        
        if arrSelectedService.count != 0{
            dictSelectedProduct.setValue(arrSelectedService, forKey: "selectedServices")
        }
        
        dictSelectedProduct.setValue(self.calculateTotal(), forKey: "grandTotal")
        dictSelectedProduct.setValue("\(intQuantity)", forKey: "quantity")
        
        
        if dictSelectedProduct.value(forKey: "cartSelectedTag") != nil{
            
            Constants.appDelegate.arrCartDetail.replaceObject(at: dictSelectedProduct.value(forKey: "cartSelectedTag") as! NSInteger, with: dictSelectedProduct)
            
        }else{
            Constants.appDelegate.arrCartDetail.add(dictSelectedProduct)
        }
        
        let archivedUser = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.arrCartDetail)
        UserDefaults.standard.setValue(archivedUser, forKey: "CartDetail")
        UserDefaults.standard.synchronize()
        
        if dictSelectedProduct.value(forKey: "cartSelectedTag") != nil{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = (storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC)
            controller.intFrom = 2
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
//        self.performSegue(withIdentifier: "orderConfirmation", sender: nil)
    }
    
    //MARK:Cell Events
    
    @IBAction func btnPreviousAction(_ sender: UIButton){
        
        
        
        let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if (dictTemp.value(forKey: "sub") as! NSArray).count != 0 {
            if dictTemp.value(forKey: "selectedIndex") as! NSInteger != 0 {
                
                var index = dictTemp.value(forKey: "selectedIndex") as! NSInteger
                index = index - 1
                
                dictTemp.setValue(index, forKey: "selectedIndex")
                
                let intLableOption = ((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
                
                if intLableOption != nil{
                    dictTemp.setValue("\(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option")!)", forKey: "selectedServiceName")
                }else{
                    dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                }
                
//                dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_price"), forKey: "selectedServicePrice")
                
                self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
                
                tblOrderDetail.reloadData()
            }
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton){
        
        let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if (dictTemp.value(forKey: "sub") as! NSArray).count != 0 {
            if dictTemp.value(forKey: "selectedIndex") as! NSInteger != (dictTemp.value(forKey: "sub") as! NSArray).count - 1 {
                
                var index = dictTemp.value(forKey: "selectedIndex") as! NSInteger
                index = index + 1
                
                dictTemp.setValue(index, forKey: "selectedIndex")
                
                let intLableOption = ((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
                
                if intLableOption != nil{
                    dictTemp.setValue("\(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option")!)", forKey: "selectedServiceName")
                }else{
                    dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                }
                
//                dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_option") as! String, forKey: "selectedServiceName")
                dictTemp.setValue(((dictTemp.value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_price"), forKey: "selectedServicePrice")
                
                self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
                
                tblOrderDetail.reloadData()
            }
        }
    }
    
    @IBAction func btnQuantityAction(_ sender: UIButton){
        
        if sender.tag == 1 {
            intQuantity = intQuantity + 1
        }else{
            if intQuantity != 1{
                intQuantity = intQuantity - 1
            }
        }
        
        tblOrderDetail.reloadData()
    }
    
    @IBAction func btnSelectOptionDropDownAction(_ sender: UIButton){
        
        
        let arrDropdownList = NSMutableArray()
        
        for i in 0 ..< ((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).count {
            
            let intLableOption = (((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
            
            if intLableOption != nil{
                arrDropdownList.add("\((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option")!)")
            }else{
                arrDropdownList.add((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as! String)
            }
        }
        
        ActionSheetStringPicker.show(withTitle: nil, rows: (arrDropdownList as NSArray) as! [String], initialSelection: 0, doneBlock: { (picker, index, value) in
            
            let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            dictTemp.setValue(value, forKey: "selectedServiceName")
            dictTemp.setValue((((self.arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
            
            self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
            
            self.tblOrderDetail.reloadData()
            
        }, cancel: { (ActionStringCancelBlock) in
                
        }, origin: sender)
        
//        self.setupSelectOptionDropDown(sender: sender)
//        serviceDropDown.show()
    }
    
    @IBAction func btnSelectQtyDropDownAction(_ sender: UIButton){
        
        let arrDropdownList = NSMutableArray()
        
        for i in 0 ..< ((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).count {
            
            let intLableOption = (((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
            
            if intLableOption != nil{
                arrDropdownList.add("\((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option")!)")
            }else{
                arrDropdownList.add((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as! String)
            }
        }
        
        ActionSheetStringPicker.show(withTitle: nil, rows: (arrDropdownList as NSArray) as! [String], initialSelection: 0, doneBlock: { (picker, index, value) in
            
            let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            dictTemp.setValue(value, forKey: "selectedServiceName")
            dictTemp.setValue((((self.arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
            
            self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
            
            self.tblOrderDetail.reloadData()
            
        }, cancel: { (ActionStringCancelBlock) in
            
        }, origin: sender)
//        self.setupSelectOptionDropDown(sender: sender)
//        serviceDropDown.show()
    }
    
    @IBAction func btnCheckBoxAction(_ sender: UIButton){
        
        let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if sender.isSelected == false{
            sender.isSelected = true
            dictTemp.setValue("true", forKey: "isSelected")
        }else{
            sender.isSelected = false
            dictTemp.setValue("false", forKey: "isSelected")
        }
        
        self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
        self.tblOrderDetail.reloadData()
    }
    
    @IBAction func btnCheckBoxSubAction(_ sender: UIButton){
        
        let intIndex = Int(sender.accessibilityIdentifier!)
        
        let dictTemp: NSMutableDictionary = (((arrProductDetail.object(at: intIndex!) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if sender.isSelected == false{
            sender.isSelected = true
            dictTemp.setValue("true", forKey: "isSelected")
            
//            let arrTempIn = ((arrProductDetail.object(at: intIndex!) as! NSDictionary).value(forKey: "sub") as! NSArray).mutableCopy() as! NSMutableArray
            
//            for i in 0 ..< arrTempIn.count {
//                
//                let dictTempIn: NSMutableDictionary = (arrTempIn.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//                
//                dictTempIn.setValue("false", forKey: "isSelected")
//                    
//                arrTempIn.replaceObject(at: i, with: dictTempIn)
//                
//                (self.arrProductDetail.object(at: intIndex!) as! NSMutableDictionary).setValue(arrTempIn, forKey: "sub")
//            }
            
        }else{
            sender.isSelected = false
            dictTemp.setValue("false", forKey: "isSelected")
        }
        
        let arrTemp = ((arrProductDetail.object(at: intIndex!) as! NSDictionary).value(forKey: "sub") as! NSArray).mutableCopy() as! NSMutableArray
        arrTemp.replaceObject(at: sender.tag, with: dictTemp)
        
        (self.arrProductDetail.object(at: intIndex!) as! NSMutableDictionary).setValue(arrTemp, forKey: "sub")
        self.tblOrderDetail.reloadData()
    }
    
    @IBAction func btnFullCleaningAction(_ sender: UIButton){
        
        if sender.isSelected == false{
            sender.isSelected = true
        }else{
            sender.isSelected = false
        }
    }
    
    @IBAction func btnSerivceDropDownAction(_ sender: UIButton){
        
        if isServiceDropDownSelcted == false{
            isServiceDropDownSelcted = true
        }else{
            isServiceDropDownSelcted = false
        }
        tblOrderDetail.reloadData()
        tblOrderDetail.scrollToRow(at: IndexPath.init(item: 0, section: 0), at: .bottom, animated: true)
    }
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        if tableView.tag == 1000{
            if self.arrProductDetail.count != 0{
                return self.arrProductDetail.count + 2
            }
        }else if tableView.tag == 1001{
            
            let intIndex = Int(tableView.accessibilityIdentifier!)
            return ((arrProductDetail.object(at: intIndex!) as! NSDictionary).value(forKey: "sub") as! NSArray).count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView.tag == 1000{
            if indexPath.row < self.arrProductDetail.count
            {
                if (arrProductDetail.object(at: indexPath.row) as! NSDictionary).value(forKey: "type") as! NSInteger == 0{
                    
                    let cell:OrderDetailWithDropTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailWithDropTableCell", for: indexPath as IndexPath) as! OrderDetailWithDropTableCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    cell.lblTitle.text = (self.arrProductDetail.object(at: indexPath.row) as! NSDictionary).value(forKey: "lable") as? String
                    
                    cell.btnSelectService.tag = indexPath.row
                    cell.btnSelectService.addTarget(self, action: #selector(self.btnSelectOptionDropDownAction(_:)), for: UIControlEvents.touchUpInside)
                    
                    if (arrProductDetail.object(at: indexPath.row) as! NSDictionary).value(forKey: "selectedServiceName") != nil{
                        
                        cell.lblServiceName.text = (arrProductDetail.object(at: indexPath.row) as! NSDictionary).value(forKey: "selectedServiceName") as? String
                        cell.lblServicePrice.text = "\((arrProductDetail.object(at: indexPath.row) as! NSDictionary).value(forKey: "selectedServicePrice") as! NSInteger) ريال"
                    }
                    
                    cell.viewDropDown.isHidden = false
                    
                    return cell;
                }else {
                    
                    let cell:OrderDetailCheckBoxTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCheckBoxTableCell", for: indexPath as IndexPath) as! OrderDetailCheckBoxTableCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    let dict = arrProductDetail.object(at: indexPath.row) as! NSDictionary
                    
                    cell.lblTitle.text = dict.value(forKey: "lable") as? String
                    
                    cell.btnSelectService.tag = indexPath.row
                    cell.btnSelectService.addTarget(self, action: #selector(self.btnSelectOptionDropDownAction(_:)), for: UIControlEvents.touchUpInside)
                    
                    cell.btnCheckBox.tag = indexPath.row
                    cell.btnCheckBox.addTarget(self, action: #selector(self.btnCheckBoxAction(_:)), for: UIControlEvents.touchUpInside)
                    
                    if dict.value(forKey: "isSelected") != nil && dict.value(forKey: "isSelected") as! String == "true"{
                        
                        cell.btnCheckBox.isSelected = true
                        
                        cell.tblList.tag = 1001
                        cell.tblList.accessibilityIdentifier = "\(indexPath.row)"
                        cell.tblList.delegate = self
                        cell.tblList.dataSource = self
                        cell.tblList.reloadData()
                        
                        cell.constTableListHeight.constant = (CGFloat((dict.value(forKey: "sub") as! NSArray).count)) * 53.0
                        
                    }else{
                        cell.btnCheckBox.isSelected = false
                        cell.constTableListHeight.constant = 0
                    }
                    
                    cell.viewDropDown.isHidden = true
                    
                    return cell
                }
            }else if indexPath.row == self.arrProductDetail.count{
                
                let cell:OrderDetailTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath as IndexPath) as! OrderDetailTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell.lblTitle.text = "كمية"
                cell.lblServiceName.text = "\(intQuantity)"
                
                cell.btnNext.tag = 1
                cell.btnPrevious.tag = 2
                
                cell.btnNext.addTarget(self, action: #selector(self.btnQuantityAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnPrevious.addTarget(self, action: #selector(self.btnQuantityAction(_:)), for: UIControlEvents.touchUpInside)
                
                return cell;
            }else{
                
                let cell:OrderDetailTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath as IndexPath) as! OrderDetailTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell.viewDropDown.isHidden = true
                
                cell.lblTitle.text = "المجموع الكلي"
                
                cell.lblServicePrice.text = "\(self.calculateTotal()) ريال"
                
                return cell
            }
        }else{
            let cell:OrderDetailCheckBoxTableCellSub = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCheckBoxTableCellSub", for: indexPath as IndexPath) as! OrderDetailCheckBoxTableCellSub
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let intIndex = Int(tableView.accessibilityIdentifier!)
            
            let dict = ((arrProductDetail.object(at: intIndex!) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: indexPath.row) as! NSDictionary
            
            cell.lblTitle.text = dict.value(forKey: "lable_option") as? String
            
            cell.lblServicePrice.text = "\(dict.value(forKey: "lable_price") as! NSInteger) ريال"
            
            cell.btnCheckBox.tag = indexPath.row
            cell.btnCheckBox.accessibilityIdentifier = tableView.accessibilityIdentifier
            cell.btnCheckBox.addTarget(self, action: #selector(self.btnCheckBoxSubAction(_:)), for: UIControlEvents.touchUpInside)
            
            if dict.value(forKey: "isSelected") != nil && dict.value(forKey: "isSelected") as! String == "true"{
                
                cell.btnCheckBox.isSelected = true
            }else{
                cell.btnCheckBox.isSelected = false
            }
            
            return cell
        }
    }
    
    //MARK: Setup Dropdown
    
    func setupSelectOptionDropDown(sender: UIButton) {
        serviceDropDown.anchorView = sender
        serviceDropDown.bottomOffset = CGPoint(x: 0, y: 40)
        
        let arrDropdownList = NSMutableArray()
        
        for i in 0 ..< ((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).count {
            
            let intLableOption = (((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as? NSInteger
            
            if intLableOption != nil{                
                arrDropdownList.add("\((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option")!)")
            }else{
                arrDropdownList.add((((arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "lable_option") as! String)
            }
        }
        
        serviceDropDown.dataSource = (arrDropdownList as NSArray) as! [String]
        
        serviceDropDown.selectionAction = { [unowned self] (index, item) in
            
            let dictTemp: NSMutableDictionary = (self.arrProductDetail.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            dictTemp.setValue(item, forKey: "selectedServiceName")
            dictTemp.setValue((((self.arrProductDetail.object(at: sender.tag) as! NSDictionary).value(forKey: "sub") as! NSArray).object(at: index) as! NSDictionary).value(forKey: "lable_price") as! NSInteger, forKey: "selectedServicePrice")
            
            self.arrProductDetail.replaceObject(at: sender.tag, with: dictTemp)
            
            self.tblOrderDetail.reloadData()
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let arrSelectedService = NSMutableArray()
        
        for i in 0 ..< arrProductDetail.count {
            
            let dict = arrProductDetail.object(at: i) as! NSDictionary
            
            if dict.value(forKey: "type") as! NSInteger == 1{
                
                if dict.value(forKey: "isSelected") != nil && dict.value(forKey: "isSelected") as! String == "true"{
                    
                    arrSelectedService.add(arrProductDetail.object(at: i))
                }
            }else if dict.value(forKey: "selectedServiceName") != nil {
                
                arrSelectedService.add(arrProductDetail.object(at: i))
            }
        }
        
        if arrSelectedService.count != 0{
            dictSelectedProduct.setValue(arrSelectedService, forKey: "selectedServices")
        }
        
        dictSelectedProduct.setValue(self.calculateTotal(), forKey: "grandTotal")
        dictSelectedProduct.setValue("\(intQuantity)", forKey: "quantity")
        
        
        let vc: OrderConfirmVC = segue.destination as! OrderConfirmVC
        vc.dictSelectedProduct = dictSelectedProduct
    }
    
    //MARK: - SlideNavigationController Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

class OrderDetailWithDropTableCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblServicePrice: UILabel!
    
    @IBOutlet var btnSelectService: UIButton!
    
    @IBOutlet var viewDropDown: UIView!
}



class OrderDetailTableCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblServicePrice: UILabel!

//    @IBOutlet var btnSelectService: UIButton!
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnPrevious: UIButton!
    
    @IBOutlet var viewDropDown: UIView!
}

class OrderDetailCheckBoxTableCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblServicePrice: UILabel!
    
    @IBOutlet var btnSelectService: UIButton!
    @IBOutlet var btnCheckBox: UIButton!
    
    @IBOutlet var viewDropDown: UIView!
    
    @IBOutlet var tblList: UITableView!
    @IBOutlet var constTableListHeight: NSLayoutConstraint!
}

class OrderDetailCheckBoxTableCellSub: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblServicePrice: UILabel!
    
    @IBOutlet var btnSelectService: UIButton!
    @IBOutlet var btnCheckBox: UIButton!
    
    @IBOutlet var viewDropDown: UIView!
}

