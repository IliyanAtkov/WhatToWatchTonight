#import "IAMoviesViewController.h"
#import "IAMovieDbClient.h"
#import "IAUrlConstants.h"
#import "IAMoviesCollection.h"
#import "MBProgressHUD.h"
#import "IAAllMoviesTableViewCell.h"
#import "IAMovieCollection.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAAllMoviesByTypeViewController.h"
#import "IAAppDelegate.h"
#import "IASingleMovieViewController.h"

@interface IAMoviesViewController ()
@property NSMutableArray *allMovies;
@end

@implementation IAMoviesViewController
{
    IAMovieDbClient *_client;
    NSDictionary *_parameters;
    NSInteger _itemsPerPage;
    NSString *_imagesUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IAAllMoviesTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"allMoviesTableViewCell"];
    
    self.tableView.dataSource = self;
    
    _itemsPerPage = 4;
    [self loadMovies];
    
    
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
    return self.allMovies.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"allMoviesTableViewCell";
    IAAllMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[IAAllMoviesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    
    IAMoviesCollection *moviesByType = self.allMovies[indexPath.row];
    moviesByType.mainTitle = [self setMainTitleWithRow:indexPath.row];
    
    cell.mainTitle.title = moviesByType.mainTitle;
    
    NSArray *movies = moviesByType.movies;
    
    NSArray *cellImages =[NSArray arrayWithObjects:cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage, cell.fifthImage,nil];
    
    [self attachGestureRecognizersToImages:cellImages];
    [self setImages:cellImages andIndexPathRow:indexPath.row];
    
    
    cell.firstLabel.text = [movies[0] title];
    cell.secondLabel.text = [movies[1] title];
    cell.thirdLabel.text = [movies[2] title];
    cell.fourthLabel.text = [movies[3] title];
    cell.fifthLabel.text = [movies[4] title];
    
    return cell;
    
}

-(void) loadMovies {
    self.allMovies = [[NSMutableArray alloc] init];
    _client = [[IAMovieDbClient alloc] init];
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue
                    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getWithUrl:IAUrlPopularMovies];
    [self getWithUrl:IAUrlNowPlayingMovies];
    [self getWithUrl:IAUrlTopRatedMovies];
    [self getWithUrl:IAUrlUpcomingMovies];
}



-(void)seeAllWasTapped:(IAAllMoviesTableViewCell *)cell {
    [self performSegueWithIdentifier:@"allMoviesByTypeScene" sender:cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqual: @"allMoviesByTypeScene"]) {
        IAAllMoviesByTypeViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        vc.movies = [self.allMovies[indexPath.row] movies];
        vc.title = [self.allMovies[indexPath.row] mainTitle];
        vc.moviesTypeUrl = [self.allMovies[indexPath.row] typeName];
        
    }
    else if([[segue identifier] isEqual:@"showSingleMovieScene"]) {
        IASingleMovieViewController *vc = [segue destinationViewController];
        vc.movieID = [sender tag];
    }
}

-(void)getWithUrl: (NSString *) url {
    
    __weak id weakSelf = self;
    [_client GET:url parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            IAMoviesCollection *_collection = response.result;
            _collection.typeName = url;
            [[weakSelf allMovies]  addObject:_collection];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
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
                    [[weakSelf tableView] reloadData];
                }
            });
        }
    }];
}

-(void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView *cell = (UIImageView*)gestureRecognizer.view;
    [self performSegueWithIdentifier:@"showSingleMovieScene" sender:cell];
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
    IAMoviesCollection *moviesByType = self.allMovies[row];
    NSArray *movies = moviesByType.movies;
    NSArray *urls = [self getImageUrls:movies];
    
    for (int i = 0; i < images.count; i++) {
        UIImageView *currentImage = images[i];
        
        currentImage.tag = [[movies[i] movieId]integerValue];
        [currentImage sd_setImageWithURL:urls[i]
                        placeholderImage:defaultImage];
    }
}

-(BOOL) isDataLoaded {
    if (self.allMovies.count == _itemsPerPage) {
        return YES;
    }
    
    return false;
}

-(NSArray *) getImageUrls: (NSArray *) movies {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        IAMovieCollection *movie = movies[i];
        if (movie.urlImage != nil) {
            [urls addObject:[NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:movie.urlImage]]];
        }
        else {
            [urls addObject:@"InvalidUrl"];
        }
    }
    
    return urls;
}

-(NSString *) setMainTitleWithRow: (NSInteger) row {
    if(row == 0) {
        return @"Popular movies";
    }
    else if(row == 1) {
        return @"Now playing movies";
    }
    else if(row == 2) {
        return @"Top rated movies";
    }
    else {
        return @"Upcoming movies";
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
