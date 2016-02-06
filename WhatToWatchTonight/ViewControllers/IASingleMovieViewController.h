#import <UIKit/UIKit.h>

@interface IASingleMovieViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *voteAverage;
@property (weak, nonatomic) IBOutlet UILabel *revenue;
@property (weak, nonatomic) IBOutlet UILabel *runtime;
@property (weak, nonatomic) IBOutlet UILabel *budget;
@property (weak, nonatomic) IBOutlet UILabel *genres;
@property NSInteger movieID;
@end
