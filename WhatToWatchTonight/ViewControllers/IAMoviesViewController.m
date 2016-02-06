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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allMovies.count;
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

-(BOOL) isDataLoaded {
    if (self.allMovies.count == _itemsPerPage) {
        return YES;
    }
    
    return false;
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
            IAAppDelegate *delegate = (IAAppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIAlertController *alert = [delegate showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
            dispatch_async(dispatch_get_main_queue(), ^{
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"allMoviesTableViewCell";
    UIImage *defaultImage = [UIImage imageNamed:@"noImage"];
    IAAllMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[IAAllMoviesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    
    IAMoviesCollection *moviesByType = self.allMovies[indexPath.row];
    if(indexPath.row == 0) {
        moviesByType.mainTitle = @"Popular movies";
    }
    else if(indexPath.row == 1) {
        moviesByType.mainTitle = @"Now playing movies";
    }
    else if(indexPath.row == 2) {
        moviesByType.mainTitle = @"Top rated movies";
    }
    else if(indexPath.row == 3) {
        moviesByType.mainTitle = @"Upcoming movies";
    }
    
    cell.mainTitle.title = moviesByType.mainTitle;
    
    NSArray *movies = moviesByType.movies;
    NSURL *firstImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:[movies[0] urlImage]]];
    NSURL *secondImageUrl =[NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:[movies[1] urlImage]]];
    NSURL *thirdImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:[movies[2] urlImage]]];;
    NSURL *fourthImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:[movies[3] urlImage]]];
    NSURL *fifthImageUrl = [NSURL URLWithString:[IAImageSmallBaseUrl stringByAppendingString:[movies[4] urlImage]]];
    
    [cell.firstImage sd_setImageWithURL:firstImageUrl
                       placeholderImage:defaultImage];
    [cell.secondImage sd_setImageWithURL:secondImageUrl
                        placeholderImage:defaultImage];
    
    [cell.thirdImage sd_setImageWithURL:thirdImageUrl
                       placeholderImage:defaultImage];
    
    [cell.fourthImage sd_setImageWithURL:fourthImageUrl
                        placeholderImage:defaultImage];
    
    [cell.fifthImage sd_setImageWithURL:fifthImageUrl
                       placeholderImage:defaultImage];
    
    cell.firstLabel.text = [movies[0] title];
    cell.secondLabel.text = [movies[1] title];
    cell.thirdLabel.text = [movies[2] title];
    cell.fourthLabel.text = [movies[3] title];
    cell.fifthLabel.text = [movies[4] title];
    
    return cell;
    
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
