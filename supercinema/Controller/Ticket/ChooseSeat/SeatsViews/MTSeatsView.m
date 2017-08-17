//
//  MTSeatsView.m
//

#import "MTSeatsView.h"
#import "SeatManager.h"
#import "SeatUIButton.h"
#import "PartRowSeatsDataEntity.h"
#import "ShowTimeDetailModel.h"

#define NormalSeatImage @"button_seat_unselected"
#define ChosenSeatImage @"button_seat_selected"
//#define ClosedSeatImage @"button_seat_cannot_select"
#define ClosedSeatImage @"direction0"
#define NormalLoverSeat @"button_lover_seat_unselected"
#define ChosenLoverSeat @"button_lover_seat_selected"
#define ClosedLoverSeat @"button_lover_seat_cannot_select"
#define DefaultMinimumZoomScale 0.6
#define NumberFont MKFONT(12)

static const CGFloat kScaleScrollViewWidth = 15;
static const CGFloat kScaleViewMaginTop = 8;//8;
static const CGFloat seatsViewMarginTop=0;//80;

#define SCALEVIEW_BACKGROUND_IMAGE [[UIImage imageNamed:@"v10_left_scaleview_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(8,8,8,8)]

static const NSUInteger kMiniSeatsViewWidth = 100;
//缩略图视图跟 背景视图得边距
//static const NSUInteger kMiniSeatsViewMargin = 8;

@implementation MTScaleView
- (void) drawRect:(CGRect)rect
{
    static const CGFloat height = 25.7f;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    for (int i = 0; i < [_rowNameList count]; i++)
    {
        RowNameListModel *rowName = [_rowNameList objectAtIndex:i];
        CGFloat f = _getOriginY([rowName.rowId integerValue]); //+80;
        CGFloat scaleViewRowWidth = _getScaleViewRowWidth();
        CGRect rect1 = CGRectMake(0, f , scaleViewRowWidth>18?scaleViewRowWidth:18, height);
//        [rowName.rowName drawInRect:rect1 withFont:NumberFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        
//#ifdef __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [rowName.rowName drawInRect:rect1 withAttributes: @{NSFontAttributeName: NumberFont,
                                                            NSForegroundColorAttributeName:[UIColor whiteColor],
                                                         NSParagraphStyleAttributeName: paragraphStyle }];
//#else
//         [rowName.rowName drawInRect:rect1 withFont:NumberFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
//#endif
    }
}

@end


@implementation MTSeatsView
@synthesize seatManager = _seatManager;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame seatManager:(ChooseSeatManager *) chooseSeatManager specialModel:(SpecialSeatImageModel*)specialModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        defaultFrame = frame;
        
//        UIView* viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, 1)];
//        viewline.backgroundColor = RGBA(229, 229, 229,1);
//        [self addSubview:viewline];
        
        _seatsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScaleViewMaginTop, CGRectGetWidth(frame) - 0, CGRectGetHeight(frame) - kScaleViewMaginTop)];
        _seatsScrollView.showsHorizontalScrollIndicator = _seatsScrollView.showsVerticalScrollIndicator = NO;
        _seatsScrollView.bounces = YES;
        _seatsScrollView.backgroundColor = [UIColor clearColor];
        _seatsScrollView.maximumZoomScale = 1.0f;
        _seatsScrollView.delegate = self;
        [self addSubview:_seatsScrollView];
        
        _seatsView = [[UIView alloc] initWithFrame:CGRectMake(_seatsScrollView.bounds.origin.x+10,
                                                              _seatsScrollView.bounds.origin.y+40,
                                                              _seatsScrollView.bounds.size.width,
                                                              _seatsScrollView.bounds.size.height)];
        _seatsView.backgroundColor = [UIColor clearColor];
        [_seatsScrollView addSubview:_seatsView];

        _scaleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-kScaleScrollViewWidth-5, kScaleViewMaginTop, kScaleScrollViewWidth, CGRectGetHeight(frame)-kScaleViewMaginTop)];
        _scaleScrollView.showsHorizontalScrollIndicator = _scaleScrollView.showsVerticalScrollIndicator = NO;
        _scaleScrollView.maximumZoomScale = 1.0f;
        _scaleScrollView.delegate = self;
        _scaleScrollView.bounces = NO;
        _scaleScrollView.userInteractionEnabled = NO;
        _scaleScrollView.clipsToBounds = YES;
//        _scaleScrollView.backgroundColor = [UIColor clearColor];
        _scaleScrollView.backgroundColor = RGBA(0, 0, 0, 0.3);
        _scaleScrollView.layer.masksToBounds = YES;
        _scaleScrollView.layer.cornerRadius = _scaleScrollView.frame.size.width/2;
        [self addSubview:_scaleScrollView];
        _scaleView = [[MTScaleView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(_scaleScrollView.bounds), CGRectGetHeight(_scaleScrollView.bounds)-kScaleViewMaginTop)];
        _scaleView.clipsToBounds = YES;
        _scaleView.backgroundColor = [UIColor clearColor];
//        _scaleView.layer.masksToBounds = YES;
//        _scaleView.layer.cornerRadius = _scaleView.frame.size.width/2;
        [_scaleScrollView addSubview:_scaleView];
        
//        UIView* viewBack = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)-kScaleScrollViewWidth, 0, kScaleScrollViewWidth, CGRectGetHeight(frame))];
//        viewBack.backgroundColor = RGBA(0, 0, 0, 0.3);
//        viewBack.layer.masksToBounds = YES;
//        viewBack.layer.cornerRadius = viewBack.frame.size.width/2;
//        [self addSubview:viewBack];
//        [self bringSubviewToFront:viewBack];
//        //[self sendSubviewToBack:viewBack];
        
        _isZoomOnOpenPage = YES;
        self.seatManager = chooseSeatManager;
        
        _margin_x = 10;
        _margin_y = 10;
        
        // 单排有13个以上的座位，座位固定使用该尺寸.
//        _seatWidth = 31;
//        _seatHeigth = _seatWidth * 31 / 36;
        
        _seatWidth = 35;
        _seatHeigth = 35;
        
        width = _seatWidth * (_seatManager.columnCount ) + (_seatManager.columnCount) * _margin_x;
        height = _seatHeigth * (_seatManager.rowCount ) + (_seatManager.rowCount) * _margin_y + _seatHeigth;
        _seatsScrollView.contentSize = CGSizeMake(width+18+10+10, height+21+50);
        if (frame.size.width>width)
        {
            _seatSpace = (_seatsScrollView.frame.size.width - width)/2;
            _firstZoomScale = (frame.size.width - kScaleScrollViewWidth) / width;
            [_seatsView setFrame:CGRectMake(_seatsView.frame.origin.x, _seatsView.frame.origin.y,
                                            _seatsScrollView.frame.size.width, _seatsScrollView.contentSize.height+seatsViewMarginTop)];
        }
        else
        {
            _seatSpace = 0;
            _firstZoomScale = (CGRectGetHeight(_seatsScrollView.frame) / height) > (CGRectGetWidth(_seatsScrollView.frame) / width) ? (CGRectGetWidth(_seatsScrollView.frame) / width) : (CGRectGetHeight(_seatsScrollView.frame) / height);
            [_seatsView setFrame:CGRectMake(_seatsView.frame.origin.x, _seatsView.frame.origin.y,
                                            _seatsScrollView.contentSize.width, _seatsScrollView.contentSize.height+seatsViewMarginTop)];
        }
        _seatsScrollView.minimumZoomScale = _firstZoomScale;
        if (_firstZoomScale>1)
        {
            _seatsScrollView.minimumZoomScale = 1;
        }
        else if (_firstZoomScale<DefaultMinimumZoomScale)
        {
            _seatsScrollView.minimumZoomScale = DefaultMinimumZoomScale;
        }
        //_firstZoomScale = _seatsScrollView.minimumZoomScale;
//        if (_seatsScrollView.minimumZoomScale < DefaultMinimumZoomScale) {
//            _seatsScrollView.minimumZoomScale = DefaultMinimumZoomScale;
//        }
//        NSLog(@"allImageScrollView.minimumZoomScale:%f",_seatsScrollView.minimumZoomScale);
//        [_seatsScrollView setContentOffset:CGPointMake(_seatsScrollView.contentSize.width/2+_seatsScrollView.frame.size.width/2,0)];
        //使座位偏移居中显示
//        if(_seatsScrollView.contentSize.width/2 > frame.size.width/2){
//            [_seatsScrollView setContentOffset:CGPointMake(_seatsScrollView.contentSize.width/2-frame.size.width/2,0)];
//        }else{
//            [_seatsScrollView setContentOffset:CGPointMake(frame.size.width/2-_seatsScrollView.contentSize.width/2,0)];
//        }
        CGFloat scaleScrollViewContentSizeWidth = kScaleScrollViewWidth/_seatsScrollView.minimumZoomScale;
        _scaleScrollView.minimumZoomScale = _seatsScrollView.minimumZoomScale;
        _scaleScrollView.contentSize = CGSizeMake(scaleScrollViewContentSizeWidth, height+70);
        CGFloat currentScaleViewWidth;
        if (scaleScrollViewContentSizeWidth<18)
        {
            currentScaleViewWidth = 18;
        }
        else
        {
            currentScaleViewWidth = scaleScrollViewContentSizeWidth;
        }
        [_scaleView setFrame:CGRectMake(0, 40, currentScaleViewWidth, height)];//_scaleScrollView.contentSize.height + seatsViewMarginTop
        
        [_seatsScrollView setZoomScale:_seatsScrollView.minimumZoomScale animated:NO];
        [_scaleScrollView setZoomScale:_seatsScrollView.minimumZoomScale animated:NO];
        
        __weak MTSeatsView *weakSelf = self;
        _scaleView.getScaleViewRowWidth = ^CGFloat()
        {
            MTSeatsView *strongSelf = weakSelf;
            if(strongSelf)
            {
                //NSLog(@"%f",strongSelf.seatsScrollView.zoomScale);
                return  kScaleScrollViewWidth / strongSelf.seatsScrollView.minimumZoomScale;
            }
            return 0.0f;
        };
        
        _dicAllBtns = [[NSMutableDictionary alloc] init];
        _beforeBtns = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.selectSeatImageList = [[NSMutableArray alloc]init];
        self._specialSeatImageModel = specialModel;
        //特殊座位
        for (NSString* specialImage in specialModel.commonSelectSeatImageList)
        {
            SpecialSeatModel* _specialSeatModel = [[SpecialSeatModel alloc]init];
            _specialSeatModel.isUsed = NO;
            _specialSeatModel.seatImageName = specialImage;
            [self.selectSeatImageList addObject:_specialSeatModel];
        }
    }
    return self;
}

//-(void)refreshFrame:(CGRect)newFrame
//{
//    _seatsScrollView.frame = CGRectMake(0, kScaleViewMaginTop, CGRectGetWidth(newFrame) - kScaleScrollViewWidth, CGRectGetHeight(newFrame) - kScaleViewMaginTop);
//    _seatsView.frame = CGRectMake(_seatsScrollView.bounds.origin.x,_seatsScrollView.bounds.origin.y,_seatsScrollView.bounds.size.width,_seatsScrollView.bounds.size.height);
//    _scaleScrollView.frame = CGRectMake(newFrame.size.width - kScaleScrollViewWidth, 0, kScaleScrollViewWidth, CGRectGetHeight(newFrame));
//    _scaleView.frame = CGRectMake(0, 8, CGRectGetWidth(_scaleScrollView.bounds), CGRectGetHeight(_scaleScrollView.bounds));
//    viewBack.frame = _scaleScrollView.frame;
//}

- (void)setRowNameList:(NSArray *)rowNameList
{
    _rowNameList = [rowNameList copy];
    __block MTSeatsView *pSelf = self;
    _scaleView.getOriginY = ^NSInteger(NSInteger i)
    {
        return i*pSelf->_seatHeigth + pSelf->_margin_y*i+4+13/2;
    };
}

- (void) dealloc
{
    onceToken1 = onceToken2 = 0;
    _seatsScrollView.delegate = nil;
    _scaleScrollView.delegate = nil;
}


- (void) removeAllSubViewsFromView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        [subview removeFromSuperview];
    }
}

///检查座位是否属于中间位置
-(BOOL)checkSeatIsMiddleColumn:(NSInteger)columnIndex
{
    if((_seatManager.columnCount+1) / 2==(columnIndex+1))
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void) drawSeat:(BOOL)isChoose
{
    @try
    {
        if (isChoose)
        {
            for (int i = 0; i < [_seatManager.allSeats count]; i++)
            {
                SeatInfo *si = [_seatManager.allSeats objectAtIndex:i];
                NSString *seatsInfoKey = [_seatManager getSeatInfoKey:si];
                
                //如果是选座位，更换不可选座位的图片
                if (si.status == selectedByOthers_SeatStatus)
                {
                    SeatUIButton *btnSeat = [_dicAllBtns valueForKey:seatsInfoKey];
                    [self setButtonImage:btnSeat forSeatType:si.type andSeatInfo:si];
                }
            }
        }
        else
        {
            [self removeAllSubViewsFromView:_seatsView];
            UIView* viewlineY = [[UIImageView alloc]initWithFrame:CGRectMake((width-_margin_x)*0.5+_seatSpace+10, -20, 1, height-_seatHeigth+40)];
            for (int i = 0; i<viewlineY.frame.size.height/8; i++)
            {
                UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 8*i, 1, 5)];
                line.backgroundColor = RGBA(203, 203, 203,1);
                [viewlineY addSubview:line];
            }
            [_seatsView addSubview:viewlineY];
            [_dicAllBtns removeAllObjects];
            _scaleView.rowNameList = self.rowNameList;
            //        NSInteger rowNameIndex=0;
            NSString *lastValidKey;
            //        NSInteger emptyRowCount=0;
            for (int i = 0; i < [_seatManager.allSeats count]; i++)
            {
                SeatInfo *si = [_seatManager.allSeats objectAtIndex:i];
                NSInteger tx = si.x;
                NSInteger ty = si.y;
                
                NSInteger xFrame = 10 + _seatSpace + tx*_seatWidth + _margin_x*tx;
                NSInteger yFrame = ty*_seatHeigth + _margin_y*ty+seatsViewMarginTop;
                //            [self drawXLineWithRow:ty andOriginY:yFrame];
                //            [self drawYLineWithColumn:tx andOriginX:xFrame];
                NSString *seatsInfoKey = [_seatManager getSeatInfoKey:si];
                if (notSeat_SeatStatus != si.status)
                {
                    BOOL hasValidButton=NO;
                    SeatUIButton *btnSeat = [[SeatUIButton alloc] init];
                    
                    //普通座位直接画
                    if (normal_SeatType == si.type)
                    {
                        btnSeat.frame = CGRectMake(xFrame, yFrame, _seatWidth, _seatHeigth);
                        hasValidButton=YES;
                    }
                    //情侣座画左边座位，右边不贴图，不可点，只写字
                    else if (loverLeft_SeatType == si.type)
                    {
                        [btnSeat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        btnSeat.frame = CGRectMake(xFrame, yFrame, (_seatWidth * 2+_margin_x), _seatHeigth);
                        hasValidButton=YES;
                    }
                    
                    if(hasValidButton)
                    {
                        //设置tag，方便查找
                        btnSeat.tag = [seatsInfoKey integerValue];
                        [self setButtonImage:btnSeat forSeatType:si.type andSeatInfo:si];
                        //                    [self setButtonTitle:btnSeat title:[NSString stringWithFormat:@"%ld",(long)si.seatNumber] seatType:si.type];
                        btnSeat.seatInfo = si;
                        [btnSeat addTarget:self action:@selector(seatsClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [_dicAllBtns setObject:btnSeat forKey:seatsInfoKey];
                        
                        [_seatsView addSubview:btnSeat];
                        lastValidKey=seatsInfoKey;
                        
                    }
                    else
                    {
                        //NSLog(@"not valid button");
                    }
                }
            }
            //添加座位图缩略图视图
            [self drawMiniSeatsView];
            [_scaleView sizeToFit];
        }
        //防止座位图被缩放的太小
//        if (_firstZoomScale<DefaultMinimumZoomScale) {
//            [_seatsScrollView setContentOffset:CGPointMake((_seatsScrollView.contentSize.width-_seatsScrollView.frame.size.width)/2, 0) animated:YES];
////            _seatsScrollView.minimumZoomScale = DefaultMinimumZoomScale;
//            
//        }else if (_firstZoomScale>1){
////            _seatsScrollView.minimumZoomScale = 1;
//        }else
//        {
////            _seatsScrollView.minimumZoomScale = _firstZoomScale;
//            
//        }
//        [_seatsScrollView setContentOffset:CGPointMake((_seatsScrollView.contentSize.width-_seatsScrollView.frame.size.width)/2, 0) animated:YES];
//        _scaleScrollView.minimumZoomScale = _seatsScrollView.minimumZoomScale;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        
    }
}

#pragma mark refresh given row seats View
-(NSArray*)refreshSeatsByGivenRowSeatsArray:(PartRowSeatsDataEntity *)partRowSeatsData selectedSeatsAry:(NSArray*)selectedSeatsAry
{
//    NSArray* rowSeatsArray = partRowSeatsData.rowSeats;
//    //数组转换，将SeatItemEntity 数组，转换成 MTSeatDataEntity 数组
//    NSArray *covertedMtSeatDataArray ;//= [ChooseSeatManager mtSeatDataArrayCovertedFromSeatItemArray:rowSeatsArray];
    //数据转换
    NSArray *seatInfoArray ;//= [ChooseSeatManager seatInfoArrayCovertedFromSeatDataArray:covertedMtSeatDataArray];
    //1.首先替换_seatManager.allSeats得指定行
    [_seatManager refreshSeatsDataByNewSeatsInfoArray:seatInfoArray selectedSeatsAry:selectedSeatsAry];
    
    //每次局部刷新回来，都要刷新用户当前已选座位，移除已经失效得座位，
    //找到一些已经选择上，但是已失效得座位数组
    NSArray *selectedRows = partRowSeatsData.selectedRows;
    NSPredicate *predicateRowDisabled = [NSPredicate predicateWithFormat:@"enable == 0"];
    NSArray *rowArrayDisabled = [selectedRows filteredArrayUsingPredicate:predicateRowDisabled];
    
    //获取已选座位中已经失效得座位，并从SeatManger 中_selectedSeats中清除
    NSArray *selectedRowArrayshouldToBeDeleted = nil;
    if(!ARRAY_IS_EMPTY(rowArrayDisabled))
    {
        NSArray *rowIdArrayDisabled = [rowArrayDisabled valueForKey:@"seatId"];
        //寻找self.selectedAry 中应该删除得一些已选座位
        NSPredicate *selectedRowArrayShouldToBeDeletedPredicate = nil;
        if(rowIdArrayDisabled.count == 1)
        {
          NSInteger seatIdDisabled = [rowIdArrayDisabled.firstObject integerValue];
          selectedRowArrayShouldToBeDeletedPredicate = [NSPredicate predicateWithFormat: @"seatId == %d", seatIdDisabled];
            
        }
        else
        {
            //> 1
            selectedRowArrayShouldToBeDeletedPredicate = [NSPredicate predicateWithFormat: @"seatId BETWEEN %@", rowIdArrayDisabled];
        }
        selectedRowArrayshouldToBeDeleted = [selectedSeatsAry filteredArrayUsingPredicate:selectedRowArrayShouldToBeDeletedPredicate];
        [self.seatManager deleteFromSelectedSeatsByDisabledRowArray:selectedRowArrayshouldToBeDeleted];
    }
    for(SeatInfo *si in seatInfoArray)
    {
           //根据seatInfoArray 刷新这些视图得状态
            if (notSeat_SeatStatus != si.status)
            {
                NSString *seatsInfoKey = [_seatManager getSeatInfoKey:si];
                NSInteger seatUIButtonTag = [seatsInfoKey integerValue];
                //从_seatsView 中寻找要刷新得一个button，刷新其显示状态
                SeatUIButton *button =  (SeatUIButton *)[self findViewByTag:seatUIButtonTag withViewsArray:[_seatsView subviews]];
                
                if (notSeat_SeatStatus != si.status)
                {
                    if (normal_SeatType == si.type || loverLeft_SeatType == si.type)
                    {
                        // 普通座位/情侣座位
                        if(![selectedSeatsAry containsObject:si])
                        {//当前座位不在已选座位列表
                            [self setButtonImage:button forSeatType:si.type andSeatInfo:si];
                            button.seatInfo = si;
                            //普通座／情侣座
                            if(button)
                            {
                                [_dicAllBtns setObject:button forKey:seatsInfoKey];
                            }
                            
                        }
                        else
                        {
                            //当前座位在已选座位列表
                            //判断当前座位是否在已失效已选座位列表中
                            if(!ARRAY_IS_EMPTY(selectedRowArrayshouldToBeDeleted)){
                                NSPredicate *predicateCurRow = [NSPredicate predicateWithFormat:@"x == %d AND y == %d", si.x , si.y];
                                NSArray *filtedSeatArray = [selectedRowArrayshouldToBeDeleted filteredArrayUsingPredicate:predicateCurRow];
                                if(!ARRAY_IS_EMPTY(filtedSeatArray))
                                {//已选座位已经失效，则更新该座位显示图片
                                    si.status =  selectedByOthers_SeatStatus;
                                    button.seatInfo = si;
                                    if(button)
                                    {
                                        [_dicAllBtns setObject:button forKey:seatsInfoKey];
                                        [_beforeBtns removeObject:si];
                                    }
                                    [self setButtonImage:button forSeatType:si.type andSeatInfo:si];
                                    
                                }
                                else
                                {
                                    //该已选座位仍然有效，则不做任何处理
                                    [self setButtonImage:button forSeatType:si.type andSeatInfo:si];
                                }
                            }
                            else
                            {
                                //该已选座位仍然有效，则不做任何处理
                                [self setButtonImage:button forSeatType:si.type andSeatInfo:si];
                            }
                        }
                        
                    }
                }
            }
        }
    return selectedRowArrayshouldToBeDeleted;
}

//在一组视图中寻找指定tag得一个视图
-(UIView*)findViewByTag:(NSUInteger)tag withViewsArray:(NSArray*)viewsArray
{
    NSPredicate *predicateTag = [NSPredicate predicateWithFormat:@"tag == %d", tag];
    NSArray *filteredList = [viewsArray filteredArrayUsingPredicate:predicateTag];
    return filteredList.firstObject;
}

//添加座位图缩略图视图
-(void)drawMiniSeatsView
{
    CGRect miniRect;
    if (_seatsScrollView.contentSize.height>=_seatsScrollView.contentSize.width) {
        miniRect = CGRectMake(0, 0, kMiniSeatsViewWidth*_seatsScrollView.contentSize.width/_seatsScrollView.contentSize.height, kMiniSeatsViewWidth);
    }
    else
    {
        miniRect = CGRectMake(0, 0,kMiniSeatsViewWidth, kMiniSeatsViewWidth*_seatsScrollView.contentSize.height/_seatsScrollView.contentSize.width);
    }
    self.miniSeatsParentView= [[UIView alloc]initWithFrame:miniRect]; //20, 40, kMiniSeatsViewWidth, 60
    self.miniSeatsParentView.backgroundColor = RGBA(0, 0, 0,0.2);
    
    UIView* viewMiniLine = [[UIView alloc]initWithFrame:CGRectMake((miniRect.size.width-40)/2, 3, 40, 2)];
    viewMiniLine.backgroundColor = [UIColor blackColor];
    [self.miniSeatsParentView addSubview:viewMiniLine];
    //self.miniSeatsParentView.alpha = 0.6;
//    self.miniSeatsParentView.layer.masksToBounds = YES;
//    self.miniSeatsParentView.layer.cornerRadius = 2;
    
    self.miniSeatsView = [[MiniSeatsView alloc] initWithUIScrollView:_seatsScrollView  seatsView:_seatsView frame:CGRectMake(5, 15, miniRect.size.width-10, miniRect.size.height-15)];//0, 0, kMiniSeatsViewWidth, 60
    [self setMiniSeatsParentViewHidden:YES];
    self.miniSeatsView.backgroundColor = [UIColor clearColor];//RGBA(0, 0, 0,0.2);
    [self addSubview:self.miniSeatsParentView];
    [self.miniSeatsParentView addSubview:_miniSeatsView];
}

//画十字线x轴
- (void) drawXLineWithRow:(CGFloat)ty andOriginY:(CGFloat)yFrame
{
    if (ceil(_seatManager.rowCount / 2.f) == ty)
    {
        dispatch_once(&onceToken1, ^{
            UIColor *grayLine = [UIColor redColor];
            UIView *line_x = [[UIView alloc] init];
            line_x.backgroundColor = grayLine;
            line_x.frame = CGRectMake(0, yFrame-3, CGRectGetWidth(_seatsView.frame), 2);
            NSLog(@"seatsView.frame:%f,,,,,%f",_seatsView.frame.size.width,CGRectGetWidth(_seatsView.frame));
            [_seatsView addSubview:line_x];
        });
    }
}

//画十字线y轴
- (void) drawYLineWithColumn:(CGFloat)tx andOriginX:(CGFloat)xFrame
{
    if (ceil(_seatManager.columnCount / 2.f) == tx)
    {
        dispatch_once(&onceToken2, ^{
            UIColor *grayLine = [UIColor blueColor];
            UIView *line_y = [[UIView alloc] init];
            line_y.backgroundColor = grayLine;
            line_y.frame = CGRectMake(xFrame-3.5, 0, 2, CGRectGetHeight(_seatsView.frame));
            [_seatsView addSubview:line_y];
        });
    }
}

//设置按钮图片
- (void) setButtonImage:(UIButton *)button forSeatType:(SeatType) type andSeatInfo:(SeatInfo*)info
{
    NSString* _strCannotSelect = ClosedSeatImage;
    if (info.status == selectedByOthers_SeatStatus)
    {
        _strCannotSelect = [self getCannotSelectName:info];
    }
    if (normal_SeatType == type)
    {
        //        [button setBackgroundImage:[UIImage imageNamed:NormalSeatImage] forState:UIControlStateNormal];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self._specialSeatImageModel.commonSaleSeatImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:NormalSeatImage]];
        [button setBackgroundImage:[UIImage imageNamed:ChosenSeatImage] forState:UIControlStateSelected];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self._specialSeatImageModel.commonSoldSeatImage] forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:_strCannotSelect]];
        //        [button setBackgroundImage:[UIImage imageNamed:ClosedSeatImage] forState:UIControlStateDisabled];
    }
    else if (loverLeft_SeatType == type)
    {
        //        [button setBackgroundImage:[UIImage imageNamed:NormalLoverSeat] forState:UIControlStateNormal];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self._specialSeatImageModel.loveSaleSeatImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:NormalLoverSeat]];
        [button setBackgroundImage:[UIImage imageNamed:ChosenLoverSeat] forState:UIControlStateSelected];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self._specialSeatImageModel.loveSoldSeatImage] forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:ClosedLoverSeat]];
        //        [button setBackgroundImage:[UIImage imageNamed:ClosedLoverSeat] forState:UIControlStateDisabled];
    }
    if (canSelect_SeatStatus == info.status)
    {
        button.enabled = YES;
        button.selected = NO;
    }
    else if (selectedByMyself_SeatStatus == info.status)
    {
        button.enabled = YES;
        button.selected = YES;
    }
    else if (selectedByOthers_SeatStatus == info.status)
    {
        button.enabled = NO;
        button.selected = NO;
    }
}

#pragma mark 获取不可选的图片
-(NSString*)getCannotSelectName:(SeatInfo*)info
{
    NSString* strName = ClosedSeatImage;
    NSArray* arrSelectedSeats = self.seatManager.selectedSeats;
    if (arrSelectedSeats.count > 0)
    {
        SeatInfo* lastSeatInfo = arrSelectedSeats[arrSelectedSeats.count-1];
        if (info.x<lastSeatInfo.x && info.y<lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的左上方
            strName = @"direction8";
        }
        if (info.x==lastSeatInfo.x && info.y<lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的上方
            strName = @"direction7";
        }
        if (info.x>lastSeatInfo.x && info.y<lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的右上方
            strName = @"direction6";
        }
        if (info.x<lastSeatInfo.x && info.y==lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的左方
            strName = @"direction5";
        }
        if (info.x>lastSeatInfo.x && info.y==lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的右方
            strName = @"direction4";
        }
        if (info.x<lastSeatInfo.x && info.y>lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的左下方
            strName = @"direction3";
        }
        if (info.x==lastSeatInfo.x && info.y>lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的下方
            strName = @"direction2";
        }
        if (info.x>lastSeatInfo.x && info.y>lastSeatInfo.y)
        {
            //该不可选座位在最后一个选中座位的右下方
            strName = @"direction1";
        }
    }
    return strName;
}

- (void) setButtonTitle:(UIButton *)button title:(int)ntitle seatType:(SeatType) type {
//    if (normal_SeatType == type) {
//        [button setTitle:[NSString stringWithFormat:@"%02d", ntitle] forState:UIControlStateNormal];
//    }
//    else if (loverLeft_SeatType == type) {
//        NSString *title = [NSString stringWithFormat:@"%02d    %02d", ntitle, ntitle + 1];
//        [button setTitle:title forState:UIControlStateNormal];
//    }
//    [button setTitle:@"" forState:UIControlStateDisabled];
//    [button setTitle:@"" forState:UIControlStateSelected];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font = NumberFont;
}

#pragma mark - UIScrollViewDelegate methods
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        return _seatsView;
    }
    else if (scrollView == _scaleScrollView)
    {
        return _scaleView;
    }
    return nil;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        if (clickZoomButton)
        {
            clickZoomButton = NO;
        }
        _scaleScrollView.zoomScale = scrollView.zoomScale;
        _scaleScrollView.contentOffset = CGPointMake(_scaleScrollView.contentOffset.x, scrollView.contentOffset.y);
        [_miniSeatsView scrollViewDidZoom:scrollView];
    }
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView == _seatsScrollView)
    {
        if ([_delegate respondsToSelector:@selector(changeButtonImgForScaleView:)])
        {
            if (scale == scrollView.maximumZoomScale)
            {
                [_delegate changeButtonImgForScaleView:YES];
            }
            else if (scale == scrollView.minimumZoomScale)
            {
                [_delegate changeButtonImgForScaleView:NO];
            }
        }
        [_miniSeatsView scrollViewDidEndZooming:scrollView withView:view atScale:scale];
        [self setMiniSeatsParentViewHidden:YES afterDelay:1.0];
        
        if (!_isZoomOnOpenPage && [_delegate respondsToSelector:@selector(animateZoomTipViewToHide)])
        {
            [_delegate animateZoomTipViewToHide];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        [_miniSeatsView scrollViewWillBeginDragging:scrollView];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
//        NSLog(@"滚动的位置1：%f,%f",scrollView.contentOffset.x, scrollView.contentOffset.y);
        _isZoomOnOpenPage = NO;
        //_scaleScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        _scaleScrollView.contentOffset = CGPointMake(_scaleScrollView.contentOffset.x, scrollView.contentOffset.y);
        //滑动过程中显示缩略图
        [self setMiniSeatsParentViewHidden:NO];
        [self setMiniSeatsParentViewHidden:YES afterDelay:1.0];
        
        //滚动时同步发消息给miniSeatsView
        [_miniSeatsView scrollViewDidScroll:scrollView];
//        NSLog(@"滚动的位置2：%f,%f",scrollView.contentOffset.x, scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _seatsScrollView)
    {
        [_miniSeatsView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        [self setMiniSeatsParentViewHidden:YES afterDelay:1.0];
        
        if (!_isZoomOnOpenPage && [_delegate respondsToSelector:@selector(animateZoomTipViewToHide)])
        {
            [_delegate animateZoomTipViewToHide];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        [_miniSeatsView scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        [_miniSeatsView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void) seatsClicked:(SeatUIButton *) button
{
    if ([_delegate respondsToSelector:@selector(seatsView:seatClickedx:y:)])
    {
        if ([_delegate seatsView:self seatClickedx:button.seatInfo.x y:button.seatInfo.y])
        {
            [self refreshSeatsBtnState];
        }
       //重新截取缩略图
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMinSeatsView) object:nil];
        [self performSelector:@selector(refreshMinSeatsView) withObject:nil
                   afterDelay:0.3];
    }
}

-(void)refreshSeatsBtnState
{
    NSArray *subAry = nil;
    NSMutableArray *selectedBtns = [NSMutableArray arrayWithArray:[_seatManager getAllSelectedSeats]];
    if ([selectedBtns count] > [_beforeBtns count])
    {
        NSArray *temp = [_beforeBtns copy];
        [_beforeBtns setArray:selectedBtns];
        [selectedBtns removeObjectsInArray:temp];
        subAry = selectedBtns;
    }
    else
    {
        [_beforeBtns removeObjectsInArray:selectedBtns];
        subAry = [_beforeBtns copy];
        [_beforeBtns setArray:selectedBtns];
    }
    for (SeatInfo *seat in subAry)
    {
        NSString *key = [_seatManager getSeatInfoKey:seat];
        UIButton *btn = [_dicAllBtns objectForKey:key];
        if (seat.type == normal_SeatType)
        {
            //普通座
            if (!btn.selected)
            {
                seat.seatImageName = [self getSpecialSeatImage];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:seat.seatImageName] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:ChosenSeatImage]];
            }
            else
            {
                [self changeSpecialSeatState:seat.seatImageName];
            }
        }
        else if (seat.type == loverLeft_SeatType)
        {
            //情侣座
            if (!btn.selected)
            {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:self._specialSeatImageModel.loveSelectSeatImage] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:ChosenLoverSeat]];
            }
        }
        btn.selected = !btn.selected;
    }
}

-(NSString*)getSpecialSeatImage
{
    for (SpecialSeatModel* specialModel in self.selectSeatImageList)
    {
        if (specialModel.isUsed == NO)
        {
            specialModel.isUsed = YES;
            return specialModel.seatImageName;
        }
    }
    return nil;
}

-(void)changeSpecialSeatState:(NSString*)sImageName
{
    for (SpecialSeatModel* specialModel in self.selectSeatImageList)
    {
        if ([sImageName isEqualToString:specialModel.seatImageName])
        {
            specialModel.isUsed = NO;
        }
    }
}

-(void)refreshMinSeatsView
{
    [_miniSeatsView  reCaptureScreenAndUpateView];
}

- (NSDictionary *) getAllButtons
{
    return [NSDictionary dictionaryWithDictionary:_dicAllBtns];
}

- (void) zoomSeatsView:(UIButton *)btn
{
    clickZoomButton = YES;
    if (btn.selected)
    {
        [_seatsScrollView setZoomScale:_seatsScrollView.maximumZoomScale animated:YES];
        [_scaleScrollView setZoomScale:_scaleScrollView.maximumZoomScale animated:YES];
        btn.selected = NO;
    }
    else
    {
        [_seatsScrollView setZoomScale:_seatsScrollView.minimumZoomScale animated:YES];
        [_scaleScrollView setZoomScale:_seatsScrollView.minimumZoomScale animated:YES];
        btn.selected = YES;
    }
    //显示缩略图
    [self setMiniSeatsParentViewHidden:NO];
    [self setMiniSeatsParentViewHidden:YES afterDelay:1.0];
}

-(void)setMiniSeatsParentViewHidden:(BOOL)isHidden afterDelay:(NSTimeInterval)delay{
    if(delay <= 0)
    {
        [self setMiniSeatsParentViewHidden:isHidden];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setMiniSeatsParentViewHiddenSelector:) object:@(YES)];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setMiniSeatsParentViewHiddenSelector:) object:@(NO)];
        if(isHidden)
        {
          [self performSelector:@selector(setMiniSeatsParentViewHiddenSelector:) withObject:@(YES) afterDelay:delay];
        }else
        {
          [self performSelector:@selector(setMiniSeatsParentViewHiddenSelector:) withObject:@(NO) afterDelay:delay];
        }
    }
}

- (void)setMiniSeatsParentViewHiddenSelector:(NSNumber*)isHiddenNumber
{
   BOOL isHidden = [isHiddenNumber boolValue];
   self.miniSeatsParentView.hidden = isHidden;
}

- (void)setMiniSeatsParentViewHidden:(BOOL)isHidden
{
    self.miniSeatsParentView.hidden = isHidden;
}

#pragma 设置座位的比例
-(void)setSeatZoom:(float)scale seatX:(NSInteger)tx seatY:(NSInteger)ty isFirst:(BOOL)isFirst
{
    if (isFirst)
    {
        [_seatsScrollView setContentOffset:CGPointMake((_seatsScrollView.contentSize.width-_seatsScrollView.frame.size.width)/2, (_seatsScrollView.contentSize.height-_seatsScrollView.frame.size.height)/2-50)];
        [UIView animateWithDuration:scale animations:^{
            [_seatsScrollView setZoomScale:scale animated:NO];
            [_scaleScrollView setZoomScale:scale animated:NO];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        if (_seatsScrollView.zoomScale == 1)
        {
            return;
        }
        
        float xFrame = _seatSpace + tx*_seatWidth + _margin_x*(tx-1);
        float yFrame = ty*_seatHeigth + _margin_y*(ty-1)+seatsViewMarginTop;
        
        [UIView animateWithDuration:1 animations:^{
            [_seatsScrollView setZoomScale:scale animated:NO];
            [_scaleScrollView setZoomScale:scale animated:NO];
            //        if (scale == 1)
            //        {
            //            [_seatsScrollView setContentOffset:CGPointMake((_seatsScrollView.contentSize.width-_seatsScrollView.frame.size.width)/2, 0) animated:NO];
            //        }
            //        else
            //        {
            float xMax = _seatsScrollView.contentSize.width - _seatsScrollView.frame.size.width;
            float yMax = _seatsScrollView.contentSize.height - _seatsScrollView.frame.size.height;
            
            float xOffset = xFrame-defaultFrame.size.width/2;
            float yOffset = yFrame-(defaultFrame.size.height-kScaleViewMaginTop)/2;
            
            //左上角
            if (xOffset<=0 && yOffset<=0)
            {
                xOffset = 0;
                yOffset = 0;
            }
            //左下角
            if (xOffset<=0 && yOffset>=0)
            {
                if (fabsf(yOffset) > fabsf(yMax))
                {
                    yOffset = yMax;
                }
                xOffset = 0;
            }
            //右上角
            if (xOffset>=0 && yOffset<=0)
            {
                if (fabsf(xOffset) > fabsf(xMax))
                {
                    xOffset = xMax;
                }
                yOffset = 0;
            }
            //右下角
            if (xOffset>=0 && yOffset>=0)
            {
                if (fabsf(xOffset) > fabsf(xMax))
                {
                    xOffset = xMax;
                }
                if (fabsf(yOffset) > fabsf(yMax))
                {
                    yOffset = yMax;
                }
            }
            
            [_seatsScrollView setContentOffset:CGPointMake(xOffset, yOffset) animated:NO];
            //        }
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end
