//
//  ChatViewController.m
//  WannaDoStuff
//
//  Created by Mac on 28/10/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCellSettings.h"
#import "ContentView.h"
#import "AppDelegate.h"
#import "ChatTableViewCell.h"
#import "Shared.h"
#import "NSDate+Util.h"
#import "AsyncImageView.h"
#import "UserData.h"
#import "WebServicesClient.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) ContentView *handler;
@property (strong, nonatomic) ChatCellSettings* chatCellSettings;
@property BOOL offlineMode;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property BOOL requestsLoading;
@property (strong,nonatomic) NSString *nextMaxIdentifier;

@property (nonatomic, strong) NSMutableArray *chatHistoryArray;
    
    @property (nonatomic, strong) UserData *userData;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*self.userPhotoContainer.layer.masksToBounds = YES;
    self.userPhotoImage.clipsToBounds = YES;
    self.userPhotoImage.crossfadeDuration = 0.0;
    self.userPhotoContainer.layer.cornerRadius = self.userPhotoContainer.frame.size.width / 2;
    self.userPhotoContainer.layer.borderWidth = 2.f;
    self.userPhotoContainer.layer.borderColor = [UIColor greenColor].CGColor;
    
    self.lbl_userName.text = self.chatUserName;
    self.userPhotoImage.imageURL = [NSURL URLWithString:self.chatUserPhotoUrl];
    
    self.mePhotoContainer.layer.masksToBounds = YES;
    self.mePhotoImage.clipsToBounds = YES;
    self.mePhotoImage.crossfadeDuration = 0.0;
    self.mePhotoContainer.layer.cornerRadius = self.userPhotoContainer.frame.size.width / 2;
    self.mePhotoContainer.layer.borderWidth = 2.f;
    self.mePhotoContainer.layer.borderColor = [UIColor redColor].CGColor;*/
    
    self.title = self.chatUserName;
    
    self.offlineMode = YES;
    
    [self initializeChatTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
//    NSString *photoUrl = _userData.photoURL;
//    self.mePhotoImage.imageURL = [NSURL URLWithString:photoUrl];
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat:@"unreadChat_%@", self.chatUserID]];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
    
    [self readMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:kReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage:) name:kRefreshMessageNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unread_message_update];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMessageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeChatTable {
    self.chatCellSettings = [ChatCellSettings getInstance];
    
    //    [self.chatCellSettings setSenderBubbleColorHex:@"007AFF"];
    [self.chatCellSettings setSenderBubbleColorHex:@"f9588f"];
    [self.chatCellSettings setReceiverBubbleColorHex:@"DFDEE5"];
    [self.chatCellSettings setSenderBubbleNameTextColorHex:@"FFFFFF"];
    [self.chatCellSettings setReceiverBubbleNameTextColorHex:@"000000"];
    [self.chatCellSettings setSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [self.chatCellSettings setReceiverBubbleMessageTextColorHex:@"000000"];
    [self.chatCellSettings setSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [self.chatCellSettings setReceiverBubbleTimeTextColorHex:@"000000"];
    
    [self.chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [self.chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [self.chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:17]];
    [self.chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:17]];
    [self.chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [self.chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    
    [self.chatCellSettings senderBubbleTailRequired:YES];
    [self.chatCellSettings receiverBubbleTailRequired:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(paginate) forControlEvents:UIControlEventValueChanged];
    [self.chatTable addSubview:self.refreshControl];
    
    self.chatTable.delegate = self;
    self.chatTable.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
    [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
    nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
    [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (IBAction)backOnclick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatHistoryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *messageData = [self.chatHistoryArray objectAtIndex:indexPath.row];
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    if([[messageData objectForKey:@"from_id"] isEqualToString:_userData.userID]) {
        fontArray = self.chatCellSettings.getSenderBubbleFontWithSize;
    } else {
        fontArray = self.chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
    CGSize messageSize = [[messageData objectForKey:@"message"] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 164.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontArray[1]}                                             context:nil].size;
    
    /*CGSize timeSize = [@"Time" boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 100.0f, CGFLOAT_MAX)                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontArray[2]} context:nil].size;
     */
    return messageSize.height + 33.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *messageData = [self.chatHistoryArray objectAtIndex:indexPath.row];
    NSString *chat_text = [messageData objectForKey:@"message"];
    NSString *chat_type = [messageData objectForKey:@"from_id"];
    NSString *chat_time = [NSString stringWithFormat:@"%@/%@", [messageData objectForKey:@"dates"],[messageData objectForKey:@"dates"]];
    
    NSDate *date = [[NSDate dateFromString:chat_time withTimeZone:@"UTC"] toLocalTime];
    chat_time = [NSDate stringFromDate:date withTimeZone:nil];
    
    if([chat_type isEqualToString:_userData.userID]) {
        ChatTableViewCell* chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        chatCell.chatMessageLabel.text = chat_text;
        //chatCell.chatTimeLabel.text = sms_time;
        
        return chatCell;
    } else {
        ChatTableViewCell* chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        chatCell.chatMessageLabel.text = chat_text;
        chatCell.photoImage.imageURL = [NSURL URLWithString:self.chatUserPhotoUrl];
        chatCell.photoImage.layer.masksToBounds = YES;
        chatCell.photoImage.layer.cornerRadius = 12.5;

        //chatCell.chatTimeLabel.text = sms_time;
        
        return chatCell;
    }
}

- (void)updateTableView:(NSMutableDictionary*)msg {
    [self.chatTextView setText:@""];
    [self changeCharacterLengthLabel];
    
    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:self.chatHistoryArray.count inSection:0];
    
    [self.chatHistoryArray insertObject:msg atIndex:self.chatHistoryArray.count];
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0] !=0 ) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

- (void) dismissKeyboard {
    [self.chatTextView resignFirstResponder];
}

- (void) changeCharacterLengthLabel {
    /*NSInteger length = [self.chatTextView.text length];
     NSString *text = [NSString stringWithFormat:@"%ld/160", (long)length];
     [self.characterLengthLabel setText:text];*/
}

- (void)receivedMessage:(NSNotification*)notification {
    NSDictionary *userInfo = notification.object;
//    static NSInteger rec_count = 0;
    
    if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"current_chat"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"type"] isEqualToString:@"contact_user"]) {
        NSMutableDictionary *message = [userInfo objectForKey:@"data"];
//        rec_count++;
        [self updateTableView:message];
    } else {
        [Shared sharedInstance].totalUnreadChatCount++;
    }
}

- (IBAction)sendMessage:(id)sender {
    NSString *chat_text = self.chatTextView.text;
    
    NSInteger length = [chat_text length];
    if(length == 0) return;

    NSInteger maxLength = 160;
    if([chat_text canBeConvertedToEncoding:NSASCIIStringEncoding] == NO) {
        maxLength = 70;
    }
    
    if(chat_text.length > maxLength) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The length of message must be shorter than 160 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    }
    
    [self.sendButton setEnabled:NO];
    [self dismissKeyboard];
    
    [SVProgressHUD showWithStatus:@"Sending Message..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSDictionary *params = @{@"from_id": _userData.userID, @"from_name":_userData.userName, @"friend_id": self.chatUserID, @"friend_name": self.chatUserName, @"message":chat_text};
    
    [[WebServicesClient sharedClient]sendMessage:params completion:^(BOOL success, NSMutableDictionary *messageData) {
        if (success) {
            
            [self updateTableView:messageData];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sending Failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;
        }
        [SVProgressHUD dismiss];
        [self.sendButton setEnabled:YES];
    }];
}

- (void)refreshMessage:(NSNotification*)notification {
    [self readMessages];
}

- (void)paginate {
    if(self.requestsLoading == YES) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    if(self.offlineMode == YES) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    if(self.nextMaxIdentifier == nil) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self.refreshControl beginRefreshing];
//    [[WebServicesClient sharedClient] readMessageWithMaxIdentifier:self.phoneNumber nextMaxIdentifier:self.nextMaxIdentifier completion:^(BOOL success, NSDictionary *messageData, NSString *nextMaxIdentifier)
//     {
//         [self.refreshControl endRefreshing];
//         if(success == YES) {
//             self.nextMaxIdentifier = nextMaxIdentifier;
//             NSMutableArray *array = [[messageData objectForKey:@"data_array"] mutableCopy];
//             for (NSDictionary *data in array) {
//                 [self.messageArray insertObject:data atIndex:0];
//             }
//             [self.chatTable reloadData];
//         }
//         self.requestsLoading = NO;
//     }];
}


- (void)reverseArray:(NSMutableArray*)array {
    if ([array count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [array count] - 1;
    while (i < j) {
        [array exchangeObjectAtIndex:i
                   withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

- (void)readMessages {
    self.requestsLoading = YES;
    self.nextMaxIdentifier = @"";
    
    [SVProgressHUD showWithStatus:@"Loading Messages..." maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *params = @{@"from_id": _userData.userID, @"from_name":_userData.userName, @"friend_id": self.chatUserID, @"friend_name": self.chatUserName};
    
    [[WebServicesClient sharedClient]chatData:params completion:^(BOOL success, NSMutableArray *messageArray) {
        if (success) {
            self.offlineMode = NO;
            self.chatHistoryArray = [messageArray mutableCopy];
            
            [_chatTable reloadData];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;
        }
        self.requestsLoading = NO;
        [self.refreshControl endRefreshing];
        
        if(self.chatHistoryArray.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:self.chatHistoryArray.count - 1 inSection:0];
            [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)unread_message_update {
    NSMutableDictionary *last_chatData = [self.chatHistoryArray objectAtIndex:[self.chatHistoryArray count] - 1];
    if ([[last_chatData objectForKey:@"to_id"] isEqualToString:_userData.userID]) {
        NSDictionary *params = @{@"from_id": [last_chatData objectForKey:@"from_id"], @"to_id": [last_chatData objectForKey:@"to_id"]};
        
        [[WebServicesClient sharedClient]unreadMessageUpdate:params completion:^(BOOL success, NSMutableArray *messageArray) {
            if (success) {
                
            }
        }];
    } else {
        NSDictionary *params = @{@"from_id": [last_chatData objectForKey:@"to_id"], @"to_id": [last_chatData objectForKey:@"from_id"], @"uid": [last_chatData objectForKey:@"uid"]};
        
        [[WebServicesClient sharedClient]unreadMessageUpdate:params completion:^(BOOL success, NSMutableArray *messageArray) {
            if (success) {
                
            }
        }];
    }
}

@end
