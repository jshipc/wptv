//
//  WTTemplateAmitVC.h
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTemplateAmitVC : UIViewController

+(instancetype)instantiateFromStoryBoard;
-(void)prepareWithTitle:(NSString*)title message:(NSString*)message backgroundImageURL:(NSString*)stringURL;

@end
