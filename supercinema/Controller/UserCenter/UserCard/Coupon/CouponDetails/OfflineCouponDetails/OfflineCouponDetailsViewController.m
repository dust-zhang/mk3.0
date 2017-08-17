//
//  OfflineCouponDetailsViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/11/16.
//
//

#import "OfflineCouponDetailsViewController.h"

@interface OfflineCouponDetailsViewController ()

@end

@implementation OfflineCouponDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
    [self initFrameAndData];
}

-(void)initController
{
    self._labelTitle.text = @"优惠券详情";
    
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
    
    //领取成功标识
    _imageSuccess = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-15*2-45)/2, 25, 45, 45)];
    _imageSuccess.backgroundColor = [UIColor clearColor];
    [_imageSuccess setImage:[UIImage imageNamed:@"image_exchangeSuccess.png"]];
    _imageSuccess.hidden = YES;
    [_viewWhiteBg addSubview:_imageSuccess];
    
    //提示信息
    _labelPrompt = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelPrompt setBackgroundColor:[UIColor clearColor]];
    [_labelPrompt setFont:MKFONT(12)];
    [_labelPrompt setTextColor:RGBA(123, 122, 152, 1)];
    [_labelPrompt setTextAlignment:NSTextAlignmentCenter];
    [_viewWhiteBg addSubview:_labelPrompt];
    
    //分割线（虚线）
    _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLine setBackgroundColor:[UIColor clearColor]];
    [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewWhiteBg addSubview:_imageLine];
    
    //往期中得使用标识Logo
    _imageType = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageType setBackgroundColor:[UIColor clearColor]];
    _imageType.hidden = YES;
    [_viewWhiteBg addSubview:_imageType];

    //Logo
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageLogo.backgroundColor = [UIColor clearColor];
    [_viewWhiteBg addSubview:_imageLogo];
    
    //优惠券名称
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelName];
    
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
    
    //影院名称
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaName setFont:MKFONT(15)];
    [_labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    _labelCinemaName.numberOfLines = 0;
    _labelCinemaName.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelCinemaName];
    
    //影院地址
    _labelCinemaAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinemaAddress setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaAddress setFont:MKFONT(12)];
    [_labelCinemaAddress setTextColor:RGBA(51, 51, 51, 1)];
    _labelCinemaAddress.numberOfLines = 0;
    _labelCinemaAddress.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelCinemaAddress];
    
    //分割线
    _imageLine1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLine1 setBackgroundColor:[UIColor clearColor]];
    [_imageLine1 setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewWhiteBg addSubview:_imageLine1];
    
/*
    //使用说明
    UILabel *labelInstructions = [[UILabel alloc] initWithFrame:CGRectMake(labelName.frame.origin.x, imageLine1.frame.origin.y+imageLine1.frame.size.height+30, labelDescribe.frame.size.width, 12)];
    [labelInstructions setBackgroundColor:[UIColor clearColor]];
    [labelInstructions setFont:MKFONT(12)];
    [labelInstructions setTextColor:RGBA(51, 51, 51, 1)];
    labelInstructions.text = @"使用说明：";
    [_viewWhiteBg addSubview:labelInstructions];
    
    UILabel *labelInstructionsContent = [[UILabel alloc] initWithFrame:CGRectMake(labelName.frame.origin.x, labelInstructions.frame.origin.y+labelInstructions.frame.size.height+10, labelDescribe.frame.size.width, 12)];
    [labelInstructionsContent setBackgroundColor:[UIColor yellowColor]];
    [labelInstructionsContent setFont:MKFONT(12)];
    [labelInstructionsContent setTextColor:RGBA(102, 102, 102, 1)];
    labelInstructionsContent.numberOfLines = 0;
    labelInstructionsContent.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:labelInstructionsContent];
    
    NSArray *arrInstructionsContent = @[@"我是使用说明第一行：啊啊四大四大四",@"使用说明第二行",@"使用说明第三行"];
    NSString* strInstructionsContent = @"";
    for (int i = 0; i < arrInstructionsContent.count; i++)
    {
        NSString* str = arrInstructionsContent[i];
        //取得最后一个不加符号不换行
        if (i == arrInstructionsContent.count-1)
        {
            NSString* strNew = [NSString stringWithFormat:@"%@",str];
            strInstructionsContent = [strInstructionsContent stringByAppendingString:strNew];
        }
        else
        {
            NSString* strNew = [NSString stringWithFormat:@"%@\n",str];
            strInstructionsContent = [strInstructionsContent stringByAppendingString:strNew];
        }
    }
    [labelInstructionsContent setText:strInstructionsContent];
    
    //Label自适应高度
    CGSize sizeInstructionsContent = [labelInstructionsContent sizeThatFits:CGSizeZero];
    [labelInstructionsContent sizeToFit];
    labelInstructionsContent.frame =  CGRectMake(labelName.frame.origin.x, labelInstructions.frame.origin.y+labelInstructions.frame.size.height+10, labelDescribe.frame.size.width, sizeInstructionsContent.height);
*/
    
    //客服电话
    _labelPhone = [[UILabel alloc] initWithFrame:CGRectZero];
    //CGRectMake(labelName.frame.origin.x, labelInstructionsContent.frame.origin.y+labelInstructionsContent.frame.size.height+30, labelDescribe.frame.size.width, 12)
    [_labelPhone setBackgroundColor:[UIColor clearColor]];
    [_labelPhone setFont:MKFONT(12)];
    [_labelPhone setTextColor:RGBA(123, 122, 152, 1)];
    [_viewWhiteBg addSubview:_labelPhone];
    
    //失效的蒙版
    _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
    _viewMask.backgroundColor = RGBA(255, 255, 255, 0.5);
    _viewMask.hidden = YES;
    [_viewWhiteBg addSubview:_viewMask];
}

-(void)initFrameAndData
{
    //整体的ScrollView
    _scrollViewWhole.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    //有效 & 往期
    if (self._myOrderType == 0)
    {
        //有效
        //显示核销码 & 立即领取 逻辑
        if ([self._couponInfoModel.exchangeType intValue] == 0)
        {
            //领取按钮
            _btnReceive = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-15*4, 40)];
            [_btnReceive setBackgroundColor:RGBA(0, 0, 0, 1)];
            [_btnReceive setTitle:@"立即领取" forState:UIControlStateNormal];
            [_btnReceive setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
            [_btnReceive.titleLabel setFont:MKFONT(15)];//按钮字体大小
            [_btnReceive.layer setCornerRadius:20.f];//按钮设置圆角
            [_btnReceive addTarget:self action:@selector(onButtonReceive) forControlEvents:UIControlEventTouchUpInside];
            [_viewWhiteBg addSubview:_btnReceive];
            
            //提示信息
            _labelPrompt.frame = CGRectMake(0, _btnReceive.frame.origin.y+_btnReceive.frame.size.height+10, SCREEN_WIDTH-15*2, 11);
            _labelPrompt.text =  self._couponInfoModel.exchangeDesc;
        }
        else
        {
            //输入核销码
            //弹起的View
            _contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15*2, 70)];
            _contentSetView.backgroundColor = [UIColor clearColor];//RGBA(255, 255, 255, 1)
            //签名:添加点击事件
            UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleTextExchange:)];
            [tapSingle setNumberOfTapsRequired:1];//点击一次
            tapSingle.cancelsTouchesInView = NO;
            [_contentSetView addGestureRecognizer:tapSingle];
            [_viewWhiteBg addSubview:_contentSetView];
            
            _textField = [[UITextField alloc ] initWithFrame:CGRectMake(0, 0, 0, 0)];
            _textField.delegate = self;
            _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            _textField.backgroundColor = [UIColor clearColor];
            [_contentSetView addSubview:_textField];
            
            //四个输入框线
            _labelTopLine= [[UILabel alloc ] initWithFrame:CGRectMake(posXOffline, 30, editWidthHegiht*4, 1)];
            [_labelTopLine setBackgroundColor:RGBA(204, 204, 204, 1)];
            [_contentSetView addSubview:_labelTopLine];
            
            _labelDownLine= [[UILabel alloc ] initWithFrame:CGRectMake(posXOffline, 70, editWidthHegiht*4, 1)];
            [_labelDownLine setBackgroundColor:RGBA(204, 204, 204, 1)];
            [_contentSetView addSubview:_labelDownLine];
            
            _arrayVerticalLine = [[NSMutableArray alloc ] initWithCapacity:0];
            for(int i = 0 ;i < inputTextCount ;i++)
            {
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posXOffline +editWidthHegiht*i,30,1, editWidthHegiht)];
                lineImageView.backgroundColor = RGBA(204, 204, 204, 1);
                [_contentSetView addSubview:lineImageView];
                [_arrayVerticalLine addObject:lineImageView];
            }
            
            //输入框
            for (int i = 0; i < inputTextCount-1; i++)
            {
                _textFieldCode[i] = [[UILabel alloc] initWithFrame:CGRectMake(posXOffline +editWidthHegiht*i,30,40, editWidthHegiht)];
                [_textFieldCode[i] setTextAlignment:NSTextAlignmentCenter];
                [_textFieldCode[i] setFont:MKFONT(20)];
                [_textFieldCode[i] setBackgroundColor:[UIColor clearColor]];
                [_contentSetView addSubview:_textFieldCode[i]];
            }
            //提示信息
            _labelPrompt.frame = CGRectMake(0, _labelDownLine.frame.origin.y+_labelDownLine.frame.size.height+10, SCREEN_WIDTH-15*2, 11);
//            _labelPrompt.text = @"到影院卖品柜台请工作人员输入4位核销码";
            _labelPrompt.text =  self._couponInfoModel.exchangeDesc;
        }
        //分割线（虚线）
        _imageLine.frame = CGRectMake(15, _labelPrompt.frame.origin.y+_labelPrompt.frame.size.height+15, SCREEN_WIDTH-15*4, 0.5);
        //Logo
        _imageLogo.frame = CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+30, 27, 27);
        
        if ([self._couponInfoModel.couponStatus intValue] == 4 &&
            [self._couponInfoModel.activeStatus intValue] == 0 )
        {
            _imageType.hidden = NO;
            [_imageType setImage:[UIImage imageNamed:@"image_activeStatus_seal.png"]];

            //按钮不可点击 按钮 和 弹起起键盘
            _btnReceive.backgroundColor = RGBA(0, 0, 0, 0.1);
            [_btnReceive setUserInteractionEnabled:NO];
            [_textField setUserInteractionEnabled:NO];
        }
        
//        if ([self._couponInfoModel.activeStatus intValue] == 1)
//        {
//            //已激活
//        }
//        else
//        {
//            //未激活
//            _imageType.hidden = NO;
//            [_imageType setImage:[UIImage imageNamed:@"image_activeStatus_seal.png"]];
//        }
    }
    else
    {
        //往期
        _imageLogo.frame = CGRectMake(15, 30, 27, 27);
        _viewMask.hidden = NO;
        _imageType.hidden = NO;
        if ([self._couponInfoModel.couponStatus intValue] == 1)
        {
            //已兑换
            [_imageType setImage:[UIImage imageNamed:@"image_exchange.png"]];
        }
        else if ([self._couponInfoModel.couponStatus intValue] == 3)
        {
            //已过期
            [_imageType setImage:[UIImage imageNamed:@"image_expired.png"]];
        }
        else if ([self._couponInfoModel.couponStatus intValue] == 4 &&
                 [self._couponInfoModel.activeStatus intValue] == 0 )
        {
            //未激活
            [_imageType setImage:[UIImage imageNamed:@"image_activeStatus_seal.png"]];
        }
        else
        {
            //无图标显示
        }
    }
    
    //Logo
    [_imageLogo setImage:[UIImage imageNamed:@"image_coupon.png"]];
    
    //优惠券名称
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, SCREEN_WIDTH/2, 15);
    _labelName.text = self._couponInfoModel.couponName;
    
    //描述（自适应）
    _labelDescribe.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH-15*5-27, 12);
    _labelDescribe.text = self._couponInfoModel.couponDesc;
    [_labelDescribe sizeToFit];
    _labelDescribe.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH-15*5-27, _labelDescribe.frame.size.height);

    //有效期
    _labelDate.frame = CGRectMake(_labelName.frame.origin.x, _labelDescribe.frame.origin.y+_labelDescribe.frame.size.height+15, _labelDescribe.frame.size.width, 11);
    _labelDate.text = [NSString stringWithFormat:@"有效期：%@至%@",[Tool returnTime:self._couponInfoModel.validStartDate format:@"yyyy年MM月dd日"],[Tool returnTime:self._couponInfoModel.validEndDate format:@"yyyy年MM月dd日"]];
    [_labelDate sizeToFit];
    _labelDate.frame = CGRectMake(_labelName.frame.origin.x, _labelDescribe.frame.origin.y+_labelDescribe.frame.size.height+15, _labelDescribe.frame.size.width, _labelDate.frame.size.height);
    
    //影院名称
    _labelCinemaName.frame = CGRectMake(_labelName.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, _labelDescribe.frame.size.width, 15);
    _labelCinemaName.text = self._couponInfoModel.cinemaName;
    [_labelCinemaName sizeToFit];
    _labelCinemaName.frame = CGRectMake(_labelName.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, _labelDescribe.frame.size.width, _labelCinemaName.frame.size.height);
    
    //影院地址
    _labelCinemaAddress.frame = CGRectMake(_labelName.frame.origin.x, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+10, _labelDescribe.frame.size.width, 12);
    _labelCinemaAddress.text = self._couponInfoModel.cinemaAddress;
    [_labelCinemaAddress sizeToFit];
    _labelCinemaAddress.frame = CGRectMake(_labelName.frame.origin.x, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+10, _labelDescribe.frame.size.width, _labelCinemaAddress.frame.size.height);
    
    //分割线
    _imageLine1.frame = CGRectMake(_labelName.frame.origin.x, _labelCinemaAddress.frame.origin.y+_labelCinemaAddress.frame.size.height+30, _labelDescribe.frame.size.width, 0.5);
    
    //客服电话
    _labelPhone.frame = CGRectMake(_labelName.frame.origin.x, _imageLine1.frame.origin.y+_imageLine1.frame.size.height+30, _labelDescribe.frame.size.width, 12);
    _labelPhone.text = [NSString stringWithFormat:@"客服中心：%@",[Config getConfigInfo:@"movikrPhoneNumber"]];
    
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelPhone.frame.origin.y+_labelPhone.frame.size.height+15);
    //失效的蒙版
    _viewMask.frame = CGRectMake(0, 0, _viewWhiteBg.frame.size.width, _viewWhiteBg.frame.size.height);
    _imageType.frame = CGRectMake(_viewWhiteBg.frame.size.width-15-60, _viewWhiteBg.frame.origin.y+15, 60, 60);
    [_scrollViewWhole setContentSize:CGSizeMake(SCREEN_WIDTH, _viewWhiteBg.frame.size.height+10+50)];
}

#pragma mark 点击领取
-(void)onButtonReceive
{
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"是否核销？" message:@"" sureBtn:@"是" cancleBtn:@"否"];
    alertView.resultIndex = ^(NSInteger index)
    {
        NSLog(@"%ld",(long)index);
        if (index == 2)
        {
            __weak OfflineCouponDetailsViewController *weakself = self;
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
            [ServicesOrder userCouponNew:self._couponInfoModel.couponId couponType:self._commonListModel.dataType userCode:nil model:^(RequestResult *model)
             {
                 //领取成功
                 [self receiveSuccessIsType:0];
                 [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
                 
             } failure:^(NSError *error) {
                 [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
                 [Tool showWarningTip:error.domain time:1];
                 
             }];
        }
    };
    [alertView showMKPAlertView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击是 进行兑换
    if (buttonIndex == 1)
    {
        __weak OfflineCouponDetailsViewController *weakself = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
        [ServicesOrder userCouponNew:self._couponInfoModel.couponId couponType:self._commonListModel.dataType userCode:nil model:^(RequestResult *model)
         {
             //领取成功
             [self receiveSuccessIsType:0];
             [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
             
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
             [Tool showWarningTip:error.domain time:1];
             
         }];
    }
}

#pragma mark 点击进行输入
-(void)tapSingleTextExchange:(UITapGestureRecognizer *)sender
{
   [MobClick event:myCenterViewbtn40];
   [_textField becomeFirstResponder];
}

-(void)textChange:(UITextField *)textField
{
    if ([_textField.text length] >= 4)
    {
        [_textField resignFirstResponder];
        
        __weak OfflineCouponDetailsViewController *weakself = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
        [ServicesOrder userCouponNew:self._couponInfoModel.couponId couponType:self._commonListModel.dataType userCode:_textField.text model:^(RequestResult *model)
        {
            //领取成功
            [self receiveSuccessIsType:1];
            [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
            
        } failure:^(NSError *error) {
            [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
            
            [Tool showWarningTip:error.domain time:1];
            [weakself resetCodeText];
        }];
    }
}

//领取成功
-(void)receiveSuccessIsType:(int)isType
{
    if (isType == 0)
    {
        //按钮
        _btnReceive.hidden = YES;
    }
    else
    {
        //输入框
        _contentSetView.hidden = YES;
    }
    _isReceiveSuccess = TRUE;
    _imageSuccess.hidden = NO; //显示成功
    [_labelPrompt setFont:MKFONT(15)];
    [_labelPrompt setTextColor:RGBA(117, 112, 255, 1)];
    _labelPrompt.text = @"领取成功";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        [self setDeleteCodeText:textField.text.length text:string];
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 4)
    {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    else
    {
        [self setSetCodeText:textField.text.length text:string];
        return YES;
    }
}

- (void)setSetCodeText:(NSInteger)count text:(NSString *)textNum
{
    textNum = @"●";
    [_textFieldCode[count] setText:textNum ];
}

- (void)setDeleteCodeText:(NSInteger)count text:(NSString *)textNum
{
    [_textFieldCode[count-1] setText:textNum];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

#pragma mark 清空核销码
-(void) resetCodeText
{
    _textField.text = @"";
    for (int i = 0; i < inputTextCount-1; i++)
    {
        _textFieldCode[i].text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
