//
//  AddEventViewController.h
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMainViewController.h"

@interface AddEventViewController : SlideMainViewController

@property (weak, nonatomic) IBOutlet UITextView *txt_title;
@property (weak, nonatomic) IBOutlet UITextView *txt_details;
@property (weak, nonatomic) IBOutlet UITextField *txt_location;
@property (weak, nonatomic) IBOutlet UIButton *txt_date;
@property (weak, nonatomic) IBOutlet UIButton *txt_time;
@property (weak, nonatomic) IBOutlet UITextField *txt_link;
@property (weak, nonatomic) IBOutlet UIButton *btn_post;
@property (weak, nonatomic) IBOutlet UIButton *selectDateBtn;
@end
