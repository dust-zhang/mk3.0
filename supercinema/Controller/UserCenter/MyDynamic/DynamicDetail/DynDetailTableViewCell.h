//
//  DynDetailTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/3.
//
//

#import <UIKit/UIKit.h>
@protocol DynDetailTableViewCellDelegate <NSObject>
-(void)toNextPage:(NSInteger)type feedModel:(FeedListModel*)model;
-(void)deleteCell:(NSInteger)index;
-(void)toUserHome:(NSNumber*)uId;
-(void)respond:(CommentListModel*)model;
-(void)hideKeyboard;
@end
@interface DynDetailTableViewCell : UITableViewCell
{
    UIButton*       _btnHead;
    UILabel*        _labelUserName;
    UILabel*        _labelDetail;
     UILabel*        _labelContent;   //内容label
    UILabel*        _labelDate;
    
    UIView*         _viewDesc;          //详情view
    UIImageView*    _imgDescIcon;       //详情icon
    UILabel*        _labelDescTitle;    //详情标题
    UILabel*        _labelDesc;         //详情label
    UIView*         _viewBack;
    UILabel*        _labelTotalComment;
    UIButton*       _btnDianzan;
    UILabel*        _labelCount;
    UIButton*       _btnPoints;     //举报删除按钮
    FeedListModel*  _fModel;
    CommentListModel*   _cModel;
    
    NSInteger       _curIndex;
    
    UITapGestureRecognizer* _tapRes;
    
    BOOL            _isBtnCanTouch;
}
@property(nonatomic,weak)id<DynDetailTableViewCellDelegate> detaildelegate;
@property(nonatomic,assign)BOOL canTouch;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier index:(NSInteger)index;
-(void)setHeadData:(FeedListModel*)model index:(NSInteger)index;
-(void)setData:(CommentListModel*)model index:(NSInteger)index curTime:(NSNumber*)curTime;
@end
