#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "IAGenre.h"

@interface IAMovie : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *movieId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *overview;
@property (copy, nonatomic, readonly) NSNumber *budget;
@property (copy, nonatomic, readonly) NSString *releaseDate;
@property (copy, nonatomic, readonly) NSArray *genres;
@property (copy, nonatomic, readonly) NSString *urlImage;
@property (copy, nonatomic, readonly) NSNumber *runtime;
@property (copy, nonatomic, readonly) NSNumber *revenue;
@property (copy, nonatomic, readonly) NSNumber *voteAverage;
@end
