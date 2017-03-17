//
//  UIPlaceHolderTextView.h
//  WannaDoStuff
//
//  Created by Mac on 11/11/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <Foundation/Foundation.h>
IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
