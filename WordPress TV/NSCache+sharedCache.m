//
//  NSCache+sharedCache.m
//  Ehco
//
//  Created by Amit Sharma on 10/30/15.
//  Copyright © 2015 Ehco. All rights reserved.
//

#import "NSCache+sharedCache.h"

@implementation NSCache (sharedCache)

+ (NSCache*)sharedCache{
    static dispatch_once_t predicate = 0;
    __strong static NSCache *globalCache = nil;
    dispatch_once(&predicate, ^{
        globalCache = [[self alloc] init];
    });
    return globalCache;
}

@end
