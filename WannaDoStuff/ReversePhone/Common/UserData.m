//
//  UserData.m
//  WannaDoStuff
//
//  Created by Mac on 3/11/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "UserData.h"
#import "Constants.h"

@implementation UserData

- (id) init
{
    if ([super init]) {
        _userID = @"";
        _facebookID = @"";
        _userName = @"";
        _userEmail = @"";
        _firstName = @"";
        _lastName = @"";
        _photoURL = @"";
        _gender = @"";
        _age = @"";
        _visitCount = @"";
        _updateDate = @"";
        _lastVisitDate = @"";
    }
    return self;
}

- (void) saveUserData
{
    NSDictionary *userData = @{
                               @"userID":_userID,
                               @"facebookID":_facebookID,
                               @"userName":_userName,
                               @"userEmail":_userEmail,
                               @"firstName":_firstName,
                               @"lastName":_lastName,
                               @"photoURL":_photoURL,
                               @"gender":_gender,
                               @"age":_age,
                               @"visitCount":_visitCount,
                               @"updateDate":_updateDate,
                               @"lastVisitDate":_lastVisitDate
                               };
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:kUserDefaultsKeyUserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) getUserData
{
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyUserData];
    if (userData) {
        _userID = [userData valueForKey:@"userID"];
        _facebookID = [userData valueForKey:@"facebookID"];
        _userName = [userData valueForKey:@"userName"];
        _userEmail = [userData valueForKey:@"userEmail"];
        _firstName = [userData valueForKey:@"firstName"];
        _lastName = [userData valueForKey:@"lastName"];
        _photoURL = [userData valueForKey:@"photoURL"];
        _gender = [userData valueForKey:@"gender"];
        _age = [userData valueForKey:@"age"];
        _visitCount = [userData valueForKey:@"visitCount"];
        _updateDate = [userData valueForKey:@"updateDate"];
        _lastVisitDate = [userData valueForKey:@"lastVisitDate"];
        
        if (!_userID) _userID = @"";
        if (!_facebookID) _facebookID = @"";
        if (!_userName) _userName = @"";
        if (!_userEmail) _userEmail = @"";
        if (!_firstName) _firstName = @"";
        if (!_lastName) _lastName = @"";
        if (!_photoURL) _photoURL = @"";
        if (!_gender) _gender = @"";
        if (!_age) _age = @"";
        if (!_visitCount) _visitCount = @"";
        if (!_updateDate) _updateDate = @"";
        if (!_lastVisitDate) _lastVisitDate = @"";
    }
}

- (void) clearUserData
{
    _userID = @"";
    _facebookID = @"";
    _userName = @"";
    _userEmail = @"";
    _firstName = @"";
    _lastName = @"";
    _photoURL = @"";
    _gender = @"";
    _age = @"";
    _visitCount = @"";
    _updateDate = @"";
    _lastVisitDate = @"";
}

- (void) deleteUserData {
    [self clearUserData];
    [self saveUserData];
}
@end
