#import "IAMovieCollection.h"

@implementation IAMovieCollection

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieId": @"id",
             @"title": @"original_title",
             @"image" : @"poster_path"
             };
}
@end
