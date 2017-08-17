//
//  ActivityTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 7/3/17.
//
//

#import <UIKit/UIKit.h>

@protocol ActivityTableViewCellDelegate <NSObject>
@optional
-(void)openWebview:(ActivityModel*)model;
-(void)receive:(ActivityModel*)model button:(UIButton*)btn;

-(void)openJoinDetails:(ActivityModel*)model;
//跳转到个人中心 & 他人个人中心
-(void)pushUserOrOtherCenterViewController:(NSString *)userId;

@end

@interface ActivityTableViewCell : UITableViewCell
{
    BOOL        _isTailor;       //是否裁剪过
}
@property (nonatomic, strong) UIView        *_viewWholeBG;          //整体View的背景
@property (nonatomic, strong) UIImageView   *_imageActivity;        //活动的图
@property (nonatomic, strong) UIImageView   *_imageShadow;          //活动图下面的阴影
@property (nonatomic, strong) UILabel       *_labelTitle;           //活动标题
@property (nonatomic, strong) UILabel       *_labelDetails;         //活动说明
@property (nonatomic, strong) UILabel       *_labelTime;            //活动结束日期
@property (nonatomic, strong) UILabel       *_labelJoinPeopleNumber;//往期中参加人数
@property (nonatomic, strong) UIButton      *_btnJoin;              //参加按钮（去参加、即将开始）
@property (nonatomic, strong) UIImageView   *_imageGoToJoinArrow;   //去参加活动箭头
@property (nonatomic, strong) UILabel       *_labelOverdueTitle;    //往期活动分割线
@property (nonatomic, strong) UILabel       *_labelLineLeft;        //往期活动分割线左
@property (nonatomic, strong) UILabel       *_labelLineRight;       //往期活动分割线右
@property (nonatomic, strong) UIImageView   *_imageOverdueActivity; //往期图片的蒙层处理


@property (nonatomic, strong) ActivityModel *_activityModel;

@property (nonatomic, weak) id<ActivityTableViewCellDelegate> activityDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//当前活动
-(void)setCurrentActivityCellFrameAndData:(ActivityModel *)activityModel indexPath:(NSInteger)row;
//往期分割线
-(void)setOverdueSegmentationLine;
//往期活动
-(void)setOverdueActivityCellFrameAndData:(ActivityModel *)activityModel;


@end
