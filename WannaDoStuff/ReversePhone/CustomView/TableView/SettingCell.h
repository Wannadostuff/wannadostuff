//
//  SettingCell.h
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCell;

@protocol SettingCellDelegate <NSObject>

- (void)switchControlChanged:(SettingCell*)cell switchControl:(UISwitch*)switchControl;

@end

@interface SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) id <SettingCellDelegate> delegate;

@end
