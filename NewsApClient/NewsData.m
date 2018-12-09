//
//  NewsData.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "NewsData.h"
#import "AppDelegate.h"


@implementation NewsData

-(id)init {
    if (self = [super init]) {
        NSLog(@"NewsData init");
        [self clear];
    }
    return self;
}

-(void)clear {
    self.articles = nil;
    self.status = nil;
    self.totalResults = 0;
    self.articles = nil;
    self.artIndex = nil;
}

-(void)dealloc {
    NSLog(@"NewsData dealloc");
}

-(bool)parseNewsData:(NSDictionary*)dict { // dictionary created from json
    if (![AppDelegate isValidObject:dict]) {
        return false;
    }
    NSString* status = [dict objectForKey:@"status"];
    if ([AppDelegate isValidObject:status]) {
        self.status = [NSString stringWithFormat:@"%@", status];
    }
    NSNumber* totalResults = [dict objectForKey:@"totalResults"];
    if ([AppDelegate isValidObject:totalResults]) {
        self.totalResults = totalResults.integerValue;
    }
    NSArray* articles = [dict objectForKey:@"articles"];
    if ([AppDelegate isValidObject:articles]) {
        NSMutableArray *articlesM = [[NSMutableArray alloc] init];
        NSMutableDictionary *dictIndex = [[NSMutableDictionary alloc] init];
        for (NSDictionary* dictArticle in articles) {
            Article* article = [[Article alloc] init];
            if ([article parseArticle:dictArticle]) {
                [articlesM addObject:article];
                [dictIndex setObject:article forKey:[article getKey]];
            }
            else {
                NSLog(@"NewsData: failed to parse JSON object: Article");
                return false;
            }
        }
        self.artIndex = dictIndex;
        self.articles = articlesM.copy;
    }
    return true;
}

- (id)copyWithZone:(NSZone *)zone {
    NewsData *new = [[NewsData alloc] init];
    new.status = [_status copyWithZone:zone];
    new.totalResults = _totalResults;
    new.articles = [_articles copyWithZone:zone];
    new.artIndex = [_artIndex copyWithZone:zone];
    return new;
}

// returns true if equal
-(bool)compare:(NewsData*)src {
    if (self.totalResults != src.totalResults) {
        return false;
    }
    if (![self.status isEqual:src.status]) {
        return false;
    }
    if (self.articles.count != src.articles.count) {
        return false;
    }
    for (NSInteger i = 0; i < self.articles.count; i++) {
        Article* article = [self.articles objectAtIndex:i];
        Article* articleSrc = [src.articles objectAtIndex:i];
        if (![article compare:articleSrc]) {
            return false;
        }
    }
    return true;
}

-(Article*)findArticle:(NSString*)key {
    if (nil == self.artIndex) {
        return nil;
    }
    return [self.artIndex objectForKey:key];
}

@end
