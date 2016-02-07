#import <Foundation/Foundation.h>
@class IAMainTableViewCell;

@protocol IAMainTableCellDelegate <NSObject>
-(void) seeAllWasTapped: (IAMainTableViewCell*) cell;
-(void) imageWasTapped: (IAMainTableViewCell*) cell;
@end
