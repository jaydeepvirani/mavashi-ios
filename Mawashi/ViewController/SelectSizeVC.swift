//
//  SelectSizeVC.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 21/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit

class SelectSizeVC: UIViewController {

    // MARK:- Outlet Decalation
    
    @IBOutlet var tblSelectSize: UITableView!
    
    
    // MARK:- Other Variable
    var dictSelectedProduct = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func btnBackAction(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSizeActionAction(_ sender: UIButton){
        
        dictSelectedProduct.setValue(((dictSelectedProduct.value(forKey: "size") as! NSArray).object(at: sender.tag) as! NSDictionary).value(forKey: "size_id"), forKey: "size_id")
        dictSelectedProduct.setValue(((dictSelectedProduct.value(forKey: "size") as! NSArray).object(at: sender.tag) as! NSDictionary).value(forKey: "size_name"), forKey: "size_name")
        dictSelectedProduct.setValue(((dictSelectedProduct.value(forKey: "size") as! NSArray).object(at: sender.tag) as! NSDictionary).value(forKey: "price"), forKey: "size_price")
        self.performSegue(withIdentifier: "orderDetailSegue", sender: nil)
    }
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return (dictSelectedProduct.value(forKey: "size") as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell:SelectSizeTableSize = tableView.dequeueReusableCell(withIdentifier: "SelectSizeTableSize", for: indexPath as IndexPath) as! SelectSizeTableSize
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.btnSize.layer.cornerRadius = 5.0
        cell.btnSize.layer.borderColor = UIColor.white.cgColor
        cell.btnSize.layer.borderWidth = 1.0
        
        let strTitle = (((dictSelectedProduct.value(forKey: "size") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "size_name") as? String)! + " : " + "\((((dictSelectedProduct.value(forKey: "size") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "price"))!)" + " " + "ريال"
        
        cell.btnSize.setTitle(strTitle, for: UIControlState.normal)
        
        cell.btnSize.tag = indexPath.row
        cell.btnSize.addTarget(self, action: #selector(self.btnSizeActionAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell;
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc: OrderDetailVC = segue.destination as! OrderDetailVC
        vc.dictSelectedProduct = dictSelectedProduct
    }
}

class SelectSizeTableSize: UITableViewCell {
    
    @IBOutlet var btnSize: UIButton!
}
