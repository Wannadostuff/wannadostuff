//
//  ChatUsersViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ChatUsersViewController.h"
#import "AppDelegate.h"
#import "ChatUsersTableViewCell.h"
#import "AsyncImageView.h"
#import "ChatViewController.h"
#import "UserData.h"
#import "WebServicesClient.h"
#import "Shared.h"

@interface ChatUsersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
    @property (nonatomic, strong) UserData *userData;
@end

@implementation ChatUsersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
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
        
        [[WebServicesClient sharedClient]chatUserData:params completion:^(BOOL success, NSMutableArray *chatUserData) {
            if (success) {
                
                self.chatUserArray = [chatUserData mutableCopy];
                [_tableview reloadData];
            }
        }];
    }

- (void)receivedMessage:(NSNotification*)notification {
    NSDictionary *userInfo = notification.object;
    //    static NSInteger rec_count = 0;
    
//    if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"contact_user"]) {
//        NSMutableDictionary *new_event = [userInfo objectForKey:@"data"];
//        NSString* from_id = [new_event objectForKey:@"from_id"];
//        
//        NSDictionary *params = @{@"user_id": _userData.userID, @"friend_id": from_id};
//        
//        [[WebServicesClient sharedClient]getUserData:params completion:^(BOOL success, NSMutableDictionary* chatUserData) {
//            if (success) {
//                [[NSUserDefaults standardUserDefaults] setInteger: 1 forKey:[NSString stringWithFormat:@"unreadChat_%@", from_id]];
//                [self updateTableView:chatUserData];
//            }
//        }];
////        [self updateTableView:new_event];
//    } else if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"current_chat"]) {
//        NSMutableDictionary *new_event = [userInfo objectForKey:@"data"];
//        NSString* from_id = [new_event objectForKey:@"from_id"];
//        NSInteger unreadCount = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"unreadChat_%@", from_id]];
//        [[NSUserDefaults standardUserDefaults] setInteger:unreadCount + 1 forKey:[NSString stringWithFormat:@"unreadChat_%@", from_id]];
//        
//        //        [self updateTableView:new_event];
//    } else {
//        [Shared sharedInstance].totalUnreadChatCount++;
//    }
}

- (void)refreshMessage:(NSNotification*)notification {
    //    [self readMessages];
}

- (void)updateTableView:(NSMutableDictionary*)msg {
    
    [self.tableview beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.chatUserArray insertObject:msg atIndex:0];
    [self.tableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableview endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.tableview numberOfRowsInSection:0] !=0 ) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.chatUserArray count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatUsersTableViewCell" forIndexPath:indexPath];
    
    cell.photoContainer.layer.masksToBounds = YES;
    cell.photoImage.clipsToBounds = YES;
    cell.photoContainer.layer.cornerRadius = cell.photoContainer.frame.size.width / 2;
    cell.photoContainer.layer.borderWidth = 2.f;
    cell.photoContainer.layer.borderColor = [UIColor greenColor].CGColor;
    
    NSMutableDictionary *chatUserData = [[NSMutableDictionary alloc] init];
    chatUserData = [self.chatUserArray objectAtIndex:indexPath.row];
    
    NSString *from_id = [chatUserData objectForKey:@"from_id"];
    NSString *friend_id = [chatUserData objectForKey:@"friend_id"];
    int unread_count = [[chatUserData objectForKey:@"unread_count"] intValue];
    NSString *friend_name;
    NSString *photoUrl;

    if ([from_id isEqualToString:@"admin"] || [friend_id isEqualToString:@"admin"]) {
        friend_name = @"admin";
        photoUrl = @"http://35.162.178.237/admin/images/login/admin_photo.png";
    } else {
        friend_name = [chatUserData objectForKey:@"username"];
        photoUrl = [chatUserData objectForKey:@"img_url"];
    }
    
    if (unread_count > 0) {
        cell.unread_count_view.hidden = NO;
        cell.unread_count_view.layer.cornerRadius = 10;
        cell.unread_count_view.layer.masksToBounds = YES;
        cell.unread_count_label.text = [NSString stringWithFormat:@"%d", unread_count];
    } else {
        cell.unread_count_view.hidden = YES;
    }

    cell.photoImage.imageURL = [NSURL URLWithString: photoUrl];
    cell.userName.text = friend_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* chatUserData = [[NSMutableDictionary alloc] init];
    chatUserData = [self.chatUserArray objectAtIndex:indexPath.row];
    
    ChatViewController* chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    
    NSString *from_id = [chatUserData objectForKey:@"from_id"];
    NSString *friend_id = [chatUserData objectForKey:@"friend_id"];
    NSString *friend_name;
    NSString *photoUrl;
    
    if ([from_id isEqualToString:@"admin"] || [friend_id isEqualToString:@"admin"]) {
        friend_name = @"admin";
        photoUrl = @"http://35.162.178.237/admin/images/login/admin_photo.png";
    } else {
        friend_name = [chatUserData objectForKey:@"username"];
        photoUrl = [chatUserData objectForKey:@"img_url"];
    }
    if ([from_id isEqualToString:_userData.userID]) {
        chatViewController.chatUserID = friend_id;
    } else if ([friend_id isEqualToString:_userData.userID]){
        chatViewController.chatUserID = from_id;
    }
    chatViewController.chatUserName = friend_name;
    chatViewController.chatUserPhotoUrl = photoUrl;
    
    [self.navigationController pushViewController:chatViewController animated:YES];
}

@end
