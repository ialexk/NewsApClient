//
//  NewsData.h
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsData : NSObject <NSCopying>
@property (nonatomic, nullable) NSString* status;
@property (nonatomic) NSInteger totalResults;
@property (strong, nonatomic, nullable) NSArray* articles;
@property (strong, nonatomic, nullable) NSDictionary* artIndex;

-(bool)parseNewsData:(NSDictionary*)dict;
-(bool)compare:(NewsData*)src;
-(Article*)findArticle:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
