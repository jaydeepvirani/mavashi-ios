//
//  UIPlaceHolderTextView.h
//  Venue Owner
//
//  Created by Sandeep Gangajaliya on 31/08/16.
//  Copyright © 2016 Sandeep Gangajaliya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

@property (nonatomic, retain) UILabel *placeHolderLabel;

-(void)textChanged:(NSNotification*)notification;

@end
