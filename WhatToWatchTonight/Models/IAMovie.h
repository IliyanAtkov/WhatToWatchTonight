#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IAMovie : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *movieId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *overview;
@property (copy, nonatomic, readonly) NSNumber *budget;
@property (copy, nonatomic, readonly) NSDate *releaseDate;

@end
