//
//  NewsFeedDetailViewController.m
//  WannaDoStuff
//
//  Created by Mac on 27/10/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "NewsFeedDetailViewController.h"
#import "AsyncImageView.h"
#import "ChatViewController.h"
#import "UserData.h"
#import "WebServicesClient.h"
#import "AppDelegate.h"

@interface NewsFeedDetailViewController ()
@property (nonatomic, strong) UserData *userData;
@end

@implementation NewsFeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    if ([self.detailState isEqualToString:@"newsFeed"]) {
        self.navigationItem.title = @"NewsFeed Detail";
    } else if([self.detailState isEqualToString:@"event"]) {
        self.navigationItem.title = @"My Event Detail";
        self.btn_acept.enabled = false;
        if ([self.posterId isEqualToString:_userData.userID]) {
            self.btn_chat.enabled = false;
        }
    } else if([self.detailState isEqualToString:@"addevent"]) {
        self.navigationItem.title = @"My Event Detail";
        self.btn_acept.enabled = false;
        self.btn_chat.enabled = false;
    }
    
    self.view_posterPhotoContainer.layer.masksToBounds = YES;
    self.img_posterPhoto.clipsToBounds = YES;
    self.view_posterPhotoContainer.layer.cornerRadius = self.view_posterPhotoContainer.frame.size.width / 2;
//    self.view_posterPhotoContainer.layer.borderWidth = 3.f;
//    self.view_posterPhotoContainer.layer.borderColor = [UIColor greenColor].CGColor;
    
    self.img_posterPhoto.imageURL = [NSURL URLWithString: self.detailPhotoUrl];
    
    self.lbl_posterName.text = self.detailPosterName;
    self.lbl_title.text = self.detailName;
    self.lbl_location.text = self.detailLocation;
    self.lbl_date.text = self.detailDate;
    self.lbl_time.text = self.detailTime;
    self.txt_link.text = self.detailLink;
    self.txt_details.text = self.detailDetails;

    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnclick:(id)sender {
    if ([self.detailState isEqualToString:@"addevent"]) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"postState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptOnclick:(id)sender {
    self.btn_acept.enabled = false;
    if ([self.accept_users isEqualToString:@""]) {
        _accept_users = [NSString stringWithFormat:@",%@,", _userData.userID];
    } else {
        _accept_users = [NSString stringWithFormat:@"%@%@,", _accept_users, _userData.userID];
    }
    NSDictionary *params = @{@"uid": self.newsfeedId, @"accept_users": _accept_users};
    
    [[WebServicesClient sharedClient]acceptEvent:params completion:^(BOOL success) {
        if (success) {
            
        }
    }];
}

- (IBAction)chatOnclick:(id)sender {
    ChatViewController *chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatViewController.chatUserPhotoUrl = self.detailPhotoUrl;
    chatViewController.chatUserName = self.detailPosterName;
    chatViewController.chatUserID = self.posterId;
    
    [self.navigationController pushViewController:chatViewController animated:YES];
}
@end
