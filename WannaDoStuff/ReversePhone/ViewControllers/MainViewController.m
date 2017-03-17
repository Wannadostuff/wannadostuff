//
//  MainViewController.m
//  ReversePhone
//
//  Created by Mac on 21/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MBProgressHUD.h"
#import "WebServicesClient.h"


@interface MainViewController ()


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }

    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    if (_userData) {
        if (![_userData.facebookID isEqualToString:@""])
            [self getLoginData];
    }
}

-(BOOL) accessTokenIsLocalyValid
{
    return [FBSDKAccessToken currentAccessToken] && [[NSDate date] compare:[FBSDKAccessToken currentAccessToken].expirationDate] == NSOrderedAscending;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLoginOnClick:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in");
        }
        
        NSDictionary *fields = @{ @"fields" : @"id, first_name, last_name, name, gender, picture, birthday, email"};
        if ([FBSDKAccessToken currentAccessToken]) {
            
//            [SVProgressHUD showWithStatus:@"Fetching data from facebook." maskType:SVProgressHUDMaskTypeBlack];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Fetching data from facebook.";
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters: fields] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    
                    if ([result[@"id"] length] == 0) {
                        //[self gotoSignUp:nil];
                        return;
                    }else{
                        
                        hud.labelText = @"Fetching data from server.";
                        
                        if([result[@"id"] length] != 0){
                            _userData.facebookID = result[@"id"];
                        }
                        if([result[@"name"] length] != 0){
                            _userData.userName = result[@"name"];
                        }
                        if([result[@"email"] length] != 0){
                            _userData.userEmail = result[@"email"];
                        }
                        if([result[@"first_name"] length] != 0){
                            _userData.firstName = result[@"first_name"];
                        }
                        if([result[@"last_name"] length] != 0){
                            _userData.lastName = result[@"last_name"];
                        }
                        if([result[@"gender"] length] != 0){
                            _userData.gender = result[@"gender"];
                        }
                        if([result[@"birthday"] length] != 0){
                            
                            NSDate *todayDate = [NSDate date];
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                            int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:result[@"birthday"]]];
                            int allDays = (((time/60)/60)/24);
                            int days = allDays%365;
                            int years = (allDays-days)/365;
                            _userData.age = [NSString stringWithFormat:@"%ld", (long)years];
                        }
                        if([[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"] length] != 0){
                            _userData.photoURL = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                        }
                        [hud hide:YES];
                        [self getLoginData];

                    }
                }
            }];

        }
    }];
}
    
- (void)getLoginData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Fetching data from server.";

    NSDictionary *params = @{@"uid":_userData.userID, @"fb_id":_userData.facebookID, @"username":_userData.userName, @"firstname":_userData.firstName, @"lastname":_userData.lastName, @"email":_userData.userEmail, @"gender":_userData.gender, @"birthday":_userData.age, @"img_url":_userData.photoURL, @"deviceToken": [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyDeviceToken]};
    
    [[WebServicesClient sharedClient] login:params completion:^(BOOL success, NSDictionary *userData) {
        if([userData objectForKey:@"uid"]) {
            
            _userData.userID = [userData objectForKey:@"uid"];
            _userData.facebookID = [userData objectForKey:@"fb_id"];
            _userData.userName = [userData objectForKey:@"username"];
            _userData.userEmail = [userData objectForKey:@"email"];
            _userData.firstName = [userData objectForKey:@"firstname"];
            _userData.lastName = [userData objectForKey:@"lastname"];
            _userData.age = [userData objectForKey:@"birthday"];
            _userData.photoURL = [userData objectForKey:@"img_url"];
            _userData.gender = [userData objectForKey:@"gender"];
            _userData.visitCount = [userData objectForKey:@"visit_count"];
            _userData.updateDate = [userData objectForKey:@"update_date"];
            _userData.lastVisitDate = [userData objectForKey:@"last_visit_date"];
            
            [_userData saveUserData];
         
            //                                //                    [SVProgressHUD dismiss];
            [hud hide:YES];
            [self loginSuccess];
        }
    }];
    
    
//    NSDictionary *params = @{@"uid":@"31", @"fb_id":@"140336193104055", @"username":@"Chu Chu", @"firstname":@"Chu", @"lastname":@"Chu", @"email":@"chachaplz@yahoo.com", @"gender":@"Female", @"birthday":@"33", @"img_url":@"http://35.162.178.237/admin/images/user/5.jpeg", @"deviceToken": @"d158d70cc370c6249fb9473226b5a597d11679a1b4d2e7f56e2d7fba08492a2b"};
//    
//    [[WebServicesClient sharedClient] login:params completion:^(BOOL success, NSDictionary *userData) {
//        if([userData objectForKey:@"uid"]) {
//            
//            _userData.userID = [userData objectForKey:@"uid"];
//            _userData.facebookID = [userData objectForKey:@"fb_id"];
//            _userData.userName = [userData objectForKey:@"username"];
//            _userData.userEmail = [userData objectForKey:@"email"];
//            _userData.firstName = [userData objectForKey:@"firstname"];
//            _userData.lastName = [userData objectForKey:@"lastname"];
//            _userData.age = [userData objectForKey:@"birthday"];
//            _userData.photoURL = [userData objectForKey:@"img_url"];
//            _userData.gender = [userData objectForKey:@"gender"];
//            _userData.visitCount = [userData objectForKey:@"visit_count"];
//            _userData.updateDate = [userData objectForKey:@"update_date"];
//            _userData.lastVisitDate = [userData objectForKey:@"last_visit_date"];
//            
//            [_userData saveUserData];
//            
//            //                                //                    [SVProgressHUD dismiss];
//            [hud hide:YES];
//            [self loginSuccess];
//        }
//    }];
}

- (void)loginSuccess {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [UIView transitionWithView:appDelegate.window duration:0.5 options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        appDelegate.window.rootViewController = appDelegate.slideViewController;
    } completion:nil];
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
