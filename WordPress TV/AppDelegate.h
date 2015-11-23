//
//  AppDelegate.h
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordPressRestApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (id)sharedManager;

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, nonatomic, retain) id<WordPressBaseApi> api;

@property (strong, nonatomic) NSArray *posts;

@end

