//
//  EventsViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "EventsViewController.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "NewsFeedDetailViewController.h"
#import "UserData.h"
#import "WebServicesClient.h"
#import "Shared.h"

@interface EventsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserData *userData;

@end

@implementation EventsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.eventArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
    
    [self initData];
    
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
    
    [[WebServicesClient sharedClient]eventData:params completion:^(BOOL success, NSMutableArray *eventData) {
        if (success) {

            self.eventArray = eventData;
            [_tableView reloadData];
        }
    }];
}


- (void)receivedMessage:(NSNotification*)notification {
    NSDictionary *userInfo = notification.object;
    //    static NSInteger rec_count = 0;
    
    if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"my_event"]) {
        NSMutableDictionary *my_event = [userInfo objectForKey:@"data"];
        NSString* event_id = [my_event objectForKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[NSString stringWithFormat:@"my_event_%@", event_id]];
        
        if (self.eventArray == nil) {
            self.eventArray = [[NSMutableArray alloc] init];
            [self.eventArray addObject:my_event];
            [_tableView reloadData];
        } else {
            [self updateTableView:my_event];
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
    
    [self.eventArray insertObject:msg atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.tableView numberOfRowsInSection:0] !=0 ) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

     return [self.eventArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell" forIndexPath:indexPath];
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    eventData = [self.eventArray objectAtIndex:indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"newsfeed_title"]];
    cell.dateTime.text = [NSString stringWithFormat:@"%@ %@", [eventData objectForKey:@"dates"],[eventData objectForKey:@"times"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    eventData = [self.eventArray objectAtIndex:indexPath.row];
    
    NewsFeedDetailViewController *newsFeedDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedDetailViewController"];
    
    newsFeedDetailViewController.newsfeedId = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"uid"]];
    newsFeedDetailViewController.posterId = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"user_id"]];
    newsFeedDetailViewController.detailName = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"newsfeed_title"]];
    newsFeedDetailViewController.detailLocation = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"location"]];
    newsFeedDetailViewController.detailDate = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"dates"]];
    newsFeedDetailViewController.detailTime = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"times"]];
    newsFeedDetailViewController.detailLink = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"link"]];
    newsFeedDetailViewController.detailDetails = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"detail"]];
    newsFeedDetailViewController.detailPhotoUrl = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"img_url"]];
    newsFeedDetailViewController.detailPosterName = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"username"]];
    newsFeedDetailViewController.accept_users = [NSString stringWithFormat:@"%@", [eventData objectForKey:@"accept_users"]];
    newsFeedDetailViewController.detailState = @"event";
    
    [self.navigationController pushViewController:newsFeedDetailViewController animated:YES];
}

@end
