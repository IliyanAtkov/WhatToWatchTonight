#import "IAMovieDbClient.h"
#import "IAMovie.h"
#import "IAUrlConstants.h"
#import "IAMoviesCollection.h"

@implementation IAMovieDbClient
-(instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:IADefaultUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

+(NSDictionary *)modelClassesByResourcePath {
    return @{
             @"movie/#": [IAMovie class],
             IAUrlPopularMovies: [IAMoviesCollection class],
             IAUrlTopRatedMovies: [IAMoviesCollection class],
             IAUrlNowPlayingMovies: [IAMoviesCollection class],
             IAUrlUpcomingMovies: [IAMoviesCollection class]
             };
}
@end
