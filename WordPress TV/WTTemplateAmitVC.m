//
//  WTTemplateAmitVC.m
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import "WTTemplateAmitVC.h"
#import "UIImageView+asyncImageLoader.h"

@interface WTTemplateAmitVC ()

@property (strong, nonatomic) NSString *slideLabel;
@property (strong, nonatomic) NSString *slideMessage;
@property (strong, nonatomic) NSString *slideImageURL;

@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UILabel *pageMessage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;

@end

@implementation WTTemplateAmitVC

+(instancetype)instantiateFromStoryBoard{
    
    return [[UIStoryboard storyboardWithName:@"WTTemplateAmit" bundle:nil] instantiateViewControllerWithIdentifier:@"AmitBoard"];
}

-(void)viewDidLoad{
    
    _labelContainer.layer.cornerRadius = 10.0f;
    _labelContainer.layer.masksToBounds = YES;
    
    _pageTitle.text = _slideLabel;
    _pageMessage.text = _slideMessage;
    [_backgroundImage asyncSetImageWithURLString:_slideImageURL];
}

-(void)prepareWithTitle:(NSString*)title message:(NSString*)message backgroundImageURL:(NSString*)stringURL{
    
    _slideLabel = title;
    _slideMessage = message;
    _slideImageURL = stringURL;
}



@end
