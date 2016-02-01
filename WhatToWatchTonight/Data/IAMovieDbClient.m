#import "IAMovieDbClient.h"
#import "IAMovie.h"

@implementation IAMovieDbClient


-(NSArray *)getMovieWithId {
    NSDictionary *parameters = @{
                                 @"api_key" : @"1a66de8b5fd64165ba0e013578af737b"
                                 };
    
     [self GET:@"movie/2" parameters:parameters completion:^(OVCResponse *response, NSError *error) {
        return NSArray *movie = response.result;
    }];
    
    return movie;
}

+(NSDictionary *)modelClassesByResourcePath {
    return @{
             @"movie/#": [IAMovie class]
             };
}
@end
