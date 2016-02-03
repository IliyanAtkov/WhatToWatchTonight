#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "IAGenre.h"

@interface IAMovie : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *movieId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *overview;
@property (copy, nonatomic, readonly) NSNumber *budget;
@property (copy, nonatomic, readonly) NSDate *releaseDate;
@property (copy, nonatomic, readonly) NSArray *genres;
@end
