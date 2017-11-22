//
//  MyCartVC.swift
//  مواشي
//
//  Created by Sandeep Gangajaliya on 19/06/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class MyCartVC: UIViewController, SlideNavigationControllerDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var tblMycartList: UITableView!
    
    @IBOutlet var btnConfirmOrder: UIButton!
    @IBOutlet var btnAddMore: UIButton!
    
    @IBOutlet var lblTotalPrice: UILabel!
    
    //MARK: Other Variable
    var intFrom = 0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Constants.appDelegate.arrCartDetail)
        
        tblMycartList.rowHeight = UITableViewAutomaticDimension
        tblMycartList.estimatedRowHeight = 80.0
        
        btnConfirmOrder.layer.cornerRadius = 5.0
        btnConfirmOrder.layer.borderColor = UIColor.white.cgColor
        btnConfirmOrder.layer.borderWidth = 1.0
        
        btnAddMore.layer.cornerRadius = 5.0
        btnAddMore.layer.borderColor = UIColor.white.cgColor
        btnAddMore.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.countTotalPrice()
        
        tblMycartList.reloadData()
    }
    
    func countTotalPrice(){
        var intGrandTotal = 0
        
        for i in 0 ..< Constants.appDelegate.arrCartDetail.count {
            intGrandTotal = intGrandTotal + ((Constants.appDelegate.arrCartDetail.object(at: i) as! NSMutableDictionary).value(forKey: "grandTotal") as! NSInteger)
        }
        
        lblTotalPrice.text = "الإجمالي" + " : " + "\(intGrandTotal)"
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction(_ sender: UIButton){
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        
        if intFrom == 1 {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        }else if intFrom == 2{
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
        }
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuRight, withCompletion: nil)
    }
    
    @IBAction func btnConfirmOrderAction(_ sender: UIButton){
        
        if Constants.appDelegate.arrCartDetail.count != 0{
            self.performSegue(withIdentifier: "orderConfirmation", sender: nil)
        }else{
            ProjectUtility.displayTost(erroemessage: "يرجى فيلوب سلة التسوق الخاصة بك")
        }
    }
    
    //MARK: Cell Event
    @IBAction func btnTrashAction(_ sender: UIButton){
        
        Constants.appDelegate.arrCartDetail.removeObject(at: sender.tag)
        tblMycartList.reloadData()
        
        let archivedUser = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.arrCartDetail)
        UserDefaults.standard.setValue(archivedUser, forKey: "CartDetail")
        UserDefaults.standard.synchronize()
        
        self.countTotalPrice()
    }
    
    @IBAction func btnEditAction(_ sender: UIButton){
        
        tblMycartList.tag = sender.tag
        self.performSegue(withIdentifier: "selectSizeSegue", sender: nil)
    }
    
    
    //MARK:- UITeableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return Constants.appDelegate.arrCartDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell:MyCartTableCell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableCell", for: indexPath as IndexPath) as! MyCartTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dictTemp = Constants.appDelegate.arrCartDetail.object(at: indexPath.row) as! NSMutableDictionary
        
        cell.lblTitle.text = dictTemp.value(forKey: "product_name") as? String
        
        cell.imgProduct.sd_setImage(with: NSURL(string: dictTemp.value(forKey: "product_image") as! String) as URL!)
        
        cell.imgProduct.clipsToBounds = true
        cell.imgProduct.layer.cornerRadius = 5.0
        
        var strServices = ""
        if dictTemp.value(forKey: "selectedServices") != nil{
            for i in 0 ..< (dictTemp.value(forKey: "selectedServices") as! NSArray).count {
                
                
                let dictTemp = (dictTemp.value(forKey: "selectedServices") as! NSArray).object(at: i) as! NSDictionary
                
                if dictTemp.value(forKey: "type") as! NSInteger == 1{
                    
                    for j in 0 ..< (dictTemp.value(forKey: "sub") as! NSArray).count {
                        
                        let dictIn = (dictTemp.value(forKey: "sub") as! NSArray).object(at: j) as! NSDictionary
                        
                        if dictIn.value(forKey: "isSelected") != nil && dictIn.value(forKey: "isSelected") as! String == "true"{
                            
                            if strServices != "" {
                                strServices = strServices + "\n"
                            }
                            
                            strServices = strServices + (dictTemp.value(forKey: "lable") as! String) + " " + (dictIn.value(forKey: "lable_option") as! String)
                        }
                    }
                }else{
                    
                    if strServices != "" {
                        strServices = strServices + "\n"
                    }
                    
                    strServices = strServices + (dictTemp.value(forKey: "lable") as! String) + " " + (dictTemp.value(forKey: "selectedServiceName") as! String)
                }
            }
        }
        
        if strServices != "" {
            strServices = strServices + "\n"
        }
        
        strServices = strServices + " \(dictTemp.value(forKey: "quantity")!) كمية"
        
        if dictTemp.value(forKey: "selectedServices") != nil && (dictTemp.value(forKey: "selectedServices") as! NSArray).count == 1 {
            
            strServices = strServices + "\n"
        }
        
        cell.lblDescription.text = strServices
        cell.lblPrice.text = "ريال \(dictTemp.value(forKey: "grandTotal")!)"
        
        cell.btnTrash.tag = indexPath.row
        cell.btnTrash.addTarget(self, action: #selector(self.btnTrashAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(self.btnEditAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectSizeSegue" {
            let vc: SelectSizeVC = segue.destination as! SelectSizeVC
            vc.dictSelectedProduct = (Constants.appDelegate.arrCartDetail.object(at: tblMycartList.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            vc.dictSelectedProduct.setValue(tblMycartList.tag, forKey: "cartSelectedTag")
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

class MyCartTableCell: UITableViewCell {
    
    @IBOutlet var imgProduct: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var btnTrash: UIButton!
    @IBOutlet var btnEdit: UIButton!
}
