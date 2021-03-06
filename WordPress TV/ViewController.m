//
//  ViewController.m
//  WordPress TV
//
//  Created by Amit Sharma on 11/22/15.
//  Copyright © 2015 WPTV. All rights reserved.
//

#import "ViewController.h"
#import "WordPressApi.h"
#import "WTTemplateAmitVC.h"
#import "WTTemplateDane.h"
#import "AppDelegate.h"

static NSString *kSampleText = @" simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was populari";

@interface ViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic) NSInteger nextIndex;

@property (strong, nonatomic) NSTimer *nextSlideTimer;

@property (strong, nonatomic) NSArray *posts;

@property (strong, nonatomic) WTTemplateDane *fakeVC;

@end

@implementation ViewController

-(void)startAutomaticScrolling{
    
    [_nextSlideTimer invalidate];
    _nextSlideTimer = nil;
    _nextSlideTimer = [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(showNextViewController) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_nextSlideTimer forMode:NSRunLoopCommonModes];
}

-(void)showNextViewController{
    
    NSInteger currentPageIndex = [self indexOfPageViewController:[[_pageController viewControllers] firstObject]];
    
    NSInteger nextPageIndex;
    nextPageIndex = (currentPageIndex == _viewControllers.count - 1) ? 0 : currentPageIndex + 1;
    
    UIViewController *nextView = [_viewControllers objectAtIndex:nextPageIndex];
    [_pageController setViewControllers:@[nextView]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_nextSlideTimer invalidate];
    _nextSlideTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self startAutomaticScrolling];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupViewControllers];
    
    _pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                   options:nil];
    
    [_pageController setViewControllers:@[[_viewControllers firstObject]]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    _pageController.delegate = self;
    _pageController.dataSource = self;
    
    [self.view addSubview:_pageController.view];
    [self preUpdateUI];
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
    
    self.posts = [NSArray arrayWithArray:tempArray];
    
    NSLog(@"the post : %@",self.posts);
    
    // grabs main thread, handles the result of the data fetch
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateUI];
        
    });
}

-(void)preUpdateUI{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *username = [def objectForKey:@"wp_username"];
    NSString *password = [def objectForKey:@"wp_password"];
    NSString *xmlrpc = [def objectForKey:@"wp_xmlrpc"];
    if (xmlrpc) {
        if (username && password) {
            WordPressRestApi *api = [WordPressApi apiWithXMLRPCURL:[NSURL URLWithString:xmlrpc] username:username password:password];
            [api getPosts:10 success:^(NSArray *posts) {
                [self extractMeaningfulDictionariesFromArray:posts];
            } failure:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
    }
}

-(void)updateUI{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.posts) {
        
        NSString *title = [dict objectForKey:@"title"];
        NSString *description = [dict objectForKey:@"description"];
        
        NSString *imageURL = nil;
        NSArray *customFields = [dict objectForKey:@"custom_fields"];
        if (customFields) {
            imageURL = [[customFields firstObject] objectForKey:@"value"];
            NSLog(@"grabtag %@",imageURL);
        }
        
        //NSString *description = [dict objectForKey:@"WP"];

        WTTemplateAmitVC *newVC = [WTTemplateAmitVC instantiateFromStoryBoard];
        [newVC prepareWithTitle:title message:description backgroundImageURL:imageURL];
        [tempArray addObject:newVC];
        
        NSLog(@"creating new VC");
    }
//    
//    _fakeVC = [[UIStoryboard storyboardWithName:@"WTTemplateDaneTwo" bundle:nil] instantiateViewControllerWithIdentifier:@"VersionTwo"];
//    NSLog(@"%@",_fakeVC);
//    _fakeVC.view.backgroundColor = [UIColor redColor];
  //  [tempArray addObject:_fakeVC];
    
    _viewControllers = [NSArray arrayWithArray:tempArray];
    [_pageController setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)viewWillLayoutSubviews{
    
    _pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)setupViewControllers{
    
    WTTemplateAmitVC *amitVC = [WTTemplateAmitVC instantiateFromStoryBoard];
    [amitVC prepareWithTitle:@"This is an Example Title" message:kSampleText backgroundImageURL:@"http://i.imgur.com/oYwWijF.jpg"];
    
    WTTemplateAmitVC *daneVC = [WTTemplateAmitVC instantiateFromStoryBoard];
    [daneVC prepareWithTitle:@"This is an Example Title" message:kSampleText backgroundImageURL:@"http://i.imgur.com/oYwWijF.jpg"];
    
    UIViewController *three = [[UIViewController alloc]init];
    three.view.backgroundColor = [UIColor greenColor];
    
    _viewControllers = @[amitVC, daneVC, three];
}


#pragma mark - Page View Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self indexOfPageViewController:viewController];
    
    if (index == NSNotFound) return nil;
    index ++;
    if (index == _viewControllers.count) index = 0;
    
    return [_viewControllers objectAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self indexOfPageViewController:viewController];
    
    if (index == NSNotFound) return nil;
    if (index == 0) index = _viewControllers.count - 1;
    else index --;
    
    return [_viewControllers objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    
    return 5;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    UIViewController *controller = [pendingViewControllers firstObject];
    self.nextIndex = [self indexOfPageViewController:controller];
}

#pragma mark - Page View Delegate

-(NSInteger)indexOfPageViewController:(UIViewController*)page{
    
    return [_viewControllers indexOfObject:page];
}

@end
