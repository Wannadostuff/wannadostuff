//
//  ChatViewController.h
//  WannaDoStuff
//
//  Created by Mac on 28/10/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentVIew.h"
#import "BaseViewController.h"

@interface ChatViewController : BaseViewController

@property (nonatomic, strong) NSString* chatUserID;
@property (nonatomic, strong) NSString* chatUserName;
@property (nonatomic, strong) NSString* chatUserPhotoUrl;


@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
