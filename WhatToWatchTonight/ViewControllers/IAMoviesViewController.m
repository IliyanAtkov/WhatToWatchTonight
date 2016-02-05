#import "IAMoviesViewController.h"
#import "IAMovieDbClient.h"
#import "IAUrlConstants.h"
#import "IAMoviesCollection.h"
#import "MBProgressHUD.h"
#import "IATableViewCell.h"
#import "IAMovieCollection.h"

@interface IAMoviesViewController ()
@end

@implementation IAMoviesViewController
{
    IAMovieDbClient *_client;
    NSMutableArray *_allMovies;
    NSDictionary *_parameters;
    NSInteger _itemsPerPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IATableViewCell" bundle:nil]
         forCellReuseIdentifier:@"tableViewCell"];

    self.tableView.dataSource = self;
    _itemsPerPage = 4;
    [self loadMovies];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allMovies.count;
}

-(void) loadMovies {
    _allMovies = [[NSMutableArray alloc] init];
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
    if (_allMovies.count == _itemsPerPage) {
        return YES;
    }
    
    return false;
}

-(void) showErrorWithError: (NSError *) error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error != nil) {
            [self showErrorWithTitle:@"ERROR" andMessage:[error localizedDescription]];
        }
        else {
            [self.tableView reloadData];
        }
        
    });
    
}


-(void)getWithUrl: (NSString *) url {
    
    __weak id weakSelf = self;
    [_client GET:url parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            id _collection = response.result;
            
            for (int i = 0; i < _itemsPerPage; i++) {
                NSArray *movies = [_collection movies];
                IAMovieCollection *movie = movies[i];
                NSString *_url = [IAImageBaseUrl stringByAppendingString:[NSString stringWithFormat:@"w92%@", movie.urlImage]];
                NSURL *imageURL = [NSURL URLWithString:_url];
                
                __weak IAMovieCollection *weakMovie = movie;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakMovie.image = [UIImage imageWithData:imageData];
                    });
                });
                
            }
            
            [_allMovies  addObject:_collection];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            [weakSelf showErrorWithError:error];
        }
    }];
}



-(void)showErrorWithTitle: (NSString *) title
               andMessage: (NSString *) message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tableViewCell";
 
    IATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[IATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (_allMovies.count != 0) {
        
        if(indexPath.row == 0) {
            cell.mainTitle.title = @"Popular movies";
        }
        else if(indexPath.row == 1) {
            cell.mainTitle.title = @"Now playing movies";
        }
        else if(indexPath.row == 2) {
            cell.mainTitle.title = @"Top rated movies";
        }
        else if(indexPath.row == 3) {
            cell.mainTitle.title = @"Upcoming movies";
        }
        
        NSArray *movies = [_allMovies[indexPath.row] movies];

        
        cell.firstLabel.text = [movies[0] title];
        cell.secondLabel.text = [movies[1] title];
        cell.thirdLabel.text = [movies[2] title];
        cell.fourthLabel.text = [movies[3] title];
        cell.firstImage.image = [movies[0] image];
        cell.secondImage.image = [movies[1] image];
        cell.thirdImage.image = [movies[2] image];
        cell.fourthImage.image = [movies[3] image];
    }
    
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
