//
//  BindTelNumberViewController.m
//  supercinema
//
//  Created by dust on 16/12/20.
//
//

#import "BindTelNumberViewController.h"

@interface BindTelNumberViewController ()

@end

@implementation BindTelNumberViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    isPwdShow = NO;
    self.view.backgroundColor = RGBA(246, 246, 251, 1);
    
    [self initCtrl];
}

//渲染UI
-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"绑定手机号"];
    
    //确认按钮
    _btnChangeMobileConfirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-35, 35, 35, 15)];
    [_btnChangeMobileConfirm setBackgroundColor:[UIColor clearColor]];
    [_btnChangeMobileConfirm.titleLabel setFont:MKFONT(15)];
    [_btnChangeMobileConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    [_btnChangeMobileConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnChangeMobileConfirm addTarget:self action:@selector(onButtonBingdMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnChangeMobileConfirm];
    _btnChangeMobileConfirm.enabled = NO;
    
    //输入新手机号
    UIView *viewLineUserName = [[UIView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10, SCREEN_WIDTH, 40)];
    [viewLineUserName setBackgroundColor:RGBA(255, 255, 255, 0.1)];
    viewLineUserName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewLineUserName];
    
    _textPhoneNO=[[ExUITextView alloc]initWithFrame:CGRectMake(15, 0, viewLineUserName.frame.size.width-30, 40)];
    [_textPhoneNO.myTextField setBackgroundColor:[UIColor whiteColor]];
    [_textPhoneNO.myTextField setPlaceholder:@" 输入11位手机号"];
    [_textPhoneNO.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];//提示文字的颜色和格式
    [_textPhoneNO.myTextField setFont:MKFONT(15) ];
    //_textPhoneNO.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textPhoneNO.myTextField.contentVerticalAlignment = 0;
    _textPhoneNO.tag = 0;
    _textPhoneNO.tfDelegate = self;
    [_textPhoneNO.myTextField setTextColor:RGBA(51, 51, 51, 1)];//输入后的颜色
    _textPhoneNO.myTextField.borderStyle = UITextBorderStyleNone;
    _textPhoneNO.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _textPhoneNO.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textPhoneNO.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textPhoneNO.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewLineUserName addSubview:_textPhoneNO];
    
    //输入短信验证码
    UIView *viewLineCheckCode = [[UIView alloc] initWithFrame:CGRectMake(0, viewLineUserName.frame.origin.y+viewLineUserName.frame.size.height+1, viewLineUserName.frame.size.width, 40)];
    [viewLineCheckCode setBackgroundColor:RGBA(255, 255, 255, 0.1)];
    viewLineCheckCode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewLineCheckCode];
    
    _textCheckCode = [[ExUITextView alloc] initWithFrame:CGRectMake(15,0, SCREEN_WIDTH-15-5-50-10-1-10-50-15, 40)];
    [_textCheckCode.myTextField setBackgroundColor:[UIColor whiteColor]];
    [_textCheckCode.myTextField setPlaceholder:@" 输入验证码"];
    [_textCheckCode.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];//提示文字的颜色和格式
    [_textCheckCode.myTextField setFont:MKFONT(15)];
    _textCheckCode.tag = 1;
//    _textCheckCode.tfDelegate = self;
    [_textCheckCode.myTextField setTextColor:RGBA(51, 51, 51, 1)];//输入后的颜色
    _textCheckCode.myTextField.borderStyle = UITextBorderStyleNone;
    _textCheckCode.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_textCheckCode.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewLineCheckCode addSubview:_textCheckCode];

    
    //获取验证码按钮
    //语音获取按钮
    _btnVoiceCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _btnVoiceCode.frame = CGRectMake(_textCheckCode.frame.origin.x+_textCheckCode.frame.size.width+10,17/2, 50, 23);
    [_btnVoiceCode setBackgroundColor:[UIColor clearColor]];
    [_btnVoiceCode setTitle:@"语音获取" forState:UIControlStateNormal];
    [_btnVoiceCode.titleLabel setFont:MKBOLDFONT(12)];
    [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnVoiceCode addTarget:self action:@selector(onButtongetVoiceCode:) forControlEvents:UIControlEventTouchUpInside];
    _btnVoiceCode.tag = 2;
    [viewLineCheckCode addSubview:_btnVoiceCode];
    [_btnVoiceCode setEnabled:NO];
    
    //分割线
    _labelDivisionLine = [[UILabel alloc] initWithFrame:CGRectMake(_btnVoiceCode.frame.origin.x+_btnVoiceCode.frame.size.width+10, 29/2, 1, 11)];
    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1)];
    [viewLineCheckCode addSubview:_labelDivisionLine];
    
    //短信获取按钮
    _btnGetCheckCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _btnGetCheckCode.frame = CGRectMake(_labelDivisionLine.frame.size.width+_labelDivisionLine.frame.origin.x+10,17/2, 50, 23);
    [_btnGetCheckCode setBackgroundColor:[UIColor clearColor]];
    [_btnGetCheckCode setTitle:@"短信获取" forState:UIControlStateNormal];
    [_btnGetCheckCode.titleLabel setFont:MKBOLDFONT(12)];
    [_btnGetCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnGetCheckCode addTarget:self action:@selector(onButtongetCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    _btnGetCheckCode.tag = 1;
    [viewLineCheckCode addSubview:_btnGetCheckCode];
    [_btnGetCheckCode setEnabled:NO];
    
    //输入登录密码
    UIView *viewLineUserPwd = [[UIView alloc] initWithFrame:CGRectMake(0, viewLineCheckCode.frame.origin.y+viewLineCheckCode.frame.size.height+1, viewLineCheckCode.frame.size.width, 40)];
    [viewLineUserPwd setBackgroundColor:RGBA(255, 255, 255, 0.1)];
    viewLineUserPwd.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewLineUserPwd];

    _textUserPwd = [[ExUITextView alloc]initWithFrame:CGRectMake(15, 0, viewLineUserPwd.frame.size.width-30-15-16, 40)];
    _textUserPwd.myTextField.backgroundColor = [UIColor whiteColor];
    _textUserPwd.myTextField.placeholder = @" 设置6-12位密码";
    //提示文字的颜色和格式
    [_textUserPwd.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textUserPwd.myTextField setFont:MKFONT(15)];
    _textUserPwd.tag = 2;
    _textUserPwd.myTextField.secureTextEntry = YES;
    _textUserPwd.tfDelegate = self;
    //输入后的颜色
    [_textUserPwd.myTextField setTextColor:RGBA(51, 51, 51, 1)];
    _textUserPwd.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textUserPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewLineUserPwd addSubview:_textUserPwd];
    
    //显示密码按钮
    UIButton *btnPwdShow = [[UIButton alloc] initWithFrame:CGRectMake(_textUserPwd.frame.origin.x+_textUserPwd.frame.size.width+15, _textUserPwd.btnDelete.frame.origin.y, 32/2, 32/2)];
    [btnPwdShow setImage:[UIImage imageNamed:@"btn_hidepwd.png"] forState:UIControlStateNormal];
    [btnPwdShow addTarget:self action:@selector(onButtonPwdShow:) forControlEvents:UIControlEventTouchUpInside];
    [viewLineUserPwd addSubview:btnPwdShow];
    
}

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
    [MobClick event:myCenterViewbtn131];
    [self hideButton];
    
    if(_textPhoneNO.myTextField.text.length != 11 || ![Tool validateTel:_textPhoneNO.myTextField.text])
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
    [MobClick event:myCenterViewbtn96];
    [self hideButton];
    if(_textPhoneNO.myTextField.text.length != 11 || ![Tool validateTel:_textPhoneNO.myTextField.text])
    {
        [self showButton];
        [Tool showWarningTip:@"您输入的手机号不对哦~" time:2.0f];
        return;
    }
    [self onSendSms:sender];
}
-(void)onSendSms:(JKCountDownButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [ServicesUser sendSms:_textPhoneNO.myTextField.text reason:@"BINDMOBILENO"  longitude:@"" latitude:@"" smsType:[NSNumber numberWithInteger:sender.tag] model:^(SendSmsModel *sendSmsModel)
     {
         [Tool showSuccessTip:sendSmsModel.respMsg  time:2.0f];
         [weakSelf updateButtonState:sender];
         
     } failure:^(NSError *error) {
         [weakSelf showButton];
         [Tool showWarningTip:error.domain  time:1.0f];
     }];
}
-(void)updateButtonState:(JKCountDownButton *)sender
{
//    [sender setTitle:@"60s" forState:UIControlStateNormal];
//    [sender startWithSecond:60];
//    [sender didChange:^NSString *(JKCountDownButton *button,int second)
//     {
//         [_btnGetCheckCode setBackgroundColor:RGBA(194, 194, 194, 1)];
//         NSString *title = [NSString stringWithFormat:@"%ds",second];
//         return title;
//     }];
//    [sender didFinished:^NSString *(JKCountDownButton *button, int second)
//     {
//         [_btnGetCheckCode setBackgroundColor:RGBA(113, 111, 250, 1)];
//         [_btnGetCheckCode setEnabled:YES];
//         return @"获取";
//     }];
    
    //短信验证码
    if (sender.tag == 1)
    {
        [sender setTitle:@"       60s" forState:UIControlStateNormal];
        
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *button,int second)
         {
             [_btnGetCheckCode setTitleColor:RGBA(194, 194, 194, 1) forState:UIControlStateNormal];
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
        [_btnGetCheckCode setTitleColor:RGBA(194, 194, 194, 1) forState:UIControlStateNormal];
        [_btnGetCheckCode setTitle:@"       60s" forState:UIControlStateNormal];
        [_btnGetCheckCode startWithSecond:60];
        
        [_btnGetCheckCode didChange:^NSString *(JKCountDownButton *button,int second)
         {
             NSString *title = [NSString stringWithFormat:@"       %ds",second];
             return title;
         }];
        
        __weak typeof(self) weakSelf = self;
        [_btnGetCheckCode didFinished:^NSString *(JKCountDownButton *button, int second)
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
    
    [_btnGetCheckCode setTitle:@"短信获取" forState:UIControlStateNormal];
    [_btnGetCheckCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnGetCheckCode setEnabled:YES];
}

-(void) hideButton
{
    [_btnVoiceCode setTitle:@"" forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:NO];
    
    [_labelDivisionLine setHidden:YES];
    
    [_btnGetCheckCode setTitle:@"" forState:UIControlStateNormal];
    [_btnGetCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnGetCheckCode setEnabled:NO];
}

#pragma mark 确认按钮
-(void)onButtonBingdMobile
{
    if (_textPhoneNO.myTextField.text.length != 11 || ![Tool validateTel:_textPhoneNO.myTextField.text])
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:2.0f];
        return;
    }
    if(_textCheckCode.myTextField.text.length != 4)
    {
        [Tool showWarningTip:@"请输入4位验证码"  time:2.0f];
        return;
    }
    if(_textUserPwd.myTextField.text.length < 6 || _textUserPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"请输入6-12位密码"  time:2.0f];
        return;
    }
    if(![Tool validateTel:_textPhoneNO.myTextField.text ])
    {
        [Tool showWarningTip:@"手机号错误"  time:2.0f];
        return;
    }
    
    [self HideKeyboard];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在绑定手机号" withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    
    [ServicesUser bindPhoneNo:_textPhoneNO.myTextField.text pasword:_textUserPwd.myTextField.text smsCode:_textCheckCode.myTextField.text latitude:@"" longitude:@"" lastVisitCinemaId:[Config getCinemaId] model:^(RequestResult *model)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
         [Tool showSuccessTip:model.respMsg time:2];
         if ([model.loginResult.cinemaId intValue] > 0)
         {
             [Config saveCinemaId:[model.loginResult.cinemaId stringValue]];
         }
         [Config saveCredential:model.loginResult.credential ];
         [Config saveUserType:[model.loginResult.passportType stringValue]];
         [weakSelf.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
         [Tool showSuccessTip:error.domain time:2];
     }];
}

//点击屏幕离开事件
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self HideKeyboard];
    return YES;
}

//隐藏系统键盘
-(void)HideKeyboard
{
    [_textPhoneNO.myTextField resignFirstResponder];
    [_textCheckCode.myTextField resignFirstResponder];
    [_textUserPwd.myTextField resignFirstResponder];
}

-(void)showHide:(UIView*)view
{
    ExUITextView* exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
    
    _btnChangeMobileConfirm.enabled = NO;
    [_btnChangeMobileConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    
    
    [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnVoiceCode setEnabled:YES];
    
    [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
    
    [_btnGetCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnGetCheckCode setEnabled:YES];
}

-(void)textFiledDidBegin:(UITextField*)textField
{
    if (textField == _textPhoneNO.myTextField && _textPhoneNO.myTextField.text.length>0)
    {
        _textPhoneNO.btnDelete.hidden = NO;
    }
    else
    {
        _textPhoneNO.btnDelete.hidden = YES;
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
    if (textField == _textPhoneNO.myTextField && _textPhoneNO.myTextField.text.length>0)
    {
        _textPhoneNO.btnDelete.hidden = NO;
    }
    else
    {
        _textPhoneNO.btnDelete.hidden = YES;
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
    if (textField == _textPhoneNO.myTextField && textField.text.length > 11)
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
    
    if (_textUserPwd.myTextField.text.length>0 && _textPhoneNO.myTextField.text.length>0  && _textCheckCode.myTextField.text.length >0)
    {
        _btnChangeMobileConfirm.enabled = YES;
        [_btnChangeMobileConfirm setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    }
    else
    {
        _btnChangeMobileConfirm.enabled = NO;
        [_btnChangeMobileConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    }
    
    //_textUserPwd.myTextField.text.length>5 && _textPhoneNO.myTextField.text.length == 11  && [_btnGetCheckCode.titleLabel.text isEqualToString:@"短信获取"]
    if (_textPhoneNO.myTextField.text.length == 11  && [_btnGetCheckCode.titleLabel.text isEqualToString:@"短信获取"])
    {
        [_btnVoiceCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [_btnVoiceCode setEnabled:YES];
        
        [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
        
        [_btnGetCheckCode setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [_btnGetCheckCode setEnabled:YES];
    }
    else
    {
        [_btnVoiceCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
        [_btnVoiceCode setEnabled:YES];
        
        [_labelDivisionLine setBackgroundColor:RGBA(180, 180, 180, 1) ];
        
        [_btnGetCheckCode setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
        [_btnGetCheckCode setEnabled:YES];
    }
}

-(void)backTopView
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
