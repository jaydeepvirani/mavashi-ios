//
//  ProjectUtility.swift
//  Happy Roads
//
//  Created by fiplmac1 on 01/10/16.
//  Copyright © 2016 fusion. All rights reserved.
//

import UIKit

class ProjectUtility: NSObject
{
    class func animatePopupView (viewPopup: UIView)
    {
        viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001);
        
        UIView.animate(withDuration: 0.3/1.5, animations: {
            
            viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.3/2, animations: {
                viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9);
                }, completion: { (finished) in
                    
                    UIView.animate(withDuration: 0.3/2, animations: {
                        viewPopup.transform = CGAffineTransform.identity;
                    })
            })
        }
    }
    
    class func loadingShow()
    {
        let loader = Loader()
        loader.show(UIColor.black)
    }
    
    class func loadingHide()
    {
        let loader = Loader()
        loader.hide()
    }
    
    class func changeDateFormate (strDate: String, strFormatter1 strDateFormatter1: String, strFormatter2 strDateFormatter2: String) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter1
        
        if let date = dateFormatter.date(from: strDate)
        {
            dateFormatter.dateFormat = strDateFormatter2
            
            if let strConvertedDate:NSString = dateFormatter.string(from: date) as NSString?
            {
                return strConvertedDate
            }
        }
        return ""
    }
    
    class func dateFromString (strDate: String, strFormatter strDateFormatter: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        if let convertedDate = dateFormatter.date(from: strDate)
        {
            return convertedDate
        }
        return Date()
    }
    
    class func displayTost(erroemessage: String)
    {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        
        let style = CSToastStyle.init(defaultStyle: ())
        style?.messageFont = UIFont.boldSystemFont(ofSize: 15.0)
        style?.messageColor = UIColor.white
        style?.messageAlignment = .center
        style?.titleAlignment = .center
        style?.backgroundColor = UIColor.init(red: 52.0 / 255.0, green: 109.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
        appDelegate.window?.makeToast(erroemessage, duration: 2.5, position: CSToastPositionBottom, style: style)
    }
    
    class func validateEmail(emailStr: String) -> Bool
    {
        let emailRegex: String = "^[_\\p{L}\\p{Mark}0-9-]+(\\.[_\\p{L}\\p{Mark}0-9-]+)*@[\\p{L}\\p{Mark}0-9-]+(\\.[\\p{L}\\p{Mark}0-9]+)*(\\.[\\p{L}\\p{Mark}]{2,})$"
        let predicateForEmail: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValidated: Bool = predicateForEmail.evaluate(with: emailStr)
        return isValidated
    }
}
