//
//  Article.h
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article : NSObject <NSCopying>
@property (strong, nonatomic, nullable) ArticleSource* articleSource;
@property (strong, nonatomic, nullable) NSString* author;
@property (strong, nonatomic, nullable) NSString* title;
@property (strong, nonatomic, nullable) NSString* descr; // description
@property (strong, nonatomic, nullable) NSString* url;
@property (strong, nonatomic, nullable) NSString* urlToImage;
@property (strong, nonatomic, nullable) NSString* publishedAt; // TODO: convert to date/time
@property (strong, nonatomic, nullable) NSString* content;
-(bool)parseArticle:(NSDictionary*)dict; // dictionary from json
-(bool)compare:(Article*)src;
-(nonnull NSString*)getKey;

@end

NS_ASSUME_NONNULL_END
