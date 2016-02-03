#import "IAMovie.h"
#import "IAFormatterHelper.h"
#import "IAGenre.h"

@implementation IAMovie

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieId": @"id",
             @"title": @"original_title",
             @"overview": @"overview",
             @"budget" : @"budget",
             @"releaseDate" : @"release_date",
             @"genres": @"genres"
             };
}

+(NSValueTransformer *) releaseDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *stringData,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [IAFormatterHelper.dateFormatter dateFromString:stringData];
    }];
}

+(NSValueTransformer *) genresJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IAGenre.class];
}


@end
