//
//  LoginView.m
//  movikr
//
//  Created by zeyuan on 15/5/10.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserCenterViewController.h"
#import "ServicesUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Tool hideTabBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: RGBA(246, 246, 251,1)];
    _longitude = @"";
    _latitude = @"";
    [self getLocalCoordinate];
    [self initCtrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundLogin) name:NOTIFITION_BACKGROUNDTOLOGIN object:nil];
}

-(void)userNameText:(NSString *)userNameText
{
    _textUserName.myTextField.text = userNameText;
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

//渲染UI
-(void)initCtrl
{
    //设置Top
    self._viewTop.backgroundColor = [UIColor clearColor];
    self._btnBack.frame = CGRectMake(0, 23, 94/2, 30);
    [self._btnBack setImage:[UIImage imageNamed:@"btn_closeBlack.png"] forState:UIControlStateNormal];

    self._labelLine.hidden = YES;
    
    //手机号
    UIView *viewUserNameBG = [[UIView alloc] initWithFrame:CGRectMake(15, 130, SCREEN_WIDTH-30, 40)];
    [viewUserNameBG.layer setCornerRadius:20];
    [viewUserNameBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewUserNameBG];

    _textUserName=[[ExUITextView alloc]initWithFrame:CGRectMake(15, 0, viewUserNameBG.frame.size.width-30, 40)];
    [_textUserName.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textUserName.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    [_textUserName.myTextField setPlaceholder:@" 输入11位手机号"];
    _textUserName.tfDelegate = self;
    [_textUserName.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textUserName.myTextField setFont:MKFONT(15) ];
    [_textUserName.myTextField setText:[Config getUserName] ];
    if (_textUserName.myTextField.text.length>0)
    {
        _textUserName.btnDelete.hidden = NO;
    }
    _textUserName.myTextField.contentVerticalAlignment = 0;
    _textUserName.myTextField.delegate=self;
    _textUserName.tag = 0;
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
    
    _textUserPwd = [[ExUITextView alloc] initWithFrame:CGRectMake(15, 0, viewUserPwdBG.frame.size.width-15-16-15-15, 40)];
    [_textUserPwd.myTextField setFont:MKFONT(15)];
    _textUserPwd.tfDelegate = self;
    [_textUserPwd.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    _textUserPwd.myTextField.contentVerticalAlignment = 0;
    _textUserPwd.myTextField.placeholder = @" 输入6-12位密码";
    _textUserPwd.myTextField.tag = 1;
    _textUserPwd.myTextField.backgroundColor = [UIColor clearColor];
    //默认密码不显示
    isPwdShow = NO;
    _textUserPwd.myTextField.secureTextEntry = YES;
    _textUserPwd.myTextField.delegate = self;
    _textUserPwd.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewUserPwdBG addSubview:_textUserPwd];
    
    //显示密码按钮
    UIButton *btnPwdShow = [[UIButton alloc] initWithFrame:CGRectMake(_textUserPwd.frame.origin.x+_textUserPwd.frame.size.width+15, _textUserPwd.btnDelete.frame.origin.y, 32/2, 32/2)];
    [btnPwdShow setImage:[UIImage imageNamed:@"btn_hidepwd.png"] forState:UIControlStateNormal];
    [btnPwdShow addTarget:self action:@selector(onButtonPwdShow:) forControlEvents:UIControlEventTouchUpInside];
    [viewUserPwdBG addSubview:btnPwdShow];
    
    //忘记密码按钮
    UIButton *btnForgotPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForgotPwd.frame = CGRectMake(SCREEN_WIDTH-15-60, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+10, 68, 18);
    [btnForgotPwd setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btnForgotPwd.titleLabel setFont:MKFONT(12) ];
    [btnForgotPwd setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [btnForgotPwd setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateHighlighted];
    btnForgotPwd.backgroundColor = [UIColor clearColor];
    [btnForgotPwd addTarget:self action:@selector(onButtonFindPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnForgotPwd];
    
    //登录按钮
    CGRect loginBtnRect;
    if (IPhone5)
    {
        loginBtnRect = CGRectMake(15, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+75, SCREEN_WIDTH-30,40);
    }
    else
    {
        loginBtnRect = CGRectMake(15, viewUserPwdBG.frame.origin.y+viewUserPwdBG.frame.size.height+115, SCREEN_WIDTH-30,40);
    }
    _btnLogin = [[BFPaperButton alloc] initWithFrame:loginBtnRect];
    [_btnLogin setBackgroundColor: RGBA(180, 180, 180, 1)];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin.titleLabel setFont:MKFONT(15)];
    [_btnLogin.layer setCornerRadius:20];
    _btnLogin.shadowColor = [UIColor clearColor];
    _btnLogin.tapCircleColor = RGBA(147, 214, 41, 1);
    [_btnLogin addTarget:self action:@selector(onButtonLogin) forControlEvents:UIControlEventTouchUpInside];
    _btnLogin.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    [self.view addSubview:_btnLogin];
    [_btnLogin setEnabled:NO];
    
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
    UILabel *labelContractName = [[UILabel alloc] initWithFrame:CGRectMake(15, _btnLogin.frame.origin.y+_btnLogin.frame.size.height+10, 125, 12)];
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
    //注册
    CGRect regBtnRect;
    if (IPhone5)
    {
        regBtnRect = CGRectMake((SCREEN_WIDTH-70)/2, _btnWeiboLogin.frame.origin.y+_btnWeiboLogin.frame.size.height+20, 70, 15);
    }
    else
    {
        regBtnRect = CGRectMake((SCREEN_WIDTH-70)/2, _btnWeiboLogin.frame.origin.y+_btnWeiboLogin.frame.size.height+41, 70, 15);
    }
    _btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRegister setFrame:regBtnRect];
    [_btnRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [_btnRegister setBackgroundColor:[UIColor clearColor]];
    [_btnRegister.titleLabel setFont:MKFONT(15)];
    [_btnRegister setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnRegister setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateHighlighted];
    [_btnRegister addTarget:self action:@selector(onButtonToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRegister];
}

//跳转到使用协议页
-(void)onButtonContract:(UIButton *)sender
{
    [MobClick event:loginViewbtn3];
    [self HideKeyboard];
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesSystem getProtocolContent:^(NSString *protocolContent)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [self createContractView:protocolContent];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
     }];

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

-(void) createContractView:(NSString *) proctrolText
{
    if(!_contractView)
    {
        [_contractView removeFromSuperview];
    }
    
    _contractView = [[ContractView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) str:proctrolText];
    _contractView.backgroundColor = [UIColor clearColor];
    _contractView.hidden = YES;
    _contractView.alpha = 0;
    _contractView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [self.view addSubview:_contractView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contractView.transform = CGAffineTransformMakeScale(1, 1);
                         _contractView.hidden = NO;
                         _contractView.alpha = 1;
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

-(void)showHide:(UIView*)view
{
    ExUITextView* exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
  
    [_btnLogin setBackgroundColor: RGBA(180, 180, 180, 1)];
    [_btnLogin setEnabled:NO];
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
    else if (textField == _textUserPwd.myTextField && textField.text.length >12)
    {
        maxLength = 12;
        [Tool showWarningTip:@"密码不能超过12位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    //都不为空则登录按钮可用
    if ( _textUserName.myTextField.text.length>0 &&  _textUserPwd.myTextField.text.length>0)
    {
        [_btnLogin setBackgroundColor: RGBA(0, 0, 0, 1)];
        [_btnLogin setEnabled:YES];
    }
    else
    {
        [_btnLogin setBackgroundColor: RGBA(180, 180, 180, 1)];
        [_btnLogin setEnabled:NO];
    }
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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboard];
    return YES;
}

//跳转到注册
- (void)onButtonToRegister
{
    [MobClick event:loginViewbtn7];
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    registerView._strTopViewName = self._strTopViewName;
    registerView.registerViewDelegate = self;
    [self.navigationController pushViewController:registerView animated:YES];
}

//跳转到找回密码
-(void)onButtonFindPassWord
{
    [MobClick event:loginViewbtn2];
    FindPasswordViewController *findPasswordVC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

//获取登录key成功后请求登录
-(void)onButtonLogin
{
    [MobClick event:loginViewbtn1];
    if (_textUserName.myTextField.text.length != 11 || ![Tool validateTel:_textUserName.myTextField.text])
    {
        [Tool showWarningTip:@"用户名或密码错误"  time:1];
        return;
    }
    else if(_textUserPwd.myTextField.text.length < 6 || _textUserPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"用户名或密码错误"  time:1];
        return;
    }
    [self HideKeyboard];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"登录中..." withBlur:NO allowTap:NO];
    //请求登陆
     __weak __typeof(self) weakSelf = self;
    [ServicesUser requestLogin:_textUserName.myTextField.text code:^(NSString *nonce)
    {
         [weakSelf loginSubmit:nonce];
         
     } failure:^(NSError *error){
         [Tool showWarningTip:error.domain  time:2.0f];
     }];
}

#pragma mark 适配器
-(void)popToController:(NSString *)controllerName param:(NSMutableDictionary *)params
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_USERCENTER object:nil];
    //通知影院首页登录成功
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
    //如果是随便逛逛点击登陆，并且该用户没有默认cinemaID
    if ([self._strTopViewName isEqualToString:@"CinemaSearchViewController"] && [[Config getCinemaId] intValue] <=0)
    {
        //跳转回随便逛逛
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        return;
    }
    
    //如果是随便逛逛点击登录，则返回到首页
    if ([self._strTopViewName isEqualToString:@"CinemaSearchViewController"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    UIViewController * controller = nil;
    
    if([controllerName isEqualToString:@"BuyCardViewController"])
    {
        //买卡页
        BuyCardViewController *buyCardController = [[BuyCardViewController alloc] init];
        buyCardController._cinema = [params objectForKey:@"_cinema"];
        CardListModel *cardListModel = [params objectForKey:@"_cardListModel"];
        buyCardController.cinemaCardId = cardListModel.cinemaCardId;
        controller = buyCardController;
    }
    else if([controllerName isEqualToString:@"CardOrderViewController"])
    {
        //卡订单页
        CardOrderViewController *cardOrderController = [[CardOrderViewController alloc] init];
        cardOrderController._cinema = [params objectForKey:@"_cinema"];
        CardListModel *cardListModel = [params objectForKey:@"_cardListModel"];
        cardOrderController.cinemaCardId = cardListModel.cinemaCardId;
        cardOrderController._memberCardDetailModel = [params objectForKey:@"_memberCardDetailModel"];
        controller = cardOrderController;
    }
    else if([controllerName isEqualToString:@"MembershipCardView"])
    {
        //捡便宜
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCARD object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    else if([controllerName isEqualToString:@"UserCenterViewController"])
    {
        //个人中心页
        UserCenterViewController *userCenterController = [[UserCenterViewController alloc] init];
        controller = userCenterController;
    }
    else if([controllerName isEqualToString:@"OtherCenterViewController"])
    {
        //他人个人中心
        if ([[Config getUserId] isEqualToString:[params objectForKey:@"_strUserId"]])
        {
            //如果当前用户ID与跳转ID是同一ID，则跳转到个人中心
//            UserCenterViewController *userCenterController = [[UserCenterViewController alloc] init];
//            controller = userCenterController;
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate switchTab:2];
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
        else
        {
            //不是同一ID，则跳转到他人中心
            OtherCenterViewController *otherCenterController = [[OtherCenterViewController alloc]init];
            otherCenterController._strUserId = [params objectForKey:@"_strUserId"];
            controller = otherCenterController;
        }
//        if ([[Config getUserId] isEqualToString:[params objectForKey:@"_strUserId"]])
//        {
//            //回到个人中心
//            NSDictionary* dictTab = @{@"tag":@2};
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        else
//        {
//            OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
//            vc._strUserId = [params objectForKey:@"_strUserId"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    else if([controllerName isEqualToString:@"MyAttentionViewController"])
    {
        //关注页面
        MyAttentionViewController *myAttentionController = [[MyAttentionViewController alloc] init];
        myAttentionController._userId = [Config getUserId];
        controller = myAttentionController;
    }
    else if([controllerName isEqualToString:@"MyFansViewController"])
    {
        //粉丝页
        MyFansViewController *myFansController = [[MyFansViewController alloc] init];
        myFansController._userId = [Config getUserId];
        controller = myFansController;
    }
    else if([controllerName isEqualToString:@"WantLookViewController"])
    {
        //想看
        WantLookViewController *wantLookController = [[WantLookViewController alloc] init];
        wantLookController._userId = [Config getUserId];
        controller = wantLookController;
    }
    else if([controllerName isEqualToString:@"MovieReviewViewController"])
    {
        MovieReviewViewController *movieReviewController = [[MovieReviewViewController alloc] init];
        movieReviewController._userId = [Config getUserId];
        controller = movieReviewController;
    }
    else if([controllerName isEqualToString:@"MyOrderViewController"])
    {
        //我的订单
        MyOrderViewController *myOrderController = [[MyOrderViewController alloc] init];
        controller = myOrderController;
    }
    else if([controllerName isEqualToString:@"MyCardViewController"])
    {
        //我的卡包
        MyCardViewController *myCardController = [[MyCardViewController alloc] init];
        controller = myCardController;
    }
    else if([controllerName isEqualToString:@"ExchangeVoucherViewController"])
    {
        //激活码
        ExchangeVoucherViewController *exchangeVoucherVC = [[ExchangeVoucherViewController alloc] init];
        exchangeVoucherVC._url = [NSURL URLWithString:[Tool stringH5UrlExchangeVoucheTime:[params objectForKey:@"_url"] systime:[Tool getSystemTime]]];
        controller = exchangeVoucherVC;
    }
    else if([controllerName isEqualToString:@"MyDynamicViewController"])
    {
        //我的动态
        MyDynamicViewController *myDynamicController = [[MyDynamicViewController alloc] init];
        controller = myDynamicController;
        
    }
    else if([controllerName isEqualToString:@"NotifiViewController"])
    {
        //通知
        NotifiViewController *notifiController = [[NotifiViewController alloc] init];
        controller = notifiController;
        
    }
    else if([controllerName isEqualToString:@"SettingsViewController"])
    {
        //设置
        SettingsViewController *settingsController = [[SettingsViewController alloc] init];
        controller = settingsController;
    }
    else if([controllerName isEqualToString:@"ShareCinemaViewController"])
    {
        //分享影院
        ShareCinemaViewController *shareCinemaController = [[ShareCinemaViewController alloc] init];
        controller = shareCinemaController;
    }
    if(controller == nil)
    {
        //(从哪来回哪去)
        //小卖列表
        if (self.refreshSalePriceBlock)
        {
            self.refreshSalePriceBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController pushViewController:controller animated:YES];
        //******* 重置导航控制器栈空间 start *******
//        NSArray *controllers = self.navigationController.viewControllers;
//        NSMutableArray *newControllers = [[NSMutableArray alloc] init];
//        for(UIViewController *viewController in controllers){
//            if(viewController != self){
//                [newControllers addObject:viewController];
//            }
//        }
//        [self.navigationController setViewControllers:[newControllers copy]];
        //******* 重置导航控制器栈空间 end *******
    }
    //刷新捡便宜
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCARD object:nil];
}

//登录提交
-(void)loginSubmit:(NSString *)nonce
{
    NSString *userPwd = [Tool xor:_textUserPwd.myTextField.text key:nonce];
    __weak typeof(self) weakSelf = self;
    [ServicesUser login:_textUserName.myTextField.text pwd:userPwd longitude:_longitude latitude:_latitude code:^(RequestResult *model)
    {
         [Tool showSuccessTip:@"登录成功"  time:1 ];
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
        [weakSelf performSelector:@selector(delayPop) withObject:nil afterDelay:1.1];
        [weakSelf getUserInfo];
        //刷新消遣
        [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHGAME object:nil];
        
     } failure:^(NSError *error) {
          [Tool showWarningTip:@"用户名或密码错误" time:1];
     }];
}

-(void) getUserInfo
{
    [ServicesUser getMyInfo:@"" model:^(UserModel *userModel)
    {
        [Config saveUserHeadImage:userModel.portrait_url];
    } failure:^(NSError *error) {
        
    }];
}
-(void) delayPop
{
     [self popToController:self._strTopViewName param:self.param];
}

//微博登录
-(void)authorizeWeiboLogin
{
    [MobClick event:loginViewbtn6];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView weiboThirdLogin];
}

//QQ登录
-(void)authorizeQQLogin
{
    [MobClick event:loginViewbtn5];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView QQLogin];
}

//微信登录
-(void)authorizeWeixinLogin
{
    [MobClick event:loginViewbtn4];
    [ShareView getShareInstance].shareDelegate = self;
    [ShareView weixinLogin];
}

#pragma mark 第三方登录回调
-(void)thirdLoginSucceed:(NSString*)token unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"授权登录中" withBlur:NO allowTap:NO];
    [ServicesUser checkThirdLoginData:token unionId:unionId loginType:loginType authorizeStatus:authorizeStatus
                            longitude:_longitude latitude:_latitude model:^(RequestResult *headModel)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
         [Config saveUserName:_textUserName.myTextField.text];
         [Config saveCredential:headModel.loginResult.credential];
         [Config saveUserType:[headModel.loginResult.passportType stringValue]];
         [Config saveLoginState:@"YES"];
         [Config saveUserId:[headModel.loginResult.userId stringValue]];
         [Config saveIsFirstStartUp:@"YES"];
         [Tool showSuccessTip:@"登录成功" time:1 ];
         
         [weakSelf getUserInfo];
         //通知登录成功
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_USERCENTER object:nil];
         //刷新消遣
         [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHGAME object:nil];
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
             if ([[Config getCinemaId] intValue] == 0)
             {
                 [Config saveCinemaId:[headModel.loginResult.cinemaId stringValue]];
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
             [weakSelf.navigationController popViewControllerAnimated:YES];
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

-(void) onButtonBack
{
    if ([__strTopViewName isEqualToString:@"GameViewController"])
    {
        [Tool showTabBar];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_BACKGROUNDTOLOGIN];
}

@end
