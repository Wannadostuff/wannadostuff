//
//  SettingsViewController.m
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingCell.h"
#import "GroupedTableHeader.h"
#import "FAQViewController.h"
#import "AppDelegate.h"
#import "Shared.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GroupedTableHeader *headerView = [[GroupedTableHeader alloc] init];
    
    NSString *headerString;
    
    if(section == 0) {
        headerString = @"PASSCODE";
    } else {
        headerString = @"SUPPORT";
    }
    headerView.textLabel.text = headerString;
    
    return headerView;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"PASSCODE";
    } else {
        return @"SUPPORT";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    else return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.switchControl setHidden:NO];
        cell.delegate = self;
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyPassCode] != nil) {
            [cell.switchControl setOn:YES];
        } else {
            [cell.switchControl setOn:NO];
        }
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        [cell.switchControl setHidden:YES];
        if(indexPath.row == 0) {
            [cell.titleLabel setText:@"FAQ"];
        } else {
            [cell.titleLabel setText:@"Feedback & Support"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            FAQViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.navigationBar.translucent    = NO;                
                [mailer.navigationBar setTintColor:[UIColor whiteColor]];
                
                mailer.mailComposeDelegate          = self;
                mailer.toRecipients                 = [NSArray arrayWithObjects:@"support@getsecret.co", nil];
                mailer.subject                      = @"Reverse Phone Lookup - Feedback";
                mailer.navigationItem.title = @"Feedback";
                
                [self presentViewController:mailer animated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                                message:@"Your device currently lacks support to send an email. Make sure you have your email account setup with this device"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

#pragma mark - switch control delegate
- (void)switchControlChanged:(SettingCell *)cell switchControl:(UISwitch *)switchControl {
    if([switchControl isOn] == YES) {
        UIViewController *choosePasscodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoosePassCodeViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:choosePasscodeViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsKeyPassCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

# pragma mark - mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                        message:@"Your email failed to send. Please try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
