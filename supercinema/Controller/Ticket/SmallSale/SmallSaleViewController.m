//
//  SmallSaleViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "SmallSaleViewController.h"

@interface SmallSaleViewController ()

@end

@implementation SmallSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(248, 248, 252, 1);
    self._labelTitle.text = @"卖品";
    [self initCtrl];
    _arrData = [[NSMutableArray alloc]init];
    [self loadGoodsData:self._arrList];
}

#pragma 加载小卖数据
-(void) loadGoodsData:(NSArray*)arrayData
{
    self._arrList = arrayData;
    for (GoodsListModel* model in arrayData)
    {
        SmallSaleModel* saleModel = [[SmallSaleModel alloc]init];
        saleModel._strImageLogo = model.goodsLogoUrl;
        saleModel._strSaleName = model.goodsName;
        saleModel._strSaleType = model.cinemaName;
        saleModel._strSaleDetail = model.goodsDesc;
        saleModel._strEndTime = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:model.validEndTime format:@"YYYY年MM月dd日"]];
        saleModel._count = 0;
        saleModel._maxCount = [model.maxSelectCount intValue];
        saleModel._goodsId = [model.goodsId intValue];
        saleModel._unit = model.unit;
        saleModel.promotionCount = [NSNumber numberWithInteger:[model.promotionCount integerValue]];
        saleModel.couponMethod = [NSNumber numberWithInteger:[model.couponMethod integerValue]];
        saleModel.promotionPrice = [NSNumber numberWithBool:[model.promotionPrice boolValue]];
        saleModel.endTime = model.validEndTime;
        
        //算出价格
        NSArray* arrMemberPrice = model.priceData.memberPriceList;
        float salePrice = 0;
        NSString* cardName;
        for (memberPriceListModel* memberModel in arrMemberPrice)
        {
            if ([self._orderModel.strCardId intValue] == [memberModel.cinemaCardId intValue])
            {
                salePrice = [memberModel.memberPrice intValue] + [memberModel.servicePrice intValue];
                cardName = memberModel.cinemaCardName;
            }
        }
        if (salePrice == 0)
        {
            salePrice = [model.priceData.priceBasic intValue] + [model.priceData.priceService intValue];
        }
        saleModel._price = salePrice;
        if (saleModel._price < [model.priceData.originalPrice floatValue])
        {
            //购买小卖的价格 < 小卖的原价
            saleModel._priceOrigin = [model.priceData.originalPrice floatValue];
        }
        saleModel._strCardName = cardName;
        [_arrData addObject:saleModel];
    }
    [_myTable reloadData];
}

-(void)refreshData
{
    [_arrData removeAllObjects];
    _lablePriceSum.text = [NSString stringWithFormat:@"合计：¥%@元",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:[self._orderModel.strFilmPrice floatValue]]]];
    totalPrice = 0;
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesGoods getGoodsList:[Config getCinemaId] cardId:[self._orderModel.strCardId integerValue] showTimeId:self._showTimeId  array:^(NSArray *array)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [weakSelf loadGoodsData:array];
     } failure:^(NSError *error)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
     }];
}

-(void)initCtrl
{
    _myTable = [[UITableView alloc ] initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.origin.y-self._viewTop.frame.size.height-60) style:UITableViewStylePlain];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    [_myTable setBackgroundColor:[UIColor clearColor]];
    _myTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:_myTable];
    
    UIView* viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    viewFooter.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewFooter];
    
    UIImageView* viewShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-66, SCREEN_WIDTH, 6)];
    viewShadow.image = [UIImage imageNamed:@"img_public_shadow.png"];
    [self.view addSubview:viewShadow];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 40);
    _btnConfirm.backgroundColor = [UIColor blackColor];
    [_btnConfirm setTitle:@"不需要卖品" forState:UIControlStateNormal];
    _btnConfirm.titleLabel.font = MKFONT(15);
    _btnConfirm.layer.masksToBounds = YES;
    _btnConfirm.layer.cornerRadius = 20;
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm addTarget:self action:@selector(onButtonConfirm) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:_btnConfirm];
}

#pragma mark - tableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier= [NSString stringWithFormat:@"SmallSaleTableViewCell%ld",(long)indexPath.row];
    SmallSaleTableViewCell *cell = (SmallSaleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[SmallSaleTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setCellData:_arrData[indexPath.row]];
    [cell setCellFrame];
    cell.saleCellDelegate = self;
    return cell;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_WIDTH == 320)
    {
        if (indexPath.row == _arrData.count-1)
        {
            //最后一个cell
            return 153+15;
        }
        return 153;
    }
    else
    {
        if (indexPath.row == _arrData.count-1)
        {
            //最后一个cell
            return 115+15;
        }
        return 115;
    }
}

#pragma mark - SmallSaleTableViewCellDelegate
-(void)changeValue:(SmallSaleModel *)saleModel isPlus:(BOOL)isPlus
{
    for (SmallSaleModel* model in _arrData)
    {
        if (model == saleModel)
        {
            if (isPlus)
            {
                [MobClick event:mainViewbtn33];
                if (model._count < model._maxCount)
                {
                    model._count += 1;
                    totalPrice = totalPrice + model._price;
                    [_lablePriceSum setText:[NSString stringWithFormat:@"合计 : ¥%@元",[Tool PreserveTowDecimals:[NSNumber numberWithInt:totalPrice]]]];
                    
                    if (model._count >= model._maxCount)
                    {
                        
                    }
                }
                else
                {
                    [Tool showWarningTip:[NSString stringWithFormat:@"选得太多了！最多购买%d件哦～",model._maxCount] time:2.0];
                    return;
                }
            }
            else
            {
                [MobClick event:mainViewbtn34];
                if (model._count>0)
                {
                    model._count -= 1;
                    totalPrice = totalPrice - model._price;
                    [_lablePriceSum setText:[NSString stringWithFormat:@"合计 : ¥%@元",[Tool PreserveTowDecimals:[NSNumber numberWithInt:totalPrice]]]];
                }
            }
            [_myTable reloadData];
        }
    }
    BOOL isNeedSale = NO;
    for (SmallSaleModel* model in _arrData)
    {
        if (model._count>0)
        {
            isNeedSale = YES;
            break;
        }
    }
    [self refreshConfirmText:isNeedSale];
}

-(void)refreshConfirmText:(BOOL)isNeed
{
    if (isNeed)
    {
        //需要卖品
        [_btnConfirm setTitle:@"选好了" forState:UIControlStateNormal];
    }
    else
    {
        [_btnConfirm setTitle:@"不需要卖品" forState:UIControlStateNormal];
    }
}

-(void)onButtonConfirm
{
    if (totalPrice == 0)
    {
        [MobClick event:mainViewbtn35];
    }
    else
    {
        [MobClick event:mainViewbtn36];
    }
    self._orderModel.strAllPrice = [NSString stringWithFormat:@"%.1f",totalPrice];
    
    NSMutableArray* arrayIdAndCount = [[NSMutableArray alloc]init];
    NSMutableArray* arrayGood = [[NSMutableArray alloc]init];
    NSMutableArray* arrayGoods = [[NSMutableArray alloc]init];
    for (SmallSaleModel* model in _arrData)
    {
        if (model._count>0)
        {
            NSString* strIdAndCount = [NSString stringWithFormat:@"%d-%d",model._goodsId,model._count];
            [arrayIdAndCount addObject:strIdAndCount];
            
            [arrayGood addObject:model];
        }
    }
    for (SmallSaleModel* model in arrayGood)
    {
        for (GoodsListModel* glModel in self._arrList)
        {
            if (model._goodsId == [glModel.goodsId intValue])
            {
                [arrayGoods addObject:glModel];
            }
        }
    }
    BuildOrderViewController *buildOrderView = [[BuildOrderViewController alloc ] init];
    buildOrderView._orderModel = self._orderModel;
    buildOrderView.smallSalePrice = totalPrice;
//    buildOrderView.arrSmallSale = _arrData;
    buildOrderView.arrGoodsList = arrayGoods;
    buildOrderView._arrayGoods = arrayIdAndCount;
    buildOrderView._arrGoods = arrayGood;
//    buildOrderView.isHaveSale = YES;
    buildOrderView.smallSaleCount = 0;
//    buildOrderView.arrGoodListModel = self._arrList;
    buildOrderView.priceListModel = self.priceListModel;
    buildOrderView.isFromSale = YES;
    for (SmallSaleModel* model in _arrData)
    {
        buildOrderView.smallSaleCount += model._count;
    }
    [self.navigationController pushViewController:buildOrderView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
