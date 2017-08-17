//
//  ChangePwdViewController.m
//  supercinema
//
//  Created by mapollo91 on 30/9/16.
//
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = RGBA(246, 246, 251, 1);
    
    [self initCtrl];
}

//渲染UI
-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"修改密码"];
    
    //确认按钮
    _btnChangePwdConfirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-35, 35, 35, 15)];
    [_btnChangePwdConfirm setBackgroundColor:[UIColor clearColor]];
    [_btnChangePwdConfirm.titleLabel setFont:MKFONT(15)];
    [_btnChangePwdConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    //按钮不能点击
    _btnChangePwdConfirm.enabled = NO;
//    [_btnChangePwdConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateHighlighted];
    [_btnChangePwdConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnChangePwdConfirm addTarget:self action:@selector(onButtonChangePwdConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnChangePwdConfirm];
    
    CGRect loginRect = CGRectMake(0, 74, SCREEN_WIDTH, 91);
    
    //原密码 & 新密码 的背景View
    UIView *loginView = [[UIView alloc] initWithFrame:loginRect];
    [loginView.layer setCornerRadius:2.5f];
    [loginView setBackgroundColor:RGBA(242, 242, 242, 1)];
    [self.view addSubview:loginView];
    
    //原密码
    UIView *viewLineOldPwd = [[UIView alloc]initWithFrame:CGRectMake(0, 0, loginRect.size.width, 45)];
    [viewLineOldPwd setBackgroundColor:[UIColor whiteColor]];
    [loginView addSubview:viewLineOldPwd];
    
    _textOldPwd = [[ExUITextView alloc]initWithFrame:CGRectMake(15, 0, viewLineOldPwd.frame.size.width-35, 45)];
    [_textOldPwd.myTextField setBackgroundColor:[UIColor whiteColor]];
    [_textOldPwd.myTextField setPlaceholder:@" 输入6-12位旧密码"];
    //提示文字的颜色和格式
    [_textOldPwd.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textOldPwd.myTextField setFont:MKFONT(15) ];
//    _textOldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textOldPwd.myTextField.contentVerticalAlignment=0;
    _textOldPwd.tag = 0;
    //输入后的颜色
    _textOldPwd.myTextField.textColor = RGBA(51, 51, 51, 1);
    _textOldPwd.myTextField.borderStyle = UITextBorderStyleNone;
    _textOldPwd.myTextField.returnKeyType = UIReturnKeyDefault;
    _textOldPwd.myTextField.secureTextEntry = YES;
    _textOldPwd.tfDelegate = self;
    [_textOldPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textOldPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewLineOldPwd addSubview:_textOldPwd];
    
    //新密码
    UIView *viewLineNewPwd = [[UIView alloc]initWithFrame:CGRectMake(0, 1+45,loginRect.size.width, 45)];
    [viewLineNewPwd setBackgroundColor:[UIColor whiteColor]];
    [loginView addSubview:viewLineNewPwd];
    
    _textNewPwd = [[ExUITextView alloc] initWithFrame:CGRectMake(15, 0, viewLineNewPwd.frame.size.width-35, 45)];
    [_textNewPwd.myTextField setBackgroundColor:[UIColor whiteColor]];
    [_textNewPwd.myTextField setPlaceholder:@" 输入6-12位新密码"];
    //提示文字的颜色和格式
    [_textNewPwd.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textNewPwd.myTextField setFont:MKFONT(15) ];
    _textNewPwd.tag = 1;
    //输入后的颜色
    _textNewPwd.myTextField.textColor = RGBA(51, 51, 51, 1);
    _textNewPwd.tfDelegate = self;
    _textNewPwd.myTextField.borderStyle = UITextBorderStyleNone;
    _textNewPwd.myTextField.secureTextEntry = YES;
    [_textNewPwd.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textNewPwd.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewLineNewPwd addSubview:_textNewPwd];
}

//确认按钮
-(void)onButtonChangePwdConfirm
{
    [MobClick event:myCenterViewbtn91];
    if (_textOldPwd.myTextField.text.length < 6 || _textOldPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"请输入6-12位旧密码"  time:2.0f];
        return;
    }
    else if(_textNewPwd.myTextField.text.length < 6 || _textNewPwd.myTextField.text.length > 12)
    {
        [Tool showWarningTip:@"请输入6-12位新密码"  time:2.0f];
        return;
    }
    
    [self HideKeyboard];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在修改密码" withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser updatePwdRequire:^(NSDictionary *model)
    {
         NSString *nonce = [model objectForKey:@"nonce" ];
         [weakSelf changePwd:nonce];

    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:error.domain time:1];
    }];
  
}

-(void)changePwd:(NSString *)nonce
{
    
    __weak typeof(self) weakSelf = self;
    [ServicesUser updatePwd:nonce oldPwd:_textOldPwd.myTextField.text newPwd:_textNewPwd.myTextField.text model:^(RequestResult *model)
    {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showSuccessTip:@"密码修改成功" time:1];
        [Config saveCredential:model.loginResult.credential];
        [Config saveUserType:[model.loginResult.passportType stringValue]];
        [weakSelf performSelector:@selector(toBack) withObject:nil afterDelay:1];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:error.domain time:1];
    }];
  }

//点击屏幕离开事件
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboard];
    return YES;
}

//隐藏键盘
-(void)HideKeyboard
{
    [_textOldPwd.myTextField resignFirstResponder];
    [_textNewPwd.myTextField resignFirstResponder];
}

-(void)toBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showHide:(UIView*)view
{
    ExUITextView *exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
    
    _btnChangePwdConfirm.enabled = NO;
    [_btnChangePwdConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    
}

-(void)textFiledDidBegin:(UITextField*)textField
{
    if (textField == _textNewPwd.myTextField && _textNewPwd.myTextField.text.length > 0)
    {
        _textNewPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textNewPwd.btnDelete.hidden = YES;
    }
    
    if (textField == _textOldPwd.myTextField && _textOldPwd.myTextField.text.length > 0)
    {
        _textOldPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textOldPwd.btnDelete.hidden = YES;
    }
}

-(void)textFiledValueChange:(UITextField*)textField
{
    if (textField == _textNewPwd.myTextField && _textNewPwd.myTextField.text.length > 0)
    {
        _textNewPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textNewPwd.btnDelete.hidden = YES;
    }
    
    if (textField == _textOldPwd.myTextField && _textOldPwd.myTextField.text.length > 0)
    {
        _textOldPwd.btnDelete.hidden = NO;
    }
    else
    {
        _textOldPwd.btnDelete.hidden = YES;
    }
    
    NSString *strLang = [[textField textInputMode] primaryLanguage];
    if ([strLang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {
            return;
        }
    }
    
    int maxLength = 0;
    
    if(textField == _textOldPwd.myTextField && textField.text.length > 12)
    {
        maxLength = 12;
        [Tool showWarningTip:@"旧密码不能超过12位"  time:0.5];
    }
    else if(textField == _textNewPwd.myTextField && textField.text.length > 12)
    {
        maxLength = 12;
        [Tool showWarningTip:@"新密码不能超过12位"  time:0.5];
    }
    
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    
    if (_textNewPwd.myTextField.text.length>0 && _textOldPwd.myTextField.text.length > 0)
    {
        _btnChangePwdConfirm.enabled = YES;
        [_btnChangePwdConfirm setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    }
    else
    {
        _btnChangePwdConfirm.enabled = NO;
        [_btnChangePwdConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
