#import <Mantle/Mantle.h>

@interface IATvsCollection : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSNumber *currentPage;
@property (copy, nonatomic, readwrite) NSString *typeName;
@property (copy, nonatomic, readonly) NSArray *tvs;
@property (copy, nonatomic, readwrite) NSString *mainTitle;
@end
