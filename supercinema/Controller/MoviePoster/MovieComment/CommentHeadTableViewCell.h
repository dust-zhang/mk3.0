//
//  CommentHeadTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import <UIKit/UIKit.h>
//#import "CircleProgressView.h"

@protocol CommentHeadTableViewCellDelegate <NSObject>

//-(void)wantLook:(BOOL)status;
//-(void)changeFollowStatus:(NSInteger)status;
-(void)toComment;
-(void)threePoints:(NSNumber*)cId;
//-(void)headToLoginVC;
@end

@interface CommentHeadTableViewCell : UITableViewCell
{
    UIButton*               _btnComment;
    UILabel*                _labelMyComment;
    UILabel*                _labelGanggang;
    UIImageView*            _imgCommentIcon;
    UILabel*                _labelCommentText;
    UIButton*               _btnPoints;
    UILabel*                _labelMyCommentDesc;
    UIView*                 _viewBack;
    UILabel*                _labelTotalComment;
    
    MovieReviewSummaryModel*    _model;
}
@property(nonatomic,weak)id<CommentHeadTableViewCellDelegate> cHDelegate;
@property(nonatomic,strong)NSString* movieId;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setData:(MovieReviewSummaryModel*)model icon:(NSArray*)imgArr count:(NSInteger)count;
@end
