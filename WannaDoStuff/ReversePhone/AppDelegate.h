//
//  AppDelegate.h
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) MMDrawerController * slideViewController;

//@property (nonatomic, retain) UINavigationController * reportNavigationController;
//@property (nonatomic, retain) UINavigationController * creditsNavigationController;
//@property (nonatomic, retain) UINavigationController * settingNavigationController;


@property (nonatomic, retain) UINavigationController * newsFeedNavigationController;
@property (nonatomic, retain) UINavigationController * eventsNavigationController;
@property (nonatomic, retain) UINavigationController * addEventNavigationController;
@property (nonatomic, retain) UINavigationController * chatNavigationController;
//@property (nonatomic, retain) UINavigationController * bookingsListNavigationController;
@property (nonatomic, retain) UINavigationController * profileNavigationController;

@property (nonatomic, retain) UINavigationController * settingNavigationController;
@property (nonatomic, retain) UINavigationController * contactNavigationController;
@property (nonatomic, retain) UINavigationController * FAQNavigationController;
@property (nonatomic, retain) UINavigationController * mainNavigationController;

- (void)switchNavigationController:(UINavigationController*)navigationController;

@end

