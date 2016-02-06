#import <UIKit/UIKit.h>

@interface IAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(UIAlertController *)showErrorWithTitle: (NSString *) title
                              andMessage: (NSString *) message;

@end

