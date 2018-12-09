//
//  AppDelegate.h
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* kMessageApiKeyIsEmpty;
extern NSString* kApiKey;

extern NSString* kAlertMessageTheRequestHasFailed;
extern NSString* kAlertActionTitleClose;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(BOOL)isValidObject:(nullable NSObject*)object;
+(bool)isApiKeyEmpty;


@end

