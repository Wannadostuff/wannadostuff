//
//  MainViewController.h
//  ReversePhone
//
//  Created by Mac on 21/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface MainViewController : UIViewController
   // id, first_name, last_name, name, gender, picture, birthday, email

    @property (nonatomic, strong) UserData *userData;

@end
