//
//  WebServicesClient.h
//  PrivateText
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface WebServicesClient : AFHTTPRequestOperationManager

+ (WebServicesClient*)sharedClient;

- (void)login:(NSDictionary *)params completion:(void(^)(BOOL success, NSDictionary *userData))completionBlock;
- (void)profileUpdate:(UIImage*)image completion:(void(^)(BOOL, NSDictionary *))completionBlock;
- (void)addEvent:(NSDictionary *)params completion:(void(^)(BOOL success))completionBlock;
- (void)acceptEvent:(NSDictionary *)params completion:(void(^)(BOOL success))completionBlock;
- (void)contactAdmin:(NSDictionary *)params completion:(void(^)(BOOL success))completionBlock;
- (void)userOutIn:(NSDictionary *)params completion:(void (^)(BOOL))completionBlock;
- (void)newsfeedData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock;
- (void)eventData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock;
- (void)chatUserData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock;
- (void)chatData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock;
- (void)sendMessage:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableDictionary *))completionBlock;
- (void)unreadMessageUpdate:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock;
- (void)getUserData:(NSDictionary *)params completion:(void(^)(BOOL success, NSMutableDictionary *userData))completionBlock;

@end
