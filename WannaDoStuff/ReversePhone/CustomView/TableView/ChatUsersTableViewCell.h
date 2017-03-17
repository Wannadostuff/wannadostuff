//
//  ChatUsersTableViewCell.h
//  WannaDoStuff
//
//  Created by Mac on 28/10/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatUsersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *unread_count_view;
@property (weak, nonatomic) IBOutlet UILabel *unread_count_label;
@end
