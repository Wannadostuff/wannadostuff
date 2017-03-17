//
//  Shared.m
//  PrivateText
//
//  Created by Mac on 3/26/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "Shared.h"
#import "SSKeychain.h"

@implementation Shared

+ (Shared*)sharedInstance {
    static Shared *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance                   = [[self alloc] init];
        _sharedInstance.totalUnreadChatCount = 0;
        _sharedInstance.isInitialized = NO;
    });
    
    return _sharedInstance;
}

- (UIImage*)getScreenShot:(UIViewController*)viewController {
    UIGraphicsBeginImageContextWithOptions(viewController.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [viewController.view drawViewHierarchyInRect:viewController.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#define radians(degree) ((degree) * M_PI/180)
+ (UIImage *)rotateImage:(UIImage *)image byDegree:(CGFloat)degree
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians(degree));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
    
    CGContextRotateCTM(bitmap, radians(degree));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
    
- (NSString *)getUniqueDeviceIdentifierAsString {
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    //strApplicationUUID	__NSCFString *	@"316FD6F4-2502-40CB-8B01-F2DFEDB16222"	0x0000000157696f10
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"secrettext"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"secrettext"];
    }
    
    return strApplicationUUID;
}

@end
