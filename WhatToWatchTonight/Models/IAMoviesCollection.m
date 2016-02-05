#import "IAMoviesCollection.h"
#import "IAMovieCollection.h"

@implementation IAMoviesCollection


+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"currentPage" : @"page",
             @"movies" : @"results"
             };
}

+(NSValueTransformer *) moviesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IAMovieCollection.class];
}
@end
