#import <UIKit/UIKit.h>
#ifdef iPhone

@interface WPHTTPAuthenticationAlertView : UIAlertView
- (id)initWithChallenge:(NSURLAuthenticationChallenge *)challenge;
@end

#endif
