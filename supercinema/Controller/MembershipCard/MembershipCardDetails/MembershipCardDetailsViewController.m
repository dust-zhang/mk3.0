//
//  MembershipCardDetailsViewController.m
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import "MembershipCardDetailsViewController.h"

@interface MembershipCardDetailsViewController ()

@end

@implementation MembershipCardDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCtrl];
}

-(void)initCtrl
{
    if ([self._cardListModel.cardType intValue] == -1)
    {
        [MobClick event:mainViewbtn64];
    }
    else
    {
        [MobClick event:mainViewbtn68];
    }
    
    //顶部View
    [self._labelTitle setText:self._cinema.cinemaName];
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    
    //设置ScrollView
    _scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_scrollViewContent setBackgroundColor:RGBA(246, 246, 255, 1)];
    _scrollViewContent.delegate = self;
    [self.view addSubview:_scrollViewContent];
    
    //整体的View背景
    _viewWholeBG = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 150)];
    _viewWholeBG.backgroundColor = [UIColor clearColor];
    _viewWholeBG.layer.masksToBounds = YES;
    _viewWholeBG.layer.cornerRadius = 10;
    [_scrollViewContent addSubview:_viewWholeBG];
    
    //卡图标
    _imageCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 27, 27)];
    [_imageCardIcon setBackgroundColor:[UIColor clearColor]];
    [_viewWholeBG addSubview:_imageCardIcon];
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
        [_viewWholeBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_cardBG.png"]]];
    }
    else
    {
        //票类型Logo
        [_imageCardIcon setImage:[UIImage imageNamed:@"image_ticketType_white.png"]];
        [_viewWholeBG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_ticketTypeBG.png"]]];
    }
    
    //卡名字
    _labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(_imageCardIcon.frame.origin.x+_imageCardIcon.frame.size.width+12, 15.5, _viewWholeBG.frame.size.width-15-_imageCardIcon.frame.size.width-12-15, 17)];
    [_labelCardName setBackgroundColor:[UIColor clearColor]];
    [_labelCardName setFont:MKFONT(17)];
    [_labelCardName setTextColor:RGBA(255, 255, 255, 1)];
    [_labelCardName setTextAlignment:NSTextAlignmentLeft];
    [_labelCardName setText:self._cardListModel.cinemaCardName];
    [_viewWholeBG addSubview:_labelCardName];
    
    //分割线(实线)
    _labelEntityLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+15.5, _viewWholeBG.frame.size.width, 0.5)];
    _labelEntityLine.backgroundColor = RGBA(255, 255, 255, 0.2);
    [_viewWholeBG addSubview:_labelEntityLine];
    
    //卡描述（自适应）
    _labelCardDescribe = [[UILabel alloc] initWithFrame:CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewWholeBG.frame.size.width-20*2, 12)];
    [_labelCardDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelCardDescribe setFont:MKFONT(12)];
    [_labelCardDescribe setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelCardDescribe.numberOfLines = 0;
    _labelCardDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    _labelCardDescribe.contentMode = UIViewContentModeTop;
    [_viewWholeBG addSubview:_labelCardDescribe];
    
    //卡描述后几行
    _labelLeftDescribe = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _viewWholeBG.frame.size.width-20*2, 100)];
    [_labelLeftDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelLeftDescribe setFont:MKFONT(12)];
    [_labelLeftDescribe setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelLeftDescribe.numberOfLines = 0;
    _labelLeftDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    _labelLeftDescribe.contentMode = UIViewContentModeTop;
    _labelLeftDescribe.alpha = 0;
    [_viewWholeBG addSubview:_labelLeftDescribe];
    
    //省略号
    _labelPoints = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelPoints setBackgroundColor:[UIColor clearColor]];
    [_labelPoints setFont:MKFONT(12)];
    [_labelPoints setTextColor:RGBA(255, 255, 255, 0.6)];
    _labelPoints.text = @"...";
    _labelPoints.contentMode = UIViewContentModeTop;
    _labelPoints.alpha = 0;
    [_viewWholeBG addSubview:_labelPoints];
    
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
    _btnUnfold = [[UIButton alloc] initWithFrame:CGRectMake(_viewWholeBG.frame.size.width-20-20, 12.5, 20, 20)];
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
        [_viewWholeBG addGestureRecognizer:click];
        
        _btnUnfold.hidden = NO;
        _labelCardDescribe.lineBreakMode = NSLineBreakByCharWrapping;
        fCardDescribeHeight = 47;
    }
    _labelCardDescribe.frame = CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewWholeBG.frame.size.width-20*2, fCardDescribeHeight);
    
    [_viewWholeBG addSubview:_btnUnfold];

    
    //影院限制
    _labelCinemaLimit= [[UILabel alloc] initWithFrame:CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+27, _labelCardDescribe.frame.size.width, 10)];
    [_labelCinemaLimit setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaLimit setFont:MKFONT(10)];
    [_labelCinemaLimit setTextColor:RGBA(255, 255, 255, 1)];
    _labelCinemaLimit.numberOfLines = 0;
    _labelCinemaLimit.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWholeBG addSubview:_labelCinemaLimit];
    
    [_labelCinemaLimit setText:[NSString stringWithFormat:@"仅限 %@ 使用",self._cinema.cinemaName]];
    [Tool setLabelSpacing:_labelCinemaLimit spacing:2 alignment:NSTextAlignmentLeft];
    _labelCinemaLimit.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+27, _labelCardDescribe.frame.size.width, _labelCinemaLimit.frame.size.height);
    
    //开通标识
    _imageOpenType = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWholeBG.frame.size.width-20-45, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+10, 45, 45)];
    _imageOpenType.backgroundColor = [UIColor clearColor];
    [_imageOpenType setImage:[UIImage imageNamed:@"image_openType.png"]];
    [_viewWholeBG addSubview:_imageOpenType];
    
    //剩余有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectMake(_labelCardDescribe.frame.origin.x, _labelCinemaLimit.frame.origin.y+_labelCinemaLimit.frame.size.height+14, _viewWholeBG.frame.size.width/2, 14)];
    _labelDate.backgroundColor = [UIColor clearColor];
    [_labelDate setFont:MKFONT(10)];
    [_labelDate setTextColor:RGBA(255, 255, 255, 1)];
    [_viewWholeBG addSubview:_labelDate];
    
    //剩余次数
    _labelCount = [[UILabel alloc] initWithFrame:CGRectMake(_viewWholeBG.frame.size.width-_viewWholeBG.frame.size.width/2-20, _labelDate.frame.origin.y, _viewWholeBG.frame.size.width/2, 14)];
    _labelCount.backgroundColor = [UIColor clearColor];
    [_labelCount setTextAlignment:NSTextAlignmentRight];
    _labelCount.hidden = YES;
    [_viewWholeBG addSubview:_labelCount];
    
    //=================重新计算卡基本信息View背景高度=================
    [self reloadWholeBGUI];
    
    //=================整体开通按钮背景=================
    _viewBuyCardButtonBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-58, SCREEN_WIDTH, 58)];
    _viewBuyCardButtonBG.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:_viewBuyCardButtonBG];
    
    //开通按钮
    _btnDredgeCard = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-15*2, 40)];
    [_btnDredgeCard setBackgroundColor:RGBA(0, 0, 0, 1)];
    [_btnDredgeCard setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnDredgeCard .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnDredgeCard.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnDredgeCard setTitle:@"免费开通" forState:UIControlStateNormal];
    [_btnDredgeCard addTarget:self action:@selector(onButtonDredgeCard) forControlEvents:UIControlEventTouchUpInside];
    [_viewBuyCardButtonBG addSubview:_btnDredgeCard];
    
    //蒙层
    _imageShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _viewBuyCardButtonBG.frame.origin.y-6, SCREEN_WIDTH, 6)];
    _imageShadow.backgroundColor = [UIColor clearColor];
    _imageShadow.image = [UIImage imageNamed:@"img_shadow.png"];
    [self.view addSubview:_imageShadow];
    
    
    //是否购买过+续卡逻辑
    [self isBought];
}


- (NSArray *)getSeparatedLinesFromLabel
{
    NSString *text = self._cardListModel.cardDesc;
    UIFont   *font = MKFONT(12);
    CGRect    rect = CGRectMake(20, 0, _viewWholeBG.frame.size.width-20*2, 12);
    
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

#pragma mark 是否购买过 + 续卡逻辑
-(void)isBought
{
    //如果 cardValidEndTime 该值 > 0，则说明用户买了该卡，并且该值为过期时间 并且是可以购卡的时显示 已开通
    if ([self._cardListModel.cardValidEndTime integerValue] > 0 &&
        [self._cardListModel.cardValidEndTime integerValue] > [self._memberModel.currentTime integerValue])
    {
        _viewBuyCardButtonBG.hidden = YES;
        _imageShadow.hidden = YES;
        //有效期（转换）
        int dayDate = [Tool calcTimeLength:self._cardListModel.cardValidEndTime]/24/60/60;
        
//        NSLog(@"截至时间%f",[Tool calcTimeLength:self._cardListModel.cardValidEndTime]/24/60/60);
//        NSLog(@"服务器时间%f",[Tool calcTimeLength:self._memberModel.currentTime]/24/60/60);
        
        /**
         *  卡类型   普通:-1
         *          常规:0
         *          次卡:1
         *          套票:2
         *          任看:3
         *          通票:4
         */
        
        //已开通
        if ([self._cardListModel.cardType intValue] == -1)
        {
             _labelDate.hidden = NO;
            [_labelDate setText:@"剩余有效期：永久"];

        }
        else if ([self._cardListModel.cardType intValue] == 0)
        {
            //普通会员
             _labelDate.hidden = NO;
            if (dayDate == 0)
            {
                //剩余有效期为0天
                [_labelDate setText:@"今日结束"];
            }
            else
            {
                //剩余有效期不为0天
                NSString *str = [NSString stringWithFormat:@"剩余有效期：%d 天",dayDate];
                NSUInteger joinCount =[[NSString stringWithFormat:@"%d", dayDate] length];
                //算出range的位置
                NSRange oneRange =NSMakeRange(0,6);
                NSRange twoRange =NSMakeRange(6,joinCount);
                NSRange threeRange =NSMakeRange(joinCount+7,1);
                NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
                //设置字号 & 颜色
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:twoRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange];
                [_labelDate setAttributedText:strAtt];
            }
        }
        else if ([self._cardListModel.cardType intValue] == 1)
        {
            //次卡会员
             _labelDate.hidden = NO;
            if (dayDate == 0)
            {
                //剩余有效期为0天
                [_labelDate setText:@"今日结束"];
            }
            else
            {
                //剩余有效期不为0天
                NSString *str = [NSString stringWithFormat:@"剩余有效期：%d 天",dayDate];
                NSUInteger joinCount =[[NSString stringWithFormat:@"%d", dayDate] length];
                //算出range的位置
                NSRange oneRange =NSMakeRange(0,6);
                NSRange twoRange =NSMakeRange(6,joinCount);
                NSRange threeRange =NSMakeRange(joinCount+7,1);
                NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
                //设置字号 & 颜色
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:twoRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange];
                [_labelDate setAttributedText:strAtt];
            }
            //剩余次数
            _labelCount.hidden = NO;
            NSString *strCount = [NSString stringWithFormat:@"剩余次数：%d次",[self._cardListModel.remainUseCount intValue]];
            NSUInteger joinCountLength =[[NSString stringWithFormat:@"%d", [self._cardListModel.remainUseCount intValue]] length];
            //算出range的位置
            NSRange oneRange1 =NSMakeRange(0,5);
            NSRange twoRange2 =NSMakeRange(5,joinCountLength);
            NSRange threeRange3 =NSMakeRange(joinCountLength+5,1);
            NSMutableAttributedString *strAttALL = [[NSMutableAttributedString alloc] initWithString:strCount];
            //设置字号 & 颜色
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange1];
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange2];
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange3];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange1];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:twoRange2];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange3];
            [_labelCount setAttributedText:strAttALL];
        }
        else if ([self._cardListModel.cardType intValue] == 3)
        {
            //任看
             _labelDate.hidden = NO;
            if (dayDate == 0)
            {
                //剩余有效期为0天
                [_labelDate setText:@"今日结束"];
            }
            else
            {
                //剩余有效期不为0天
                NSString *str = [NSString stringWithFormat:@"剩余有效期：%d 天",dayDate];
                NSUInteger joinCount =[[NSString stringWithFormat:@"%d", dayDate] length];
                //算出range的位置
                NSRange oneRange =NSMakeRange(0,6);
                NSRange twoRange =NSMakeRange(6,joinCount);
                NSRange threeRange =NSMakeRange(joinCount+7,1);
                NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
                //设置字号 & 颜色
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:twoRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange];
                [_labelDate setAttributedText:strAtt];

            }
        }
        else
        {
            //通票
             _labelDate.hidden = NO;
            if (dayDate == 0)
            {
                //剩余有效期为0天
                [_labelDate setText:@"今日结束"];
            }
            else
            {
                //剩余有效期不为0天
                NSString *str = [NSString stringWithFormat:@"剩余有效期：%d 天",dayDate];
                NSUInteger joinCount =[[NSString stringWithFormat:@"%d", dayDate] length];
                //算出range的位置
                NSRange oneRange =NSMakeRange(0,6);
                NSRange twoRange =NSMakeRange(6,joinCount);
                NSRange threeRange =NSMakeRange(joinCount+7,1);
                NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
                //设置字号 & 颜色
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
                [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:twoRange];
                [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange];
                [_labelDate setAttributedText:strAtt];
            }
            
            //剩余张数
            _labelCount.hidden = NO;
            NSString *strCount = [NSString stringWithFormat:@"剩余张数：%d张",[self._cardListModel.remainUseCount intValue]];
            NSUInteger joinCountLength =[[NSString stringWithFormat:@"%d", [self._cardListModel.remainUseCount intValue]] length];
            //算出range的位置
            NSRange oneRange1 =NSMakeRange(0,5);
            NSRange twoRange2 =NSMakeRange(5,joinCountLength);
            NSRange threeRange3 =NSMakeRange(joinCountLength+5,1);
            NSMutableAttributedString *strAttALL = [[NSMutableAttributedString alloc] initWithString:strCount];
            //设置字号 & 颜色
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange1];
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange2];
            [strAttALL addAttribute:NSFontAttributeName value:MKFONT(10) range:threeRange3];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:oneRange1];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:twoRange2];
            [strAttALL addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1)range:threeRange3];
            [_labelCount setAttributedText:strAttALL];
        }
        //本身买过，还能买(续卡逻辑) 
        if ([self._cardListModel.canContinuCard boolValue])
        {
            //如果有返回卡列表（距离剩余天数 < 60 天  && dayDate < 60）
            if (self._cardListModel.cinemaCardItemList.count > 0 )
            {
                _viewBuyCardButtonBG.hidden = NO;
                _btnDredgeCard.hidden = NO;
                _imageShadow.hidden = NO;
                [_btnDredgeCard setTitle:@"开通" forState:UIControlStateNormal];
            }
            else
            {
                //如果没有返回卡列表，则隐藏起来
                _viewBuyCardButtonBG.hidden = YES;
                _btnDredgeCard.hidden = YES;
                _imageShadow.hidden = YES;
                _scrollViewContent.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            }
            
            if (self._isAllPastDue == YES)
            {
                //从失效列表来 显示续费按钮（续费按钮叫开通）， 不显示日期以及次数
                _viewBuyCardButtonBG.hidden = NO;
                _btnDredgeCard.hidden = NO;
                _imageShadow.hidden = NO;
                
                [_btnDredgeCard setTitle:@"开通" forState:UIControlStateNormal];
                
                _labelDate.hidden = YES;
                _labelCount.hidden = YES;
            }
        }
        else
        {
            //本身买过，但是不让买，则隐藏起来
            _viewBuyCardButtonBG.hidden = YES;
            _btnDredgeCard.hidden = YES;
            _imageShadow.hidden = YES;
            _scrollViewContent.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
    }
    else
    {
        //未开通
        if ([self._cardListModel.cardType intValue] == -1)
        {
            //普通会员
            //判断登录状态
            if ([Config getLoginState])
            {
                //已登录，不显示免费开通
                _viewBuyCardButtonBG.hidden = YES;
                _btnDredgeCard.hidden = YES;
                _imageShadow.hidden = YES;
            }
            else
            {
                //未登录，显示免费开通
                _viewBuyCardButtonBG.hidden = NO;
                _btnDredgeCard.hidden = NO;
                _imageShadow.hidden = NO;
                [_btnDredgeCard setTitle:@"免费开通" forState:UIControlStateNormal];
            }
        }
        else
        {
            //其他会员
            _viewBuyCardButtonBG.hidden = YES;
            _btnDredgeCard.hidden = YES;
            _imageShadow.hidden = YES;
//            _viewBuyCardButtonBG.hidden = NO;
//            _btnDredgeCard.hidden = NO;
//            _imageShadow.hidden = NO;
//            [_btnDredgeCard setTitle:@"开通" forState:UIControlStateNormal];
        }
    }
}

#pragma mark 跳转到购卡页
-(void)onButtonDredgeCard
{
    if ([self._cardListModel.cardType intValue] == -1)
    {
        //点击免费开通，弹出登录页
        [MobClick event:mainViewbtn65];
        [self showLoginController];
    }
    else
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
            [MobClick event:mainViewbtn69];
            BuyCardViewController *buyCardController = [[BuyCardViewController alloc] init];
            buyCardController._cinema = self._cinema;
            buyCardController.cinemaCardId = self._cardListModel.cinemaCardId;
            [self.navigationController pushViewController:buyCardController animated:YES];
        }
    }
    
//    测试购买成功页
//    BuyCardSuccessViewController *saleSuccess = [[BuyCardSuccessViewController alloc] init];
//    [self.navigationController pushViewController:saleSuccess animated:YES];
    
//    测试购买失败页面
//    if(!_payFaildView)
//    {
//        _payFaildView = [[PayFaildVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) orderModel:nil];
//        _payFaildView.hidden=YES;
//        _payFaildView.alpha=0;
//        _payFaildView.payFaildViewDelegate = self;
//        _payFaildView.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        [self.view addSubview:_payFaildView];
//    }
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         _payFaildView.transform = CGAffineTransformMakeScale(1, 1);
//                         _payFaildView.hidden=NO;
//                         _payFaildView.alpha=1;
//                     }completion:^(BOOL finish){
//                         
//                     }];
}

#pragma mark 展开按钮
-(void)onButtonUnfold:(UIButton *)btn
{
    if (btn.tag == 100)
    {
        __block CGRect rect0 = _viewWholeBG.frame;
        __block CGRect rect1 = _labelCinemaLimit.frame;
        
        __block CGRect rect2 = _imageOpenType.frame;
        __block CGRect rect3 = _labelDate.frame;
        __block CGRect rect4 = _labelCount.frame;
        //展开
        [UIView animateKeyframesWithDuration:0.8 delay:0 options:0 animations: ^{
            btn.frame = CGRectMake(_viewWholeBG.frame.size.width-20-60, btn.frame.origin.y, 60, btn.frame.size.height);
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label上移10px，BuyCardBG上移10px
                _viewWholeBG.frame = CGRectMake(rect0.origin.x, rect0.origin.y, rect0.size.width, rect0.size.height-10);
                _labelCinemaLimit.frame = CGRectMake(rect1.origin.x, rect1.origin.y-10, rect1.size.width, rect1.size.height);
                
                _imageOpenType.frame = CGRectMake(rect2.origin.x, rect2.origin.y-10, rect2.size.width, rect2.size.height);
                _labelDate.frame = CGRectMake(rect3.origin.x, rect3.origin.y-10, rect3.size.width, rect3.size.height);
                _labelCount.frame = CGRectMake(rect4.origin.x, rect4.origin.y-10, rect4.size.width, rect4.size.height);
                
            }];
            
            [UIView addKeyframeWithRelativeStartTime:1/4.0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label下移10px，BuyCardBG下移10px
                _viewWholeBG.frame = rect0;
                _labelCinemaLimit.frame = rect1;
                
                _imageOpenType.frame = rect2;
                _labelDate.frame = rect3;
                _labelCount.frame = rect4;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:1.5/4.0 relativeDuration:0.5 / 4.0 animations: ^{
                _viewWholeBG.frame = CGRectMake(rect0.origin.x, rect0.origin.y, rect0.size.width, rect0.size.height+20);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:2/4.0 relativeDuration:2 / 4.0 animations: ^{
                _labelLeftDescribe.alpha = 1;
                _labelPoints.alpha = 0;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:2/4.0 relativeDuration:0.5 / 4.0 animations: ^{
                //卡描述全展开，限制Label和BuyCardBG跟卡描述一起向下展开+10px
                _viewWholeBG.frame = CGRectMake(_viewWholeBG.frame.origin.x, _viewWholeBG.frame.origin.y, _viewWholeBG.frame.size.width,  _labelCardDescribe.frame.origin.y+_fOriginallyHeight+10+_labelCinemaLimit.frame.size.height+14+_labelDate.frame.size.height+10+10);
                
                _labelCinemaLimit.frame = CGRectMake(_labelCinemaLimit.frame.origin.x, _labelCardDescribe.frame.origin.y+_fOriginallyHeight+10+10, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
                
                
                _imageOpenType.frame = CGRectMake(_viewWholeBG.frame.size.width-20-45, _labelCardDescribe.frame.origin.y+_fOriginallyHeight+10+10, 45, 45);
                _labelDate.frame = CGRectMake(_labelCardDescribe.frame.origin.x, (_labelCardDescribe.frame.origin.y+_fOriginallyHeight+10)+_labelCinemaLimit.frame.size.height+14+10, _viewWholeBG.frame.size.width/2, 14);
                _labelCount.frame = CGRectMake(_viewWholeBG.frame.size.width-_viewWholeBG.frame.size.width/2-20, (_labelCardDescribe.frame.origin.y+_fOriginallyHeight+10)+_labelCinemaLimit.frame.size.height+14+10, _viewWholeBG.frame.size.width/2, 14);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:3/4.0 relativeDuration:1 / 4.0 animations: ^{
                //限制Label和BuyCardBG上移10px
                _labelCinemaLimit.frame = CGRectMake(_labelCinemaLimit.frame.origin.x, _labelCinemaLimit.frame.origin.y-10, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
                _viewWholeBG.frame = CGRectMake(_viewWholeBG.frame.origin.x, _viewWholeBG.frame.origin.y, _viewWholeBG.frame.size.width, _viewWholeBG.frame.size.height-10);
                
                _imageOpenType.frame = CGRectMake(_imageOpenType.frame.origin.x, _imageOpenType.frame.origin.y-10, _imageOpenType.frame.size.width, _imageOpenType.frame.size.height);
                _labelDate.frame = CGRectMake(_labelDate.frame.origin.x, _labelDate.frame.origin.y-10, _labelDate.frame.size.width, _labelDate.frame.size.height);
                _labelCount.frame = CGRectMake(_labelCount.frame.origin.x, _labelCount.frame.origin.y-10, _labelCount.frame.size.width, _labelCount.frame.size.height);
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
            btn.frame = CGRectMake(_viewWholeBG.frame.size.width-20-20, btn.frame.origin.y, 20, btn.frame.size.height);
            _labelLeftDescribe.alpha = 0;
            _labelPoints.alpha = 1;
            
            _viewWholeBG.frame = CGRectMake(_viewWholeBG.frame.origin.x, _viewWholeBG.frame.origin.y, _viewWholeBG.frame.size.width, _labelCardDescribe.frame.origin.y+47+27+_labelCinemaLimit.frame.size.height+14+_labelDate.frame.size.height+10);
            _labelCinemaLimit.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+47+27, _labelCinemaLimit.frame.size.width, _labelCinemaLimit.frame.size.height);
            
            _imageOpenType.frame = CGRectMake(_viewWholeBG.frame.size.width-20-45, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+10, 45, 45);
            _labelDate.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCinemaLimit.frame.origin.y+_labelCinemaLimit.frame.size.height+14, _viewWholeBG.frame.size.width/2, 14);
            _labelCount.frame = CGRectMake(_viewWholeBG.frame.size.width-_viewWholeBG.frame.size.width/2-20, _labelDate.frame.origin.y, _viewWholeBG.frame.size.width/2, 14);
            
        } completion:^(BOOL finished) {
            
            [btn setImage:[UIImage imageNamed:@"btn_unfoldDetial.png"] forState:UIControlStateNormal];
            btn.tag = 100;
        }];
    }
    
    _scrollViewContent.contentSize = CGSizeMake(_scrollViewContent.frame.size.width, _viewWholeBG.frame.origin.y+_viewWholeBG.frame.size.height+100);
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        if (btn.tag == 100)
//        {
//            btn.frame = CGRectMake(_viewWholeBG.frame.size.width-20-60, btn.frame.origin.y, 60, btn.frame.size.height);
//            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            _labelCardDescribe.frame = CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewWholeBG.frame.size.width-20*2, _fOriginallyHeight);
//        }
//        else
//        {
//            [btn setTitle:@"" forState:UIControlStateNormal];
//            btn.frame = CGRectMake(_viewWholeBG.frame.size.width-20-20, btn.frame.origin.y, 20, btn.frame.size.height);
//            
//            _labelCardDescribe.lineBreakMode = NSLineBreakByTruncatingTail;
//            _labelCardDescribe.frame = CGRectMake(20, _labelEntityLine.frame.origin.y+_labelEntityLine.frame.size.height+15, _viewWholeBG.frame.size.width-20*2, fCardDescribeHeight);
//        }
//        [self reloadAllControlsUI];
//        
//    } completion:^(BOOL finished) {
//        
//        if (btn.tag == 100)
//        {
//            [btn setTitle:@"收起" forState:UIControlStateNormal];
//            btn.tag = 101;
//        }
//        else
//        {
//            [btn setImage:[UIImage imageNamed:@"btn_unfoldDetial.png"] forState:UIControlStateNormal];
//            btn.tag = 100;
//        }
//        
//    }];
}

#pragma mark 刷新整体控件UI
-(void)reloadAllControlsUI
{
    [self reloadWholeBGUI];
    
    //影院限制
    _labelCinemaLimit.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+27, _labelCardDescribe.frame.size.width, _labelCinemaLimit.frame.size.height);
    
    _imageOpenType.frame = CGRectMake(_viewWholeBG.frame.size.width-20-45, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+10, 45, 45);
    
    //剩余有效期
    _labelDate.frame = CGRectMake(_labelCardDescribe.frame.origin.x, _labelCinemaLimit.frame.origin.y+_labelCinemaLimit.frame.size.height+14, _viewWholeBG.frame.size.width/2, 14);
    
    //剩余次数
    _labelCount.frame = CGRectMake(_viewWholeBG.frame.size.width-_viewWholeBG.frame.size.width/2-20, _labelDate.frame.origin.y, _viewWholeBG.frame.size.width/2, 14);
    
    
}

#pragma mark 刷新背景UI
-(void)reloadWholeBGUI
{
    //重新获取整体View的高度
    float fBasicInformationHeight = 15.5+_labelCardName.frame.size.height+15.5+0.5+15+_labelCardDescribe.frame.size.height+27+_labelCinemaLimit.frame.size.height+14+_labelDate.frame.size.height+10;
    _viewWholeBG.frame = CGRectMake(_viewWholeBG.frame.origin.x, _viewWholeBG.frame.origin.y, _viewWholeBG.frame.size.width, fBasicInformationHeight);
}

#pragma mark 点击背景展开
-(void)onViewClick:(UITapGestureRecognizer *)sender
{
    [self onButtonUnfold:_btnUnfold];
}

#pragma mark 弹出登录view
-(void) showLoginController
{
    LoginViewController *loginControlller = [[LoginViewController alloc] init];
    loginControlller.param = [[NSMutableDictionary alloc] init];
    [loginControlller.param setObject:self._cinema forKey:@"_cinema"];
    [loginControlller.param setObject:self._cardListModel forKey:@"_cardListModel"];
    loginControlller._strTopViewName = @"MembershipCardView";//BuyCardViewController
    [self.navigationController pushViewController:loginControlller animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
