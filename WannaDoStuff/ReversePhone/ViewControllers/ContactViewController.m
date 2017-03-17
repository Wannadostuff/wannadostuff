//
//  FeedbackViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "WebServicesClient.h"

@interface ContactViewController()
    @property (nonatomic, strong) UserData *userData;
@end

@implementation ContactViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
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
- (IBAction)submitOnclick:(id)sender {
    
    if ([self.txt_title.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please enter title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.txt_content.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please enter content." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *message = [NSString stringWithFormat:@"Hello,\r\nYou have a new message from %@.\r\n\r\n%@ \r\n%@ \r\n\r\nClick on the link: http://35.162.178.237/admin/ to check your admin site. \r\nBest Regards.", _userData.userName, self.txt_title.text, self.txt_content.text];
    NSDictionary *params = @{@"username": _userData.userName, @"title": self.txt_title.text, @"content":message};

    [[WebServicesClient sharedClient]contactAdmin:params completion:^(BOOL success) {
        if (success) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Your mail has been submitted to Admin." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
@end
