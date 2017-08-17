//
//  WantLookTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import <UIKit/UIKit.h>

@interface WantLookTableViewCell : UITableViewCell
{
    //影片Logo
    UIImageView     *_imageLogo;
    //影片名字
    UILabel         *_labelName;
    //评分
    UILabel         *_labelScore;
    //有效期
    UILabel         *_labelDate;
    //上映状态
    UILabel         *_labelMovieType;
}
-(void)setWantLookCellFrameAndData:(MovieModel *)movieModel sysTime:(NSNumber*)systemTime;

@end
