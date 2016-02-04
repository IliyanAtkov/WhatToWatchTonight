#import "IAMovieDbClient.h"
#import "IAMovie.h"

@implementation IAMovieDbClient


-(instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.themoviedb.org/3/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

+(NSDictionary *)modelClassesByResourcePath {
    return @{
             @"movie/#": [IAMovie class]
             };
}
@end
