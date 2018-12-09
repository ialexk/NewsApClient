//
//  NewsDataSource.h
//  NewsApClient
//
//  Created by S. K. on 09.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSNotificationName kNotificationNewData;
extern const NSNotificationName kNotificationRequestFailed;

NS_ASSUME_NONNULL_BEGIN

@class NewsData;

@interface NewsDataSource : NSObject
@property (strong, nonatomic) NewsData* newsData;
+ (id)sharedInstance;
-(void)subscribe;
-(void)unsubscribe;

@end

NS_ASSUME_NONNULL_END
