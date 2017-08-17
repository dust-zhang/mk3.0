//
//  SpreadListTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 24/4/17.
//
//

#import <UIKit/UIKit.h>

@interface SpreadListTableViewCell : UITableViewCell
{
    //影片名字
    UILabel         *_labelName;
}

-(void)setSpreadListTableViewCellFrameAndData:(NSString *)labelText;

@end
