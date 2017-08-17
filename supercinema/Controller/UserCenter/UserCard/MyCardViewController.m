//
//  MyCardViewController.m
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import "MyCardViewController.h"

@interface MyCardViewController ()

@end

@implementation MyCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cardAndCouponCountModel = [[CardAndCouponCountModel alloc] init];
    [self initController];
    [self loadOrderDetail];
    
    if( [Config getLoginState])
    {
        [MkPullMessage showPushMessage:self.navigationController triggerType:OPEN_CARDPACK apnsModel:nil typeTime:@"myCradPackTime"];
    }
    
}

-(void)initController
{
    //顶部View（64高）
    [self._labelTitle setText:@"我的卡包"];
    
    _tabMyCardList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tabMyCardList.delegate = self;
    _tabMyCardList.dataSource = self;
    [_tabMyCardList setBackgroundColor:RGBA(246, 246, 251, 1)];
    [_tabMyCardList setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tabMyCardList];
}

#pragma mark - 加载信息
-(void)loadOrderDetail
{
    __weak MyCardViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCardPack getMemberAndCouponSum:^(CardAndCouponCountModel *model)
    {
        _cardAndCouponCountModel = model;
        [_tabMyCardList reloadData];
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
    }];
}

#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10+97;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCardTableViewCell";
    MyCardTableViewCell *myCardCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (myCardCell == nil)
    {
        myCardCell = [[MyCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        myCardCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [myCardCell setCardAndCouponFrameData:_cardAndCouponCountModel indexPath:indexPath.row];
  
    return myCardCell;
}

//Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
//    MyCardTableViewCell *myCardCell = (MyCardTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    __weak typeof (self) weakSelf = self;
    
    if (indexPath.row == 0)
    {
        //会员卡
        [MobClick event:myCenterViewbtn30];
        [weakSelf showMembershipCardListDetails];
//        [weakSelf bounceAwardView];
    }
    else
    {
        //优惠券
        [MobClick event:myCenterViewbtn38];
        [weakSelf showCouponListDetails];
    }
}

/****弹起奖励页****/
-(void)bounceAwardView
{
    AwardView *awardView = [[AwardView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) arr:nil shareRedpackFee:nil];
    awardView.hidden=YES;
    awardView.alpha=0;
    awardView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [self.view addSubview:awardView];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         awardView.transform = CGAffineTransformMakeScale(1, 1);
                         awardView.hidden=NO;
                         awardView.alpha=1;
                         
                     }completion:^(BOOL finish){
                         
                     }];
}

//优惠券
-(void)showCouponListDetails
{
    CouponInfoViewController *couponInfoController = [[CouponInfoViewController alloc]init];
    [self.navigationController pushViewController:couponInfoController animated:YES];
}

//会员卡
-(void)showMembershipCardListDetails
{
    MemberBenefitsInfoViewController *memberBenefitsInfoController = [[MemberBenefitsInfoViewController alloc]init];
    [self.navigationController pushViewController:memberBenefitsInfoController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
