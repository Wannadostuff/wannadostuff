//
//  ContactViewController.h
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMainViewController.h"

@interface ContactViewController : SlideMainViewController
    @property (weak, nonatomic) IBOutlet UITextField *txt_title;
    @property (weak, nonatomic) IBOutlet UITextView *txt_content;
    @property (weak, nonatomic) IBOutlet UIButton *btn_submit;
@end
