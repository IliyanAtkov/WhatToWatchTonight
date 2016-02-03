#import "IAGenre.h"

@implementation IAGenre
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"genreId" : @"id",
             @"name" : @"name"
             };
}
@end
