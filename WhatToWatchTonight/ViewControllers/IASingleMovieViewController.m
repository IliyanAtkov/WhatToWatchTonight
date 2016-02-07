#import "IASingleMovieViewController.h"
#import "IAMovie.h"
#import "IAMovieDbClient.h"
#import "IAUrlConstants.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAAppDelegate.h"

@implementation IASingleMovieViewController
{
    IAMovie *_movie;
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMovie];

}

-(void) loadMovie {
    _client = [[IAMovieDbClient alloc] init];
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue
                    };
    NSString *url = [IAUrlMovieById stringByAppendingString:[NSString stringWithFormat:@"%ld", self.movieID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak id weakSelf = self;
    [_client GET:url parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
            [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
            if (error != nil) {
                if (![weakSelf presentedViewController])
                {
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            }
            else {
                _movie = response.result;
                [self setMovie];
            }
        });
    }];
}

-(void)setMovie {
    UIImage *defaultImage = [UIImage imageNamed:@"noImage"];

    self.title = _movie.title;
    self.budget.text = [_movie.budget stringValue];
    if (_movie.urlImage != nil) {
        NSURL *imageUrl = [NSURL URLWithString:[IAImageBigBaseUrl stringByAppendingString:_movie.urlImage]];
        [self.image sd_setImageWithURL:imageUrl
                      placeholderImage:defaultImage];
    }
    else {
        self.image.image = defaultImage;
    }
    
    self.genres.text = [self appendGenres];
    self.releaseDate.text = [[[NSDateFormatter alloc] init] stringFromDate:_movie.releaseDate];
    self.runtime.text = [_movie.runtime stringValue];
    self.revenue.text = [_movie.revenue stringValue];
    self.voteAverage.text = [_movie.voteAverage stringValue];
    self.overview.text = _movie.overview;
}
-(NSString *) appendGenres {
    NSMutableString *genres = [[NSMutableString alloc] init];
    for (int i = 0; i < _movie.genres.count; i++) {
        NSString *genre = [_movie.genres[i] name];
        [genres appendString:genre];
        if (i != _movie.genres.count - 1) {
            [genres appendString:@", "];
        }
    }
    
    return genres;
}
@end
