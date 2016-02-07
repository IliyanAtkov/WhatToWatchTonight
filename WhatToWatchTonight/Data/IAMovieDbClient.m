#import "IAMovieDbClient.h"
#import "IAMovie.h"
#import "IAUrlConstants.h"
#import "IAMoviesCollection.h"
#import "IATvsCollection.h"
#import "IATv.h"

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
             IAUrlUpcomingMovies: [IAMoviesCollection class],
             @"tv/#": [IATv class],
             IAUrlOnTheAirTvs: [IATvsCollection class],
             IAUrlAiringTodayTvs: [IATvsCollection class],
             IAUrlPopularTvs: [IATvsCollection class],
             IAUrlTopRatedTvs: [IATvsCollection class]
             };
}
@end
