#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IAGenre : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSNumber *genreId;
@property (copy, nonatomic, readonly) NSString *name;
@end
