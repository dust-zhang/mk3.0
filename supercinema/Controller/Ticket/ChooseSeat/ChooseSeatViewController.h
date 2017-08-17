//
//  ChooseSeatViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/8.
//
//

#import "HideTabBarViewController.h"
#import "MTSeatsView.h"
#import "SeatManager.h"
#import "ChooseSeatShowView.h"
#import "SmallSaleViewController.h"
#import "BuildOrderViewController.h"
#import "LoginViewController.h"

typedef enum{
    LoginStateNormal = 0,   //进选座页时就是登录状态
    LoginStateNot = 1,      //进选座页时是未登录状态
    LoginStateYes = 2,      //未登录状态进选座页登录后的状态
    LoginStateSpecial = 3   //未登录状态进选座页登录后，点击选好了进入下一页面
}LoginState;

@interface ChooseSeatViewController : HideTabBarViewController<MTSeatsViewProtocol,ChooseSeatShowViewDelegate,UIAlertViewDelegate>
{
    UILabel*    _labelDate;    //日期
    UILabel*    _labelScreenName;   //厅名
    UILabel*    _labelScreenExplain;   //场次说明
    UIImageView* _imageScreenExplain;
    UIImageView* screenCenter;
    UIImageView* screenRight;
    UIView*     _viewSeat;
    
    CinemaInfoModel         *modelCinema;
    HallModel               *modelHall;
    MovieDetailModel        *modelMovieDetail;
    FilmDetailModel         *modelShowTime;
    ShowTimeDetailModel     *STModel;
    NSMutableArray          *arrSeats;
    
    MTSeatsView*     _seatsView;
    NSArray                 *arrRowNameList;
    
    UIButton*   _btnConfirm;
    
    ChooseSeatShowView* _showView;
    
    //座位图获取失败的控件
    UIImageView* imageFailure;
    UILabel* labelFailure;
    UIButton* btnTryAgain;
    
    float                   allPrice;
    
    UIView* _viewAlpha;
    UIView* _viewTip;
    UILabel* _labelTipDesc;
    
    LoginState  _loginState;
    BuildOrderModel* buildOrderModel;
}

@property (nonatomic,assign)    NSNumber* movieId;
///选择的座位
@property (nonatomic, strong)   NSMutableArray *selectedSeats;
///已选座位提示区
@property (nonatomic, strong)   UIView *selectedSeatsView;

@property (nonatomic,strong)    ShowTimesModel *showTimesModel;
@property (nonatomic,assign)    NSInteger cardId;
@property (nonatomic,assign)    NSInteger ticketPrice;
@property (nonatomic,assign)    NSInteger servicePrice;
@property (nonatomic, strong)   ShowTimeModel *dataModel;
@property (nonatomic,assign)    BOOL isFirstLoad;
@property (nonatomic,assign)    NSInteger dateIndex;

@property (nonatomic, copy)void(^loginBackBlock)(void);
@end
