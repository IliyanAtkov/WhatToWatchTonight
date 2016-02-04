#import "IAMovieDbClient.h"
#import "IAMovie.h"
#import "IAUrlConstants.h"

@implementation IAMovieDbClient
-(instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:IADefaultUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

+(NSDictionary *)modelClassesByResourcePath {
    return @{
             @"movie/#": [IAMovie class]
             };
}
@end
