//
//  MoviePosterViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2017/3/22.
//
//

#import "HideTabBarViewController.h"
#import "MoviePosterTableView.h"
#import "MovieDetialView.h"
#import "PosterShareView.h"

@interface MoviePosterViewController : HideTabBarViewController<UIScrollViewDelegate>//PosterShareViewDelegate
{
    UIScrollView*   _scrollView;
    NSMutableArray* _arrModel;
    CGFloat         _lastOffset;
    BOOL            _isCalLastOffset;
    NSInteger       timerNumber;
    NSTimer*        lookTimer;
    NSInteger       _lastIndex;
    
    PosterShareView     *_posterShareView;
}
@property(nonatomic,strong)NSArray*        arrMovieData;
@property(nonatomic,strong)NSArray*        arrCommingMovieData;
@property(nonatomic,strong)NSMutableArray* arrData;
@property(nonatomic,assign)NSInteger       currentIndex;
@property(nonatomic,strong)UIView*         viewHead;
@property(nonatomic,strong)UIButton*       btnTicket;
@property(nonatomic,strong)UIButton*       btnBack;
@property(nonatomic,strong)UIButton*       btnWantLook;
@property(nonatomic,strong)UIButton*       btnShare;
@property(nonatomic,strong)UIButton*       btnDetail;
@property(nonatomic,strong)UIImageView*    imgWantLook;
@property(nonatomic,strong)UIScrollView*   scrollView;
@property(nonatomic,strong)MovieDetialView *movieDetialView;
@property(nonatomic,strong)UIView* viewCover;
@property(nonatomic,assign)BOOL            isShowCommentList;   //是否默认显示短评列表
@end
