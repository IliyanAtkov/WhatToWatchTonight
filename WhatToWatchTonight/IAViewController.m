#import "IAViewController.h"
#import "IAMovieDbClient.h"
#import <Mantle/Mantle.h>

@interface IAViewController ()
@end

@implementation IAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IAMovieDbClient *client = [[IAMovieDbClient alloc] init];
    
    NSDictionary *parameters = @{
                                 @"api_key" : @"1a66de8b5fd64165ba0e013578af737b"
                                 };

    [client GET:@"movie/2" parameters:parameters completion:^(OVCResponse *response, NSError *error) {
        IAMovie *movie = response.result;
        NSLog(@"%@", [movie.genres[0] name]);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
