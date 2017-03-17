//
//  SignUpViewController.m
//  ReversePhone
//
//  Created by Mac on 21/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "SignUpViewController.h"
#import "ReportViewController.h"
#import "EnterPassCodeViewController.h"
#import "SVProgressHUD.h"

#import "AppDelegate.h"

@interface SignUpViewController () <UIAlertViewDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signupOnClick:(id)sender {
    NSString *passcode = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyPassCode];
    if(passcode == nil) {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [UIView transitionWithView:appDelegate.window duration:2 options:(UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionAllowAnimatedContent) animations:^{
            appDelegate.window.rootViewController = appDelegate.slideViewController;
        } completion:nil];
    } else {
        EnterPassCodeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPassCodeViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
