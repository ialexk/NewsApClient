//
//  ArticleSource.m
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import "ArticleSource.h"

@implementation ArticleSource

-(id)init {
    if (self = [super init]) {
        [self clear];
    }
    return self;
}

-(void)clear {
    self.sourceid = nil;
    self.name = nil;
}

- (id)copyWithZone:(NSZone *)zone {
    ArticleSource *new = [[ArticleSource alloc] init];
    new.sourceid = [_sourceid copyWithZone:zone];
    new.name = [_name copyWithZone:zone];
    return new;
}

@end
