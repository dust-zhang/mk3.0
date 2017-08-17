//
//  CDetailHeadTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import <UIKit/UIKit.h>

@protocol CDetailHeadTableViewCellDelegate <NSObject>
-(void)toUserHome:(NSNumber*)uId;
-(void)focusComment:(NSNumber*)uId state:(BOOL)state;
@end

@interface CDetailHeadTableViewCell : UITableViewCell
{
    UIButton*           _btnHead;
    UILabel*            _labelUserName;
    UIImageView*        _imgCommentIcon;
    UILabel*            _labelCommentText;
    UIButton*           _btnFocus;
    UILabel*            _labelDetail;
    UIButton*           _btnDianzan;
    UILabel*            _labelCount;
    UIView*             _viewLine;
    UILabel*            _labelMovieName;
    UILabel*            _labelDate;
    UILabel*            _labelScore;
    UIView*             _viewBack;
    UILabel*            _labelTotalComment;
    MovieReviewDetailModel* _model;
    BOOL            _isBtnCanTouch;
}
@property(nonatomic,weak)id<CDetailHeadTableViewCellDelegate> cHDelegate;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(MovieReviewDetailModel*)model icon:(NSArray*)imgArr count:(NSInteger)count;
@end
