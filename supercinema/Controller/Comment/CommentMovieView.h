//
//  CommentMovieViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/29.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IconChaozan = 0,
    IconTuijian = 1,
    IconHaixing = 2,
    IconE = 3,
    IconLan = 4,
    IconNone = 5,
} IconIndex;

@interface CommentMovieView : UIView<UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray*        _arrIconDefault;
    NSArray*        _arrIconSelected;
    NSArray*        _arrText;
    NSArray*        _arrScore;
    NSArray*        _arrScoreText;
    UIView*         _viewWhite;
    UILabel*        _labelCommentText;
    UILabel*        _labelScore;
    UITextView*     _textView;
    UILabel*        _labelDefault;
    UILabel*        _labelCount;
    UIButton*       _btnRelease;
    CGFloat         _spaceIcon;
    CGFloat         _heightDefault;
    BOOL            _isSelectIcon;
    IconIndex       _curIndex;
    CGFloat         _originYTextView;
    NSMutableArray  *_arrMovieTag;
    
    UIScrollView    *_scrollView;
    UIButton        *_btnPre;
    UILabel         *_labelTitle;
    int             _keyBoardHeight;
    NSNumber        *_movieId;
    NSMutableArray  *_arrSaveSeleteTag;
    UIView          *_viewWhiteTop;
    UIButton        *_btnClose;
    BOOL            isFirst;
    int             _lastPosition;
}

@property (nonatomic, copy)     void(^refreshListBlock)(void);

-(instancetype) initWithFrame:(CGRect)frame movieId:(NSNumber *)id;
@end
