#import "IAMovie.h"
#import "IAFormatterHelper.h"

@implementation IAMovie

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"movieId": @"id",
             @"title": @"original_title",
             @"overview": @"overview",
             @"budget" : @"budget",
             @"releaseDate" : @"release_date"
             };
}

+(NSValueTransformer *) releaseDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *stringData,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [FormatterHelper.dateFormatter dateFromString:stringData];
    }];
}


@end
