//
//  SettingViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "TermOfServiceViewController.h"
#import "PrivacyPolicyViewController.h"

@implementation SettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goTermOfServiceOnClick:(id)sender {
    TermOfServiceViewController *termOfServiceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermOfServiceViewController"];
    [self.navigationController pushViewController:termOfServiceViewController animated:YES];
}

- (IBAction)goPrivacyPolicyOnClick:(id)sender {
    PrivacyPolicyViewController *privacyPolicyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    [self.navigationController pushViewController:privacyPolicyViewController animated:YES];
}

@end
