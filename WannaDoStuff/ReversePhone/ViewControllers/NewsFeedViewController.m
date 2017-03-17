//
//  InboxViewController.m
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "AppDelegate.h"
#import "Shared.h"
#import "NewsFeedTableViewCell.h"
#import "NewsFeedDetailViewController.h"
#import "WebServicesClient.h"
#import "UserData.h"

@interface NewsFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserData *userData;
@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    [self initData];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:kReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage:) name:kRefreshMessageNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMessageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    NSDictionary *params = @{@"user_id": _userData.userID};
    
    [[WebServicesClient sharedClient]newsfeedData:params completion:^(BOOL success, NSMutableArray *newsfeedData) {
        if (success) {
            self.newsFeedArray = [newsfeedData mutableCopy];
            [_tableView reloadData];
        }
    }];
}

- (void)receivedMessage:(NSNotification*)notification {
    NSDictionary *userInfo = notification.object;
    //    static NSInteger rec_count = 0;
    
    if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"add_event"]) {
        NSMutableDictionary *new_event = [userInfo objectForKey:@"data"];
        NSString* event_id = [new_event objectForKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[NSString stringWithFormat:@"add_event_%@", event_id]];
        
        if (self.newsFeedArray == nil) {
            self.newsFeedArray = [[NSMutableArray alloc] init];
            [self.newsFeedArray addObject:new_event];
            [_tableView reloadData];
        } else {
            [self updateTableView:new_event];
        }
    } else {
        [Shared sharedInstance].totalUnreadChatCount++;
    }
}

- (void)refreshMessage:(NSNotification*)notification {
//    [self readMessages];
}

- (void)updateTableView:(NSMutableDictionary*)msg {
    
    [self.tableView beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.newsFeedArray insertObject:msg atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.tableView numberOfRowsInSection:0] !=0 ) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_newsFeedArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedTableViewCell" forIndexPath:indexPath];
    
    NSMutableDictionary *newsFeedData = [[NSMutableDictionary alloc] init];
    newsFeedData = [self.newsFeedArray objectAtIndex:indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"newsfeed_title"]];
    cell.dateTime.text = [NSString stringWithFormat:@"%@ %@", [newsFeedData objectForKey:@"dates"], [newsFeedData objectForKey:@"times"]];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"add_event_%@", [newsFeedData objectForKey:@"uid"]]]){
        cell.title.textColor = [UIColor redColor];
    } else {
        cell.title.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *newsFeedData = [[NSMutableDictionary alloc] init];
    newsFeedData = [self.newsFeedArray objectAtIndex:indexPath.row];
    
    NewsFeedDetailViewController *newsFeedDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedDetailViewController"];
    
    newsFeedDetailViewController.newsfeedId = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"uid"]];
    newsFeedDetailViewController.posterId = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"user_id"]];
    newsFeedDetailViewController.detailName = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"newsfeed_title"]];
    newsFeedDetailViewController.detailLocation = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"location"]];
    newsFeedDetailViewController.detailDate = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"dates"]];
    newsFeedDetailViewController.detailTime = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"times"]];
    newsFeedDetailViewController.detailLink = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"link"]];
    newsFeedDetailViewController.detailDetails = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"detail"]];
    newsFeedDetailViewController.detailPhotoUrl = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"img_url"]];
    newsFeedDetailViewController.detailPosterName = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"username"]];
    newsFeedDetailViewController.accept_users = [NSString stringWithFormat:@"%@", [newsFeedData objectForKey:@"accept_users"]];
    newsFeedDetailViewController.detailState = @"newsFeed";
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:[NSString stringWithFormat:@"add_event_%@", [newsFeedData objectForKey:@"uid"]]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"add_event_%@", [newsFeedData objectForKey:@"uid"]]]) {
        [Shared sharedInstance].totalUnreadChatCount--;
    }
    
    [self.navigationController pushViewController:newsFeedDetailViewController animated:YES];
}

@end
