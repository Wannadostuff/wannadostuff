#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height >= 568 )

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kUserDefaultsKeyPassCode        @"PassCode"
#define kUserDefaultsKeyDeviceToken     @"DeviceToken"
#define kUserDefaultsKeyDeviceID        @"DeviceID"
#define kUserDefaultsKeyUserData        @"UserData"

#define kCreditChangedNotification      @"CoinChanged"
#define kReceiveMessageNotification     @"ReceiveMessage"
#define kRefreshMessageNotification     @"RefreshMessage"

#define BaseURL                         @"http://35.162.178.237/admin/backend/"
