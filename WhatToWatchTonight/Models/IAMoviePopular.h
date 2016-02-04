#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IAMoviePopular : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *currentPage;
@property (copy, nonatomic, readonly) NSArray *movies;
@end
