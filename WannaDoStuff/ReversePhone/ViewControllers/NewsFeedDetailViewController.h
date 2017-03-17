//
//  NewsFeedDetailViewController.h
//  WannaDoStuff
//
//  Created by Mac on 27/10/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewsFeedDetailViewController : BaseViewController

@property (nonatomic, strong) NSString *newsfeedId;
@property (nonatomic, strong) NSString *posterId;
@property (nonatomic, strong) NSString *detailName;
@property (nonatomic, strong) NSString *detailLocation;
@property (nonatomic, strong) NSString *detailDate;
@property (nonatomic, strong) NSString *detailTime;
@property (nonatomic, strong) NSString *detailLink;
@property (nonatomic, strong) NSString *detailDetails;
@property (nonatomic, strong) NSString *detailPhotoUrl;
@property (nonatomic, strong) NSString *detailPosterName;
@property (nonatomic, strong) NSString *accept_users;
@property (nonatomic, strong) NSString *detailState;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_location;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UIView *view_posterPhotoContainer;
@property (weak, nonatomic) IBOutlet UIImageView *img_posterPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btn_acept;
@property (weak, nonatomic) IBOutlet UIButton *btn_chat;
@property (weak, nonatomic) IBOutlet UILabel *lbl_posterName;
@property (weak, nonatomic) IBOutlet UITextView *txt_link;
@property (weak, nonatomic) IBOutlet UITextView *txt_details;


@end
