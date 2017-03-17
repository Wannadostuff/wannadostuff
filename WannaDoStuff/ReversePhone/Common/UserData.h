//
//  UserData.h
//  WannaDoStuff
//
//  Created by Mac on 3/11/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *visitCount;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString *lastVisitDate;

- (void) saveUserData;
- (void) getUserData;
- (void) clearUserData;
- (void) deleteUserData;

@end
