#import <Foundation/Foundation.h>
@class IAMainTableViewCell;

@protocol IAMainTableCellDelegate <NSObject>
-(void) seeAllWasTapped: (IAMainTableViewCell*) cell;
@end
