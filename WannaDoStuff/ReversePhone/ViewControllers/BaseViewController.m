//
//  BaseViewController.m
//  PrivateText
//
//  Created by Mac on 3/31/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatViewController.h"
#import "Shared.h"
#import "WebServicesClient.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self isKindOfClass:[ChatViewController class]] == NO) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:kReceiveMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage:) name:kRefreshMessageNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if([self isKindOfClass:[ChatViewController class]] == NO) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceiveMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMessageNotification object:nil];
    }
}

- (void)receivedMessage:(NSNotification*)notification {
    if([self isKindOfClass:[ChatViewController class]] == NO) {
        [Shared sharedInstance].totalUnreadChatCount++;
    }
}

- (void)refreshMessage:(NSNotification*)notification {
    if([self isKindOfClass:[ChatViewController class]] == NO) {
//        [[WebServicesClient sharedClient] readInboxWithMaxIdentifier:nil completion:^(BOOL success, NSDictionary *inbox, NSString *nextMaxIdentifier)
//         {
//             if(success == YES) {
//                 [Shared sharedInstance].totalUnreadChatCount = [[inbox objectForKey:@"unread_count"] integerValue];
//             }
//         }];
    }
}

@end
