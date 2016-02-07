#import "IATvCollection.h"

@implementation IATvCollection
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tvId": @"id",
             @"title": @"name",
             @"urlImage" : @"poster_path"
             };
}
@end
