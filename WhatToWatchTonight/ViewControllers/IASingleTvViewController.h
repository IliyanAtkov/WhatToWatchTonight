#import <UIKit/UIKit.h>

@interface IASingleTvViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UILabel *runtime;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSeasons;
@property (weak, nonatomic) IBOutlet UILabel *numberOfEpisodes;
@property (weak, nonatomic) IBOutlet UILabel *lastAirDate;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *voteAverage;
@property (weak, nonatomic) IBOutlet UILabel *genres;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property NSInteger tvID;

@end
