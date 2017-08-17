//
//  RegisterView.m
//  movikr
//
//  Created by zeyuan on 15/5/12.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: RGBA(246, 246, 251,1)];
    _longitude = @"";
    _latitude = @"";
    [self getLocalCoordinate];
    
    [self initCtrl];
}

//渲染UI
-(void)initCtrl
{
    //设置Top
    self._viewTop.backgroundColor = [UIColor clearColor];
    [self._labelLine setHidden:YES];
    //手机号码
    UIView *viewUserNameBG = [[UIView alloc] initWithFrame:CGRectMake(15, 130, SCREEN_WIDTH-30, 40)];
    [viewUserNameBG.layer setCornerRadius:20];
    [viewUserNameBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewUserNameBG];
    
    _textUserName = [[ExUITextView alloc] initWithFrame:CGRectMake(10, 0, viewUserNameBG.frame.size.width-20, 40)];
    [_textUserName.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textUserName.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    _textUserName.myTextField.contentVerticalAlignment = 0;
    [_textUserName.myTextField setFont:MKFONT(15)];
    _textUserName.tfDelegate = self;
    [_textUserName.myTextField setPlaceholder:@"输入11位手机号"];
    [_textUserName.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    _textUserName.myTextField.delegate = self;
    _textUserName.myTextField.tag = 0;
    _textUserName.myTextField.borderStyle = UITextBorderStyleNone;
    _textUserName.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _textUserName.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textUserName.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserName.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewUserNameBG addSubview:_textUserName];
    
    //密码
    UIView *viewUserPwdBG = [[UIView alloc] initWithFrame:CGRectMake(15, viewUserNameBG.frame.origin.y+viewUserNameBG.frame.size.height+15, SCREEN_WIDTH-30, 40)];
    [viewUserPwdBG.layer setCornerRadius:20];
    [viewUserPwdBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewUserPwdBG];
    
    _textUserPwd=[[ExUITextView alloc] initWithFrame:CGRectMake(10, 0, viewUserPwdBG.frame.size.width-53, 40)];
    _textUserPwd.myTextField.backgroundColor = [UIColor clearColor];
    [_textUserPwd.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    _textUserPwd.myTextField.contentVerticalAlignment = 0;
    [_textUserPwd.myTextField setFont:MKFONT(15)];
    _textUserPwd.tfDelegate = self;
    _textUserPwd.myTextField.placeholder = @"输入6-12位密码";
    [_textUserPwd.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    _textUserPwd.myTextField.borderStyle = UITextBorderStyleNone;
    _textUserPwd.myTextField.tag = 2;
    _textUserPwd.myTextField.secureTextEntry = YES;
    _textUserPwd.myTextField.delegate = self;
//_textUserPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textUserPwd.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewUserPwdBG addSubview:_textUserPwd];
    
    //显示密码按钮
    UIButton *btnPwdShow = [[UIButton alloc] initWithFrame:CGRectMake(_textUserPwd.btnDelete.frame.origin.x+_textUserPwd.btnDelete.frame.size.width+24, _textUserPwd.btnDelete.frame.origin.y, 32/2, 32/2)];
    [btnPwdShow setImage:[UIImage imageNamed:@"btn_hidepwd.png"] forState:UIControlStateNormal];
    [btnPwdShow addTarget:self action:@selector(onButtonPwdShow:) forControlEvents:UIControlEventTouchUpInside];
    [viewUserPwdBG addSubview:btnPwdShow];
    
    //验证码
    UIView *viewCheckCode = [[UIView alloc] initWithFrame:CGRectMake(15, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+15, viewUserPwdBG.frame.size.width, 40)];
    [viewCheckCode.layer setCornerRadius:20];
    [viewCheckCode setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewCheckCode];
    
    _textCheckCode = [[ExUITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-25-15-5-50-10-1-10-50-15, 40)];
    [_textCheckCode.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textCheckCode.myTextField setTextColor:RGBA(51, 51, 51, 1)];
//    _textCheckCode.tfDelegate = self;
    [_textCheckCode.myTextField setPlaceholder:@"输入验证码"];
    [_textCheckCode.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textCheckCode.myTextField setFont:MKFONT(15) ];
    _textCheckCode.myTextField.contentVerticalAlignment = 0;
    _textCheckCode.myTextField.delegate = self;
    _textCheckCode.myTextField.tag = 1;
    _textCheckCode.myTextField.borderStyle = UITextBorderStyleNone;
    _textCheckCode.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_textCheckCode.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textCheckCode.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewCheckCode addSubview:_textCheckCode];
    
    //验证码按钮
    //语音获取按钮
    _btnVoiceCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _btnVoiceCode.frame = CGRectMake(_textCheckCode.frame.origin.x+_textCheckCode.frame.size.width+10,17/2, 50, 23);
    [_btnVoiceCode setBackgroundColor:[UIColor clearColor]];
    [_btnVoiceCode setTitle:@"语音获取" forState:UIControlStateNormal];
    [_btnVoiceCode.titleLabel setFont:MKBOLDFONT(12)];
    [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnVoiceCode addTarget:self action:@selector(onButtongetVoiceCode:) forControlEvents:UIControlEventTouchUpInside];
    _btnVoiceCode.tag = 2;
    [viewCheckCode addSubview:_btnVoiceCode];
    [_btnVoiceCode setEnabled:NO];
    
    //分割线
    _labelDivisionLine = [[UILabel alloc] initWithFrame:CGRectMake(_btnVoiceCode.frame.origin.x+_btnVoiceCode.frame.size.width+10, 29/2, 1, 11)];
    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1)];
    [viewCheckCode addSubview:_labelDivisionLine];
    
    //短信获取按钮
    _btnCheckCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _btnCheckCode.frame = CGRectMake(_labelDivisionLine.frame.size.width+_labelDivisionLine.frame.origin.x+10,17/2, 50, 23);
    [_btnCheckCode setBackgroundColor:[UIColor clearColor]];
    [_btnCheckCode setTitle:@"短信获取" forState:UIControlStateNormal];
    [_btnCheckCode.titleLabel setFont:MKBOLDFONT(12)];
    [_btnCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnCheckCode addTarget:self action:@selector(onButtongetCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    _btnCheckCode.tag = 1;
    [viewCheckCode addSubview:_btnCheckCode];
    [_btnCheckCode setEnabled:NO];
    
    //注册按钮
    _btnRegister = [[BFPaperButton alloc] initWithFrame:CGRectMake(15, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+(IPhone5?75:115), SCREEN_WIDTH-30,40)];
    [_btnRegister setBackgroundColor:RGBA(180, 180, 180, 1)];
    [_btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [_btnRegister.titleLabel setFont:MKBOLDFONT(17)];
    [_btnRegister.layer setCornerRadius:20];
    _btnRegister.shadowColor = [UIColor clearColor];
    _btnRegister.tapCircleColor = RGBA(147, 214, 41, 1);
    _btnRegister.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    [_btnRegister addTarget:self action:@selector(onButtonRegisterSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRegister];
    [_btnRegister setEnabled:NO];
    
    CGFloat leftRight;
    CGFloat space;
    CGFloat spaceUpDown;
    spaceUpDown = IPhone4 ? 10 : 29;
    if (SCREEN_WIDTH > 320)
    {
        space = 75;
    }
    else
    {
        space = 40;
    }
    leftRight = (SCREEN_WIDTH-space*2-50*3)/2;
    
    //使用协议
    UILabel *labelContractName = [[UILabel alloc] initWithFrame:CGRectMake(15, _btnRegister.frame.origin.y+_btnRegister.frame.size.height+10, 125, 12)];
    [labelContractName setFont:MKFONT(12)];
    [labelContractName setTextColor:RGBA(180, 180, 180, 1)];
    [labelContractName setBackgroundColor:[UIColor clearColor]];
    [labelContractName setTextAlignment:NSTextAlignmentLeft];
    [labelContractName setText:@"注册或登录代表你同意"];
    [self.view addSubview:labelContractName];
    //使用协议按钮
    UIButton *btnContractName = [[UIButton alloc] initWithFrame:CGRectMake(labelContractName.frame.origin.x+labelContractName.frame.size.width, labelContractName.frame.origin.y, 165, 12)];
    btnContractName.backgroundColor = [UIColor clearColor];
    [btnContractName.titleLabel setFont:MKFONT(12)];
    [btnContractName setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [btnContractName setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateHighlighted];
    [btnContractName setTitle:@"《超级电影院软件使用协议》" forState:UIControlStateNormal];
    [btnContractName addTarget:self action:@selector(onButtonContract:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContractName];
    
    int lineHeight = 0;
    if (IPhone5)
    {
        lineHeight = 63.5;
    }
    else
    {
        lineHeight = 103.5;
    }
    
    UILabel *labelLineLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, labelContractName.frame.origin.y+labelContractName.frame.size.height+lineHeight+5, (SCREEN_WIDTH-143)/2, 1)];
    labelLineLeft.backgroundColor = RGBA(233, 233, 238, 1);
    [self.view addSubview:labelLineLeft];
    
    //分割线说明
    UILabel *labelLineName = [[UILabel alloc] initWithFrame:CGRectMake(labelLineLeft.frame.origin.x+labelLineLeft.frame.size.width+15, labelContractName.frame.origin.y+labelContractName.frame.size.height+lineHeight-3, SCREEN_WIDTH, 14)];
    labelLineName.backgroundColor = [UIColor clearColor];
    [labelLineName setTextAlignment:NSTextAlignmentCenter];//文字居中对齐
    [labelLineName setTextColor:RGBA(85, 85, 85, 1)];
    [labelLineName setFont:MKFONT(14)];
    [labelLineName setText:@"其他登录方式"];
    [self.view addSubview:labelLineName];
    [labelLineName sizeToFit];
    
    UILabel *labelLine2 = [[UILabel alloc] initWithFrame:CGRectMake(labelLineName.frame.origin.x+labelLineName.frame.size.width+15, labelLineLeft.frame.origin.y, labelLineLeft.frame.size.width, labelLineLeft.frame.size.height)];
    labelLine2.backgroundColor = RGBA(233, 233, 238, 1);
    [self.view addSubview:labelLine2];
    
    //QQ登录
    _btnQQLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnQQLogin.frame = CGRectMake(137/2, labelLineName.frame.origin.y+labelLineName.frame.size.height+spaceUpDown, 76/2, 76/2);
    [_btnQQLogin setBackgroundImage:[UIImage imageNamed:@"btn_qq.png"] forState:UIControlStateNormal];
    [_btnQQLogin addTarget:self action:@selector(authorizeQQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnQQLogin];
    
    //微信登录
    _btnWeixinLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnWeixinLogin.frame = CGRectMake(_btnQQLogin.frame.origin.x+_btnQQLogin.frame.size.width+(SCREEN_WIDTH-(76/2*3)-137)/2, labelLineName.frame.origin.y+labelLineName.frame.size.height+spaceUpDown, 76/2, 76/2);
    [_btnWeixinLogin setBackgroundImage:[UIImage imageNamed:@"btn_weixin.png"] forState:UIControlStateNormal];
    [_btnWeixinLogin addTarget:self action:@selector(authorizeWeixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnWeixinLogin];
    
    //微博登录
    _btnWeiboLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnWeiboLogin.frame = CGRectMake(_btnWeixinLogin.frame.origin.x+_btnWeixinLogin.frame.size.width+(SCREEN_WIDTH-(76/2*3)-137)/2, labelLineName.frame.origin.y+labelLineName.frame.size.height+spaceUpDown, 76/2, 76/2);
    [_btnWeiboLogin setBackgroundImage:[UIImage imageNamed:@"btn_weibo.png"] forState:UIControlStateNormal];
    [_btnWeiboLogin addTarget:self action:@selector(authorizeWeiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnWeiboLogin];

    
    if (![WXApi isWXAppInstalled])
    {
        _btnWeixinLogin.hidden = YES;
    }
}

-(void)backgroundLogin
{
    if (_btnWeixinLogin)
    {
        if (![WXApi isWXAppInstalled])
        {
            _btnWeixinLogin.hidden = YES;
        }
        else
        {
            _btnWeixinLogin.hidden = NO;
        }
    }
}

//微博登录
-(void)authorizeWeiboLogin
{
    [MobClick event:registerViewbtn6];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView weiboThirdLogin];
}

//QQ登录
-(void)authorizeQQLogin
{
    [MobClick event:registerViewbtn5];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView QQLogin];
}

//微信登录
-(void)authorizeWeixinLogin
{
    [MobClick event:registerViewbtn4];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView weixinLogin];
}

#pragma mark 第三方登录回调
-(void)thirdLoginSucceed:(NSString*)token unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus
{
     __weak __typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"授权登录中" withBlur:NO allowTap:NO];
    [ServicesUser checkThirdLoginData:token unionId:unionId loginType:loginType authorizeStatus:authorizeStatus
                            longitude:_longitude latitude:_latitude model:^(RequestResult *headModel)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
         [Config saveUserId:[headModel.loginResult.userId stringValue]];
         [Config saveCredential:headModel.loginResult.credential];
         [Config saveUserType:[headModel.loginResult.passportType stringValue]];
         [Config saveLoginState:@"YES"];
         [Config saveIsFirstStartUp:@"YES"];
//         [weakSelf performSelector:@selector(toMain) withObject:nil afterDelay:0.8];
         [Tool showSuccessTip:@"登录成功" time:1 ];
         //通知登录成功
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_USERCENTER object:nil];
         //如果是随便逛逛点击登陆，并且该用户没有默认cinemaID
         if ([weakSelf._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [[Config getCinemaId] intValue] <=0)
         {
             //跳转回随便逛逛
             [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
             return;
         }
         //如果是随便逛逛点击登录，则返回到首页
         if ([weakSelf._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [headModel.loginResult.cinemaId intValue] > 0)
         {
             //保存影院ID
             [Config saveCinemaId:[headModel.loginResult.cinemaId stringValue]];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex: ([weakSelf.navigationController.viewControllers count] -3)] animated:YES];
         }
     } failure:^(NSError *error){
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
         [Tool showWarningTip:error.domain  time:2];
     }];
}

-(void)thirdLoginFailed
{
    
}

-(void)touchUpCloseShare
{
    
}

-(void)thirdLoginByWeb
{
    //获取第三方网页登录url
}

//显示密码
-(void)onButtonPwdShow:(UIButton *)btn
{
    if (isPwdShow)
    {
        //密码不显示
        _textUserPwd.myTextField.secureTextEntry = YES;
        isPwdShow = NO;
        [btn setImage:[UIImage imageNamed:@"btn_hidepwd.png"] forState:UIControlStateNormal];
    }
    else
    {
        //密码显示
        _textUserPwd.myTextField.secureTextEntry = NO;
        isPwdShow = YES;
        [btn setImage:[UIImage imageNamed:@"btn_showpwd.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 获取语音验证码
-(void)onButtongetVoiceCode:(JKCountDownButton *)sender
{
    [MobClick event:registerViewbtn8];
    [self hideButton];
    
    if (_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text] )
    {
        [self showButton];
        [Tool showWarningTip:@"您输入的手机号不对哦~" time:2.0f];
        return;
    }
    
    [self onSendSms:sender];
}

#pragma mark 获取短信验证码
-(void)onButtongetCheckCode:(JKCountDownButton *)sender
{
//    [MobClick event:myCenterViewbtn96];
    [self hideButton];
    [self HideKeyboard];
    if (_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text] )
    {
        [self showButton];
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:2.0f];
        return ;
    }
    
    [self onSendSms:sender];
}

//发送验证码
-(void)onSendSms:(JKCountDownButton *)sender
{
    [MobClick event:registerViewbtn2];
    [sender setEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser sendSms:_textUserName.myTextField.text reason:@"REG" longitude:_longitude latitude:_latitude smsType:[NSNumber numberWithInteger:sender.tag] model:^(SendSmsModel *sendSmsModel)
    {
        [Tool showSuccessTip:sendSmsModel.respMsg  time:2.0f];
        
        isUserExist = [sendSmsModel.userIsExist boolValue];
        [weakSelf updateButtonState:sender];
    
    } failure:^(NSError *error) {
        [weakSelf showButton];
//        [Tool showWarningTip:error.domain  time:2.0f];
        if ([error.domain isEqualToString:@"该手机号已经注册过啦"])
        {
            //手机号已注册，弹出提示
            [weakSelf isRegistered];
        }
        else
        {
            [Tool showWarningTip:error.domain  time:2.0f];
        }
    }];
}

#pragma mark 手机号已注册，弹出提示
-(void)isRegistered
{
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"该手机号已经注册，是否去登录" message:@"" sureBtn:@"确定" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index)
    {
        if (index == 2)
        {
            //点击确认页面回到登录页
            [self setUserNameText:_textUserName.myTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (index == 1)
        {
            //点击取消，清空手机号
            _textUserName.myTextField.text = nil;
            _textUserName.btnDelete.hidden = YES;
        }
    };
    [alertView showMKPAlertView];
    
}

-(void)setUserNameText:(NSString *)userNameText
{
    if ([self.registerViewDelegate respondsToSelector:@selector(userNameText:)])
    {
        [self.registerViewDelegate userNameText:userNameText];
    }
}

-(void)updateButtonState:(JKCountDownButton *)sender
{
    //短信验证码
    if (sender.tag == 1)
    {
        [sender setTitle:@"       60s" forState:UIControlStateNormal];
        
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *button,int second)
         {
             [_btnCheckCode setTitleColor:RGBA(194, 194, 194, 1) forState:UIControlStateNormal];
             NSString *title = [NSString stringWithFormat:@"       %ds",second];
             return title;
         }];
        
        __weak typeof(self) weakSelf = self;
        [sender didFinished:^NSString *(JKCountDownButton *button, int second)
         {
             [weakSelf showButton];
             return @"短信获取";
         }];
    }
    
    //语音验证码
    if (sender.tag == 2)
    {
        [_btnCheckCode setTitleColor:RGBA(194, 194, 194, 1) forState:UIControlStateNormal];
        [_btnCheckCode setTitle:@"       60s" forState:UIControlStateNormal];
        [_btnCheckCode startWithSecond:60];
        
        [_btnCheckCode didChange:^NSString *(JKCountDownButton *button,int second)
         {
             NSString *title = [NSString stringWithFormat:@"       %ds",second];
             return title;
         }];
        
        __weak typeof(self) weakSelf = self;
        [_btnCheckCode didFinished:^NSString *(JKCountDownButton *button, int second)
         {
             [weakSelf showButton];
             return @"语音获取";
         }];
    }
}

-(void) showButton
{
    [_btnVoiceCode setTitle:@"语音获取" forState:UIControlStateNormal];
    [_btnVoiceCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:YES];
    
    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
    [_labelDivisionLine setHidden:NO];
    
    [_btnCheckCode setTitle:@"短信获取" forState:UIControlStateNormal];
    [_btnCheckCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnCheckCode setEnabled:YES];
}

-(void) hideButton
{
    [_btnVoiceCode setTitle:@"" forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:NO];
    
    [_labelDivisionLine setHidden:YES];
    
    [_btnCheckCode setTitle:@"" forState:UIControlStateNormal];
    [_btnCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnCheckCode setEnabled:NO];
}

#pragma mark 输入内容校验
-(BOOL) inputTextCheck
{
    NSLog(@"%@",_textCheckCode.myTextField.text);
    if (_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text] )
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:2.0f];
        return FALSE;
    }
    if(_textCheckCode.myTextField.text.length == 0)
    {
        [Tool showWarningTip:@"请输入4位短信验证码"  time:2.0f];
         return FALSE;
    }
    if(_textUserPwd.myTextField.text.length < 6 || _textUserPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"请输入6-12位密码"  time:2.0f];
        return FALSE;
    }
    
    return TRUE;
}

//提交注册信息
-(void)onButtonRegisterSubmit
{
    [MobClick event:registerViewbtn1];
    //隐藏虚拟键盘
    [self HideKeyboard];
    
    if ([self inputTextCheck ])
    {
        __weak typeof(self) weakself = self;
        [ServicesUser userRegister:_textUserName.myTextField.text smsCode:_textCheckCode.myTextField.text passwd:_textUserPwd.myTextField.text longitude:_longitude latitude:_latitude model:^(RequestResult *model)
         {
             [FVCustomAlertView hideAlertFromView:weakself.view fading:NO];
             //注册成功，跳转注册详情
             if ([model.loginResult.credential length] > 0)
             {
                 //刷新福利社
                 [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHGAME object:nil];
                 [Config saveCredential:model.loginResult.credential];
                 [Config saveUserType:[model.loginResult.passportType stringValue]];
                 [Config saveUserId:[model.loginResult.userId stringValue]];
                 [Config saveLoginState:@"YES"];
                 [Tool showSuccessTip:model.respMsg  time:0.8];
                 [weakself performSelector:@selector(toMain) withObject:nil afterDelay:0.8];
             }
             else
             {
                 [weakself loginRequire];
             }
             
         } failure:^( NSError *error) {
             [Tool showWarningTip:error.domain  time:2.0f];
         }];
    }
}

//跳转到主页
-(void)toMain
{
    //如果是随便逛逛点击登陆，并且该用户没有默认cinemaID
    if ([self._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [[Config getCinemaId] intValue] <=0)
    {
        //跳转回随便逛逛
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//点击屏幕离开事件
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

//隐藏系统键盘
-(void) HideKeyboard
{
    [_textUserName.myTextField resignFirstResponder];
    [_textUserPwd.myTextField resignFirstResponder];
    [_textCheckCode.myTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboard];
    return YES;
}

//打开使用协议
-(void)onButtonContract:(UIButton *)sender
{
    [MobClick event:registerViewbtn3];
    [self HideKeyboard];
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesSystem getProtocolContent:^(NSString *protocolContent)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [self createContractView:protocolContent];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:2];
         
     }];
}

-(void)createContractView:(NSString *) proctrolText
{
    if(!_contractView)
    {
        _contractView = [[ContractView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) str:proctrolText];
        _contractView.backgroundColor = [UIColor clearColor];
        _contractView.hidden=YES;
        _contractView.alpha=0;
        _contractView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self.view addSubview:_contractView];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contractView.transform = CGAffineTransformMakeScale(1, 1);
                         _contractView.hidden=NO;
                         _contractView.alpha=1;
                     }completion:^(BOOL finish){
                     }];
}

//关闭使用协议
-(void)closeContractView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contractView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         _contractView.alpha = 0;
                     }completion:^(BOOL finish){
                         [_contractView removeFromSuperview];
                         _contractView = nil;
                     }];
}

//获取登录key成功后请求登录
-(void)loginRequire
{
    [ServicesUser requestLogin:_textUserName.myTextField.text code:^(NSString *nonce)
     {
         [self loginSubmit:nonce];
         
     } failure:^(NSError *error) {
         
         NSString* strMsg =error.domain;
         [Tool showWarningTip:strMsg  time:1.0f];
         [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:requestErrorTip withBlur:NO allowTap:YES];
     }];
}

//登录提交
-(void)loginSubmit:(NSString *)nonce
{
    NSString *userPwd = [Tool xor:_textUserPwd.myTextField.text key:nonce];
    __weak typeof(self) weakSelf = self;
    [ServicesUser login:_textUserName.myTextField.text pwd:userPwd longitude:_longitude latitude:_latitude code:^(RequestResult *model)
     {
         [Config saveUserName:_textUserName.myTextField.text];
         [Config saveCredential:model.loginResult.credential];
         [Config saveUserType:[model.loginResult.passportType stringValue]];
         [Config saveLoginState:@"YES"];
         [Config saveUserId:[model.loginResult.userId stringValue]];
         //保存影院ID
         if ([[Config getCinemaId] intValue] == 0)
         {
             [Config saveCinemaId:[model.loginResult.cinemaId stringValue]];
         }
         [Config saveIsFirstStartUp:@"YES"];
         [Tool showSuccessTip:@"登录成功"  time:1 ];
         //如果是随便逛逛点击登陆，并且该用户没有默认cinemaID
         if ([weakSelf._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [[Config getCinemaId] intValue] <=0)
         {
             //跳转回随便逛逛
             [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
             return;
         }
         //通知登录成功
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_USERCENTER object:nil];
         //刷新福利社
         [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHGAME object:nil];
         //如果是随便逛逛点击登录，则返回到首页
         if ([weakSelf._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [model.loginResult.cinemaId intValue] > 0)
         {
             //保存影院ID
             [Config saveCinemaId:[model.loginResult.cinemaId stringValue]];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex: ([weakSelf.navigationController.viewControllers count] -3)] animated:YES];
         }
     } failure:^(NSError *error) {
         [Tool showWarningTip:@"用户名或密码错误" time:1];
     }];
}


-(void)showHide:(UIView*)view
{
    ExUITextView* exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
   
    [_btnRegister setBackgroundColor:RGBA(180, 180, 180, 1)];
    [_btnRegister setEnabled:NO];
    
    
    [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:YES];
    
    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
    
    [_btnCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnCheckCode setEnabled:YES];
}

-(void)textFiledDidBegin:(UITextField*)textField
{
    if (textField == _textUserName.myTextField && _textUserName.myTextField.text.length>0)
    {
        _textUserName.btnDelete.hidden = NO;
    }
    else
    {
        _textUserName.btnDelete.hidden = YES;
    }
    
    if (textField == _textUserPwd.myTextField && _textUserPwd.myTextField.text.length>0)
    {
        _textUserPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textUserPwd.btnDelete.hidden = YES;
    }
    
//    if (textField == _textCheckCode.myTextField && _textCheckCode.myTextField.text.length>0)
//    {
//        _textCheckCode.btnDelete.hidden = NO;
//    }
//    else
//    {
//        _textCheckCode.btnDelete.hidden = YES;
//    }
}

-(void)textFiledValueChange:(UITextField*)textField
{
    if (textField == _textUserName.myTextField && _textUserName.myTextField.text.length>0)
    {
        _textUserName.btnDelete.hidden = NO;
    }
    else
    {
        _textUserName.btnDelete.hidden = YES;
    }
    
    if (textField == _textUserPwd.myTextField && _textUserPwd.myTextField.text.length>0)
    {
        _textUserPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textUserPwd.btnDelete.hidden = YES;
    }
    
//    if (textField == _textCheckCode.myTextField && _textCheckCode.myTextField.text.length>0)
//    {
//        _textCheckCode.btnDelete.hidden = NO;
//    }
//    else
//    {
//        _textCheckCode.btnDelete.hidden = YES;
//    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position) {
            return;
        }
    }
    
    int maxLength = 0;
    if (textField == _textUserName.myTextField && textField.text.length > 11)
    {
        maxLength = 11;
        [Tool showWarningTip:@"手机号不能超过11位"  time:0.5];
    }
    else if(textField == _textCheckCode.myTextField && textField.text.length >4)
    {
        maxLength = 4;
        [Tool showWarningTip:@"短信验证码不能超过4位"  time:0.5];
    }
    else if(textField == _textUserPwd.myTextField && textField.text.length >12)
    {
        maxLength = 12;
        [Tool showWarningTip:@"密码不能超过12位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    
    //如果手机号正常 则获取验证码可用
    if (textField == _textUserName.myTextField && textField.text.length == 11)
    {
        [_btnVoiceCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [_btnVoiceCode setEnabled:YES];
        
        [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
        
        [_btnCheckCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [_btnCheckCode setEnabled:YES];
    }

//    if (_textUserPwd.myTextField.text.length>5 && _textUserName.myTextField.text.length == 11)
//    {
//        [_btnVoiceCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
//        [_btnVoiceCode setEnabled:YES];
//        
//        [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
//        
//        [_btnCheckCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
//        [_btnCheckCode setEnabled:YES];
//    }
//    else
//    {
//        [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
//        [_btnVoiceCode setEnabled:YES];
//        
//        [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
//        
//        [_btnCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
//        [_btnCheckCode setEnabled:YES];
//    }
    
    
    if (_textUserName.myTextField.text.length == 11 && _textCheckCode.myTextField.text.length == 4 && _textUserPwd.myTextField.text.length > 0 )
    {
        [_btnRegister setBackgroundColor:RGBA(0, 0, 0, 1)];
        [_btnRegister setEnabled:YES];
    }
    
    if (_textUserName.myTextField.text.length == 0 || _textCheckCode.myTextField.text.length == 0 ||  _textUserPwd.myTextField.text.length == 0 )
    {
        [_btnRegister setBackgroundColor:RGBA(180, 180, 180, 1)];
        [_btnRegister setEnabled:NO];
    }
    
   
}

//返回
-(void)onButtonBack
{
    [MobClick event:registerViewbtn7];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位获取本地坐标
-(void)getLocalCoordinate
{
    if (!self._locationMgr)
    {
        //定位功能可用，开始定位
        self._locationMgr = [[CLLocationManager alloc] init];
        self._locationMgr.delegate = self;
        // 设置定位精度
        self._locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
        self._locationMgr.distanceFilter = 100.0f;
        if(SYSTEMVERSION >= 8)
        {
            [self._locationMgr requestWhenInUseAuthorization];
        }
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled])
    {
        if (status != kCLAuthorizationStatusDenied)
        {
            [self._locationMgr startUpdatingLocation];
        }
    }
}

#pragma mark - 获取定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self._locationMgr stopUpdatingLocation];
    CLLocation *cl = [locations objectAtIndex:0];
    self._localCoordinate = cl.coordinate;
    
    _longitude = [NSString stringWithFormat:@"%f",self._localCoordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",self._localCoordinate.latitude];
}


// 获取定位失败回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self._locationMgr stopUpdatingLocation];
    self._locationMgr = nil;
}


@end
