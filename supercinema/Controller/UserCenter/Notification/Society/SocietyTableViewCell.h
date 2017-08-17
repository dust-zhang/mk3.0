//
//  SocietyTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import <UIKit/UIKit.h>
#import "SystemNoticeModel.h"

@protocol SocietyTableViewCellDelegate <NSObject>
-(void)respondToUserHome:(NSNumber *)uId;
@end

@interface SocietyTableViewCell : UITableViewCell
{
    UIView*     _viewPoint;     //小蓝点
    UIView*     _viewLine;      //分割线
    UIButton*   _btnHead;       //头像
    UILabel*    _labelUserName;   //用户名
    UILabel*    _labelFocus;    //关注label
    UILabel*    _labelRespond;  //回复label
    UIView*     _viewDesc;      //详情view
    UILabel*    _labelTargetTitle;    //通知相关内容的标题
    UILabel*    _labelTargetDesc;     //通知相关内容的描述
    UILabel*    _labelTargetType;     //targetType的描述
    UIImageView*    _imgTarget; //通知相关内容的icon
    UILabel*    _labelTime;     //时间label
    int         _type;
    SysNotifyListModel* _model;
}
@property(nonatomic,weak)id<SocietyTableViewCellDelegate> sDelegate;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(SysNotifyListModel*)model curTime:(NSNumber*)curTime isFirst:(NSInteger)isFirst;
@end
