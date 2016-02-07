#import "IATvCollection.h"
#import "IATvsCollection.h"

@implementation IATvsCollection
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"currentPage" : @"page",
             @"tvs" : @"results"
             };
}

+(NSValueTransformer *) tvsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IATvCollection.class];
}
@end
