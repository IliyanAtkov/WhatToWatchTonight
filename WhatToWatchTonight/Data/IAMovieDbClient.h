#import <Foundation/Foundation.h>
#import <Overcoat/Overcoat.h>
#import "IAMovie.h"

@interface IAMovieDbClient : OVCHTTPSessionManager
-(NSArray *)getMovieWithId;
@end
