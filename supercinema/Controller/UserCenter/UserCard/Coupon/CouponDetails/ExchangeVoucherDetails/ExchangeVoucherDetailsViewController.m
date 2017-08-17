//
//  ExchangeVoucherDetailsViewController.m
//  supercinema
//
//  Created by mapollo91 on 28/11/16.
//
//

#import "ExchangeVoucherDetailsViewController.h"

@interface ExchangeVoucherDetailsViewController ()

@end

@implementation ExchangeVoucherDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
    [self initFrameAndData];
}

-(void)initController
{
    //整体的ScrollView
    _scrollViewWhole = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollViewWhole.showsHorizontalScrollIndicator = NO;
    _scrollViewWhole.showsVerticalScrollIndicator = NO;
    _scrollViewWhole.delegate = self;
    [_scrollViewWhole setBackgroundColor:RGBA(246, 246, 251,1)];
    [self.view addSubview:_scrollViewWhole];
    
    _viewWhiteBg = [[UIView alloc] initWithFrame:CGRectZero];
    [_viewWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [_viewWhiteBg.layer setBorderWidth:1];
    [_viewWhiteBg.layer setBorderColor:RGBA(233, 233, 238,1).CGColor];
    [_scrollViewWhole addSubview:_viewWhiteBg];
    
    //Logo
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageLogo.backgroundColor = [UIColor clearColor];
    [_viewWhiteBg addSubview:_imageLogo];
    
    //通票名称
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelName];
    
    //余额
    _labelRemainder = [[UILabel alloc] initWithFrame:CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH/2, 15)];
    [_labelRemainder setBackgroundColor:[UIColor clearColor]];
    [_labelRemainder setFont:MKFONT(15)];
    [_labelRemainder setTextColor:RGBA(51, 51, 51, 1)];
    [_labelRemainder setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelRemainder];
    
    //描述（自适应）
    _labelDescribe = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelDescribe setFont:MKFONT(12)];
    [_labelDescribe setTextColor:RGBA(51, 51, 51, 1)];
    _labelDescribe.numberOfLines = 0;
    _labelDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelDescribe];
    
    //有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setFont:MKFONT(11)];
    [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [_viewWhiteBg addSubview:_labelDate];
    
    //适用影片
    _labelMovie = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMovie setBackgroundColor:[UIColor clearColor]];
    [_labelMovie setFont:MKFONT(15)];
    [_labelMovie setTextColor:RGBA(51, 51, 51, 1)];
    _labelMovie.text = @"适用影片：";
    [_viewWhiteBg addSubview:_labelMovie];
    
    _labelMovieName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMovieName setBackgroundColor:[UIColor clearColor]];
    [_labelMovieName setFont:MKFONT(12)];
    [_labelMovieName setTextColor:RGBA(102, 102, 102, 1)];
    _labelMovieName.numberOfLines = 0;
    _labelMovieName.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelMovieName];
    
    //分割线
    _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLine setBackgroundColor:[UIColor clearColor]];
    [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewWhiteBg addSubview:_imageLine];
    
    //使用说明
    _labelInstructions = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelInstructions setBackgroundColor:[UIColor clearColor]];
    [_labelInstructions setFont:MKFONT(12)];
    [_labelInstructions setTextColor:RGBA(51, 51, 51, 1)];
    _labelInstructions.text = @"使用说明：";
    [_viewWhiteBg addSubview:_labelInstructions];
    
    _labelInstructionsContent = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelInstructionsContent setBackgroundColor:[UIColor clearColor]];
    [_labelInstructionsContent setFont:MKFONT(12)];
    [_labelInstructionsContent setTextColor:RGBA(102, 102, 102, 1)];
    _labelInstructionsContent.numberOfLines = 0;
    _labelInstructionsContent.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelInstructionsContent];
    
    //客服电话
    _labelPhone = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelPhone setBackgroundColor:[UIColor clearColor]];
    [_labelPhone setFont:MKFONT(12)];
    [_labelPhone setTextColor:RGBA(123, 122, 152, 1)];
    [_viewWhiteBg addSubview:_labelPhone];
    
    //往期中得使用标识Logo
    _imageType = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageType setBackgroundColor:[UIColor clearColor]];
    _imageType.hidden = YES;
    [_viewWhiteBg addSubview:_imageType];
    
    //失效的蒙版
    _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
    _viewMask.backgroundColor = RGBA(255, 255, 255, 0.5);
    _viewMask.hidden = YES;
    [_viewWhiteBg addSubview:_viewMask];
    
}

-(void)initFrameAndData
{
    NSLog(@"%@",self._tongPiaoInfoModel);
    
    //顶部导航栏显示名称
    self._labelTitle.text = [NSString stringWithFormat:@"%@详情",self._tongPiaoInfoModel.cinemaCardName];
    
    //整体的ScrollView
    _scrollViewWhole.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    //Logo
    _imageLogo.frame = CGRectMake(15, 30, 27, 27);
    [_imageLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];
    
    //通票名称
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, SCREEN_WIDTH/2, 15);
    _labelName.text = self._tongPiaoInfoModel.cinemaCardName;
    
    //余额
    _labelRemainder.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH/2, 15);
    NSString *str = [NSString stringWithFormat:@"余额：%d/%d张",[self._tongPiaoInfoModel.remainUseCount intValue],[self._tongPiaoInfoModel.totalUseCount intValue]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%d", [self._tongPiaoInfoModel.remainUseCount intValue]] length];
    NSUInteger joinCount1 =[[NSString stringWithFormat:@"%d", [self._tongPiaoInfoModel.totalUseCount intValue]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,3);
    NSRange twoRange =NSMakeRange(3,joinCount+1);
    NSRange threeRange =NSMakeRange(3+joinCount+1,joinCount1+1);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:twoRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:threeRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:threeRange];
    [_labelRemainder setAttributedText:strAtt];

    //描述（自适应）
    _labelDescribe.frame = CGRectMake(_labelName.frame.origin.x, _labelRemainder.frame.origin.y+_labelRemainder.frame.size.height+15, SCREEN_WIDTH-15*5-27, 12);
    _labelDescribe.text = self._tongPiaoInfoModel.cardDesc;
    [_labelDescribe sizeToFit];
    _labelDescribe.frame = CGRectMake(_labelName.frame.origin.x, _labelRemainder.frame.origin.y+_labelRemainder.frame.size.height+15, SCREEN_WIDTH-15*5-27, _labelDescribe.frame.size.height);
    
    //有效期
    _labelDate.frame = CGRectMake(_labelName.frame.origin.x, _labelDescribe.frame.origin.y+_labelDescribe.frame.size.height+15, _labelDescribe.frame.size.width, 11);
    _labelDate.text = [NSString stringWithFormat:@"有效期至%@",[Tool returnTime:self._tongPiaoInfoModel.cardValidEndTime format:@"yyyy年MM月dd日"]];

    if (self._tongPiaoInfoModel.useMovieNameList != nil && self._tongPiaoInfoModel.useMovieNameList.count > 0)
    {
        //适用影片
        _labelMovie.frame = CGRectMake(_labelName.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, _labelDescribe.frame.size.width, 15);
        _labelMovieName.frame = CGRectMake(_labelName.frame.origin.x, _labelMovie.frame.origin.y+_labelMovie.frame.size.height+10, _labelDescribe.frame.size.width, 12);
        NSArray *arrMovieName = self._tongPiaoInfoModel.useMovieNameList;
        NSString* strMovieName = @"";
        for (int i = 0; i < arrMovieName.count; i++)
        {
            NSString* str = arrMovieName[i];
            //取得最后一个不换行
            if (i == arrMovieName.count-1)
            {
                NSString* strNew = [NSString stringWithFormat:@"%@",str];
                strMovieName = [strMovieName stringByAppendingString:strNew];
            }
            else
            {
                NSString* strNew = [NSString stringWithFormat:@"%@\n",str];
                strMovieName = [strMovieName stringByAppendingString:strNew];
            }
        }
        [_labelMovieName setText:strMovieName];
        //Label自适应高度
        CGSize sizeMovieName = [_labelMovieName sizeThatFits:CGSizeZero];
        [_labelMovieName sizeToFit];
        _labelMovieName.frame =  CGRectMake(_labelName.frame.origin.x, _labelMovie.frame.origin.y+_labelMovie.frame.size.height+10, _labelDescribe.frame.size.width, sizeMovieName.height);
        //分割线
        _imageLine.frame = CGRectMake(_labelName.frame.origin.x, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+30, _labelDescribe.frame.size.width, 0.5);
    }
    else
    {
        //分割线
        _imageLine.frame = CGRectMake(_labelName.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, _labelDescribe.frame.size.width, 0.5);
    }
    
    //使用说明
    _labelInstructions.frame = CGRectMake(_labelName.frame.origin.x, _imageLine.frame.origin.y+_imageLine.frame.size.height+30, _labelDescribe.frame.size.width, 12);
    _labelInstructionsContent.frame = CGRectMake(_labelName.frame.origin.x, _labelInstructions.frame.origin.y+_labelInstructions.frame.size.height+10, _labelDescribe.frame.size.width, 12);
//    NSArray *arrInstructionsContent = @[@"我是使用说明离开；看来；的第一行",@"使用说明第二行啊啊大三大四的",@"使用说明第三行"];
//    NSString* strInstructionsContent = @"";
//    for (int i = 0; i < arrInstructionsContent.count; i++)
//    {
//        NSString* str = arrInstructionsContent[i];
//        //取得最后一个不加符号不换行
//        if (i == arrInstructionsContent.count-1)
//        {
//            NSString* strNew = [NSString stringWithFormat:@"%@",str];
//            strInstructionsContent = [strInstructionsContent stringByAppendingString:strNew];
//        }
//        else
//        {
//            NSString* strNew = [NSString stringWithFormat:@"%@\n",str];
//            strInstructionsContent = [strInstructionsContent stringByAppendingString:strNew];
//        }
//    }
    [_labelInstructionsContent setText:self._tongPiaoInfoModel.useRulesDesc];//strInstructionsContent
    //Label自适应高度
    [_labelInstructionsContent sizeToFit];
    _labelInstructionsContent.frame =  CGRectMake(_labelName.frame.origin.x, _labelInstructions.frame.origin.y+_labelInstructions.frame.size.height+10, _labelDescribe.frame.size.width, _labelInstructionsContent.frame.size.height);
    
    //客服电话
    _labelPhone.frame = CGRectMake(_labelName.frame.origin.x, _labelInstructionsContent.frame.origin.y+_labelInstructionsContent.frame.size.height+30, _labelDescribe.frame.size.width, 12);
    _labelPhone.text = [NSString stringWithFormat:@"客服中心：%@",[Config getConfigInfo:@"movikrPhoneNumber"]];
    
    //有效 & 往期
    if (self._myOrderType == 0)
    {
        //有效
    }
    else
    {
        //往期
        _viewMask.hidden = NO;
        _imageType.hidden = NO;
        //        if ([self._couponInfoModel.couponStatus intValue] == 1)
        //        {
        //            //已兑换
        //            [_imageType setImage:[UIImage imageNamed:@"image_exchange.png"]];
        //        }
        //        else
        //        {
        //已过期
        [_imageType setImage:[UIImage imageNamed:@"image_expired.png"]];
        //        }
    }

    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelPhone.frame.origin.y+_labelPhone.frame.size.height+15);
    //失效的蒙版
    _viewMask.frame = CGRectMake(0, 0, _viewWhiteBg.frame.size.width, _viewWhiteBg.frame.size.height);
    _imageType.frame = CGRectMake(_viewWhiteBg.frame.size.width-15-60, _viewWhiteBg.frame.origin.y+15, 60, 60);
    [_scrollViewWhole setContentSize:CGSizeMake(SCREEN_WIDTH, _viewWhiteBg.frame.size.height+10+50)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
