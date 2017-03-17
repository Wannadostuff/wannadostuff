//
//  SlideMainViewController.m
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "SlideMainViewController.h"
#import "AppDelegate.h"
#import "Shared.h"

#import "UIBarButtonItem+Badge.h"
#import "NewsFeedViewController.h"
#import "ChatUsersViewController.h"
#import "EventsViewController.h"

@interface SlideMainViewController ()

@end

@implementation SlideMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *homeButtonItem = self.navigationItem.leftBarButtonItems[0];
    [homeButtonItem setTarget:self];
    [homeButtonItem setAction:@selector(homeButtonItemClicked:)];
    homeButtonItem.badgeBGColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self isKindOfClass:[NewsFeedViewController class]] == NO && [self isKindOfClass:[ChatUsersViewController class]] == NO && [self isKindOfClass:[EventsViewController class]] == NO) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:kReceiveMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage:) name:kRefreshMessageNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if([self isKindOfClass:[NewsFeedViewController class]] == NO && [self isKindOfClass:[ChatUsersViewController class]] == NO && [self isKindOfClass:[EventsViewController class]] == NO) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceiveMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMessageNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedMessage:(NSNotification*)notification {
    if([self isKindOfClass:[NewsFeedViewController class]] == NO && [self isKindOfClass:[ChatUsersViewController class]] == NO && [self isKindOfClass:[EventsViewController class]] == NO) {
        [Shared sharedInstance].totalUnreadChatCount++;
        [self setBadgeValue];
    }
}

- (void)refreshMessage:(NSNotification*)notification {
    if([self isKindOfClass:[NewsFeedViewController class]] == NO && [self isKindOfClass:[ChatUsersViewController class]] == NO && [self isKindOfClass:[EventsViewController class]] == NO) {
//        [[WebServicesClient sharedClient] readInboxWithMaxIdentifier:nil completion:^(BOOL success, NSDictionary *inbox, NSString *nextMaxIdentifier)
//         {
//             if(success == YES) {
//                 [Shared sharedInstance].totalUnreadSMSCount = [[inbox objectForKey:@"unread_count"] integerValue];
//                 [self setBadgeValue];
//             }
//         }];
    }
}

- (void)setBadgeValue {
    NSString *badgeValue = [NSString stringWithFormat:@"%ld", (long)[Shared sharedInstance].totalUnreadChatCount];
    UIBarButtonItem *homeButtonItem = self.navigationItem.leftBarButtonItems[0];
//    homeButtonItem.badgeValue = badgeValue;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)homeButtonItemClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
