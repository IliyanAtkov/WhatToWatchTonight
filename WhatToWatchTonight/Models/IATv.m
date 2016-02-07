#import "IATv.h"
#import "IAGenre.h"

@implementation IATv
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tvId": @"id",
             @"title": @"name",
             @"overview": @"overview",
             @"firstAirDate" : @"first_air_date",
             @"lastAirDate" : @"last_air_date",
             @"numberOfEpisodes" : @"number_of_episodes",
             @"numberOfSeasons" : @"number_of_seasons",
             @"genres": @"genres",
             @"urlImage" : @"poster_path",
             @"runtime" : @"episode_run_time",
             @"voteAverage" : @"vote_average"
             };
}

+(NSValueTransformer *) genresJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:IAGenre.class];
}

@end
