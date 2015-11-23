//
//  AppDelegate.m
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import "AppDelegate.h"
#import "WordPressApi.h"
#import "WordPressRestApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (id)sharedManager {
    static AppDelegate *sharedApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApplication = [[self alloc] init];
    });
    return sharedApplication;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    if (DEBUG) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        [def setObject:@"naqi" forKey:@"wp_username"];
        [def setObject:@"Be#t%tM*#y^GKIga8^QMuCCQ" forKey:@"wp_password"];
        [def synchronize];
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *username = [def objectForKey:@"wp_username"];
    NSString *password = [def objectForKey:@"wp_password"];
    
    [WordPressApi signInWithURL:@"http://wptv.io" username:username password:password success:^(NSURL *xmlrpcURL) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[xmlrpcURL absoluteString] forKey:@"wp_xmlrpc"];
        [def synchronize];
        
        if (self.api == nil) {
            NSString *xmlrpc = [def objectForKey:@"wp_xmlrpc"];
            if (xmlrpc) {
                if (username && password) {
                    self.api = [WordPressApi apiWithXMLRPCURL:xmlrpcURL username:username password:password];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationForCompletion" object:nil];
                }
            }
        }
        
//        [self.api getPosts:10 success:^(NSArray *posts) {
//            NSLog(@"posts:%@", posts);
//            [self extractMeaningfulDictionariesFromArray:posts];
//        } failure:^(NSError *error) {
//            NSLog(@"error:%@", error);
//        }];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
    return YES;
}

-(void)extractMeaningfulDictionariesFromArray:(NSArray*)dictionaries{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in dictionaries) {
        
        NSArray *catergories = [dict objectForKey:@"categories"];
        NSString *catergory = [catergories firstObject];
        NSLog(@"catergory: %@", catergory);
        
        if ([catergory isEqualToString:@"apple-tv"]) {
            [tempArray addObject:dict];
        }
    }
    
    _posts = [NSArray arrayWithArray:tempArray];
    
    NSLog(@"the post : %@",_posts);
    
    // grabs main thread, handles the result of the data fetch
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataIsReady" object:nil];
        
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
