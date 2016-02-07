#import <Mantle/Mantle.h>

@interface IATv: MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSNumber *tvId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *overview;
@property (copy, nonatomic, readonly) NSString *firstAirDate;
@property (copy, nonatomic, readonly) NSNumber *numberOfEpisodes;
@property (copy, nonatomic, readonly) NSNumber *numberOfSeasons;
@property (copy, nonatomic, readonly) NSString * lastAirDate;
@property (copy, nonatomic, readonly) NSArray *genres;
@property (copy, nonatomic, readonly) NSString *urlImage;
@property (copy, nonatomic, readonly) NSArray *runtime;
@property (copy, nonatomic, readonly) NSNumber *voteAverage;
@end
