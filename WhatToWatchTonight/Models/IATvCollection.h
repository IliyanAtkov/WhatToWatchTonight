#import <Mantle/Mantle.h>

@interface IATvCollection : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic, readonly) NSNumber *tvId;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *urlImage;
@end
