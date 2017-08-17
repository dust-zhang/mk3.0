//
//  CommentTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import <UIKit/UIKit.h>
#import "CJLabel.h"
#import "NSString+CJString.h"

@protocol CommentTableViewCellDelegate <NSObject>
-(void)commentElse:(NSNumber*)cId;
-(void)threePointsElse:(NSNumber*)cId type:(int)type;
-(void)toUserHome:(NSInteger)uId;
-(void)toLoginVC;
@end

@interface CommentTableViewCell : UITableViewCell
{
    UIButton*       _btnHead;
    UILabel*        _labelUserName;
    UIImageView*    _imgCommentIcon;
    UILabel*        _labelCommentText;
    UIButton*       _btnPoints;
    UILabel*        _labelDesc;
    UILabel*        _labelDate;
    UIButton*       _btnDianzan;
//    UIImageView*    _imgDianzan;
    UILabel*        _labelCount;
    UIImageView*    _imgCment;
    UILabel*        _labelCment;
    UIView*         _viewMore;
    UILabel*        _labelRespond;
    UILabel*        _labelMore;
    
    CJLabel*        _labelRes[5];
    UIView*         _view[5];
    
    MovieReviewListModel* _model;
    
    BOOL            _isBtnCanTouch;
}
@property(nonatomic,weak)id<CommentTableViewCellDelegate> cDelegate;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(MovieReviewListModel*)model icon:(NSArray*)imgArr curTime:(NSNumber*)curTime;
@end
