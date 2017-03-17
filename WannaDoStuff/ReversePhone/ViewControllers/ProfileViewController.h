//
//  ProfileViewController.h
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMainViewController.h"

@interface ProfileViewController : SlideMainViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_firstname;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastname;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;

@property BOOL photoChanged;
@end
