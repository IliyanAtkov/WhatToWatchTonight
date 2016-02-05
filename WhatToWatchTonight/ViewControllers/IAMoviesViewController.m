#import "IAMoviesViewController.h"
#import "IAMovieDbClient.h"
#import "IAUrlConstants.h"
#import "IAMoviesCollection.h"
#import "MBProgressHUD.h"
#import "IATableViewCell.h"

@interface IAMoviesViewController ()
@end

@implementation IAMoviesViewController
{
    IAMovieDbClient *_client;
    NSMutableArray *_allMovies;
    NSDictionary *_parameters;
    IAMoviesCollection *_popularMovies;
    IAMoviesCollection *_upcomingMovies;
    IAMoviesCollection *_nowPlayingMovies;
    IAMoviesCollection *_topRatedMovies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IATableViewCell" bundle:nil]
          forCellReuseIdentifier:@"tableViewCell"];
    
    self.tableView.dataSource = self;
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
    _client = [[IAMovieDbClient alloc] init];
    _parameters = @{
                    IAApiKeyName : IAApiKeyValue
                    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _allMovies = [[NSMutableArray alloc] init];
    [self getPopularMovies];
    [self getNowPlayingMovies];
    [self getTopRatedMovies];
    [self getUpcomingMovies];

}

-(BOOL) isDataLoaded {
    if (_allMovies.count == 4) {
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


-(void)getPopularMovies {
    [_client GET:IAUrlPopularMovies parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            _popularMovies = response.result;
            [_allMovies  addObject:_popularMovies];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            [self showErrorWithError:error];
        }
    }];
}
-(void)getNowPlayingMovies {
    [_client GET:IAUrlNowPlayingMovies parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            _nowPlayingMovies = response.result;
            [_allMovies  addObject:_nowPlayingMovies];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            [self showErrorWithError:error];
        }
    }];
}

-(void)getTopRatedMovies {
    [_client GET:IAUrlTopRatedMovies parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            _topRatedMovies = response.result;
            [_allMovies  addObject:_topRatedMovies];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            [self showErrorWithError:error];
        }

    }];
}
-(void)getUpcomingMovies {
    [_client GET:IAUrlUpcomingMovies parameters:_parameters completion:^(OVCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            _upcomingMovies = response.result;
            [_allMovies  addObject:_popularMovies];
        }
        if([self isDataLoaded] == YES || error != nil)
        {
            [self showErrorWithError:error];
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
    cell.fourthLabel.text = [movies[3] title];;
    
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
