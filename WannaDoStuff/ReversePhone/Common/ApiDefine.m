//
//  ApiDefine.m
//  PrivateText
//
//  Created by Mac on 3/25/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ApiDefine.h"
#import "Constants.h"

@implementation ApiDefine

+ (NSString*)loginURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"sign_in"];
}

+ (NSString*)profileUpdateURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"profile_update"];
}

+ (NSString*)addEventURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"add_event"];
}

+ (NSString*)acceptEventURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"accept_event"];
}

+ (NSString*)contactAdminURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"contact_admin"];
}
+ (NSString*)userOutInURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"user_out_in"];
}

+ (NSString*)newsFeedURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"newsfeed_data"];
}

+ (NSString*)eventURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"event_data"];
}
    
+ (NSString*)chatUserURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"chat_users"];
}

+ (NSString*)chatDataURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"chat_data"];
}

+ (NSString*)unreadMessageUpdateURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"unread_message_update"];
}

+ (NSString*)sendMessageURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"send_message"];
}


    
+ (NSString*)getUserURL {
    return [NSString stringWithFormat:@"%@%@", BaseURL, @"get_user"];
}


@end
