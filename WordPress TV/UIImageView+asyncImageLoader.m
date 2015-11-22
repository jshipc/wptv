//
//  UIImageView+asyncImageLoader.m
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import "UIImageView+asyncImageLoader.h"
#import "NSCache+sharedCache.h"

@implementation UIImageView (asyncImageLoader)

-(void)asyncSetImageWithURLString:(NSString*)URLString{
    
    __weak UIImageView *weakImageView = self;
    __weak NSString *weakURLString = URLString;
    
    // creates and dispatches a aync queue
    dispatch_queue_t asyncQueue = dispatch_queue_create("async operation", NULL);
    dispatch_async(asyncQueue, ^{
        
        NSURL *URL = [NSURL URLWithString:weakURLString];
        
        // checks for image in global cache
        NSCache *sharedCache = [NSCache sharedCache];
        UIImage *image = [sharedCache objectForKey:weakURLString];
        
        // downloads image if not found in cache
        if (!image) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:URL];
            image = [UIImage imageWithData:imageData];
            
            // adds image to cache
            if (image){
                [sharedCache setObject:image forKey:weakURLString];
                weakImageView.image = image;
            }
        }
        else weakImageView.image = image;
    });
}

@end
