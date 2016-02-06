#import "IAAllMoviesByTypeViewController.h"
#import "IAAllMoviesByTypeCollectionViewCell.h"
#import "IAMovieCollection.h"
#import "IAUrlConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAMovieDbClient.h"
#import "IAAppDelegate.h"
#import "MBProgressHUD.h"

@interface IAAllMoviesByTypeViewController ()

@end

@implementation IAAllMoviesByTypeViewController
{
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
    NSInteger _currentPage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"IAAllMoviesByTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"allMoviesByTypeViewCell"];
    _currentPage = 1;
    _client = [[IAMovieDbClient alloc] init];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(void)loadMoreMovies {
    __weak id weakSelf = self;
    _currentPage += 1;
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue,
                    IAPageName : [NSNumber numberWithInteger:_currentPage]
                    };
    
    [_client GET:self.moviesTypeUrl parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            id _moreMovies = response.result;
            [[weakSelf movies] addObjectsFromArray:[_moreMovies movies]];
        }
        else {
            IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        }
        [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
        [[weakSelf collectionView] reloadData];
    }];
}

     
     - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
         NSString *cellIdentifier = @"allMoviesByTypeViewCell";
         UIImage *defaultImage = [UIImage imageNamed:@"noImage"];
         IAAllMoviesByTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
         if(!cell) {
             cell = [[IAAllMoviesByTypeCollectionViewCell alloc] init];
         }
         
         IAMovieCollection *movie = self.movies[indexPath.row];
         if (movie.urlImage != nil) {
             NSURL *firstImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:movie.urlImage]];
             [cell.image sd_setImageWithURL:firstImageUrl
                           placeholderImage:defaultImage];
         }
         else {
             cell.image.image = defaultImage;
         }

         cell.label.text = movie.title;
         
         if (indexPath.row == [self.movies count] - 1) {
             [self loadMoreMovies];
         }
         return cell;
     }
     @end
