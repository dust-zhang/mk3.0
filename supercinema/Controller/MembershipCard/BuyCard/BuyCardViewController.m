//
//  BuyCardViewController.m
//  supercinema
//
//  Created by mapollo91 on 8/11/16.
//
//

#import "BuyCardViewController.h"

@interface BuyCardViewController ()
//@property(nonatomic, strong)CardListModel  *_cardList;
@end

@implementation BuyCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isHavePreferential = NO;
    btnTag = 300;
//    [self initCtrl];
    
    
    if (self._cardListModel.cinemaCardItemList == nil)
    {
        [self getCinemaUserCardList];
    }
    else
    {
        [self initControllerData];
    }
}

-(void)initControllerData
{
    NSMutableArray *arrCardItemIds = [[NSMutableArray alloc]init];
     for (int i = 0; i < self._cardListModel.cinemaCardItemList.count ; i++)
     {
         MemberCardDetailModel *memberCardDetailModel = self._cardListModel.cinemaCardItemList[i];
         [arrCardItemIds addObject:memberCardDetailModel.id];
     }
    
    //获取会员卡Item的优惠信息
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMember getMemberCardFavorableInfo:[self._cinema.cinemaId stringValue] cardItemIds:arrCardItemIds array:^(NSArray *array)
     {
         NSLog(@"%@",array);
         
         if (array != nil && array.count >0)
         {
             for (int i = 0; i< array.count; i++)
             {
                 MemberCardFavorableInfoModel *memberCardFavorableInfoModel = array[i];
                 
                 if ([memberCardFavorableInfoModel.couponMethod intValue] > 0)
                 {
                     _isHavePreferential = YES;
                     break;
                 }
             }
         }
         [weakSelf initCtrl];
         
         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
     } failure:^(NSError *error) {
         [weakSelf initCtrl];
         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
     }];
    

}

-(void)getCinemaUserCardList
{
    //获取用户在影院中的会员信息
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMember getCinemaUserCardList:[self._cinema.cinemaId stringValue] model:^(MemberModel *memberModel)
     {
         NSLog(@"%@",[memberModel toJSONString]);

         NSArray * cardList = memberModel.cinemaCardList;
         if(cardList != nil && cardList.count >0)
         {
             for(CardListModel *card in cardList)
             {
                 if(card.cinemaCardId.longValue == weakSelf.cinemaCardId.longValue)
                 {
                     NSMutableArray *arrCardItemIds = [[NSMutableArray alloc]init];
                     for (int i = 0; i < card.cinemaCardItemList.count ; i++)
                     {
                         MemberCardDetailModel *memberCardDetailModel = card.cinemaCardItemList[i];
                         [arrCardItemIds addObject:memberCardDetailModel.id];
                     }
                     weakSelf._cardListModel = card;
                     [weakSelf initControllerData];
//                     [weakSelf getHavePreferential:arrCardItemIds];
                     break;
                 }
             }
         }
        
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
     }];
}

//-(void)getHavePreferential:(NSMutableArray *)arrCardItemIds
//{
//    //获取会员卡Item的优惠信息
//    [ServicesMember getMemberCardFavorableInfo:[self._cinema.cinemaId stringValue] cardItemIds:arrCardItemIds array:^(NSArray *array)
//     {
//         NSLog(@"%@",array);
//         
//         if (array != nil && array.count >0)
//         {
//             for (int i = 0; i< array.count; i++)
//             {
//                 MemberCardFavorableInfoModel *memberCardFavorableInfoModel = array[i];
//                 
//                 if ([memberCardFavorableInfoModel.couponMethod intValue] > 0)
//                 {
//                     _isHavePreferential = YES;
//                     break;
//                 }
//             }
//         }
//         
//         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
//     } failure:^(NSError *error) {
//         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
//     }];
//}

-(void)initCtrl
{
    [MobClick event:mainViewbtn70];
    
    //顶部View
    [self._labelTitle setText:self._cinema.cinemaName];
    
//    [self.view setBackgroundColor:RGBA(246, 246, 251, 1)];
    
    //整体的ScrollView
    _scrollViewBuyCard = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_scrollViewBuyCard setBackgroundColor:RGBA(246, 246, 251, 1)];
    _scrollViewBuyCard.delegate = self;
    [self.view addSubview:_scrollViewBuyCard];
    
    //提示语
    UILabel *labelRuleDescribe = [[UILabel alloc] initWithFrame:CGRectZero];
    [labelRuleDescribe setBackgroundColor:[UIColor clearColor]];
    [labelRuleDescribe setFont:MKFONT(12)];
    [labelRuleDescribe setTextColor:RGBA(123, 122, 152, 0.6)];
    [labelRuleDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelRuleDescribe setText:@"请认真核对，一旦售出不支持退款"];
    [_scrollViewBuyCard addSubview:labelRuleDescribe];
    //提示语
    labelRuleDescribe.frame = CGRectMake(0, 20, SCREEN_WIDTH, 12);
    
    //=================卡基本信息View=================
    _viewBasicInformation = [[UIImageView alloc] initWithFrame:CGRectMake(15, labelRuleDescribe.frame.origin.y+labelRuleDescribe.frame.size.height+10, SCREEN_WIDTH-15*2, 100)];
    _viewBasicInformation.backgroundColor = [UIColor clearColor];
    _viewBasicInformation.userInteractionEnabled = YES;
    [_scrollViewBuyCard addSubview:_viewBasicInformation];
    
    _viewBasicInformationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewBasicInformation.frame.size.width, 10)];
    _viewBasicInformationLine.backgroundColor = [UIColor clearColor];
    _viewBasicInformationLine.userInteractionEnabled = YES;
    [_viewBasicInformation addSubview:_viewBasicInformationLine];
    
    //卡图标
    _imageCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 27, 27)];
    [_imageCardIcon setBackgroundColor:[UIColor clearColor]];
    [_viewBasicInformation addSubview:_imageCardIcon];
    /**
     *  卡类型   普通:-1
     *          常规:0
     *          次卡:1
     *          套票:2
     *          任看:3
     *          通票:4
     */
    if (
        [self._cardListModel.cardType intValue] == -1  ||
        [self._cardListModel.cardType intValue] == 0   ||
        [self._cardListModel.cardType intValue] == 1   )
    {
        //卡类型Logo
        [_imageCardIcon setImage:[UIImage imageNamed:@"image_membershipCard_white.png"]];
        [_viewBasicInformation setImage:[UIImage imageNamed:@"image_buyCardBG.png"]];
        [_viewBasicInformationLine setImage:[UIImage imageNamed:@"image_buyCardBGLine.png"]];
//        [_viewBasicInformation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_buyCardBG.png"]]];
    }
    else
    {
        //票类型Logo
        [_imageCardIcon setImage:[UIImage imageNamed:@"image_ticketType_white.png"]];
        [_viewBasicInformation setImage:[UIImage imageNamed:@"image_buyTicketTypeBG.png"]];
        [_viewBasicInformationLine setImage:[UIImage imageNamed:@"image_buyTicketTypeBGLine.png"]];
//        [_viewBasicInformation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_buyTicketTypeBG.png"]]];
    }
    
    //卡名字
    _labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(_imageCardIcon.frame.origin.x+_imageCardIcon.frame.size.width+12, 15.5, _viewBasicInformation.frame.size.width-15-_imageCardIcon.frame.size.width-12-15, 17)];
    [_labelCardName setBackgroundColor:[UIColor clearColor]];
    [_labelCardName setFont:MKFONT(17)];
    [_labelCardName setTextColor:RGBA(255, 255, 255, 1)];
    [_labelCardName setTextAlignment:NSTextAlignmentLeft];
    [_labelCardName setText:self._cardListModel.cinemaCardName];
    [_viewBasicInformation addSubview:_labelCardName];

    //分割线(实线)
    _labelEntityLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+15.5, _viewBasicInformation.frame.size.width, 0.5)];
    _labelEntityLine.backgroundColor = RGBA(255, 255, 255, 0.2);
    [_viewBasicInformation addSubview:_labelEntityLine];
    
    //卡描述（自适应）
    _labelCardDescribe = [[UILabel alloc] initWithFrame:CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewBasicInformation.frame.size.width-20*2, 12)];
    [_labelCardDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelCardDescribe setFont:MKFONT(12)];
    [_labelCardDescribe setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelCardDescribe.numberOfLines = 0;
    _labelCardDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    _labelCardDescribe.contentMode = UIViewContentModeTop;
    [_viewBasicInformation addSubview:_labelCardDescribe];

    //卡描述后几行
    _labelLeftDescribe = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _viewBasicInformation.frame.size.width-20*2, 100)];
    [_labelLeftDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelLeftDescribe setFont:MKFONT(12)];
    [_labelLeftDescribe setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelLeftDescribe.numberOfLines = 0;
    _labelLeftDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    _labelLeftDescribe.contentMode = UIViewContentModeTop;
    _labelLeftDescribe.alpha = 0;
    [_viewBasicInformation addSubview:_labelLeftDescribe];
    
    //省略号
    _labelPoints = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelPoints setBackgroundColor:[UIColor clearColor]];
    [_labelPoints setFont:MKFONT(12)];
    [_labelPoints setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelPoints.text = @"...";
    _labelPoints.contentMode = UIViewContentModeTop;
    _labelPoints.alpha = 0;
    [_viewBasicInformation addSubview:_labelPoints];
    
//    self._cardListModel.cardDesc = @"111我的字数很多很多很多我的字数很多很多很多我的字数很多很多很多我的字数很多很多很多我的字数很多很多很多很多很多很多很多很多多很多多很多多很多多很多多很多多很多多很多多很多的字数很多很多很多我的字数很多很多很多我的字数很的字数很多很多很多我的字数很多很多很多我的字数很的字数很多很多很多我的字数很多很多很多我的字数很";
    
    NSArray* arrDescribe = [self getSeparatedLinesFromLabel];
    
    if (arrDescribe.count>5)
    {
        //大于5行,_labelCardDescribe.text显示前两行，省略号显示，_labelLeftDescribe.text显示后几行
        _labelPoints.alpha = 1;
        
        _labelCardDescribe.numberOfLines = 2;
        NSString* strFront = @"";
        NSString* strLeft = @"";
        for (int i = 0; i<arrDescribe.count; i++)
        {
            if (i<2)
            {
                NSString* strDes = arrDescribe[i];
                strFront = [strFront stringByAppendingString:strDes];
            }
            else
            {
                NSString* strDes = arrDescribe[i];
                strLeft = [strLeft stringByAppendingString:strDes];
            }
        }
        _labelCardDescribe.text = strFront;
        _labelLeftDescribe.text = strLeft;
        
        [Tool setLabelSpacing:_labelCardDescribe spacing:2 alignment:NSTextAlignmentLeft];
        [Tool setLabelSpacing:_labelLeftDescribe spacing:2 alignment:NSTextAlignmentLeft];
        _labelPoints.frame = CGRectMake(20, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+9, 100, 12);
        _labelLeftDescribe.frame = CGRectMake(20, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+9, _labelLeftDescribe.frame.size.width, _labelLeftDescribe.frame.size.height);
        
        _fOriginallyHeight = _labelCardDescribe.frame.size.height + _labelLeftDescribe.frame.size.height + 9;
    }
    else
    {
        //小于等于5行，_labelCardDescribe.text= self._cardListModel.cardDesc
        _labelCardDescribe.numberOfLines = 0;
        _labelCardDescribe.text= self._cardListModel.cardDesc;
        [Tool setLabelSpacing:_labelCardDescribe spacing:2 alignment:NSTextAlignmentLeft];
        _fOriginallyHeight = _labelCardDescribe.frame.size.height;
    }
    
    //展开按钮
    _btnUnfold = [[UIButton alloc] initWithFrame:CGRectMake(_viewBasicInformation.frame.size.width-20-20, 12.5, 20, 20)];
    [_btnUnfold setImage:[UIImage imageNamed:@"btn_unfoldDetial.png"] forState:UIControlStateNormal];
    [_btnUnfold.layer setMasksToBounds:YES];
    [_btnUnfold.layer setCornerRadius:_btnUnfold.frame.size.height/2];
    [_btnUnfold setBackgroundColor:RGBA(255, 255, 255, 0.1)];
    [_btnUnfold setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnUnfold.titleLabel setFont:[UIFont systemFontOfSize:12] ];
//    [_btnUnfold addTarget:self action:@selector(onButtonUnfold:) forControlEvents:UIControlEventTouchUpInside];
    _btnUnfold.tag = 100;
    
    //显示展开的逻辑(商品说明最多显示5行,说明内容大于5行，显示前2行，并在第3行显示“...”省略号)
    //卡权益描述的高度
    
    if (arrDescribe.count<=5)
    {
        _btnUnfold.hidden = YES;
        fCardDescribeHeight = _labelCardDescribe.frame.size.height;
    }
    else
    {
        //添加手势 - 点击事件
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClick:)];
        [click setNumberOfTapsRequired:1];//点击一次
        click.cancelsTouchesInView = NO;//设置可点击
        [_viewBasicInformation addGestureRecognizer:click];
        
        _btnUnfold.hidden = NO;
        _labelCardDescribe.lineBreakMode = NSLineBreakByCharWrapping;
        fCardDescribeHeight = 47;
    }
    _labelCardDescribe.frame = CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewBasicInformation.frame.size.width-20*2, fCardDescribeHeight);
    
    [_viewBasicInformation addSubview:_btnUnfold];
    
    //影院限制
    _labelCinemaLimit= [[UILabel alloc] initWithFrame:CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+27, _labelCardDescribe.frame.size.width, 10)];
    [_labelCinemaLimit setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaLimit setFont:MKFONT(10)];
    [_labelCinemaLimit setTextColor:RGBA(255, 255, 255, 1)];
    _labelCinemaLimit.numberOfLines = 0;
    _labelCinemaLimit.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewBasicInformation addSubview:_labelCinemaLimit];

    [_labelCinemaLimit setText:[NSString stringWithFormat:@"仅限 %@ 使用",self._cinema.cinemaName]];
    [Tool setLabelSpacing:_labelCinemaLimit spacing:2 alignment:NSTextAlignmentLeft];
    _labelCinemaLimit.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+27, _labelCardDescribe.frame.size.width, _labelCinemaLimit.frame.size.height);
    
    //=================重新计算卡基本信息View背景高度=================
    [self reloadWholeBGUI];
    
    
    //=================整体买卡的背景=================
    _viewBuyCardBG = [[UIView alloc] initWithFrame:CGRectMake(15, _viewBasicInformation.frame.origin.y+_viewBasicInformation.frame.size.height, SCREEN_WIDTH-15*2, 100)];
    _viewBuyCardBG.backgroundColor = RGBA(255, 255, 255, 1);
    [_scrollViewBuyCard addSubview:_viewBuyCardBG];

    NSArray *arrBtn = self._cardListModel.cinemaCardItemList;
    CGFloat height  = 30;
    for (int i = 0 ; i <[arrBtn count] ; i++)
    {
        MemberCardDetailModel *memberCardDetailModel = arrBtn[i];
        
        UIView *view;
        
        if ([self._cardListModel.cardType intValue] == 2)
        {
            view = [self generateTPCView:memberCardDetailModel isHavePreferential:_isHavePreferential index:i];
        }
        else
        {
            view = [self generateOtherCardView:memberCardDetailModel isHavePreferential:_isHavePreferential index:i];
        }
        view.frame = CGRectMake(0, height, view.frame.size.width, view.frame.size.height);
        view.backgroundColor = [UIColor clearColor];
        height = height + view.frame.size.height;
        [_viewBuyCardBG addSubview:view];
    }
    _fBuyCardBGHeight = height;
    _viewBuyCardBG.frame = CGRectMake(15, _viewBasicInformation.frame.origin.y+_viewBasicInformation.frame.size.height, SCREEN_WIDTH-15*2, _fBuyCardBGHeight);

//    _scrollViewBuyCard.contentSize = CGSizeMake(_scrollViewBuyCard.frame.size.width, _viewBuyCardBG.frame.origin.y+_viewBuyCardBG.frame.size.height+100);
    
    //分割线（锯齿线）
    _imageLine =[[UIImageView alloc ] initWithFrame:CGRectMake(15, _viewBuyCardBG.frame.origin.y+_viewBuyCardBG.frame.size.height, SCREEN_WIDTH-15*2, 5)];
    _imageLine.backgroundColor = [UIColor clearColor];
    [_imageLine setImage:[UIImage imageNamed:@"image_sawtoothLine.png"]];
    [_scrollViewBuyCard addSubview:_imageLine];
    
    //=================整体开通按钮背景=================
    _viewBuyCardButtonBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-58, SCREEN_WIDTH, 58)];
    _viewBuyCardButtonBG.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:_viewBuyCardButtonBG];
    
    //开通按钮
    _btnBuyCard = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-15*2, 40)];
    [_btnBuyCard setBackgroundColor:RGBA(0, 0, 0, 1)];
    [_btnBuyCard setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnBuyCard .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnBuyCard.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnBuyCard setTitle:@"开通" forState:UIControlStateNormal];
    [_btnBuyCard addTarget:self action:@selector(onButtonBuyCard:) forControlEvents:UIControlEventTouchUpInside];
    [_viewBuyCardButtonBG addSubview:_btnBuyCard];
    
    //蒙层
    _imageShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _viewBuyCardButtonBG.frame.origin.y-6, SCREEN_WIDTH, 6)];
    _imageShadow.backgroundColor = [UIColor clearColor];
    _imageShadow.image = [UIImage imageNamed:@"img_shadow.png"];
    [self.view addSubview:_imageShadow];
}

- (NSArray *)getSeparatedLinesFromLabel
{
    NSString *text = self._cardListModel.cardDesc;
    UIFont   *font = MKFONT(12);
    CGRect    rect = CGRectMake(20, 0, _viewBasicInformation.frame.size.width-20*2, 12);
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

#pragma mark 生成套票view
-(UIView *)generateTPCView:(MemberCardDetailModel *)memberCardDetailModel isHavePreferential:(BOOL)isHavePreferential index:(int)i
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    //有效期
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 130, 15)];
    [labelDate setBackgroundColor:[UIColor clearColor]];
    [labelDate setFont:MKFONT(15)];
    [labelDate setTextColor:RGBA(51, 51, 51, 1)];
    [view addSubview:labelDate];
    
    //有效期(自适应)
    if ([memberCardDetailModel.validDayCount intValue] == 0)
    {
        [labelDate setText:@"今日结束"];
    }
    else
    {
        [labelDate setText:[NSString stringWithFormat:@"有效期：%@天",memberCardDetailModel.validDayCount]];
    }
    [Tool setLabelSpacing: labelDate spacing:2 alignment:NSTextAlignmentLeft];
    labelDate.frame = CGRectMake(15, labelDate.frame.origin.y, labelDate.frame.size.width, 15);

    //剩余张数
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(labelDate.frame.origin.x+labelDate.frame.size.width, labelDate.frame.origin.y+2, 130, 12)];
    [labelCount setBackgroundColor:[UIColor clearColor]];
    [labelCount setFont:MKFONT(12)];
    [labelCount setTextColor:RGBA(123, 122, 152, 1)];
    [labelCount setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:labelCount];
    //数量
    [labelCount setText:[NSString stringWithFormat:@"(%@张)",memberCardDetailModel.exchangeTicketCount]];
    
    //数量(自适应)
    [Tool setLabelSpacing:labelCount spacing:2 alignment:NSTextAlignmentLeft];
    labelCount.frame = CGRectMake(labelDate.frame.origin.x+labelDate.frame.size.width, labelDate.frame.origin.y+2, labelCount.frame.size.width, 12);
    

    //权益优惠
    UIImageView *imageCanCheapType = [[UIImageView alloc] initWithFrame:CGRectMake(labelCount.frame.origin.x+labelCount.frame.size.width+15, labelDate.frame.origin.y, 14, 14)];
    [imageCanCheapType setBackgroundColor:RGBA(248, 188, 41, 1)];
    [imageCanCheapType setImage:[UIImage imageNamed:@"image_CheapType.png"]];
    imageCanCheapType.hidden = YES;
    [view addSubview:imageCanCheapType];

    //判断登录状态
    if ( ![Config getLoginState ])
    {
        //没有登录
        imageCanCheapType.hidden = YES;
    }
    else
    {
        //已登录
        imageCanCheapType.hidden = !isHavePreferential;
    }

    //购买按钮
    UIButton *btnBuyCard = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-21-15, labelDate.frame.origin.y-3, 21, 21)];
    if (i == 0)
    {
        [btnBuyCard setBackgroundColor:RGBA(117, 112, 255, 1)];
        [btnBuyCard setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnBuyCard setBackgroundColor:RGBA(241, 240, 255, 1)];
        [btnBuyCard setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    [btnBuyCard.layer setCornerRadius:10.5];//按钮设置圆角
    btnBuyCard.tag = i+300;//给标签
    [btnBuyCard addTarget:self action:@selector(onButtonChooseCard:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnBuyCard];
    
    //卡的价钱
    UILabel *labelCardPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-21-32-60, labelDate.frame.origin.y, 60, 15)];
    [labelCardPrice setBackgroundColor:[UIColor clearColor]];
    [labelCardPrice setFont:MKFONT(15)];
    [labelCardPrice setTextColor:RGBA(249, 81, 81, 1)];
    [labelCardPrice setTextAlignment:NSTextAlignmentRight];
    [labelCardPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:memberCardDetailModel.price]]];
    [view addSubview:labelCardPrice];
    
    
    CGFloat paddingBottom = 30;
    //活动描述(自适应高度)
    //如果返回的活动列表为空时，不显示优惠活动
    UIView *activityDescribeView = [self generateActivityDescribe:memberCardDetailModel.activityDescList];
    activityDescribeView.frame = CGRectMake(labelDate.frame.origin.x, labelDate.frame.origin.y + labelDate.frame.size.height + 10, activityDescribeView.frame.size.width, activityDescribeView.frame.size.height);
    [view addSubview:activityDescribeView];
    
    if (memberCardDetailModel.activityDescList != nil && memberCardDetailModel.activityDescList.count > 0)
    {
        //如果活动描述列表不是空，并且活动个数>0
//        btnBuyCard.frame = CGRectMake(SCREEN_WIDTH-30-60-15, labelDate.frame.origin.y, 60, 24);
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15 * 2, activityDescribeView.frame.origin.y + activityDescribeView.frame.size.height + paddingBottom);
    }
    else
    {
        //没有返回活动描述列表
//        btnBuyCard.frame = CGRectMake(SCREEN_WIDTH-30-60-15, labelDate.frame.origin.y-6, 60, 24);
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15 * 2, labelDate.frame.origin.y + labelDate.frame.size.height + paddingBottom);
    }
    
    return view;
}

#pragma mark 生成其他类型卡view
-(UIView *)generateOtherCardView:(MemberCardDetailModel *)memberCardDetailModel isHavePreferential:(BOOL)isHavePreferential index:(int)i
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    //有效期
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 130, 15)];
    [labelDate setBackgroundColor:[UIColor clearColor]];
    [labelDate setFont:MKFONT(15)];
    [labelDate setTextColor:RGBA(51, 51, 51, 1)];
    [view addSubview:labelDate];
    
    //有效期(自适应)
    if ([memberCardDetailModel.validDayCount intValue] == 0)
    {
        [labelDate setText:@"今日结束"];
    }
    else
    {
        [labelDate setText:[NSString stringWithFormat:@"有效期：%@天",memberCardDetailModel.validDayCount]];
    }
    [Tool setLabelSpacing: labelDate spacing:2 alignment:NSTextAlignmentLeft];
    labelDate.frame = CGRectMake(15, 0, labelDate.frame.size.width, 15);
    
    //卡的价钱
    UILabel *labelCardPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-21-32-60, labelDate.frame.origin.y, 60, 15)];
    [labelCardPrice setBackgroundColor:[UIColor clearColor]];
    [labelCardPrice setFont:MKFONT(15)];
    [labelCardPrice setTextColor:RGBA(249, 81, 81, 1)];
    [labelCardPrice setTextAlignment:NSTextAlignmentRight];
    [labelCardPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:memberCardDetailModel.price]]];
    [view addSubview:labelCardPrice];
    
    //权益优惠
    UIImageView *imageCanCheapType = [[UIImageView alloc] initWithFrame:CGRectMake(labelDate.frame.origin.x+labelDate.frame.size.width+15, labelDate.frame.origin.y, 14, 14)];
    [imageCanCheapType setBackgroundColor:RGBA(248, 188, 41, 1)];
    [imageCanCheapType setImage:[UIImage imageNamed:@"image_CheapType.png"]];
    imageCanCheapType.hidden = YES;
    [view addSubview:imageCanCheapType];
    
    //判断登录状态
    if ( ![Config getLoginState ])
    {
        //没有登录
        imageCanCheapType.hidden = YES;
    }
    else
    {
        //已登录
        imageCanCheapType.hidden = !isHavePreferential;
    }
    
    //购买按钮
    UIButton *btnBuyCard = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-21-15, labelDate.frame.origin.y-3, 21, 21)];
    if (i == 0)
    {
        [btnBuyCard setBackgroundColor:RGBA(117, 112, 255, 1)];
        [btnBuyCard setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnBuyCard setBackgroundColor:RGBA(241, 240, 255, 1)];
        [btnBuyCard setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    [btnBuyCard.layer setCornerRadius:10.5];//按钮设置圆角
    btnBuyCard.tag = i+300;//给标签
    [btnBuyCard addTarget:self action:@selector(onButtonChooseCard:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnBuyCard];

    CGFloat paddingBottom = 30;
    //活动描述(自适应高度)
    //如果返回的活动列表为空时，不显示优惠活动
    UIView *activityDescribeView = [self generateActivityDescribe:memberCardDetailModel.activityDescList];
    activityDescribeView.frame = CGRectMake(labelDate.frame.origin.x, labelDate.frame.origin.y + labelDate.frame.size.height + 10, activityDescribeView.frame.size.width, activityDescribeView.frame.size.height);
    [view addSubview:activityDescribeView];
    
    //view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15 * 2, activityDescribeView.frame.origin.y + activityDescribeView.frame.size.height + paddingBottom);
    if (memberCardDetailModel.activityDescList != nil && memberCardDetailModel.activityDescList.count > 0)
    {
        //如果活动描述列表不是空，并且活动个数>0
//        btnBuyCard.frame = CGRectMake(SCREEN_WIDTH-30-21-15, labelDate.frame.origin.y, 21, 21);
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15 * 2, activityDescribeView.frame.origin.y + activityDescribeView.frame.size.height + paddingBottom);
    }
    else
    {
//        //没有返回活动描述列表
//        btnBuyCard.frame = CGRectMake(SCREEN_WIDTH-30-21-15, labelDate.frame.origin.y-4, 21, 21);
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15 * 2, labelDate.frame.origin.y + labelDate.frame.size.height + paddingBottom);
    }

    return view;
}

-(UIView *)generateActivityDescribe:(NSArray *)descArr
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    if (descArr != nil && descArr.count > 0){
        CGFloat height = 0;
        for (int j = 0; j< descArr.count; j++)
        {
            //单独卡的描述
            activityDescListModel *acModel = descArr[j];
            
            UILabel *labelActivityDescribe = [[UILabel alloc]initWithFrame:CGRectZero];
            [labelActivityDescribe setBackgroundColor:[UIColor clearColor]];
            [labelActivityDescribe setFont:MKFONT(12)];
            [labelActivityDescribe setTextColor:RGBA(123, 122, 152, 1)];
            labelActivityDescribe.numberOfLines = 0;
            labelActivityDescribe.lineBreakMode = NSLineBreakByCharWrapping;
            //取得的第一个和最后一个不加符号
            if (descArr.count == 1 || j == descArr.count-1)
            {
                [labelActivityDescribe setText:[NSString stringWithFormat:@"%@",acModel.activityDesc]];
            }
            else
            {
                [labelActivityDescribe setText:[NSString stringWithFormat:@"%@；",acModel.activityDesc]];
            }
            
            [labelActivityDescribe setFrame:CGRectMake(0, 0, SCREEN_WIDTH-15*2-15*2, 12)];
            
            
            [Tool setLabelSpacing:labelActivityDescribe spacing:2 alignment:NSTextAlignmentLeft];
            
            [labelActivityDescribe setFrame:CGRectMake(labelActivityDescribe.frame.origin.x, height, SCREEN_WIDTH-15*2-15*2, labelActivityDescribe.frame.size.height)];
            height = height + labelActivityDescribe.frame.size.height + 3;
            
            [view addSubview:labelActivityDescribe];
        }
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH-15*2-15*2, height);
    }
    return view;
}

#pragma mark 购买按钮选项 - 切换
-(void)onButtonChooseCard:(UIButton *)sender
{
    if (sender.tag != btnTag)
    {
        UIButton *btnUnPress = (UIButton*)[self.view viewWithTag:btnTag];
        [btnUnPress setBackgroundColor:RGBA(241, 240, 255, 1)];
        [btnUnPress setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [sender setBackgroundColor:RGBA(117, 112, 255, 1)];
        [sender setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
        
        btnTag = sender.tag;
    }
    else
    {
        [sender setBackgroundColor:RGBA(117, 112, 255, 1)];
        [sender setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 展开按钮
-(void)onButtonUnfold:(UIButton *)btn
{
    if (btn.tag == 100)
    {
        __block CGRect rect0 = _viewBasicInformation.frame;
        __block CGRect rect1 = _labelCinemaLimit.frame;
        __block CGRect rect2 = _viewBuyCardBG.frame;
        __block CGRect rect3 = _imageLine.frame;
        //展开
        [UIView animateKeyframesWithDuration:0.8 delay:0 options:0 animations: ^{
            btn.frame = CGRectMake(_viewBasicInformation.frame.size.width-20-60, btn.frame.origin.y, 60, btn.frame.size.height);
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label上移10px，BuyCardBG上移10px
                _viewBasicInformation.frame = CGRectMake(rect0.origin.x, rect0.origin.y, rect0.size.width, rect0.size.height-10);
                _labelCinemaLimit.frame = CGRectMake(rect1.origin.x, rect1.origin.y-10, rect1.size.width, rect1.size.height);
                _viewBuyCardBG.frame = CGRectMake(rect2.origin.x, rect2.origin.y-10, rect2.size.width, rect2.size.height);
                _imageLine.frame = CGRectMake(rect3.origin.x, rect3.origin.y-10, rect3.size.width, rect3.size.height);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:1/4.0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label下移10px，BuyCardBG下移10px
                _viewBasicInformation.frame = rect0;
                _labelCinemaLimit.frame = rect1;
                _viewBuyCardBG.frame = rect2;
                _imageLine.frame = rect3;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:1.5/4.0 relativeDuration:0.5 / 4.0 animations: ^{
                _viewBasicInformation.frame = CGRectMake(rect0.origin.x, rect0.origin.y, rect0.size.width, rect0.size.height+20);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:2/4.0 relativeDuration:2 / 4.0 animations: ^{
                _labelLeftDescribe.alpha = 1;
                _labelPoints.alpha = 0;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:2/4.0 relativeDuration:0.5 / 4.0 animations: ^{
                //卡描述全展开，限制Label和BuyCardBG跟卡描述一起向下展开+10px
                _viewBasicInformation.frame = CGRectMake(_viewBasicInformation.frame.origin.x, 42, _viewBasicInformation.frame.size.width,  _labelCardDescribe.frame.origin.y+_fOriginallyHeight+10+_labelCinemaLimit.frame.size.height+10+10);
                
                _labelCinemaLimit.frame = CGRectMake(_labelCinemaLimit.frame.origin.x, _labelCardDescribe.frame.origin.y+_fOriginallyHeight+10+10, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
    
                _viewBuyCardBG.frame = CGRectMake(_viewBuyCardBG.frame.origin.x, _viewBasicInformation.frame.origin.y+_viewBasicInformation.frame.size.height, _viewBuyCardBG.frame.size.width, _fBuyCardBGHeight);
                _imageLine.frame = CGRectMake(15, _viewBuyCardBG.frame.origin.y+_viewBuyCardBG.frame.size.height, SCREEN_WIDTH-15*2, 5);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:3/4.0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label和BuyCardBG上移10px
                _labelCinemaLimit.frame = CGRectMake(_labelCinemaLimit.frame.origin.x, _labelCinemaLimit.frame.origin.y-10, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
                _viewBasicInformation.frame = CGRectMake(_viewBasicInformation.frame.origin.x, _viewBasicInformation.frame.origin.y, _viewBasicInformation.frame.size.width, _viewBasicInformation.frame.size.height-10);
                _viewBuyCardBG.frame = CGRectMake(_viewBuyCardBG.frame.origin.x, _viewBuyCardBG.frame.origin.y-10, _viewBuyCardBG.frame.size.width, _viewBuyCardBG.frame.size.height);
                _imageLine.frame = CGRectMake(_imageLine.frame.origin.x, _imageLine.frame.origin.y-10, _imageLine.frame.size.width, _imageLine.frame.size.height);
            }];
        } completion:^(BOOL finished) {
            [btn setTitle:@"收起" forState:UIControlStateNormal];
            btn.tag = 101;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [btn setTitle:@"" forState:UIControlStateNormal];
            btn.frame = CGRectMake(_viewBasicInformation.frame.size.width-20-20, btn.frame.origin.y, 20, btn.frame.size.height);
            _labelLeftDescribe.alpha = 0;
            _labelPoints.alpha = 1;
        
            _viewBasicInformation.frame = CGRectMake(15, 42, SCREEN_WIDTH-15*2, _labelCardDescribe.frame.origin.y+47+27+_labelCinemaLimit.frame.size.height+10);
            _labelCinemaLimit.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+47+27, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
            _viewBuyCardBG.frame = CGRectMake(15, _viewBasicInformation.frame.origin.y+_viewBasicInformation.frame.size.height, SCREEN_WIDTH-15*2, _fBuyCardBGHeight);;
            _imageLine.frame = CGRectMake(15, _viewBuyCardBG.frame.origin.y+_viewBuyCardBG.frame.size.height, SCREEN_WIDTH-15*2, 5);
        } completion:^(BOOL finished) {
            
            [btn setImage:[UIImage imageNamed:@"btn_unfoldDetial.png"] forState:UIControlStateNormal];
            btn.tag = 100;
        }];
    }
    _scrollViewBuyCard.contentSize = CGSizeMake(_scrollViewBuyCard.frame.size.width, _viewBuyCardBG.frame.origin.y+_viewBuyCardBG.frame.size.height+100);
}

#pragma mark 刷新背景UI
-(void)reloadWholeBGUI
{
    float fBasicInformationHeight = _labelCinemaLimit.frame.origin.y+_labelCinemaLimit.frame.size.height+10;
    _viewBasicInformation.frame = CGRectMake(_viewBasicInformation.frame.origin.x, _viewBasicInformation.frame.origin.y, _viewBasicInformation.frame.size.width, fBasicInformationHeight);
}

#pragma mark 点击背景展开
-(void)onViewClick:(UITapGestureRecognizer *)sender
{
    [self onButtonUnfold:_btnUnfold];
}

#pragma mark 开通
-(void)onButtonBuyCard:(UIButton*)btn
{
    //判断登录状态
    if ( ![Config getLoginState ])
    {
        //没有登录，弹出登录页
        [self showLoginController];
    }
    else
    {
        //已登录，跳转到
        NSLog(@"点击了开通");
        CardOrderViewController *cardOrderVC = [[CardOrderViewController alloc] init];
        cardOrderVC._memberCardDetailModel = self._cardListModel.cinemaCardItemList[btnTag-300];
        cardOrderVC._cardListModel = self._cardListModel;
        cardOrderVC._cinema = self._cinema;
        [self.navigationController pushViewController:cardOrderVC animated:YES];
    }
}

#pragma mark 弹出登录view
-(void) showLoginController
{
    LoginViewController *loginControlller = [[LoginViewController alloc] init];
    loginControlller.param = [[NSMutableDictionary alloc] init];
    [loginControlller.param setObject:self._cinema forKey:@"_cinema"];
    [loginControlller.param setObject:self._cardListModel forKey:@"_cardListModel"];
    [loginControlller.param setObject:self._cardListModel.cinemaCardItemList[btnTag-300] forKey:@"_memberCardDetailModel"];
    loginControlller._strTopViewName = @"CardOrderViewController";
    [self.navigationController pushViewController:loginControlller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
