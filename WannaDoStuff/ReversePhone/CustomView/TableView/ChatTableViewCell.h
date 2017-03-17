//
//  ChatTableViewCell.h
//  iMessageBubble
//
//  Created by Prateek Grover on 19/09/15.
//  Copyright (c) 2015 Prateek Grover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chatMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
//@property BOOL outbound;
@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet AsyncImageView *photoImage;

//- (void)adjustPositions:(UIFont*)font;

@end
