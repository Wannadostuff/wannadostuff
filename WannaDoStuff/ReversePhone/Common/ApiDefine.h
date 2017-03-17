//
//  ApiDefine.h
//  PrivateText
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiDefine : NSObject

+ (NSString*)loginURL;
+ (NSString*)profileUpdateURL;
+ (NSString*)addEventURL;
+ (NSString*)acceptEventURL;
+ (NSString*)contactAdminURL;
+ (NSString*)userOutInURL ;
+ (NSString*)newsFeedURL;
+ (NSString*)eventURL;
+ (NSString*)chatUserURL;
+ (NSString*)chatDataURL;
+ (NSString*)sendMessageURL;
+ (NSString*)unreadMessageUpdateURL;
+ (NSString*)getUserURL;

@end
