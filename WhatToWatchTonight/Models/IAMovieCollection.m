#import "IAMovieCollection.h"

@implementation IAMovieCollection

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieId": @"id",
             @"title": @"original_title",
             @"urlImage" : @"poster_path"
             };
}
@end
