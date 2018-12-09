//
//  Article.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "Article.h"
#import "ArticleSource.h"
#import "AppDelegate.h"

@implementation Article

-(id)init {
    if (self = [super init]) {
        [self clear];
    }
    return self;
}

-(void)clear {
    self.articleSource = nil;
    self.author = nil;
    self.title = nil;
    self.descr = nil;
    self.url = nil;
    self.urlToImage = nil;
    self.publishedAt = nil;
    self.content = nil;
}

-(bool)parseArticle:(NSDictionary*)dict { // dictionary created from json
    if (![AppDelegate isValidObject:dict]) {
        return false;
    }
    NSDictionary* source = [dict objectForKey:@"source"];
    if ([AppDelegate isValidObject:source]) {
        // parse article source
        self.articleSource = [[ArticleSource alloc] init];
        NSString* sourceid = [source objectForKey:@"id"];
        if ([AppDelegate isValidObject:sourceid]) {
            self.articleSource.sourceid = [NSString stringWithFormat:@"%@", sourceid];
        }
        NSString* name = [source objectForKey:@"name"];
        if ([AppDelegate isValidObject:name]) {
            self.articleSource.name = [NSString stringWithFormat:@"%@", name];
        }
    }

    NSString* author = [dict objectForKey:@"author"];
    if ([AppDelegate isValidObject:author]) {
        self.author = [NSString stringWithFormat:@"%@", author];
    }
    NSString* title = [dict objectForKey:@"title"];
    if ([AppDelegate isValidObject:title]) {
        self.title = [NSString stringWithFormat:@"%@", title];
    }
    NSString* descr = [dict objectForKey:@"description"];
    if ([AppDelegate isValidObject:descr]) {
        self.descr = [NSString stringWithFormat:@"%@", descr];
    }
    NSString* url = [dict objectForKey:@"url"];
    if ([AppDelegate isValidObject:url]) {
        self.url = [NSString stringWithFormat:@"%@", url];
    }
    NSString* urlToImage = [dict objectForKey:@"urlToImage"];
    if ([AppDelegate isValidObject:urlToImage]) {
        self.urlToImage = [NSString stringWithFormat:@"%@", urlToImage];
    }
    NSString* publishedAt = [dict objectForKey:@"publishedAt"];
    if ([AppDelegate isValidObject:publishedAt]) {
        self.publishedAt = [NSString stringWithFormat:@"%@", publishedAt];
    }
    NSString* content = [dict objectForKey:@"content"];
    if ([AppDelegate isValidObject:content]) {
        self.content = [NSString stringWithFormat:@"%@", content];
    }
    return true;
}

- (id)copyWithZone:(NSZone *)zone {
    Article *new = [[Article alloc] init];
    new.articleSource = [_articleSource copyWithZone:zone];
    new.author = [_author copyWithZone:zone];
    new.title = [_title copyWithZone:zone];
    new.descr = [_descr copyWithZone:zone];
    new.url = [_url copyWithZone:zone];
    new.urlToImage = [_urlToImage copyWithZone:zone];
    new.publishedAt = [_publishedAt copyWithZone:zone];
    new.content = [_content copyWithZone:zone];
    return new;
}

// returns true if equal
-(bool)compare:(Article*)src {
    // compare only "visible" data
    if (nil != self.title || nil != src.title) {
        if (![self.title isEqual:src.title]) {
            return false;
        }
    }
    if (nil != self.descr || nil != src.descr) {
        if (![self.descr isEqual:src.descr]) {
            return false;
        }
    }
    if (nil != self.content || nil != src.content) {
        if (![self.content isEqual:src.content]) {
            return false;
        }
    }
    if (nil != self.url || nil != src.url) {
        if (![self.url isEqual:src.url]) { // url is used in WebKit view
            return false;
        }
    }
    // ... other data is "invisible"
    return true;
}

-(nonnull NSString*)getKey {
    NSString* t = (nil == self.title) ? @"" : self.title;
    NSString* u = (nil == self.url) ? @"" : self.url;
    // we assume that if title or url has changed, then it is another news article
    // thus, if news editor changes at least one symbol in title, then on the next data update we will not be able to identify it and associate with the article we preview in detailed view
    return [NSString stringWithFormat:@"%@%@", t, u];
}

@end
