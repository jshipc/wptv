//
//  WTTemplateDane.m
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import "WTTemplateDane.h"
#import "UIImageView+asyncImageLoader.h"

@interface WTTemplateDane ()

@property (strong, nonatomic) NSString *slideLabel;
@property (strong, nonatomic) NSString *slideMessage;
@property (strong, nonatomic) NSString *slideImageURL;
//
//@property (weak, nonatomic) IBOutlet UIImageView *imageWrapper;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation WTTemplateDane

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    
//    self.imageWrapper.layer.cornerRadius = 3.0;
//    
//    [self.imageWrapper asyncSetImageWithURLString:_slideImageURL];
//   // self.titleLabel.text = _slideLabel;
//    self.detailLabel.text = _slideMessage;
//    
//    [self.detailLabel sizeToFit];
}

+(instancetype)instantiateFromStoryBoard{
//    
    return [[UIStoryboard storyboardWithName:@"WTTemplateDaneTwo" bundle:nil] instantiateViewControllerWithIdentifier:@"VersionTwo"];
}

-(void)prepareWithTitle:(NSString*)title message:(NSString*)message backgroundImageURL:(NSString*)stringURL{
//    
//    _slideLabel = title;
//    _slideMessage = message;
//    _slideImageURL = stringURL;
}




@end
