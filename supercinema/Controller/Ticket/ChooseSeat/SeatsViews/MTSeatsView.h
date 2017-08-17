//
//  MTSeatsView.h
//

#import <UIKit/UIKit.h>
#import "MiniSeatsView.h"
#import "SpecialSeatModel.h"
#import "ShowTimeDetailModel.h"
#import "CinemaShowtimeInfo.h"

@class MTSeatsView;
@protocol MTSeatsViewProtocol <NSObject>

- (BOOL) seatsView:(MTSeatsView *)seatsView seatClickedx:(NSInteger) x y:(NSInteger)y;
- (void)changeButtonImgForScaleView:(BOOL)isMax;
-(void)animateZoomTipViewToHide;

@end

@interface MTScaleView : UIView

@property (nonatomic, strong) NSArray *rowNameList;
@property (nonatomic, copy) NSInteger (^getOriginY)(NSInteger);
@property (nonatomic, copy) CGFloat (^getScaleViewRowWidth)();
@end

@class ChooseSeatManager;
@class PartRowSeatsDataEntity;
@interface MTSeatsView : UIView<UIScrollViewDelegate>
{
    UIScrollView        *_seatsScrollView;     //座位图scrollview
    UIView              *_seatsView;                 //放置座位图标的view
    UIScrollView        *_scaleScrollView;               //左方标尺scrollview
    MTScaleView         *_scaleView;            //左方标尺
    ChooseSeatManager   *_seatManager;
    NSMutableArray      *_beforeBtns;      //存放点击之前所选择的座位
    CGFloat             _firstZoomScale;
    CGFloat             _seatSpace;
    
    dispatch_once_t     onceToken1;
    dispatch_once_t     onceToken2;
    NSMutableDictionary *_dicAllBtns;
    
    BOOL                clickZoomButton;
    BOOL                _isZoomOnOpenPage;
    
    float               width;
    float               height;
    
    CGRect              defaultFrame;

@public
    int                 _seatWidth;     //原始座位宽度
    int                 _seatHeigth;    //原始座位高度
    int                 _margin_x;     //座位横向间隙
    int                 _margin_y;    //座位竖向间隙
}
@property (nonatomic,strong)UIView *miniSeatsParentView;
@property (nonatomic,strong)NSMutableArray *beforeBtns;
@property (nonatomic,strong)MiniSeatsView *miniSeatsView;
@property (nonatomic, strong) UIScrollView *seatsScrollView;
@property (nonatomic, strong) ChooseSeatManager *seatManager;
@property (nonatomic, assign) id<MTSeatsViewProtocol> delegate;
@property (nonatomic, copy) NSArray *rowNameList;
@property (nonatomic, strong) NSMutableArray *selectSeatImageList;
@property (nonatomic, strong) SpecialSeatImageModel *_specialSeatImageModel;

- (id) initWithFrame:(CGRect)frame seatManager:(ChooseSeatManager *)chooseSeatManager specialModel:(SpecialSeatImageModel*)specialModel;
- (void) drawSeat:(BOOL)isChoose;
- (void) zoomSeatsView:(UIButton *)btn;
- (NSDictionary *) getAllButtons;
-(void)setSeatZoom:(float)scale seatX:(NSInteger)tx seatY:(NSInteger)ty isFirst:(BOOL)isFirst;
//延时隐藏_miniSeatsView
-(void)setMiniSeatsParentViewHidden:(BOOL)isHidden afterDelay:(NSTimeInterval)delay;

//根据服务器返回得一行座位信息，刷新座位图指定行
-(NSArray*)refreshSeatsByGivenRowSeatsArray:(PartRowSeatsDataEntity *)partRowSeatsData selectedSeatsAry:(NSArray*)selectedSeatsAry;

-(void)refreshSeatsBtnState;
@end
