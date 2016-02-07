#import "IASingleTvViewController.h"
#import "IAMovieDbClient.h"
#import "IAUrlConstants.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAAppDelegate.h"
#import "IATv.h"
#import "IAUIConstants.h"

@implementation IASingleTvViewController
{
    IATv *_tv;
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTv];
    
}

-(void) loadTv {
    _client = [[IAMovieDbClient alloc] init];
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue
                    };
    NSString *url = [IAUrlTvById stringByAppendingString:[NSString stringWithFormat:@"%ld", self.tvID]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak id weakSelf = self;
    [_client GET:url parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
            [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
            if (error != nil) {
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }
            else {
                _tv = response.result;
                [weakSelf setTv];
            }
        });
    }];
}

-(void)setTv {
    UIImage *defaultImage = [UIImage imageNamed:@"noImage"];
    
    self.title = _tv.title;
    if (_tv.urlImage != nil) {
        NSURL *imageUrl = [NSURL URLWithString:[IAImageBigBaseUrl stringByAppendingString:_tv.urlImage]];
        [self.image sd_setImageWithURL:imageUrl
                      placeholderImage:defaultImage];
    }
    else {
        self.image.image = defaultImage;
    }
    if (_tv.genres) {
        self.genres.text = [self appendGenres];
    }
    else {
        self.genres.text = IANoInformation;
    }
    if (_tv.firstAirDate) {
        self.releaseDate.text = _tv.firstAirDate;
    }
    else {
        self.releaseDate.text = IANoInformation;
    }
    if (self.lastAirDate) {
        self.lastAirDate.text = _tv.lastAirDate;
    }
    else {
        self.lastAirDate.text = IANoInformation;
    }
    if (self.runtime) {
        self.runtime.text = [self appendRunTime];
    }
    else {
        self.runtime.text = IANoInformation;
    }
    if (self.voteAverage != 0) {
        self.voteAverage.text = [_tv.voteAverage stringValue];
    }
    else {
        self.voteAverage.text = IANoInformation;
    }
    if (self.overview) {
        self.overview.text = _tv.overview;
    }
    else {
        self.overview.text = IANoInformation;
    }
    if (self.numberOfEpisodes != 0) {
        self.numberOfEpisodes.text = [_tv.numberOfEpisodes stringValue];
    }
    else {
        self.numberOfEpisodes.text = IANoInformation;
    }
    if (self.numberOfSeasons != 0) {
        self.numberOfSeasons.text = [_tv.numberOfSeasons stringValue];
    }
    else {
        self.numberOfSeasons.text = IANoInformation;
    }
    [self.overview setNumberOfLines:0];
    [self.overview sizeToFit];
}
-(NSString *) appendGenres {
    NSMutableString *genres = [[NSMutableString alloc] init];
    for (int i = 0; i < _tv.genres.count; i++) {
        NSString *genre = [_tv.genres[i] name];
        [genres appendString:genre];
        if (i != _tv.genres.count - 1) {
            [genres appendString:@", "];
        }
    }
    
    return genres;
}

-(NSString *) appendRunTime {
    NSMutableString *runtime = [[NSMutableString alloc] init];
    for (int i = 0; i < _tv.runtime.count; i++) {
        [runtime appendString:[_tv.runtime[i] stringValue]];
        if (i != _tv.genres.count - 1) {
            [runtime appendString:@", "];
        }
    }
    
    return runtime;
}

@end
