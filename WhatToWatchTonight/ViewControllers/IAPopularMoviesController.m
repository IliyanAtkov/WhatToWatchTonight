#import "IAPopularMoviesController.h"
#import "IAMovieDbClient.h"
#import <Mantle/Mantle.h>
#import "IAUrlConstants.h"

@interface IAPopularMoviesController ()
@property NSArray *popularMovies;
@end

@implementation IAPopularMoviesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  IAMovieDbClient *client = [[IAMovieDbClient alloc] init];
   //NSDictionary *parameters = @{
   //                              IAApiKeyName : IAApiKeyValue
   //                              };
    
    //[client GET:IAUrlMovieById parameters:parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error)  {
        
//        self.popularMovies = response.result;
       // dispatch_async(dispatch_get_main_queue(), ^{
        //    self.popularMovie
     //   })
        //NSLog(@"%@", [movie.genres[0] name]);
  //  }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
