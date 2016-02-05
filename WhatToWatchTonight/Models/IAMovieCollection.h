#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IAMovieCollection: MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSNumber *movieId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *image;
@end
