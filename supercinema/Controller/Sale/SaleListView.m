//
//  SaleListView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import "SaleListView.h"

@implementation SaleListView

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation
{
    self = [super initWithFrame:frame];
    self._nav = navigation;
    
    [ParabolaTool sharedTool].delegate = self;
    
    _delayTime = 0;
    
    _detailViewWidth = SCREEN_WIDTH == 320 ? 520/2 : 610/2;
    _detailViewHeight = SCREEN_WIDTH == 320 ? 790/2 : 880/2;
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height) style:UITableViewStylePlain];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    [_myTable setBackgroundColor:[UIColor clearColor]];
    _myTable.separatorColor = [UIColor clearColor];
    [self addSubview:_myTable];
    
    [_myTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    [_myTable.header setTitle:@"" forState:MJRefreshHeaderStateRefreshing];
    
    //去结账
    _btnPay = [SYFireworksButton buttonWithType:UIButtonTypeCustom];
    _btnPay.frame = CGRectMake(15, frame.size.height-27-48-tabbarHeight, 48, 48);
    [_btnPay addTarget:self action:@selector(onButtonPay) forControlEvents:UIControlEventTouchUpInside];
    [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select_not.png"] forState:UIControlStateNormal];
    _btnPay.hidden = YES;
    [self addSubview:_btnPay];
    [self bringSubviewToFront:_btnPay];
    
    _totalCount = 0;
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(refreshData) name:NOTIFITION_REFRESHGOODS object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHGOODS];
}


-(void)removeAllData
{
    _arrSnack = nil;
    [_myTable reloadData];
}

-(void)refreshNewData
{
    [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select_not.png"] forState:UIControlStateNormal];
    _btnPay.imageCount.hidden = YES;
    _totalCount = 0;
    
     __weak SaleListView *weakself = self;
    NSLog(@"sale:refreshNewData");
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesGoods getSnackList:[Config getCinemaId] model:^(SnackModel *model)
     {
         [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
         _myTable.header.hidden = NO;
         _arrSnack = model.goodsList;
         for (SnackListModel* model in _arrSnack)
         {
             model.count = @0;
         }
         if (_arrSnack.count>0)
         {
             _btnPay.hidden =NO;
             [weakself refreshTable];
         }
         else
         {
             [weakself notHaveSale];
         }
         [_myTable.header endRefreshing];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1.0];
         [weakself loadFailed];
         [_myTable.header endRefreshing];
     }];
}

-(void)refreshTable
{
    if (_imageFailure)
    {
        _imageFailure.hidden = YES;
        _labelFailure.hidden = YES;
        _btnTryAgain.hidden = YES;
    }
    if (self.imgDefault)
    {
        self.imgDefault.hidden = YES;
        self.labelDefault.hidden = YES;
    }
    [_myTable reloadData];
}

-(void)refreshData
{
    [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select_not.png"] forState:UIControlStateNormal];
    _btnPay.imageCount.hidden = YES;
    _totalCount = 0;
    [self loadData];
}

-(void)loadData
{
    [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select_not.png"] forState:UIControlStateNormal];
    _btnPay.imageCount.hidden = YES;
    _totalCount = 0;
    
    __weak SaleListView *weakself = self;
    NSLog(@"sale:loadData");
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesGoods getSnackList:[Config getCinemaId] model:^(SnackModel *model)
    {
        [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
        _myTable.header.hidden = NO;
        _arrSnack = model.goodsList;
        for (SnackListModel* model in _arrSnack)
        {
            model.count = @0;
        }
        if (_arrSnack.count>0)
        {
            _btnPay.hidden =NO;
            [weakself refreshTable];
        }
        else
        {
            [weakself notHaveSale];
        }
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:1.0];
        [weakself loadFailed];
    }];
}

#pragma mark 没有小卖
-(void)notHaveSale
{
    //    self.btnPay.hidden = YES;
    
    if (_imageFailure)
    {
        _imageFailure.hidden = YES;
        _labelFailure.hidden = YES;
        _btnTryAgain.hidden = YES;
    }
    
    _arrSnack = nil;
    [_myTable reloadData];
    _myTable.header.hidden = YES;
    _btnPay.hidden = YES;
    
    if (!self.imgDefault)
    {
        self.imgDefault = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-128/2)/2, 209/2, 128/2, 131/2)];
        self.imgDefault.image = [UIImage imageNamed:@"image_NoDataGoods.png"];
        [self addSubview:self.imgDefault];
        
        self.labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imgDefault.frame.origin.y+self.imgDefault.frame.size.height+15, SCREEN_WIDTH, 14)];
        self.labelDefault.text = @"缤纷商品即将推出，常来看看哦!";
        [self.labelDefault setTextColor:RGBA(123, 122, 152, 1)];
        [self.labelDefault setTextAlignment:NSTextAlignmentCenter];
        [self.labelDefault setFont:MKFONT(14)];
        [self addSubview:self.labelDefault];
    }
    else
    {
        self.imgDefault.hidden = NO;
        self.labelDefault.hidden = NO;
    }
}

#pragma mark 加载失败 显示UI
-(void) loadFailed
{
    //加载失败
    _arrSnack = nil;
    [_myTable reloadData];
    _myTable.header.hidden = YES;
    _btnPay.hidden = YES;
    
    if (self.imgDefault)
    {
        self.imgDefault.hidden = YES;
        self.labelDefault.hidden = YES;
    }
    
    if (!_imageFailure)
    {
        _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-73)/2, 103, 73, 67)];
        _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
        [self addSubview:_imageFailure];
        
        _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
        _labelFailure.text = @"加载失败";
        _labelFailure.textColor = RGBA(123, 122, 152, 1);
        _labelFailure.font = MKFONT(14);
        _labelFailure.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelFailure];
        
        _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+25, 146/2, 24);
        [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
        [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnTryAgain.titleLabel.font = MKFONT(14);
        _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
        _btnTryAgain.layer.masksToBounds = YES;
        _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
        [_btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnTryAgain];
    }
    else
    {
        _imageFailure.hidden = NO;
        _labelFailure.hidden = NO;
        _btnTryAgain.hidden = NO;
    }
}

-(void)onButtonTryAgain
{
    [self loadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_arrSnack.count == 1)
    {
        //唯一一个cell
        return 90+15+10+150+10;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return  90+15+5;
        }
        else if (indexPath.row == _arrSnack.count-1)
        {
            return 90+15+150+10;
        }
        else
        {
            return 90+15+10;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrSnack.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier= [NSString stringWithFormat:@"SaleListTableViewCell%ld",(long)indexPath.row];
    SaleListTableViewCell *cell = (SaleListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[SaleListTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    BOOL isLastCell = NO;
    if (_arrSnack.count == 1 || indexPath.row == _arrSnack.count-1)
    {
        isLastCell = YES;
    }
    [cell setCellData:_arrSnack[indexPath.row]];
    [cell setCellFrame:indexPath.row isLast:isLastCell];
    cell.saleCellDelegate = self;
    cell.curIndexPath = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath.row;
    [self showSaleDetail:_arrSnack[indexPath.row] curIndex:indexPath.row];
}

-(void)changeValue:(SnackListModel *)saleModel isPlus:(BOOL)isPlus curIndex:(NSInteger)curIndex
{
    _currentIndex = curIndex;
    for (SnackListModel* model in _arrSnack)
    {
        if (model == saleModel)
        {
            if (isPlus)
            {
                if ([model.count intValue] < [model.maxSelectCount intValue])
                {
                    model.count = [NSNumber numberWithInt:([model.count intValue]+1)];
                }
                else
                {
                    [Tool showWarningTip:[NSString stringWithFormat:@"选得太多了！最多购买%d件哦～",[model.maxSelectCount intValue]] time:2];
                    return;
                }
            }
            else
            {
                if ([model.count intValue]>0)
                {
                    model.count = [NSNumber numberWithInt:([model.count intValue]-1)];
                }
            }
        }
    }
    
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:curIndex inSection:0];
    SaleListTableViewCell *cell = (SaleListTableViewCell*)[_myTable cellForRowAtIndexPath:indexP];
    
    if ([saleModel.count intValue] >= [saleModel.maxSelectCount intValue])
    {
        [cell.btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
    }
    
    if ([saleModel.count intValue]>0 && [saleModel.count intValue] != 1)
    {
        cell.labelCount.text = [NSString stringWithFormat:@"%d",[saleModel.count intValue]];
        cell.btnMinus.hidden = NO;
        [cell.btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_sale_minus.png"] forState:UIControlStateNormal];
    }
    else if([saleModel.count intValue] == 1)
    {
        [cell.btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_sale_minus.png"] forState:UIControlStateNormal];
        cell.btnMinus.hidden = NO;
        cell.labelCount.text = [NSString stringWithFormat:@"%d",[saleModel.count intValue]];
        if (isPlus)
        {
            cell.btnMinus.transform = CGAffineTransformIdentity;
            cell.btnMinus.frame = cell.btnPlus.frame;
            [cell.backView bringSubviewToFront:cell.btnPlus];
            
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
                    cell.btnMinus.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    cell.btnMinus.frame = CGRectMake(cell.btnPlus.frame.origin.x-30-11.5, cell.btnPlus.frame.origin.y, 30, 30);
                }];

                [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1 / 2.0 animations: ^{
                    cell.btnMinus.transform = CGAffineTransformMakeRotation(M_PI);
                    cell.btnMinus.frame = CGRectMake(cell.btnPlus.frame.origin.x-30-23, cell.btnPlus.frame.origin.y, 30, 30);
                }];
            } completion:nil];
        }
    }
    else
    {
        cell.labelCount.text = @"";
        if (!isPlus)
        {
            cell.btnMinus.transform = CGAffineTransformIdentity;
            [cell.backView bringSubviewToFront:cell.btnPlus];
            [UIView animateWithDuration:0.3 animations:^{
                cell.btnMinus.transform = CGAffineTransformMakeRotation(M_PI);
                cell.btnMinus.frame = cell.btnPlus.frame;
            } completion:^(BOOL finished) {
                cell.btnMinus.hidden = YES;
                cell.btnMinus.frame = CGRectMake(cell.btnPlus.frame.origin.x-30-23, cell.btnPlus.frame.origin.y, 23, 23);
            }];
        }
        else
        {
            cell.btnMinus.hidden = YES;
        }
    }
    
    if (isPlus)
    {
        [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select.png"] forState:UIControlStateNormal];
        _btnPay.imageCount.hidden = NO;
        _totalCount += 1;
        _btnPay.labelTotalCount.text = [NSString stringWithFormat:@"%d",_totalCount];
        
        [self performSelector:@selector(addCount) withObject:nil afterDelay:_delayTime];
    }
    else
    {
        _totalCount -= 1;
        if (_totalCount == 0)
        {
            _btnPay.imageCount.hidden = YES;
            [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select_not.png"] forState:UIControlStateNormal];
        }
        else
        {
            _btnPay.imageCount.hidden = NO;
            _btnPay.labelTotalCount.text = [NSString stringWithFormat:@"%d",_totalCount];
            [_btnPay setBackgroundImage:[UIImage imageNamed:@"img_sale_select.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)addCount
{
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    SaleListTableViewCell *cell = (SaleListTableViewCell*)[_myTable cellForRowAtIndexPath:indexP];
    [self addToShoppingCar:[cell convertRect:cell.btnPlus.frame toView:self]];
    
    _delayTime = 0;
}

#pragma mark - 加入购物车动画
/**
 *  抛物线小红点
 *
 *  @return
 */
- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _redView;
}

-(void)addToShoppingCar:(CGRect)rect
{
    CGRect parentRectA = CGRectMake(rect.origin.x+(rect.size.width-12)/2, rect.origin.y+(rect.size.height-12)/2, 12, 12);
    CGRect parentRectB = _btnPay.frame;
    /**
     *  是否执行添加的动画
     */
    self.redView.frame = parentRectA;
    [self.redView setImage:[UIImage imageNamed:@"image_bluePoint.png"]];
    [self addSubview:self.redView];
    
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(parentRectA.origin.x, parentRectA.origin.y)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+25,  parentRectB.origin.y+25) controlPoint:CGPointMake((parentRectB.origin.x -parentRectA.origin.x )/2 +parentRectA.origin.x, parentRectA.origin.y - 200)];
    
    [[ParabolaTool sharedTool] throwObject:self.redView  path:path isRotation:NO endScale:1];
}

/**
 *  抛物线结束的回调
 */
- (void)animationDidFinish
{
    [self.redView removeFromSuperview];
    [_btnPay popOutsideWithDuration:0.5];
}

-(void)showSaleDetail:(SnackListModel *)saleModel curIndex:(NSInteger)curIndex
{
    _currentIndex = curIndex;
    CGRect btnLogoFrame = [self getBtnLogoFrame];
    if (!_viewSaleDetail)
    {
        _viewDetailAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _viewDetailAlpha.backgroundColor = [UIColor blackColor];
        _viewDetailAlpha.alpha = 0;
        
        
        _viewSaleDetail = [[UIView alloc]initWithFrame:CGRectZero];
        _viewSaleDetail.backgroundColor = [UIColor whiteColor];
        _viewSaleDetail.layer.masksToBounds = YES;
        _viewSaleDetail.layer.cornerRadius = 8;
       
        
        UITapGestureRecognizer* alphaGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDetail)];
        [_viewDetailAlpha addGestureRecognizer:alphaGes];
        
        _imageSaleDetail = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageSaleDetail.backgroundColor = [UIColor clearColor];
        [_viewSaleDetail addSubview:_imageSaleDetail];
        
        _imageSaleDetailShadow = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageSaleDetailShadow.image = [UIImage imageNamed:@"image_saleDetail_shadow.png"];
        [_viewSaleDetail addSubview:_imageSaleDetailShadow];
        
        _labelSaleDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _detailViewWidth-30, 0)];
        _labelSaleDetail.font = MKFONT(12);
        _labelSaleDetail.textColor = [UIColor whiteColor];
        _labelSaleDetail.lineBreakMode = NSLineBreakByCharWrapping;
        _labelSaleDetail.numberOfLines = 0;
        [_viewSaleDetail addSubview:_labelSaleDetail];
        
        _labelSaleName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _detailViewWidth-30, 0)];
        _labelSaleName.font = MKFONT(15);
        _labelSaleName.textColor = RGBA(51, 51, 51, 1);
        _labelSaleName.lineBreakMode = NSLineBreakByTruncatingTail;
        _labelSaleName.numberOfLines = 2;
        [_viewSaleDetail addSubview:_labelSaleName];
        
        _labelCardName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCardName.font = MKFONT(12);
        _labelCardName.textColor = RGBA(102, 102, 102, 1);
        [_viewSaleDetail addSubview:_labelCardName];
        
        _labelMemberPrice = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMemberPrice.font = MKFONT(16);
        _labelMemberPrice.textColor = RGBA(249, 81, 81, 1);
        [_viewSaleDetail addSubview:_labelMemberPrice];
        
        _labelOriginPrice = [[LPLabel alloc]initWithFrame:CGRectZero];
        _labelOriginPrice.font = MKFONT(12);
        _labelOriginPrice.textColor = RGBA(180, 180, 180, 1);
        _labelOriginPrice.strikeThroughEnabled = YES;
        [_viewSaleDetail addSubview:_labelOriginPrice];
        
        //加
        _btnSalePlus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSalePlus.frame = CGRectZero;
        [_btnSalePlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
        _btnSalePlus.backgroundColor = [UIColor clearColor];
        _btnSalePlus.tag = 0;
        [_btnSalePlus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_viewSaleDetail addSubview:_btnSalePlus];
        
        //减
        _btnSaleMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSaleMinus.frame = CGRectZero;
        _btnSaleMinus.tag = 1;
        _btnSaleMinus.backgroundColor = [UIColor clearColor];
        [_btnSaleMinus setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnSaleMinus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_viewSaleDetail addSubview:_btnSaleMinus];
        
        //count
        _labelSaleCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSaleCount.font = MKFONT(15);
        _labelSaleCount.textAlignment = NSTextAlignmentCenter;
        _labelSaleCount.textColor = RGBA(51, 51, 51, 1);
        [_viewSaleDetail addSubview:_labelSaleCount];
    }
    [self setDetailSubviewsOldFrame];
    
    [Tool downloadImage:saleModel.goodsLogoUrl button:nil imageView:_imageSaleDetail defaultImage:@"image_saleDetail_default.png"];
    
    _labelSaleDetail.text = saleModel.goodsDesc;
    [_labelSaleDetail sizeToFit];
    
    _labelSaleName.text = saleModel.goodsName;
    [_labelSaleName sizeToFit];
    
    NSString* cardName = [NSString stringWithFormat:@"%@：",saleModel.priceData.cinemaCardName];
    if (saleModel.priceData.cinemaCardName.length>0)
    {
        //有会员卡名
        _labelCardName.text = cardName;
    }
    else
    {
        //没有会员卡名
        _labelCardName.text = @"普通会员价：";
    }
    [_labelCardName sizeToFit];
    
    SnackPriceDataModel* priceModel = saleModel.priceData;
    float originPrice = [priceModel.originalPrice floatValue];
    float memberPrice = [priceModel.priceBasic floatValue] + [priceModel.priceService floatValue];
    _labelMemberPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:memberPrice]]];
    
    if (originPrice > 0 && originPrice > memberPrice)
    {
        _labelOriginPrice.text = [NSString stringWithFormat:@"原价：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:originPrice]]];
    }
    else
    {
        _labelOriginPrice.text = @"";
    }
    
    if ([saleModel.count intValue] >= [saleModel.maxSelectCount intValue])
    {
        [_btnSalePlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnSalePlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
    }
    if ([saleModel.count intValue]>0)
    {
        _labelSaleCount.text = [NSString stringWithFormat:@"%d",[saleModel.count intValue]];
        _btnSaleMinus.hidden = NO;
        [_btnSaleMinus setBackgroundImage:[UIImage imageNamed:@"btn_sale_minus.png"] forState:UIControlStateNormal];
    }
    else
    {
        _labelSaleCount.text = @"";
        _btnSaleMinus.hidden = YES;
    }
    
    _viewDetailAlpha.alpha = 0.5;
    _viewSaleDetail.frame = CGRectMake(btnLogoFrame.origin.x+75/2, btnLogoFrame.origin.y+75/2, 0, 0);
    _imageSaleDetail.frame = CGRectZero;
    _viewSaleDetail.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        _imageSaleDetail.frame = CGRectMake(0, 0, _detailViewWidth, _detailViewWidth);
        _viewSaleDetail.frame = CGRectMake((SCREEN_WIDTH - _detailViewWidth)/2, (SCREEN_HEIGHT-_detailViewHeight)/2, _detailViewWidth, _detailViewHeight);
        [self.window addSubview:_viewDetailAlpha];
        [self.window addSubview:_viewSaleDetail];
    } completion:^(BOOL finished) {
        [self setDetailSubviewsNewFrame];
    }];
}

-(void)setDetailSubviewsOldFrame
{
    _labelSaleDetail.hidden = YES;
    _labelSaleName.hidden = YES;
    _labelCardName.hidden = YES;
    
    _imageSaleDetailShadow.frame = CGRectZero;
    _labelSaleDetail.frame = CGRectMake(15, 0, _detailViewWidth-30, 0);
    _labelSaleName.frame = CGRectMake(15, 0, _detailViewWidth-30, 0);
    _labelCardName.frame = CGRectZero;
    _labelMemberPrice.frame = CGRectZero;
    _labelOriginPrice.frame = CGRectZero;
    _btnSalePlus.frame = CGRectZero;
    _labelSaleCount.frame = CGRectZero;
    _btnSaleMinus.frame = CGRectZero;
}

-(void)setDetailSubviewsNewFrame
{
    _labelSaleDetail.hidden = NO;
    _labelSaleName.hidden = NO;
    _labelCardName.hidden = NO;
    
    _imageSaleDetailShadow.frame = CGRectMake(0,_detailViewWidth-278/2, _detailViewWidth, 278/2);
    _labelSaleDetail.frame = CGRectMake(15, _imageSaleDetailShadow.frame.size.height-_labelSaleDetail.frame.size.height-10, _detailViewWidth-30, _labelSaleDetail.frame.size.height);
    _labelSaleName.frame = CGRectMake(15, _detailViewWidth+10, _detailViewWidth-30, _labelSaleName.frame.size.height);
    _labelSaleDetail.frame = CGRectMake(15, _detailViewWidth-_labelSaleDetail.frame.size.height-10, _detailViewWidth-30, _labelSaleDetail.frame.size.height);
    _labelSaleName.frame = CGRectMake(15, _detailViewWidth+10, _detailViewWidth-30, _labelSaleName.frame.size.height);
    if (_labelCardName.text.length>0)
    {
        _labelCardName.frame = CGRectMake(15, _labelSaleName.frame.origin.y+_labelSaleName.frame.size.height+15+4, _labelCardName.frame.size.width, 12);
    }
    _labelMemberPrice.frame = CGRectMake(_labelCardName.frame.origin.x+_labelCardName.frame.size.width, _labelSaleName.frame.origin.y+_labelSaleName.frame.size.height+15, 150, 16);
    _labelOriginPrice.frame = CGRectMake(15, _labelMemberPrice.frame.origin.y+_labelMemberPrice.frame.size.height+12, 200, 12);
    _btnSalePlus.frame = CGRectMake(_detailViewWidth-15-30, _detailViewHeight-15-30, 30, 30);
    _labelSaleCount.frame = CGRectMake(_btnSalePlus.frame.origin.x-23, _btnSalePlus.frame.origin.y+7.5, 23, 15);
    _btnSaleMinus.frame = CGRectMake(_btnSalePlus.frame.origin.x-30-23, _btnSalePlus.frame.origin.y, 30, 30);
}

-(void)onButtonCount:(UIButton*)btn
{
    _delayTime = 0.1;
    
    SnackListModel* sModel = _arrSnack[_currentIndex];
    BOOL isPlus = btn.tag == 0 ? YES : NO;
    [self changeValue:sModel isPlus:isPlus curIndex:_currentIndex];
    
    if ([sModel.count intValue] >= [sModel.maxSelectCount intValue])
    {
        [_btnSalePlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnSalePlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
    }
    
    if ([sModel.count intValue] > 0)
    {
        _labelSaleCount.text = [NSString stringWithFormat:@"%d",[sModel.count intValue]];
        [_btnSaleMinus setBackgroundImage:[UIImage imageNamed:@"btn_sale_minus.png"] forState:UIControlStateNormal];
        _btnSaleMinus.hidden = NO;
    }
    else
    {
        _labelSaleCount.text = @"";
        if (!isPlus)
        {
            [self minusBtnAnimation];
        }
        else
        {
            _btnSaleMinus.hidden = YES;
        }
    }
    if (isPlus)
    {
        [self closeDetail];
    }
}

-(void)minusBtnAnimation
{
    _btnSaleMinus.transform = CGAffineTransformIdentity;
    [_viewSaleDetail bringSubviewToFront:_btnSalePlus];
    [UIView animateWithDuration:0.3 animations:^{
        _btnSaleMinus.transform = CGAffineTransformMakeRotation(M_PI);
        _btnSaleMinus.frame = _btnSalePlus.frame;
    } completion:^(BOOL finished) {
        _btnSaleMinus.hidden = YES;
        _btnSaleMinus.frame = CGRectMake(_btnSalePlus.frame.origin.x-30-23, _btnSalePlus.frame.origin.y, 30, 30);
    }];
}

-(CGRect)getBtnLogoFrame
{
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    SaleListTableViewCell *cell = (SaleListTableViewCell*)[_myTable cellForRowAtIndexPath:indexP];
    return [cell convertRect:cell.btnLogo.frame toView:self.window];
}

-(void)closeDetail
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewDetailAlpha.alpha = 0;
        _viewSaleDetail.alpha = 0;
        [_viewDetailAlpha removeFromSuperview];
        [_viewSaleDetail removeFromSuperview];
    }];
}

-(void)onButtonPay
{
    if (_totalCount == 0)
    {
        [Tool showWarningTip:@"亲，先去挑个卖品吧~" time:2];
        return;
    }
    if( ![Config getLoginState] )
    {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        loginViewController._strTopViewName = @"SaleListView";
        __weak SaleListView *weakself = self;
        [loginViewController setRefreshSalePriceBlock:^{
            [FVCustomAlertView showDefaultLoadingAlertOnView:weakself.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
            [ServicesGoods getSnackList:[Config getCinemaId] model:^(SnackModel *model)
             {
                 [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
                 //登录之后刷新小卖价格
                 [weakself pushToOrder:model.goodsList];
                 
             } failure:^(NSError *error) {
                 [Tool showWarningTip:error.domain time:1.0];
                 [weakself loadFailed];
             }];
        }];
        [self._nav pushViewController:loginViewController animated:YES];
        return;
    }
    
    [self pushToOrder:_arrSnack];
}

-(void)pushToOrder:(NSArray*)arrPrice
{
    [MobClick event:mainViewbtn95];
    __block NSMutableArray* arrayIdAndCount = [[NSMutableArray alloc]init];
    __block NSMutableArray* arrayGood = [[NSMutableArray alloc]init];
    __block NSString* strCard;
    __block int cardId = 0;
    __block float goodsTotalPrice;
    for (SnackListModel* model in _arrSnack)
    {
        strCard = model.priceData.cinemaCardName;
        cardId = [model.priceData.cinemaCardId intValue];
        if ([model.count intValue]>0)
        {
            NSString* strIdAndCount = [NSString stringWithFormat:@"%d-%d",[model.goodsId intValue],[model.count intValue]];
            [arrayIdAndCount addObject:strIdAndCount];
            
            [arrayGood addObject:model];
        }
    }
    goodsTotalPrice = [self calTotalPrice:arrPrice];
    
    //判断库存
    __weak SaleListView *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesGoods getGoodsListRemainCount:[Config getCinemaId] goodsIdAndCountList:arrayIdAndCount model:^(NSArray *array) {
        [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
        for (SnackRemainCountModel* remainModel in array)
        {
            if ([remainModel.count integerValue] == 0)
            {
                //该商品没有库存
                [Tool showWarningTip:@"部分商品库存不足，请重新选择商品" time:2.0];
                [weakself refreshData];
                return;
            }
        }
        SaleOrderViewController* orderViewController = [[SaleOrderViewController alloc]init];
        orderViewController.totalPrice = goodsTotalPrice;
        orderViewController._arrGoods = arrayGood;
        orderViewController._arrayGoods = arrayIdAndCount;
        orderViewController._strCardName = strCard;
        orderViewController.cardId = cardId;
        [weakself._nav pushViewController:orderViewController animated:YES];
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:2.0];
        if (!(error.code == -1001 || error.code == 20000))
        {
            [weakself performSelector:@selector(refreshData) withObject:nil afterDelay:2.0];
        }
    }];
}

-(float)calTotalPrice:(NSArray*)arr
{
    float totalPrice = 0;
    for (SnackListModel* model in _arrSnack)
    {
        if ([model.count intValue] > 0)
        {
            for (SnackListModel* sModel in arr)
            {
                if ([model.goodsId intValue] == [sModel.goodsId intValue])
                {
                    float memberPrice = [sModel.priceData.priceBasic floatValue] + [sModel.priceData.priceService floatValue];
                    totalPrice += memberPrice * [model.count intValue];
                }
            }
        }
    }
    return totalPrice;
}

#pragma mark scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0)
    {
        if (self._lastScrollContentOffset < scrollView.contentOffset.y)
        {
            //                            NSLog(@"up:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            //scroll向上滚动
            if (!self._isScrollTop)
            {
                if (scrollView.contentOffset.y >= 30)
                {
                    if (!self._isScrollTop)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEUP object:nil];
                        //[self refreshFrameUp];
                    }
                }
                else if(scrollView.contentOffset.y < 30)
                {
                    self._lastScrollContentOffset = scrollView.contentOffset.y;
                }
                else
                {
                    self._lastScrollContentOffset = 30;
                }
            }
        }
        else if (self._lastScrollContentOffset > scrollView.contentOffset.y)
        {
            //scroll向下滚动
            //                            NSLog(@"down:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            if (self._isScrollTop)
            {
                //滑到顶
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEDOWN object:nil];
                //                [self refreshFrameDown];
            }
            self._lastScrollContentOffset = scrollView.contentOffset.y;
        }
    }
    else if (scrollView.contentOffset.y<0)
    {
        //scroll向下滚动
        if (self._isScrollTop)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEDOWN object:nil];
        }
        self._lastScrollContentOffset = scrollView.contentOffset.y;
    }
}

@end
