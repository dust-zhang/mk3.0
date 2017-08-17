//
//  FindPasswordViewController.m
//  movikr
//
//  Created by zeyuan on 15/6/2.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: RGBA(246, 246, 251,1)];
    _longitude = @"";
    _latitude = @"";
    isFirst = FALSE;
    
    [self getLocalCoordinate];
    
    [self initCtrl];
}

//渲染UI
-(void)initCtrl
{
    //设置Top
    self._viewTop.backgroundColor = [UIColor clearColor];
    self._labelLine.hidden = YES;
    
    //手机号码
    UIView *viewUserNameBG = [[UIView alloc] initWithFrame:CGRectMake(15, 130, SCREEN_WIDTH-30, 40)];
    [viewUserNameBG.layer setCornerRadius:20];
    [viewUserNameBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewUserNameBG];
    
    _textUserName = [[ExUITextView alloc] initWithFrame:CGRectMake(15, 0, viewUserNameBG.frame.size.width-30, 40)];
    [_textUserName.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textUserName.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    [_textUserName.myTextField setPlaceholder:@" 输入11位手机号"];
    [_textUserName.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textUserName.myTextField setFont:MKFONT(15)];
    _textUserName.myTextField.contentVerticalAlignment = 0;
    _textUserName.tfDelegate = self;
    _textUserName.tag = 0;
    _textUserName.myTextField.borderStyle = UITextBorderStyleNone;
    _textUserName.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _textUserName.myTextField.returnKeyType = UIReturnKeyDefault;
    if (self._userName)
    {
        _textUserName.myTextField.text = self._userName;
        _textUserName.btnDelete.hidden = NO;
    }
    [_textUserName.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserName.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewUserNameBG addSubview:_textUserName];
    
    //验证码
    UIView *viewCheckCode = [[UIView alloc] initWithFrame:CGRectMake(15, viewUserNameBG.frame.origin.y+viewUserNameBG.frame.size.height+15, SCREEN_WIDTH-30, 40)];
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
    [_btnCheckCode addTarget:self action:@selector(onButtonCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    _btnCheckCode.tag = 1;
    [viewCheckCode addSubview:_btnCheckCode];
    [_btnCheckCode setEnabled:NO];
    
    //密码
    UIView *viewUserPwdBG = [[UIView alloc]initWithFrame:CGRectMake(15, viewCheckCode.frame.origin.y+viewCheckCode.frame.size.height+15, SCREEN_WIDTH-30, 40)];
    [viewUserPwdBG.layer setCornerRadius:20];
    [viewUserPwdBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewUserPwdBG];
    
    _textUserPwd = [[ExUITextView alloc] initWithFrame:CGRectMake(10, 0, viewUserPwdBG.frame.size.width-53, 40)];
    [_textUserPwd.myTextField setFont:MKFONT(15)];
    _textUserPwd.myTextField.contentVerticalAlignment = 0;
    [_textUserPwd.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    _textUserPwd.myTextField.placeholder = @" 输入6-12位新密码";
    [_textUserPwd.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    _textUserPwd.myTextField.borderStyle = UITextBorderStyleNone;
    _textUserPwd.tag = 2;
    _textUserPwd.myTextField.backgroundColor = [UIColor clearColor];
    _textUserPwd.myTextField.secureTextEntry = YES;
    _textUserPwd.tfDelegate = self;
    [[NSUserDefaults standardUserDefaults]setObject:_textUserPwd.myTextField.text forKey:@"passWord"];
    _textUserPwd.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewUserPwdBG addSubview:_textUserPwd];
    
    //显示密码按钮
    UIButton *btnPwdShow = [[UIButton alloc] initWithFrame:CGRectMake(_textUserPwd.frame.origin.x+_textUserPwd.frame.size.width+15, _textUserPwd.btnDelete.frame.origin.y, 32/2, 32/2)];
    [btnPwdShow setImage:[UIImage imageNamed:@"btn_hidepwd.png"] forState:UIControlStateNormal];
    [btnPwdShow addTarget:self action:@selector(onButtonPwdShow:) forControlEvents:UIControlEventTouchUpInside];
    [viewUserPwdBG addSubview:btnPwdShow];
    
    //登录按钮
    CGRect regBtnRect = CGRectMake(15, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+60, SCREEN_WIDTH-30,40);
    _btnLogin = [[BFPaperButton alloc] initWithFrame:regBtnRect];
    [_btnLogin setBackgroundColor:RGBA(180, 180, 180, 1)];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin.titleLabel setFont:MKBOLDFONT(15)];
    [_btnLogin.layer setCornerRadius:20];
    _btnLogin.shadowColor = [UIColor clearColor];
    _btnLogin.tapCircleColor = RGBA(147, 214, 41, 1);
    _btnLogin.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    [_btnLogin addTarget:self action:@selector(onButtonPwdSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLogin];
    [_btnLogin setEnabled:NO];
}

-(void)showHide:(UIView*)view
{
    ExUITextView* exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
    
    
    [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:YES];

    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];

    [_btnCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnCheckCode setEnabled:YES];
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
    [MobClick event:findPwdViewbtn4];
    [self hideButton];
    
    if(_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text])
    {
        [self showButton];
        [Tool showWarningTip:@"您输入的手机号不对哦~" time:2.0f];
        return;
    }
    
    [self onSendSms:sender];
}

#pragma mark 获取短信验证码
-(void)onButtonCheckCode:(JKCountDownButton *)sender
{
//    [MobClick event:myCenterViewbtn96];
    [self hideButton];
    if(_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text])
    {
        [self showButton];
        [Tool showWarningTip:@"您输入的手机号不对哦~"   time:2.0f];
        return;
    }
    [self onSendSms:sender];
    
}

//发送验证码(验证码按钮)
-(void)onSendSms:(JKCountDownButton *)sender
{
    [MobClick event:findPwdViewbtn2];
    sender.enabled = NO;
     __weak __typeof(self) weakSelf = self;
    [ServicesUser sendSms:_textUserName.myTextField.text reason:@"RESETPASSWD"  longitude:_longitude latitude:_latitude smsType:[NSNumber numberWithInteger:sender.tag] model:^(SendSmsModel *sendSmsModel)
    {
        [Tool showSuccessTip:sendSmsModel.respMsg  time:2.0f];
        [weakSelf updateButtonState:sender];
         
    } failure:^(NSError *error){
        [weakSelf showButton];
        sender.enabled = YES;
         NSString* strMsg =error.domain;
         [Tool showWarningTip:strMsg  time:1.0f];
     }];
}

-(void)updateButtonState:(JKCountDownButton *)sender
{
//    //验证码发送成功
//    [sender setTitle:@"60s" forState:UIControlStateNormal];
//    [sender startWithSecond:60];
//    [sender didChange:^NSString *(JKCountDownButton *button,int second)
//     {
//         [_btnCheckCode setBackgroundColor:RGBA(180, 180, 180, 1)];
//         NSString *title = [NSString stringWithFormat:@"%ds",second];
//         return title;
//     }];
//    [sender didFinished:^NSString *(JKCountDownButton *button, int second)
//     {
//         [_btnCheckCode setBackgroundColor:RGBA(194, 194, 194, 1)];
//         button.enabled = YES;
//         return @"获取";
//     }];
    
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


//提交注册信息
-(void)onButtonPwdSubmit
{
    [MobClick event:findPwdViewbtn1];
    if (_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text])
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:2.0f];
        return;
    }
    else if(_textCheckCode.myTextField.text.length != 4)
    {
        [Tool showWarningTip:@"请输入4位短信验证码"  time:2.0f];
        return;
    }
    else if(_textUserPwd.myTextField.text.length == 0)
    {
        [Tool showWarningTip:@"请输入密码"  time:2.0f];
        return;
    }
    else if (_textUserPwd.myTextField.text.length < 6 || _textUserPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"请输入6-12位密码"  time:2.0f];
        return;
    }
    [self HideKeyboard];
    
    //重置密码
    [self resetPwd];
}

#pragma mark 重置密码
-(void)resetPwd
{
     __weak __typeof(self) weakSelf = self;
    [ServicesUser reSetPwd:_textUserName.myTextField.text newPwd:_textUserPwd.myTextField.text smsCode:_textCheckCode.myTextField.text model:^(RequestResult *model)
     {
         [weakSelf loginRequire:_textUserName.myTextField.text userPwd:_textUserPwd.myTextField.text];
        
     } failure:^(NSError *error) {
         
         [Tool showWarningTip:error.domain  time:1.0f];
     }];
}


//获取登录key成功后请求登录
-(void)loginRequire:(NSString *)userName userPwd:(NSString *)userPwd
{
    __weak __typeof(self) weakSelf = self;
    [ServicesUser requestLogin:userName code:^(NSString *nonce)
     {
         [weakSelf loginSubmit:nonce userName:userName userPwd:userPwd];
         
     } failure:^(NSError *error){
      
         [Tool showWarningTip:error.domain  time:1.0f];
     }];
}

//登录提交
-(void)loginSubmit:(NSString *)nonce userName:(NSString *)userName userPwd:(NSString *)userPwd
{
    __weak typeof(self) weakSelf = self;
    NSString *loginUserPwd = [Tool xor:userPwd key:nonce];
    [ServicesUser login:_textUserName.myTextField.text pwd:loginUserPwd longitude:_longitude latitude:_latitude code:^(RequestResult *model)
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
         [Tool showSuccessTip:model.respMsg  time:1];
         
         if (! [Config isFirstStartUp] )
         {
             isFirst = TRUE;//是第一次
         }
         [Config saveIsFirstStartUp:@"YES"];
         [weakSelf performSelector:@selector(toMainView) withObject:nil afterDelay:1];
         
     } failure:^(NSError *error) {
         
         [Tool showWarningTip:error.domain time:2];
     }];
}

-(void)toMainView
{
    if(isFirst)
    {
        [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
    }
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
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {
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
        [Tool showWarningTip:@"密码不能超过12位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    //如果手机号正常 则获取验证码可用
    if (textField == _textUserName.myTextField && textField.text.length == 11)
    {
//        [_btnCheckCode setBackgroundColor:RGBA(113, 111, 250, 1)];
//        [_btnCheckCode setEnabled:YES];
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
        [_btnLogin setBackgroundColor:RGBA(0, 0, 0, 1)];
        [_btnLogin setEnabled:YES];
    }
}


//点击屏幕离开事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self HideKeyboard];
    return YES;
}

//隐藏系统键盘
-(void) HideKeyboard
{
    [_textUserName.myTextField resignFirstResponder];
    [_textUserPwd.myTextField resignFirstResponder];
    [_textCheckCode.myTextField resignFirstResponder];
}

//返回登录
-(void)toLogin
{
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
