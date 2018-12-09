//
//  NewsDataSource.m
//  NewsApClient
//
//  Created by S. K. on 09.12.2018.
//  Copyright © 2018 newsapclient. All rights reserved.
//

#import "NewsDataSource.h"
#import "NewsData.h"
#import "AppDelegate.h"

NSString* kNewsApiUrl = @"https://newsapi.org/v2/top-headlines?country=us";
const NSNotificationName kNotificationNewData = @"Notification_NewData";
const NSNotificationName kNotificationRequestFailed = @"Notification_RequestFailed";
const NSTimeInterval kRequestsPeriodSeconds = 15.0;

@interface NewsDataSource ()
@property(nonatomic,retain) NSTimer* timer;
@property(nonatomic) NSInteger countSubscribers;
@end

@implementation NewsDataSource

-(id)init {
    if (self = [super init]) {
        NSLog(@"NewsDataSource init");
        self.countSubscribers = 0;
    }
    return self;
}

-(void)dealloc {
    NSLog(@"NewsDataSource dealloc");
    [self stopTimer];
}

+ (id)sharedInstance {
    static NewsDataSource *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

-(void)subscribe {
    if (0 == self.countSubscribers) {
        if (nil == self.newsData) {
            [self getNews];
            [self startTimer];
        }
    }
    else {
        if (nil != self.newsData) {
            // let subscriber know that the data is already available
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewData object:nil userInfo:nil];
        }
    }
    self.countSubscribers++;
    NSLog(@"Subscribed");
}

-(void)unsubscribe {
    if (0 == self.countSubscribers) {
        NSLog(@"Subscribers count is already 0");
    }
    else {
        self.countSubscribers--;
    }
    if (0 == self.countSubscribers) {
        [self stopTimer];
    }
    NSLog(@"Unsubscribed");
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kRequestsPeriodSeconds target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (nil != self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onTimer {
    NSLog(@"onTimer");
    [self getNews];
}

-(void)getNews {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:kNewsApiUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:kApiKey forHTTPHeaderField:@"Authorization"];
    NSLog(@"GET url %@ with Authorization:%@", url.absoluteString, kApiKey);
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        if (nil == response) {
            NSLog(@"Error response from: %@", url.absoluteString);
        }
        else {
            NSInteger code = ((NSHTTPURLResponse*)response).statusCode;
            if (code == 200) {
                NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSLog(@"JSON returned: %@", json);
                NSData* dataJson = [json dataUsingEncoding:NSUTF8StringEncoding];
                json = nil;
                NSError *e = nil;
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&e];
                dataJson = nil;
                if ([NSJSONSerialization isValidJSONObject:dict]) {
                    NewsData* newsData = [[NewsData alloc] init];
                    if ([newsData parseNewsData:dict]) {
                        if ([newsData.status isEqualToString:@"ok"]) {
                            // compare new and old one
                            if ((nil == self.newsData) || ![self.newsData compare:newsData]) {
                                self.newsData = newsData;
                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewData object:nil userInfo:nil];
                            }
                        }
                    }
                    else {
                        // TODO: Incorrect data format
                    }
                    dict = nil;
                }
            }
            else {
                NSLog(@"Server returned code: %li (\"%@\")", code, [NSHTTPURLResponse localizedStringForStatusCode:code]);
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRequestFailed object:nil userInfo:nil];
            }
        }
    }];
    [task resume];
}

@end
