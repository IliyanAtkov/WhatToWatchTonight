#import "IAAllMoviesByTypeViewController.h"
#import "IAAllMoviesByTypeCollectionViewCell.h"
#import "IAMovieCollection.h"
#import "IAUrlConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAMovieDbClient.h"
#import "IAAppDelegate.h"
#import "MBProgressHUD.h"
#import "IASingleMovieViewController.h"

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
            [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
            if (![weakSelf presentedViewController])
            {
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        }
        
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
         
         cell.image.tag = [movie.movieId integerValue];
         
         
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
         tap.cancelsTouchesInView = YES;
         tap.numberOfTapsRequired = 1;
         
         [cell.image addGestureRecognizer:tap];
         
         cell.label.text = movie.title;
         
         if (indexPath.row == [self.movies count] - 1) {
             [self loadMoreMovies];
         }
         return cell;
     }
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqual:@"gotoSingleMovieScene"]) {
        IASingleMovieViewController *vc = [segue destinationViewController];
        vc.movieID = [sender tag];
    }
}

-(void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView *cell = (UIImageView*)gestureRecognizer.view;
    [self performSegueWithIdentifier:@"gotoSingleMovieScene" sender:cell];
}
     @end
