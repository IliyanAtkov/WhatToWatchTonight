#import "IAMoviesCollection.h"
#import "IAMovie.h"

@implementation IAMoviesCollection


+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"currentPage" : @"page",
             @"movies" : @"results"
             };
}

+(NSValueTransformer *) moviesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IAMovie.class];
}
@end
