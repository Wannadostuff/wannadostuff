//
//  WebServicesClient.m
//  PrivateText
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "WebServicesClient.h"
#import "ApiDefine.h"
#import "Constants.h"
#import "UserData.h"
//#import "SVProgressHUD.h"

@implementation WebServicesClient

+ (WebServicesClient*)sharedClient {
    static WebServicesClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedClient                    = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.requestSerializer  = [AFHTTPRequestSerializer serializer];
    });    

    return _sharedClient;
}

- (void)login:(NSDictionary *)params completion:(void (^)(BOOL, NSDictionary *))completionBlock {
    
        NSString *url = [ApiDefine loginURL];
        [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject objectForKey:@"data"]) {
                completionBlock(YES, [responseObject objectForKey:@"data"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            completionBlock(NO, nil);
            
        }];
}

- (void)profileUpdate:(UIImage*)image completion:(void(^)(BOOL, NSDictionary *))completionBlock {

    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSString *url = [ApiDefine profileUpdateURL];
    
    UserData *userData = [[UserData alloc] init];
    [userData getUserData];
    
    NSDictionary *params = @{@"uid":userData.userID, @"firstname":userData.firstName, @"lastname":userData.lastName, @"email":userData.userEmail, @"img_url":userData.photoURL};
    
    NSInteger photo_no = 0;
    photo_no = [[NSUserDefaults standardUserDefaults] integerForKey:@"photoNo"];
    
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"img_url" fileName:[NSString stringWithFormat:@"%@_photo_%ld.jpg", userData.userID, photo_no + 1] mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:photo_no + 1 forKey:@"photoNo"];
        userData.photoURL = [NSString stringWithFormat:@"http://35.162.178.237/admin/images/user/%@_photo_%ld.jpg", userData.userID, photo_no + 1];
        [userData saveUserData];
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completionBlock(NO, nil);
    }];
}

- (void)addEvent:(NSDictionary *)params completion:(void (^)(BOOL))completionBlock {
    
    NSString *url = [ApiDefine addEventURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

            completionBlock(YES);
     
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO);
        
    }];
}

- (void)acceptEvent:(NSDictionary *)params completion:(void (^)(BOOL))completionBlock {
    
    NSString *url = [ApiDefine acceptEventURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completionBlock(YES);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO);
        
    }];
}
    
- (void)contactAdmin:(NSDictionary *)params completion:(void (^)(BOOL))completionBlock {
    
    NSString *url = [ApiDefine contactAdminURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completionBlock(YES);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO);
        
    }];
}

- (void)userOutIn:(NSDictionary *)params completion:(void (^)(BOOL))completionBlock {
    
    NSString *url = [ApiDefine userOutInURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completionBlock(YES);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO);
        
    }];
}

- (void)newsfeedData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock {
    
    NSString *url = [ApiDefine newsFeedURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}

- (void)eventData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock {
    
    NSString *url = [ApiDefine eventURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}
    
    - (void)chatUserData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock {
        
        NSString *url = [ApiDefine chatUserURL];
        [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject objectForKey:@"data"]) {
                completionBlock(YES, [responseObject objectForKey:@"data"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            completionBlock(NO, nil);
            
        }];
    }

- (void)chatData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock {
    
    NSString *url = [ApiDefine chatDataURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}

- (void)unreadMessageUpdate:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableArray *))completionBlock {
    
    NSString *url = [ApiDefine unreadMessageUpdateURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}

- (void)sendMessage:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableDictionary *))completionBlock {
    
    NSString *url = [ApiDefine sendMessageURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}



- (void)getUserData:(NSDictionary *)params completion:(void (^)(BOOL, NSMutableDictionary *))completionBlock {
    
    NSString *url = [ApiDefine getUserURL];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject objectForKey:@"data"]) {
            completionBlock(YES, [responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completionBlock(NO, nil);
        
    }];
}

@end
