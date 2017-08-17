//
//  MyCardTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import <UIKit/UIKit.h>

@interface MyCardTableViewCell : UITableViewCell
{
    UIImageView     *_imageLogo;
    UILabel         *_labelName;
    UILabel         *_labelCountInfo;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setCardAndCouponFrameData:(CardAndCouponCountModel *)cardAndCouponCountModel indexPath:(NSInteger)indexPath;
@end
