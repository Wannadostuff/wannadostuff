//
//  SlideMenuViewController.m
//  My Calendar Assistant
//
//  Created by Lokesh Dudhat on 09/02/15.
//  Copyright (c) 2015 Let Nurture. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "AppDelegate.h"
#import "MenuCell.h"
#import "Shared.h"
#import "MainViewController.h"
#import "AsyncImageView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserData.h"

@interface SlideMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuImages;
@property (nonatomic, strong) NSArray *menuImagesSelected;
@property (nonatomic, strong) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *useremail;
@property (nonatomic, strong) UserData *userData;

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSupersonic];
    
    [self creditsCountChanged:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creditsCountChanged:) name:kCreditChangedNotification object:nil];
    self.photoContainer.layer.masksToBounds = YES;
    self.photoImage.clipsToBounds = YES;
    self.photoContainer.layer.cornerRadius = self.photoContainer.frame.size.width / 2;
    self.photoContainer.layer.borderWidth = 2.f;
    self.photoContainer.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    NSString *photoUrl = _userData.photoURL;
    self.photoImage.imageURL = [NSURL URLWithString: photoUrl];
    self.username.text = _userData.userName;
    self.useremail.text = _userData.userEmail;
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClicked)];
    [self.photoImage setUserInteractionEnabled:YES];
    [self.photoImage addGestureRecognizer:photoTap];
}

- (void)creditsCountChanged:(NSNotification*)notification {
    self.navigationItem.title = @"WannaDoStuff";
}

- (void)initializeSupersonic {
/*    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];;
    if(deviceID == nil) deviceID = @"";
    
    [SUSupersonicAdsConfiguration getConfiguration].useClientSideCallbacks = [NSNumber numberWithBool:YES];
    //Supersonic tracking SDK
    [SupersonicEventsReporting reportAppStarted];
    
    self.rvDelegate = [[RVDelegate alloc] init];
    self.owDelegate = [[OWDelegate alloc] init];
    self.isDelegate = [[ISDelegate alloc] init];
    
    [[Supersonic sharedInstance] setRVDelegate:self.rvDelegate];
    [[Supersonic sharedInstance] setOWDelegate:self.owDelegate];
    [[Supersonic sharedInstance] setISDelegate:self.isDelegate];
    
    [[Supersonic sharedInstance] initRVWithAppKey:kSupersonic_APP_KEY withUserId:deviceID];
    [[Supersonic sharedInstance] initOWWithAppKey:kSupersonic_APP_KEY withUserId:deviceID];
    [[Supersonic sharedInstance] initISWithAppKey:kSupersonic_APP_KEY withUserId:deviceID];*/
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems)
        return _menuItems;
    
    _menuItems = @[@"NEWSFEED",
                   @"EVENTS",
                   @"ADD EVENT",
                   @"CHAT",
                   @"",
//                   @"PROFILES",
//                   @"SETTINGS",
                   @"CONTACT US",
                   @"TERMS OF USE",
                   @"LOGOUT"];

    return _menuItems;
}

- (NSArray *)menuImages {
    if (_menuImages)
        return _menuImages;
    
    _menuImages = @[@"menu_ico_map",
                    @"menu_ico_report",
                    @"menu_ico_vehicles",
                    @"menu_ico_contacts",
                    @"",
//                    @"menu_ico_bookings",
//                    @"menu_ico_setting",
                    @"menu_ico_feedback",
                    @"menu_ico_faq",
                    @"menu_ico_logout"];
    
    return _menuImages;
}

- (NSArray *)menuImagesSelected {
    if (_menuImagesSelected)
        return _menuImagesSelected;
    
    _menuImagesSelected = @[@"menu_ico_map_selected",
                            @"menu_ico_report_selected",
                            @"menu_ico_vehicles_selected",
                            @"menu_ico_contacts_selected",
                            @"",
//                            @"menu_ico_bookings_selected",
//                            @"menu_ico_setting_selected",
                            @"menu_ico_feedback_selected",
                            @"menu_ico_faq_selected",
                            @"menu_ico_logout_selected"];
    return _menuImagesSelected;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.iconImageView.image = [UIImage imageNamed:self.menuImages[indexPath.row]];
    cell.iconImageView.highlightedImage = [UIImage imageNamed:self.menuImagesSelected[indexPath.row]];
    
    cell.titleLabel.text = menuItem;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.view respondsToSelector:@selector(traitCollection)]){
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
            return 35;
        }
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(indexPath.row == 0) {
        [appDelegate switchNavigationController:appDelegate.newsFeedNavigationController];
    } else if(indexPath.row == 1) {
        [appDelegate switchNavigationController:appDelegate.eventsNavigationController];
    } else if(indexPath.row == 2) {
        [appDelegate switchNavigationController:appDelegate.addEventNavigationController];
    } else if(indexPath.row == 3) {
        [appDelegate switchNavigationController:appDelegate.chatNavigationController];
    } else if(indexPath.row == 4) {

//    } else if(indexPath.row == 5) {
//        [appDelegate switchNavigationController:appDelegate.profileNavigationController];
//    } else if(indexPath.row == 7) {
//        [appDelegate switchNavigationController:appDelegate.settingNavigationController];
    } else if(indexPath.row == 5) {
        [appDelegate switchNavigationController:appDelegate.contactNavigationController];
    } else if(indexPath.row == 6) {
        [appDelegate switchNavigationController:appDelegate.FAQNavigationController];
    } else if(indexPath.row == 7) {
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        if ([FBSDKAccessToken currentAccessToken]) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            NSString *domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook.com"];
            if(domainRange.length > 0)
                [storage deleteCookie:cookie];
        }
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        
        [_userData deleteUserData];
        
        UIViewController *viewController = [self.storyboard instantiateInitialViewController];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate switchNavigationController:appDelegate.newsFeedNavigationController];
        
        [appDelegate.slideViewController closeDrawerAnimated:NO completion:^(BOOL finished) {
            [UIView transitionWithView:appDelegate.window duration:0.5 options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent) animations:^{
                appDelegate.window.rootViewController = viewController;
            } completion:nil];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)photoClicked{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate switchNavigationController:appDelegate.profileNavigationController];
}
@end
