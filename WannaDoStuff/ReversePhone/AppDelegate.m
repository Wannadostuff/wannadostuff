//
//  AppDelegate.m
//  Reverse Phone Lookup
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "AppDelegate.h"

#import "SlideMenuViewController.h"
#import "NewsFeedViewController.h"
#import "SettingsViewController.h"
#import "EventsViewController.h"
#import "AddEventViewController.h"
#import "ChatUsersViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "ContactViewController.h"
#import "FAQViewController.h"
#import "MainViewController.h"

#import "SVProgressHUD.h"

#import "MMDrawVisualStateManager.h"
#import "Shared.h"

#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "RMStoreAppReceiptVerifier.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Shared.h"
#import "UserData.h"
#import "WebServicesClient.h"

@interface AppDelegate ()

@property (nonatomic, strong) UserData *userData;

@end

@implementation AppDelegate {
    id<RMStoreReceiptVerifier> _receiptVerifier;
    RMStoreKeychainPersistence *_persistence;
}

//deviceUDID	__NSCFString *	@"E047584C-4939-4D90-AE3A-7A62904FD11E"	0x14e72150
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *deviceUDID = [[Shared sharedInstance] getUniqueDeviceIdentifierAsString];
    if(deviceUDID.length == 0) deviceUDID = @"Simulator";
    //NSString *deviceUDID = @"Test Device3";
    [[NSUserDefaults standardUserDefaults] setObject:deviceUDID forKey:kUserDefaultsKeyDeviceID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self initNotificationSettings];
    
    NSDictionary * remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //Accept push notification when app is not open
    if (remoteNotifiInfo) {
        [self application:application didReceiveRemoteNotification: remoteNotifiInfo];
    }
    
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];

    [self initializeViewControllers];
    [self initializeAppearance];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [FBSDKButton class];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}
    
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)configureStore {
    _receiptVerifier = [[RMStoreAppReceiptVerifier alloc] init];
    [RMStore defaultStore].receiptVerifier = _receiptVerifier;
    
    _persistence = [[RMStoreKeychainPersistence alloc] init];
    [RMStore defaultStore].transactionPersistor = _persistence;
}

//711EF5EC-7354-4813-A83B-94C2A1C0CD8F
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self userInit:@"N"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([Shared sharedInstance].isInitialized == YES) {

    }
    [FBSDKAppEvents activateApp];
    [self userInit:@"Y"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initializeViewControllers {
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SlideMenuViewController *sliderView = [storyboard instantiateViewControllerWithIdentifier:@"SlideMenuViewController"];
    UINavigationController *sliderNavigationController = [[UINavigationController alloc] initWithRootViewController:sliderView];
    
    NewsFeedViewController *newsFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewsFeedViewController"];
    self.newsFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:newsFeedViewController];
    EventsViewController *eventsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
    self.eventsNavigationController = [[UINavigationController alloc] initWithRootViewController:eventsViewController];
    
    AddEventViewController *addEventViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddEventViewController"];
    self.addEventNavigationController = [[UINavigationController alloc] initWithRootViewController:addEventViewController];
    
    ChatUsersViewController *chatUsersViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChatUsersViewController"];
    self.chatNavigationController = [[UINavigationController alloc] initWithRootViewController:chatUsersViewController];
    
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    self.profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    ContactViewController *contactViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    self.contactNavigationController = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    
    FAQViewController *faqViewController = [storyboard instantiateViewControllerWithIdentifier:@"FAQViewController"];
    self.FAQNavigationController = [[UINavigationController alloc] initWithRootViewController:faqViewController];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    _slideViewController = [[MMDrawerController alloc] initWithCenterViewController:self.newsFeedNavigationController leftDrawerViewController:sliderNavigationController rightDrawerViewController:nil];
    [_slideViewController setShowsShadow:YES];
    [_slideViewController setRestorationIdentifier:@"MMDrawer"];
    [_slideViewController setMaximumRightDrawerWidth:200.0];
    [_slideViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_slideViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [_slideViewController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
}

- (void)initializeAppearance {
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x809abf)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xFFFFFF)];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Avenir" size:20], NSFontAttributeName, nil]];
    
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0x809abf)];
    [SVProgressHUD setForegroundColor:UIColorFromRGB(0x5df1f6)];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 10001) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

- (void)switchNavigationController:(UINavigationController*)navigationController {
    [navigationController popToRootViewControllerAnimated:NO];
    [self.slideViewController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
}
    
- (void)initNotificationSettings {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self launchNotification:userInfo];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self launchNotification:userInfo];
}

- (void)launchNotification:(NSDictionary*)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSDictionary *aps = (NSDictionary *)[userInfo objectForKey:@"aps"];

    NSDictionary* userData = [userInfo objectForKey:@"data"];

    NSString* type = [aps objectForKey:@"type"];
    NSString* event_id = [userData objectForKey:@"uid"];

    if ([type isEqualToString:@"add_event"]) {

        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[NSString stringWithFormat:@"add_event_%@", event_id]];
//        [self goEventPage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveMessageNotification object:userInfo];
}
         
- (void)goEventPage {
    [self switchNavigationController:self.newsFeedNavigationController];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *newToken = [deviceToken description];
    newToken           = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken           = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:kUserDefaultsKeyDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userInit:(NSString *)activeState {
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    if (![_userData.userID isEqualToString:@""]) {
        NSDictionary *params = @{@"uid": _userData.userID, @"is_active": activeState};
        
        [[WebServicesClient sharedClient]userOutIn:params completion:^(BOOL success) {
            if (success) {
                
            }
        }];
    }
}

@end
