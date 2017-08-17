//
//  CDetailTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import <UIKit/UIKit.h>
@protocol CDetailTableViewCellDelegate <NSObject>
-(void)respondUser:(MovieReviewCommentListModel*)model;
-(void)toElseHome:(NSInteger)uId;
-(void)jubaoUser:(NSNumber*)cId type:(int)type;
-(void)hideKeyboard;
@end
@interface CDetailTableViewCell : UITableViewCell
{
    UIButton*       _btnHead;
    UILabel*        _labelUserName;
    UIButton*       _btnPoints;
    UILabel*        _labelDetail;
    UILabel*        _labelDate;
    UIButton*       _btnDianzan;
    UILabel*        _labelCount;
    
    MovieReviewCommentListModel*   _model;
    
    BOOL            _isBtnCanTouch;
}
@property(nonatomic,weak)id<CDetailTableViewCellDelegate> cDelegate;
@property(nonatomic,assign)BOOL canTouch;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(MovieReviewCommentListModel*)model curTime:(NSNumber*)curTime;
@end
