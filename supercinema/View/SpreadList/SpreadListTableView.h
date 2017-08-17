//
//  SpreadListTableView.h
//  supercinema
//
//  Created by mapollo91 on 25/4/17.
//
//

#import <UIKit/UIKit.h>
#import "SpreadListTableViewCell.h"

//@protocol SpreadListTableViewDelegate <NSObject>
////画卡片View
//@required
//-(UIView *)spreadListTableViewView;
//@end

@interface SpreadListTableView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView                 *_tabSpreadList;
    UILabel                     *_labelSpreadType;
    UIImageView                 *_imageSpreadType;
    BOOL                        _isClickAll;
    NSString                    *_strLabelText;
    RedPacketCinemaListModel    *_model;
    NSMutableArray              *_arrState;
}

//@property (nonatomic, strong)NSMutableArray      *_arrData;
//@property (nonatomic, weak) id <SpreadListTableViewDelegate> delegate;

//初始化控件
-(id)initWithFrame:(CGRect)frame;
//画View
-(void)drawSpreadListTableViewAndData:(RedPacketCinemaListModel *)model;

@end
