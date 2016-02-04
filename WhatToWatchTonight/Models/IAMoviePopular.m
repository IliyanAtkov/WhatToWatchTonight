#import "IAMoviePopular.h"
#import "IAMovie.h"

@implementation IAMoviePopular

+(NSDictionary *)JSONTransformerForKey:(NSString *)key {
    return @{
             @"currentPage" : @"page",
             @"movies" : @"results"
             };
}

+(NSValueTransformer *) moviesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IAMovie.class];
}
@end
