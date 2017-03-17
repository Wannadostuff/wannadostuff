//
//  Shared.h
//  PrivateText
//
//  Created by Mac on 3/26/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface Shared : NSObject

@property (nonatomic, strong) NSMutableArray *regionArray;
@property NSInteger totalUnreadChatCount;
@property BOOL isInitialized;

+ (Shared*)sharedInstance;

- (UIImage*)getScreenShot:(UIViewController*)viewController;

+ (UIImage *)rotateImage:(UIImage *)image byDegree:(CGFloat)degree;
    - (NSString*)getUniqueDeviceIdentifierAsString;

@end
