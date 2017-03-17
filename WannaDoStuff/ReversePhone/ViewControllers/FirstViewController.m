//
//  FirstViewController.m
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "FirstViewController.h"
#import "SVProgressHUD.h"
#import "MainViewController.h"

#import "AppDelegate.h"

@interface FirstViewController () <UIAlertViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self checkPasscode];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkPasscode {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainViewController animated:NO];
}

@end
