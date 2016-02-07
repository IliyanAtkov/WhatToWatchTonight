#import "IAAllTvsByTypeViewController.h"
#import "IAMovieDbClient.h"
#import "IATvCollection.h"
#import "IATvsCollection.h"
#import "IAUrlConstants.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAAppDelegate.h"
#import "IAAllByTypeCollectionViewCell.h"
#import "IASingleTvViewController.h"
#import "IAUIConstants.h"

@interface IAAllTvsByTypeViewController ()

@end

@implementation IAAllTvsByTypeViewController
{
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
    NSInteger _currentPage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:IAAllByTypeCollectionViewCellName bundle:nil] forCellWithReuseIdentifier:IAAllByTypeViewCell];
    
    _currentPage = 1;
    _client = [[IAMovieDbClient alloc] init];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tvs.count;
}

-(void)loadMoreTvs {
    __weak id weakSelf = self;
    _currentPage += 1;
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue,
                    IAPageName : [NSNumber numberWithInteger:_currentPage]
                    };
    
    [_client GET:self.tvsTypeUrl parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                IATvsCollection *_moreTvs = response.result;
                [[weakSelf tvs] addObjectsFromArray:[_moreTvs tvs]];
            }
            else {
                IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
                
                UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
                [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }
            
            [[weakSelf collectionView] reloadData];
        });
    }];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = IAAllByTypeViewCell;
    UIImage *defaultImage = [UIImage imageNamed:@"noImage"];
    IAAllByTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[IAAllByTypeCollectionViewCell alloc] init];
    }
    
    IATvCollection *tv = self.tvs[indexPath.row];
    if (tv.urlImage != nil) {
        NSURL *firstImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:tv.urlImage]];
        [cell.image sd_setImageWithURL:firstImageUrl
                      placeholderImage:defaultImage];
    }
    else {
        cell.image.image = defaultImage;
    }
    
    cell.image.tag = [tv.tvId integerValue];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    
    [cell.image addGestureRecognizer:tap];
    
    cell.label.text = tv.title;
    
    if (indexPath.row == [self.tvs count] - 1) {
        [self loadMoreTvs];
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqual:IAShowSingleTvScene]) {
        IASingleTvViewController *vc = [segue destinationViewController];
        vc.tvID = [sender tag];
    }
}

-(void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView *cell = (UIImageView*)gestureRecognizer.view;
    [self performSegueWithIdentifier:IAShowSingleTvScene sender:cell];
}
@end
