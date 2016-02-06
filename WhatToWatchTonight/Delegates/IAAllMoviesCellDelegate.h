#import <Foundation/Foundation.h>
@class IAAllMoviesTableViewCell;

@protocol IAAllMoviesCellDelegate <NSObject>
-(void) seeAllWasTapped: (IAAllMoviesTableViewCell*) cell;
-(void) imageWasTapped: (IAAllMoviesTableViewCell*) cell;
@end
