//
//  SlideMenuViewController.h
//  My Calendar Assistant
//
//  Created by Lokesh Dudhat on 09/02/15.
//  Copyright (c) 2015 Let Nurture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController<UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *navTitleView;

@end
