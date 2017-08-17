//
//  MyDynamicTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import <UIKit/UIKit.h>
#import "CJLabel.h"
#import "NSString+CJString.h"

typedef enum {
    WANT_SEE_MOVIE = 1,             // 想看 电影
    WRITE_MOVIE_COMMENT = 2,        // 写了 短评
    UPDATE_SIGNATURE = 3,           //更新了 签名
    FOLLOW_PERSON = 4,              //关注了 用户
    JOIN_ACTIVITY = 5,              //参加了 活动
    RECEIVE_ACTIVITY_GOODS = 6      //领取了 活动物品
} DynamicType;

@protocol MyDynamicTableViewCellDelegate <NSObject>
-(void)toNextPage:(DynamicType)type feedModel:(FeedListModel*)model;
-(void)deleteCell:(NSInteger)index;
-(void)toDynDetail:(NSNumber*)feedId;
-(void)toUserHome:(NSNumber*)uId;
@end

@interface MyDynamicTableViewCell : UITableViewCell
{
    UIView*         _viewPoint;     //第一个cell的小灰点
    UILabel*        _labelAllDyn;   //全部动态
    UIView*         _viewTimeLine;  //时间轴
    UIImageView*    _imgIcon;
    UILabel*        _labelTitle;    //动态标题
    UIButton*       _btnPoints;     //举报删除按钮
    UILabel*        _labelContent;   //内容label
    UIView*         _viewDesc;      //详情view
    UIImageView*    _imgDescIcon;    //详情icon
    UILabel*        _labelDescTitle;    //详情标题
    UILabel*        _labelDesc;     //详情label
    UILabel*        _labelTime;     //时间label
    UIButton*       _btnPraise;     //赞button
    UILabel*        _labelPraise;   //赞数label
    UIButton*       _btnComment;    //评论btn
    UILabel*        _labelComment;  //评论数label
    UIView*         _viewRespond;   //回复view
    UILabel*        _labelRespond;  //回复label
    UILabel*        _labelMore;     //更多回复label

    CJLabel*        _labelRes[5];
    UIView*         _view[5];
    
    int             _type;
    FeedListModel*  _model;
    NSInteger       _curIndex;
    
    UIView*     _viewFirst;
    
    BOOL            _isBtnCanTouch;
}
@property(nonatomic,weak)id<MyDynamicTableViewCellDelegate> dDelegate;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(FeedListModel*)model index:(NSInteger)index model:(UserDynamicModel*)dynModel;
@end
