//
//  DashboardVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 11/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController, MWPhotoBrowserDelegate, SlideNavigationControllerDelegate, UIGestureRecognizerDelegate {

    // MARK:- Outlet Decalation
    @IBOutlet var tblList: UITableView!
    
    @IBOutlet var imgCartCount: UIImageView!
    @IBOutlet var lblCartCount: UILabel!
    
    // MARK:- Other Variable
    var arrProductList = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if arrProductList.count == 0 {
            
            ProjectUtility.loadingShow()
        }
        self.productListJson()
        
        imgCartCount.clipsToBounds = true
        imgCartCount.layer.cornerRadius = 9.0
        
        lblCartCount.text = "\(Constants.appDelegate.arrCartDetail.count)"
        
        let intTime: Int = Int((Int64)(1 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(intTime) / Double(NSEC_PER_SEC), execute: {() -> Void in
            DispatchQueue.main.async(execute: {(_: Void) -> Void in
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            })
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    //MARK:- Webservice Call
    
    func productListJson()
    {
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/productlist"
        print("\(strUrl)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.get(NSURL(string: strUrl) as URL!, parameters: nil as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            ProjectUtility.loadingHide()
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    print("response = ",dictData)
                    
                    if dictData.value(forKey: "status") as! NSString == "1"{
                        
                        self.arrProductList = ObjectiveCMethods.arrayByReplacingNulls(withBlanks: (dictData.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray as [AnyObject])
//                        self.arrProductList = (dictData.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        self.tblList.reloadData()
                    }
                    
                    return
                }
            }
            
            ProjectUtility.displayTost(erroemessage: "قائمة المنتجات غير متوفرة")
        }) { (error) -> Void in
            
            print("error = ",error!)
            ProjectUtility.loadingHide()
            ProjectUtility.displayTost(erroemessage: "نحن نواجه بعض المشاكل")
        }
    }

    //MARK:- Button TouchUp
    
    @IBAction func btnMenuAction(_ sender: UIButton){
        
        SlideNavigationController.sharedInstance().open(MenuLeft, withCompletion: nil)
    }
    
    @IBAction func btnMyCartAction(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC)
        controller.intFrom = 1
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Cell Event
    
    @IBAction func btnPhotoAction(_ sender: UIButton){
        
        tblList.tag = sender.tag
        
        let browser = MWPhotoBrowser.init(delegate: self)
        browser?.displayActionButton = false
        
        let navigationController = UINavigationController.init(rootViewController: browser!)
        browser?.setCurrentPhotoIndex(0)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(navigationController, animated: false, completion: nil)
    }
    
    @IBAction func btnCartAction(_ sender: UIButton){
        
        tblList.tag = sender.tag
        self.performSegue(withIdentifier: "selectSizeSegue", sender: nil)
    }
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell:DashboardTableCell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath as IndexPath) as! DashboardTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblName.text = (arrProductList.object(at: indexPath.row) as! NSDictionary).value(forKey: "product_name") as? String
        
        cell.btnPhoto.tag = indexPath.row
        cell.btnPhoto.addTarget(self, action: #selector(DashboardVC.btnPhotoAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnCart.tag = indexPath.row
        cell.btnCart.addTarget(self, action: #selector(DashboardVC.btnCartAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.imgProduct.sd_setImage(with: NSURL(string: (arrProductList.object(at: indexPath.row) as! NSDictionary).value(forKey: "product_image") as! String) as URL!)

        cell.lblPrice.text =  ((arrProductList.object(at: indexPath.row) as! NSDictionary).value(forKey: "price") as? String)! + " " + "ريال"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tblList.tag = indexPath.row
        self.performSegue(withIdentifier: "selectSizeSegue", sender: nil)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        return Constants.ScreenSize.SCREEN_HEIGHT * 0.7346
    }
    
    // MARK:- MWPhotoBrowserDelegate
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        
        return 1
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        
        return MWPhoto.init(url: NSURL(string: (arrProductList.object(at: tblList.tag) as! NSDictionary).value(forKey: "product_image") as! String) as URL!)
//        return MWPhoto.init(image: UIImage.init(named: "list_img"))
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc: SelectSizeVC = segue.destination as! SelectSizeVC
        vc.dictSelectedProduct = (arrProductList.object(at: tblList.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        vc.dictSelectedProduct.setValue(tblList.tag, forKey: "cartIndex")
    }
    
    //MARK: - SlideNavigationController Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

class DashboardTableCell: UITableViewCell {
    
    @IBOutlet var btnPhoto: UIButton!
    @IBOutlet var btnCart: UIButton!
    
    @IBOutlet var imgProduct: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
}
