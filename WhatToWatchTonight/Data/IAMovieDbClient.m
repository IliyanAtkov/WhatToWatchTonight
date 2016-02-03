#import "IAMovieDbClient.h"
#import "IAMovie.h"

@implementation IAMovieDbClient


-(instancetype)init {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders =  @{
                                      @"Accept":@"application/json",
                                      @"Content-Type":@"application/json"
                                      };
    
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.themoviedb.org/3/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}
-(void)getMovieWithId {

}

+(NSDictionary *)modelClassesByResourcePath {
    return @{
             @"movie/#": [IAMovie class]
             };
}
@end
