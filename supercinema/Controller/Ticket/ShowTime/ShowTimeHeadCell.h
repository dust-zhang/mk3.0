//
//  ShowTimeHeadCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/20.
//
//

#import <UIKit/UIKit.h>

@interface ShowTimeHeadCell : UITableViewCell
{
    UIView*  _viewTop;
    UILabel* _labelCinemaName;
    UILabel* _labelAddress;
    UIView* _viewLine1;
}
-(void)setData:(CinemaInfoModel*)cinema;
@end
