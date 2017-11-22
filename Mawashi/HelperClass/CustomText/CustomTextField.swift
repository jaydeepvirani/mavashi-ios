//
//  CustomTextField.swift
//  RedFootStep
//
//  Created by Ashesh on 10/06/16.
//  Copyright © 2016 Ashesh. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    let  arrNoOfTextfiled = NSMutableArray()
    
    @IBInspectable var TextBound: CGFloat = 8
    @IBInspectable var EditBound: CGFloat = 8
    @IBInspectable var MaxValue: NSInteger = 500
    @IBInspectable var DataType: NSString = ""
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    // MARK: - Class Life Cycle
    
    override internal func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    required internal init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        
        self.delegate = self
//        self.addTarget(self, action: #selector(CustomTextField.Didbegin), forControlEvents: UIControlEvents.EditingDidBegin)
    }
    
    required internal override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    // MARK: - TextBound or EditingBound
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.insetBy(dx: TextBound,dy: EditBound)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.insetBy(dx: TextBound , dy: TextBound)
    }
    
    // MARK: - TextFieldDidEditing
    
    @IBAction func KeyBoardStroke(_ sender: AnyObject)
    {
        var txt: UITextField!
        
        txt = sender as! UITextField
        
        if (txt.text?.characters.count)! > MaxValue
        {
            var str:NSString
            str = txt.text! as NSString
            
            str = str.substring(to: MaxValue) as NSString
            txt.text = str as String
        }
        
        if DataType == "Numeric"
        {
            let inverseSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        if DataType == "Numeric+Punctuation"
        {
            let inverseSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        if DataType == "Character"
        {
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        if DataType == "Numeric+Character"
        {
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        if DataType == "Character+Punctuation"
        {
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<>?:}{+|_)(*&^%$#@!~,./'=-0;").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        if DataType == "Email"
        {
            let inverseSet = NSCharacterSet(charactersIn: "abcdegfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@_").inverted
            let components = txt.text!.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
            
            return txt.text = filtered
            
        }
        self .ValidateTextfield(txtValue: txt.text! as NSString)
    }
    
    // MARK: - Texfield ShouldReturn
    
    @IBAction func KeyBoardHide(textfield: UITextField)
    {
        var intIndex: NSInteger
        var txtfield = textfield
        
        intIndex = arrNoOfTextfiled .index(of: txtfield)
        
        if txtfield.returnKeyType == UIReturnKeyType.next
        {
            if intIndex < arrNoOfTextfiled.count
            {
                txtfield = arrNoOfTextfiled.object(at: intIndex+1) as! UITextField
                txtfield .becomeFirstResponder()
                return
            }
        }
        else if txtfield.returnKeyType == UIReturnKeyType.done
        {
            txtfield.resignFirstResponder()
            return
        }
    }
    
    // MARK: - TextField Editing Begin
    
    func Didbegin()
    {
        if let wd = self.window
        {
            var vc = wd.rootViewController
            if(vc is UINavigationController)
            {
                vc = (vc as! UINavigationController).visibleViewController
            }
            for subv in (vc?.view.subviews)!
            {
                if let textField:UITextField = subv as? UITextField
                {
                    arrNoOfTextfiled.add(textField);
                }
            }
        }
    }
    
    // MARK: - Validation Method
    
    func ValidateTextfield(txtValue: NSString)
    {
        
    }
    
}
