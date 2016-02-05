#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IAMoviesCollection : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *currentPage;
@property (copy, nonatomic, readonly) NSArray *movies;
@end
