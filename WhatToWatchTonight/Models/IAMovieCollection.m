#import "IAMovieCollection.h"

@implementation IAMovieCollection

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieId": @"id",
             @"title": @"title",
             @"urlImage" : @"poster_path"
             };
}
@end
