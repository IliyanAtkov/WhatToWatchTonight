#import "IAMainTableViewCell.h"

@implementation IAMainTableViewCell
- (IBAction)seeAllBtn:(id)sender {
    [self.delegate seeAllWasTapped:self];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
@end
