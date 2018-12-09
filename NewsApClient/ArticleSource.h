//
//  ArticleSource.h
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleSource : NSObject <NSCopying>
@property (nonatomic, nullable) NSString* sourceid;
@property (strong, nonatomic, nullable) NSString* name;

@end

NS_ASSUME_NONNULL_END
