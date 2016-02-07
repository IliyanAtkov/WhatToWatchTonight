#import "IATvsViewController.h"
#import "IAMovieDbClient.h"
#import "IAMainTableViewCell.h"
#import "IATvCollection.h"
#import "IAUrlConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "IASingleTvViewController.h"
#import "IAAllTvsByTypeViewController.h"
#import "IAAppDelegate.h"
#import "IATvsCollection.h"
#import "IAUIConstants.h"

@interface IATvsViewController ()
@property NSMutableArray *allTvs;
@end

@implementation IATvsViewController
{
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
    NSInteger _itemsPerPage;
    NSString *_imagesUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:IAMainTableViewCellName bundle:nil]
         forCellReuseIdentifier:IAMainTableViewCellIdentifier];
    
    self.tableView.dataSource = self;
    [self loadAllTvs];
    _itemsPerPage = 4;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTvs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = IAMainTableViewCellIdentifier;
    IAMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[IAMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    
    IATvsCollection *tvsByType = self.allTvs[indexPath.row];
    tvsByType.mainTitle = [self setMainTitleWithRow:indexPath.row];
    
    cell.mainTitle.title = tvsByType.mainTitle;
    
    NSArray *tvs = tvsByType.tvs;
    
    NSArray *cellImages =[NSArray arrayWithObjects:cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage, cell.fifthImage,nil];
    
    [self attachGestureRecognizersToImages:cellImages];
    [self setImages:cellImages andIndexPathRow:indexPath.row];
    
    
    cell.firstLabel.text = [tvs[0] title];
    cell.secondLabel.text = [tvs[1] title];
    cell.thirdLabel.text = [tvs[2] title];
    cell.fourthLabel.text = [tvs[3] title];
    cell.fifthLabel.text = [tvs[4] title];
    
    return cell;
}

-(void) loadAllTvs {
    self.allTvs = [[NSMutableArray alloc] init];
    _client = [[IAMovieDbClient alloc] init];
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue
                    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getWithUrl:IAUrlPopularTvs];
    [self getWithUrl:IAUrlOnTheAirTvs];
    [self getWithUrl:IAUrlTopRatedTvs];
    [self getWithUrl:IAUrlAiringTodayTvs];
}



-(void)seeAllWasTapped:(IAMainTableViewCell *)cell {
    [self performSegueWithIdentifier:IAShowAllTvsScene sender:cell];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqual: IAShowAllTvsScene]) {
        IAAllTvsByTypeViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        vc.tvs = [self.allTvs[indexPath.row] tvs];
        vc.title = [self.allTvs[indexPath.row] mainTitle];
        vc.tvsTypeUrl = [self.allTvs[indexPath.row] typeName];
        
    }
    else if([[segue identifier] isEqual:IAShowSingleTvScene]) {
        IASingleTvViewController *vc = [segue destinationViewController];
        vc.tvID = [sender tag];
    }
}

-(void)getWithUrl: (NSString *) url {
    
    __weak id weakSelf = self;
    [_client GET:url parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            IATvsCollection *_collection = response.result;
            _collection.typeName = url;
            [[weakSelf allTvs]  addObject:_collection];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
                
                UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
                [MBProgressHUD hideHUDForView:[weakSelf view] animated:YES];
                if (error != nil) {
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
                else {
                    [[weakSelf tableView] reloadData];
                }
            });
        }
    }];
}

-(void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView *cell = (UIImageView*)gestureRecognizer.view;
    [self performSegueWithIdentifier:IAShowSingleTvScene sender:cell];
}


-(void)attachGestureRecognizersToImages: (NSArray *) images {
    for (int i = 0; i < images.count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
        tap.cancelsTouchesInView = YES;
        tap.numberOfTapsRequired = 1;
        
        [images[i] addGestureRecognizer:tap];
    }
}

-(void) setImages: (NSArray *) images andIndexPathRow: (NSInteger)row{
    UIImage *defaultImage = [UIImage imageNamed:@"noImage"];
    IATvsCollection *tvsByType = self.allTvs[row];
    NSArray *tvs = tvsByType.tvs;
    NSArray *urls = [self getImageUrls:tvs];
    
    for (int i = 0; i < images.count; i++) {
        UIImageView *currentImage = images[i];
        
        currentImage.tag = [[tvs[i] tvId]integerValue];
        [currentImage sd_setImageWithURL:urls[i]
                        placeholderImage:defaultImage];
    }
}

-(BOOL) isDataLoaded {
    if (self.allTvs.count == _itemsPerPage) {
        return YES;
    }
    
    return false;
}

-(NSArray *) getImageUrls: (NSArray *) tvs {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        IATvCollection *tv = tvs[i];
        if (tv.urlImage != nil) {
            [urls addObject:[NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:tv.urlImage]]];
        }
        else {
            [urls addObject:@"InvalidUrl"];
        }
    }
    
    return urls;
}

-(NSString *) setMainTitleWithRow: (NSInteger) row {
    if(row == 0) {
        return @"Popular Tvs";
    }
    else if(row == 1) {
        return @"On the air Tvs";
    }
    else if(row == 2) {
        return @"Top rated Tvs";
    }
    else {
        return @"Airing today Tvs";
    }
}

@end
