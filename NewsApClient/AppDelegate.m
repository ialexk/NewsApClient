//
//  AppDelegate.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "AppDelegate.h"

NSString* kMessageApiKeyIsEmpty = @"The API Key is empty. To test this application, go to newsapi.org, choose 'Get API Key' (free) and set the kApiKey constant string variable.";
NSString* kApiKey = @""; // <==== @"XXXXXXX-your-APIKey-from-newsapi.org-XXXXXXXX". Go to newsapi.org and choose 'Get API Key' (free).

NSString* kAlertMessageTheRequestHasFailed = @"The request has failed. You use invalid API Key, or target API URL has changed, or something else."; // GET request to newsapi.org has failed. Probably the API Key is invalid or the API URL has changed (see kNewsApiUrl).
NSString* kAlertActionTitleClose = @"Close";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(BOOL)isValidObject:(nullable NSObject*)object {
    if (nil != object) {
        if ([NSNull null] != (NSObject*)object) {
            return YES;
        }
    }
    return NO;
}

+(bool)isApiKeyEmpty {
    if (0 == kApiKey.length) {
        return true;
    }
    return false;
}

@end
