//
//  AddEventViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "AddEventViewController.h"
#import "AppDelegate.h"
#import "NewsFeedDetailViewController.h"
#import "UserData.h"
#import "WebServicesClient.h"
#import "MBProgressHUD.h"

@interface AddEventViewController() <UITextViewDelegate>

@property (nonatomic, strong) UserData *userData;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end

@implementation AddEventViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.txt_title.delegate = self;
    self.txt_details.delegate = self;
    self.btn_post.layer.cornerRadius = 5;
    
    [[self.txt_date layer] setBorderWidth:0.5f];
    [[self.txt_date layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    self.txt_date.layer.cornerRadius = 5;
    [self.txt_date setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    self.txt_time.layer.cornerRadius = 5;
    [[self.txt_time layer] setBorderWidth:0.5f];
    [[self.txt_time layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.txt_time setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    BOOL postState = [[NSUserDefaults standardUserDefaults] boolForKey:@"postState"];
    if (postState) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"postState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showEventController];
    }
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
    
    self.txt_title.text = @"";
    self.txt_details.text = @"";
    self.txt_location.text = @"";
    [self.txt_date setTitle:@"date" forState:UIControlStateNormal];
    [self.txt_date setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.txt_time setTitle:@"time" forState:UIControlStateNormal];
    [self.txt_time setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.txt_link.text = @"";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showEventController {
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate.slideViewController setSideMenuEnabled:YES];
//    [appDelegate switchNavigationController:appDelegate.eventsNavigationController];
}

- (IBAction)postOnclick:(id)sender {
    if ([self.txt_title.text isEqualToString:@""] || [self.txt_title.text isEqualToString:@"Title of Event"]) {
        [self postAlert];
        return;
    }
    if ([self.txt_location.text isEqualToString:@""]) {
        [self postAlert];
        return;
    }
    if ([self.txt_date.titleLabel.text isEqualToString:@""]) {
        [self postAlert];
        return;
    }
    if ([self.txt_time.titleLabel.text isEqualToString:@""]) {
        [self postAlert];
        return;
    }
    if ([self.txt_details.text isEqualToString:@""] || [self.txt_details.text isEqualToString:@"Details"]) {
        [self postAlert];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Posting event...";
    
    NSDictionary *params = @{@"user_id":_userData.userID, @"newsfeed_title":self.txt_title.text, @"location":self.txt_location.text, @"dates":self.txt_date.titleLabel.text, @"times":self.txt_time.titleLabel.text, @"detail":self.txt_details.text, @"link":self.txt_link.text};
    
    [[WebServicesClient sharedClient] addEvent:params completion:^(BOOL success) {
        if(success) {
            [hud hide:YES];
            [self goNewsFeedDetail];
        }
    }];
}

- (void)goNewsFeedDetail {
    NewsFeedDetailViewController *newsFeedDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedDetailViewController"];
    
    newsFeedDetailViewController.detailName = self.txt_title.text;
    newsFeedDetailViewController.detailLocation = self.txt_location.text;
    newsFeedDetailViewController.detailDate = self.txt_date.titleLabel.text;
    newsFeedDetailViewController.detailTime = self.txt_time.titleLabel.text;
    newsFeedDetailViewController.detailLink = self.txt_link.text;
    newsFeedDetailViewController.detailDetails = self.txt_details.text;
    newsFeedDetailViewController.detailPhotoUrl = _userData.photoURL;
    newsFeedDetailViewController.detailPosterName = _userData.userName;
    newsFeedDetailViewController.detailState = @"addevent";
    
    [self.navigationController pushViewController:newsFeedDetailViewController animated:YES];
}

- (void)postAlert {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"If you want to post the event, you should enter the  values for Title, Location, Date, Time, and Detail fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Title of Event"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    if ([textView.text isEqualToString:@"Details"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

-(IBAction)datePickerBtnAction:(id)sender
{
    _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    _datePicker.hidden=NO;
    _datePicker.date=[NSDate date];
    [_datePicker addTarget:self action:@selector(dateTitle:) forControlEvents:UIControlEventValueChanged];
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    self.btn_post.hidden = YES;
    self.selectDateBtn.hidden = NO;
    self.selectDateBtn.layer.cornerRadius = 5;
}

-(void)dateTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *date=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    //assign text to label
    [self.txt_date setTitle:date forState:UIControlStateNormal];
    [self.txt_date setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [dateFormat setDateFormat:@"hh:mm:ss a"];
    NSString *time=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    //assign text to label
    
    [self.txt_time setTitle:time forState:UIControlStateNormal];
    [self.txt_time setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)save:(id)sender {
    _datePicker.hidden = YES;
    self.btn_post.hidden = NO;
    self.selectDateBtn.hidden = YES;
}

@end
