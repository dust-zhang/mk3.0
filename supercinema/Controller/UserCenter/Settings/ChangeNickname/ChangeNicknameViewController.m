//
//  ChangeNicknameViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/9/16.
//
//

#import "ChangeNicknameViewController.h"

@interface ChangeNicknameViewController ()

@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(246, 246, 251,1);
    
    [self initCtrl];
}


-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"修改昵称"];
    
    //确认按钮
    _btnChangeNicknameConfirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-35, 35, 35, 15)];
    [_btnChangeNicknameConfirm setBackgroundColor:[UIColor clearColor]];
    [_btnChangeNicknameConfirm.titleLabel setFont:MKFONT(15)];
    [_btnChangeNicknameConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    [_btnChangeNicknameConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnChangeNicknameConfirm addTarget:self action:@selector(onButtonChangeNicknameConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnChangeNicknameConfirm];
    [_btnChangeNicknameConfirm setEnabled:NO];
    
    //输入框的View的背景
    _textViewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, 44)];
    [_textViewBG setBackgroundColor:RGBA(255, 255, 255,1)];
    [self.view addSubview:_textViewBG];
    
    _textFieldChangeNickname = [[ExUITextView alloc] initWithFrame:CGRectMake(15, 14.5, SCREEN_WIDTH-30, 15)];
    [_textFieldChangeNickname.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textFieldChangeNickname.myTextField setFont:MKFONT(15)];
    [_textFieldChangeNickname.myTextField setTextAlignment:NSTextAlignmentLeft];
    [_textFieldChangeNickname.myTextField setTextColor:RGBA(51, 51, 51,1)];
    //改变光标颜色
    _textFieldChangeNickname.myTextField.tintColor = RGBA(117, 112, 255,1);
    //水印提示文字
    _textFieldChangeNickname.myTextField.placeholder = @"请输入昵称";
    //改变输入框提示文字的颜色
    [_textFieldChangeNickname.myTextField setValue:RGBA(255, 255, 255, 0.6) forKey:@"_placeholderLabel.textColor"];
    //继承代理
    _textFieldChangeNickname.tfDelegate = self;
    
    [_textFieldChangeNickname.myTextField setText:self._userModel.nickname];
    if (_textFieldChangeNickname.myTextField.text.length>0)
    {
        _textFieldChangeNickname.btnDelete.hidden = NO;
        [_btnChangeNicknameConfirm setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnChangeNicknameConfirm setEnabled:YES];
    }
    _textFieldChangeNickname.myTextField.contentVerticalAlignment = 0;
    //继承代理
    _textFieldChangeNickname.myTextField.delegate = self;
    _textFieldChangeNickname.myTextField.borderStyle = UITextBorderStyleNone;
    //默认的全键盘
    _textFieldChangeNickname.myTextField.keyboardType = UIKeyboardTypeDefault;
    _textFieldChangeNickname.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textFieldChangeNickname.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textFieldChangeNickname.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textViewBG addSubview:_textFieldChangeNickname];
    //清空输入框的按钮
    
    _labelWordNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -15 - 100,64+10+44+10,100,15)];
    _labelWordNum.attributedText = [self wordNumAttributeString:__userModel.nickname.length];
    _labelWordNum.numberOfLines = 1;
    _labelWordNum.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_labelWordNum];
    
    [_textFieldChangeNickname.btnDelete addTarget:self action:@selector(toBtnClearEmpty) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)toBtnClearEmpty {
    
    _labelWordNum.text = @"0/10";
    _labelWordNum.textColor = RGBA(153, 153, 153, 1);
    _labelWordNum.font = MKFONT(15);
}

- (NSAttributedString *)wordNumAttributeString:(NSInteger)lenth
{
    UIColor *wordNumColor = RGBA(153, 153, 153, 1);
    if (lenth > 10)
    {
        wordNumColor = RGBA(249, 81, 81, 1);
    }
   
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",lenth] attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : wordNumColor}];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/10" attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : RGBA(153, 153, 153, 1)}]];
    return attrStr;
}

//确认按钮
-(void)onButtonChangeNicknameConfirm
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (_textFieldChangeNickname.myTextField.text.length > 10)
    {
        [Tool showWarningTipForView:@"别写了，写太多装不下了" time:1 view:window];
        return;
    }
    else
    {
        [MobClick event:myCenterViewbtn77];
        [_textFieldChangeNickname.myTextField resignFirstResponder];
        __weak typeof(self) weakSelf = self;
        [ServicesUser updateUserInfo:_textFieldChangeNickname.myTextField.text gender:@0 birthday:@"" signature:@""  headUrl:@"" model:^(RequestResult *model)
         {
             [weakSelf.navigationController popViewControllerAnimated:YES];
             if ([weakSelf.delegate respondsToSelector:@selector(changeNickname:)])
             {
                 NSString *newNickName = _textFieldChangeNickname.myTextField.text;
                 [weakSelf.delegate changeNickname:newNickName];
             }
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:1];
         }];
    }
}

//显示 & 隐藏 清空文字按钮
-(void)showHide:(UIView*)view
{
    ExUITextView *exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
    
    [_btnChangeNicknameConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    [_btnChangeNicknameConfirm setEnabled:NO];
    
    
}

-(void)textFiledDidBegin:(UITextField*)textField
{
    if (textField == _textFieldChangeNickname.myTextField && _textFieldChangeNickname.myTextField.text.length > 0)
    {
        _textFieldChangeNickname.btnDelete.hidden = NO;
    }
    else
    {
        _textFieldChangeNickname.btnDelete.hidden = YES;
    }
}

-(void)textFiledValueChange:(UITextField*)textField
{
   
    if (textField == _textFieldChangeNickname.myTextField && _textFieldChangeNickname.myTextField.text.length > 0)
    {
        _textFieldChangeNickname.btnDelete.hidden = NO;
        [_btnChangeNicknameConfirm setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnChangeNicknameConfirm setEnabled:YES];
    }
    else
    {
        [_btnChangeNicknameConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
        [_btnChangeNicknameConfirm setEnabled:NO];
        _textFieldChangeNickname.btnDelete.hidden = YES;
        
    }
    
    _labelWordNum.attributedText = [self wordNumAttributeString:textField.text.length];
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFieldChangeNickname.myTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
