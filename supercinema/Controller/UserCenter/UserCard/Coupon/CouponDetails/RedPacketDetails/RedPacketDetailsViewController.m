//
//  RedPacketDetailsViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/11/16.
//
//

#import "RedPacketDetailsViewController.h"

@interface RedPacketDetailsViewController ()

@end

@implementation RedPacketDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
    [self initFrameAndData];
}

-(void)initController
{
    self._labelTitle.text = @"红包详情";
    
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
    
    //红包面值
    _labelRedPacketPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelRedPacketPrice setBackgroundColor:[UIColor clearColor]];
    [_labelRedPacketPrice setFont:MKFONT(20)];
    [_labelRedPacketPrice setTextColor:RGBA(249, 81, 81, 1)];
    [_viewWhiteBg addSubview:_labelRedPacketPrice];
    
    //红包名称
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelName];
    
    //剩余label
    _labelLeft = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelLeft.font = MKFONT(12);
    _labelLeft.backgroundColor = [UIColor clearColor];
    _labelLeft.textColor = RGBA(51, 51, 51, 1);
    _labelLeft.numberOfLines = 0;
    _labelLeft.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelLeft];

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
    _labelDate.numberOfLines = 0;//能换行
    _labelDate.lineBreakMode = NSLineBreakByCharWrapping;//能换行
    [_viewWhiteBg addSubview:_labelDate];
    
    //适用影院(自适应)
    _labelCinema = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinema setBackgroundColor:[UIColor clearColor]];
    [_labelCinema setFont:MKFONT(15)];
    [_labelCinema setTextColor:RGBA(51, 51, 51, 1)];
    _labelCinema.text = @"适用影院：";
    [_viewWhiteBg addSubview:_labelCinema];
    
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaName setFont:MKFONT(12)];
    [_labelCinemaName setTextColor:RGBA(102, 102, 102, 1)];
    _labelCinemaName.numberOfLines = 0;
    _labelCinemaName.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelCinemaName];
    
    //查看全部影院按钮
    _btnInquireCinema = [[UIButton alloc] initWithFrame:CGRectZero];
    [_btnInquireCinema setBackgroundColor:[UIColor clearColor]];
    [_btnInquireCinema setTitle:@"查看全部影院" forState:UIControlStateNormal];
    [_btnInquireCinema setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnInquireCinema .titleLabel setFont:MKFONT(12)];
    [_btnInquireCinema addTarget:self action:@selector(onButtonInquireCinema) forControlEvents:UIControlEventTouchUpInside];
    [_viewWhiteBg addSubview:_btnInquireCinema];
    
    //查看影院箭头
    _imageCheckArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageCheckArrow.backgroundColor = [UIColor clearColor];
    [_imageCheckArrow setImage:[UIImage imageNamed:@"image_checkAllCinema_arrow.png"]];
    [_viewWhiteBg addSubview:_imageCheckArrow];
    
    //适用影片
    _labelMovie = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMovie setBackgroundColor:[UIColor clearColor]];
    [_labelMovie setFont:MKFONT(15)];
    [_labelMovie setTextColor:RGBA(51, 51, 51, 1)];
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
    
    //通用标识
    _imageGeneralType = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageGeneralType setBackgroundColor:[UIColor clearColor]];
    [_imageGeneralType setImage:[UIImage imageNamed:@"image_sharing.png"]];
    _imageGeneralType.hidden = YES;
    [_viewWhiteBg addSubview:_imageGeneralType];
    
}

-(void)initFrameAndData
{
    NSLog(@"%@",[self._redPacketModel toJSONString]);
    
    //整体的ScrollView
    _scrollViewWhole.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    //Logo
    _imageLogo.frame = CGRectMake(15, 30, 27, 27);
    [_imageLogo setImage:[UIImage imageNamed:@"image_redPacket.png"]];
    
    //红包面值
    _labelRedPacketPrice.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, 30, 20);
    //_labelRedPacketPrice.text = [NSString stringWithFormat:@"￥%ld",[self._redPacketModel.worth integerValue]/100];
    _labelRedPacketPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:self._redPacketModel.worth]];
    [_labelRedPacketPrice sizeToFit];
    _labelRedPacketPrice.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, _labelRedPacketPrice.frame.size.width, 20);

    //红包名称
    _labelName.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x+_labelRedPacketPrice.frame.size.width+10, 33, SCREEN_WIDTH/2, 15);
    _labelName.text = self._redPacketModel.redPacketName;
    
    
    _labelLeft.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH-15*5-27, 12);
    
    _labelLeft.text = [Tool getRedPacketDetail:self._redPacketModel.redPacketType useLimit:self._redPacketModel.useLimit]; //common:[self._redPacketModel.common boolValue]];
    if ([self._redPacketModel.redPacketType intValue] == 0)
    {
        _labelLeft.text = [_labelLeft.text stringByReplacingOccurrencesOfString:@"。" withString:@"；"];
        if ([self._redPacketModel.movieLimitCount intValue] == 0)
        {
            _labelDescribe.text = @"每部影片使用个数不限。";
        }
        else
        {
            _labelDescribe.text = [NSString stringWithFormat:@"每部影片最多可用%@个。",self._redPacketModel.movieLimitCount];
        }
    }
    //重新计算高度
    [_labelLeft sizeToFit];
    _labelLeft.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH-15*5-27, _labelLeft.frame.size.height);
    
    [_labelDescribe sizeToFit];
    _labelDescribe.frame = CGRectMake(_labelLeft.frame.origin.x, _labelLeft.frame.origin.y+_labelLeft.frame.size.height+5, SCREEN_WIDTH-15*5-27, _labelDescribe.frame.size.height);

    //有效期
    _labelDate.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelDescribe.frame.origin.y+_labelDescribe.frame.size.height+15, _labelDescribe.frame.size.width, 11);
    _labelDate.text = [NSString stringWithFormat:@"有效期：%@至%@",[Tool returnTime:self._redPacketModel.validStartTime format:@"yyyy年MM月dd日"],[Tool returnTime:self._redPacketModel.validEndTime format:@"yyyy年MM月dd日"]];
    [_labelDate sizeToFit];
    _labelDate.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelDescribe.frame.origin.y+_labelDescribe.frame.size.height+15, _labelDescribe.frame.size.width, _labelDate.frame.size.height);
    
    //通用红包标识
    _imageGeneralType.frame = CGRectMake(SCREEN_WIDTH-30-35, _labelDate.frame.origin.y-4, 35, 15);
    
    //通用红包标识显示逻辑
    if ([self._redPacketModel.common boolValue] == 1)
    {
        _imageGeneralType.hidden = NO;
    }
    else
    {
        //false 为不通用
        _imageGeneralType.hidden = YES;
    }
    
    //判断适用影院的高度
    CGFloat fLabelCinemaName;
    //如果适用影院字段不为nil，正常画UI
    if (self._redPacketModel.cinemaNameList != nil)
    {
        //适用影院(自适应)
        _labelCinema.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, _labelDescribe.frame.size.width, 15);
        _labelCinemaName.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelCinema.frame.origin.y+_labelCinema.frame.size.height+10, _labelDescribe.frame.size.width, 12);
        NSArray *arrCinemaName = self._redPacketModel.cinemaNameList;
        NSString* strCinemaName = @"";
        //for循环遍历数组取值
        for (int i = 0; i < arrCinemaName.count; i++)
        {
            NSString* str = arrCinemaName[i];
            //取得最后一个不换行
            if (i == arrCinemaName.count-1)
            {
                NSString* strNew = [NSString stringWithFormat:@"%@",str];
                strCinemaName = [strCinemaName stringByAppendingString:strNew];
            }
            else
            {
                NSString* strNew = [NSString stringWithFormat:@"%@\n",str];
                strCinemaName = [strCinemaName stringByAppendingString:strNew];
            }
        }
        [_labelCinemaName setText:strCinemaName];
        //Label自适应高度
        [_labelCinemaName sizeToFit];
        _labelCinemaName.frame =  CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelCinema.frame.origin.y+_labelCinema.frame.size.height+10, _labelDescribe.frame.size.width, _labelCinemaName.frame.size.height);
        
        //如果适用影院字段不为nil，间距到适用影院
        fLabelCinemaName = _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height;
    }
    else
    {
        //如果适用影院字段为nil，间距到有效期
        fLabelCinemaName = _labelDate.frame.origin.y+_labelDate.frame.size.height;
    }
    
    //显示查看影院的显示间距
    CGFloat fIntervalHeight;
    //查看全部影院显示逻辑
    //如果适用影院个数大于3，显示查看全部影院
    if ([self._redPacketModel.cinemaSize intValue] > 3)
    {
        //查看全部影院
        _btnInquireCinema.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, fLabelCinemaName+13, 74, 12);
        //查看影院箭头
        _imageCheckArrow.frame = CGRectMake(_btnInquireCinema.frame.origin.x+_btnInquireCinema.frame.size.width+5, _btnInquireCinema.frame.origin.y+(_btnInquireCinema.frame.size.height-9)/2, 4.5, 9);
        
        fIntervalHeight = _btnInquireCinema.frame.origin.y+_btnInquireCinema.frame.size.height;
    }
    else
    {
        //适用影院个数不大于3，间距判断
        if (self._redPacketModel.cinemaNameList != nil)
        {
            //如果有适用影院列表，间距到适用影院
            fIntervalHeight = _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height;
        }
        else
        {
            //如果没有适用影院列表，间距到有效期
            fIntervalHeight = _labelDate.frame.origin.y+_labelDate.frame.size.height;
        }
    }

    //适用影片
    if (self._redPacketModel.otherUseLimitList !=nil && self._redPacketModel.otherUseLimitList.count > 0)
    {
        //有使用限制
        if ([self._redPacketModel.hasUseLimit intValue] == 1)
        {
            _labelMovie.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, fIntervalHeight+30, _labelDescribe.frame.size.width, 12);
            //红包类型 0:票红包，3:会员卡红包,4：小卖红包
            if ([self._redPacketModel.redPacketType intValue] == 0)
            {
                //票红包类型
                _labelMovie.text = @"适用影片";
            }
            else if ([self._redPacketModel.redPacketType intValue] == 3)
            {
                //卡红包类型
                _labelMovie.text = @"适用权益";
                
            }
            else if ([self._redPacketModel.redPacketType intValue] == 4)
            {
                //小卖红包类型
                _labelMovie.text = @"适用卖品";
            }
            else
            {
                //其他类型
                _labelMovie.text = @"适用类别";
            }
            _labelMovieName.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelMovie.frame.origin.y+_labelMovie.frame.size.height+10, _labelDescribe.frame.size.width, 12);
            NSArray *arrMovieName = self._redPacketModel.otherUseLimitList;
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
            [_labelMovieName sizeToFit];
            _labelMovieName.frame =  CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelMovie.frame.origin.y+_labelMovie.frame.size.height+10, _labelDescribe.frame.size.width, _labelMovieName.frame.size.height);
            
            //分割线
            _imageLine.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+30, _labelDescribe.frame.size.width, 0.5);
        }
        else
        {
            //没有使用限制
            //分割线
            _imageLine.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, fIntervalHeight+30, _labelDescribe.frame.size.width, 0.5);
        }
    }
    else
    {
        //没有返回适用影片列表 (分割线与适用影院对齐)
        //分割线
        _imageLine.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, fIntervalHeight+30, _labelDescribe.frame.size.width, 0.5);
    }

    //使用说明
    _labelInstructions.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _imageLine.frame.origin.y+_imageLine.frame.size.height+30, _labelDescribe.frame.size.width, 12);
    _labelInstructionsContent.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelInstructions.frame.origin.y+_labelInstructions.frame.size.height+10, _labelDescribe.frame.size.width, 12);
//    NSArray *arrInstructionsContent = @[@"我是使用说明第一行：啊啊四大四大四大四大四大大三大四的第一行",@"使用说明第二行",@"使用说明第三行"];
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
    [_labelInstructionsContent setText:self._redPacketModel.redPacketDescription];//strInstructionsContent
    //Label自适应高度
    [_labelInstructionsContent sizeToFit];
    _labelInstructionsContent.frame =  CGRectMake(_labelRedPacketPrice.frame.origin.x, _labelInstructions.frame.origin.y+_labelInstructions.frame.size.height+10, _labelDescribe.frame.size.width, _labelInstructionsContent.frame.size.height);
    
    //有效 & 往期
    if (self._myOrderType == 0)
    {
        //有效
        if ([self._redPacketModel.activeStatus intValue] == 1)
        {
            //已激活
        }
        else
        {
            //未激活
            _imageType.hidden = NO;
            [_imageType setImage:[UIImage imageNamed:@"image_activeStatus_seal.png"]];
        }
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
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelInstructionsContent.frame.origin.y+_labelInstructionsContent.frame.size.height+30);
    //失效的蒙版
    _viewMask.frame = CGRectMake(0, 0, _viewWhiteBg.frame.size.width, _viewWhiteBg.frame.size.height);
    _imageType.frame = CGRectMake(_viewWhiteBg.frame.size.width-15-60, _viewWhiteBg.frame.origin.y+15, 60, 60);
    [_scrollViewWhole setContentSize:CGSizeMake(SCREEN_WIDTH, _viewWhiteBg.frame.size.height+10+50)];
}

#pragma mark 查看全部影院
-(void)onButtonInquireCinema
{
    if(self._checkAllCinemaView == nil)
    {
        //初始化
        self._checkAllCinemaView = [[CheckAllCinemaView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)redPacketId:self._redPacketModel.redPacketId];
        self._checkAllCinemaView.alpha=0;
        self._checkAllCinemaView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self._checkAllCinemaView.delegate = self;
        [self.view addSubview:self._checkAllCinemaView];
    }
    //弹起View动画
    [self._checkAllCinemaView bouncePopMessageViews];
}

//CheckAllCinemaView继承的代理
-(void)cancelViewAndIsRemove:(BOOL)isRemoveFromSuperview
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self._checkAllCinemaView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         self._checkAllCinemaView.alpha=0;
                         
                     }completion:^(BOOL finish){
                         if (isRemoveFromSuperview)
                         {
                            self._checkAllCinemaView = nil;
                         }
                     }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
