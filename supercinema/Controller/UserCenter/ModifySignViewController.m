//
//  ModifySignViewController.m
//  supercinema
//
//  Created by dust on 16/11/29.
//
//

#import "ModifySignViewController.h"

@interface ModifySignViewController ()

@end

@implementation ModifySignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.view setBackgroundColor:RGBA(246, 246, 250, 1)];
    [Tool hideTabBar];
    [self initController];
}

- (void)initController
{
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 27, 94/2, 30)];
    [btnClose setImage:[UIImage imageNamed:@"btn_closeBlack.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    _btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-55,67/2, 40, 15)];
    [_btnEnsure setTitle:@"确认" forState:UIControlStateNormal];
    [_btnEnsure setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    [_btnEnsure.titleLabel setFont:MKFONT(15)];
    [_btnEnsure addTarget:self action:@selector(onButtonEnsure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEnsure];
    [_btnEnsure setEnabled:NO];
    if([self._strSign length] > 0)
    {
        [_btnEnsure setEnabled:YES];
        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    }
    UIView *viewbg = [[UIView alloc ] initWithFrame:CGRectMake(0, _btnEnsure.frame.origin.y+_btnEnsure.frame.size.height+25, SCREEN_WIDTH, 200)];
    [viewbg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewbg];
    
    _textViewSign = [[UITextView alloc ] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-30, 170)];
    _textViewSign.delegate = self;
    [_textViewSign setKeyboardType:UIKeyboardTypeDefault];
    [_textViewSign setReturnKeyType:UIReturnKeyDone];
    [_textViewSign setFont:MKFONT(15)];
    _textViewSign.text = self._strSign;
    [viewbg addSubview:_textViewSign];
    
    _labelShowContent = [[UILabel alloc ] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 15)];
    [_labelShowContent setFont:MKFONT(15) ];
    if( [self._strSign length] ==0)
    {
        [_labelShowContent setText:@"  编辑一条个性签名吧"];
    }
    [_labelShowContent setTextColor:RGBA(180, 180, 180,1)];
    [_labelShowContent setBackgroundColor:[UIColor clearColor]];
    [viewbg addSubview:_labelShowContent];
    
    //输入字数
    _labelTextCount= [[UILabel alloc ] initWithFrame:CGRectMake(0, 200-30, SCREEN_WIDTH-15, 15)];
    [_labelTextCount setFont:MKFONT(15) ];
    [_labelTextCount setText:@"0/25"];
    [_labelTextCount setTextColor:RGBA(51, 51, 51,0.7)];
    [_labelTextCount setBackgroundColor:[UIColor clearColor]];
    [_labelTextCount setTextAlignment:NSTextAlignmentRight];
    [viewbg addSubview:_labelTextCount];
    
}
- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"%@",textView.text);
    if([textView.text length] > 25)
    {
        _textViewSign.text = [textView.text substringToIndex:25 ];
    }
    if([textView.text length] == 0)
    {
        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
        [_btnEnsure setEnabled:NO];
        _labelShowContent.hidden = NO;
    }
    else
    {
        [_btnEnsure setEnabled:YES];
        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        _labelShowContent.hidden = YES;
    }
    
    if ([textView.text length] >= 25)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [Tool showWarningTipForView:@"别写啦!写太多装不下了!" time:1 view:window];
        [_textViewSign setText:[_textViewSign.text substringToIndex:25]];
    }
    
    NSInteger strACout = textView.text.length;
    NSString * str = [NSString stringWithFormat:@"%ld/25",(long)strACout];
    [_labelTextCount setText:str];
    if((int)strACout < 0 )
    {
         [_labelTextCount setTextColor:[UIColor redColor]];
    }
    else
    {
         [_labelTextCount setTextColor:RGBA(51, 51, 51,0.7)];
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [_textViewSign resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void) onButtonClose
{
    [MobClick event:myCenterViewbtn4];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 修改用户签名
-(void) onButtonEnsure
{
    [MobClick event:myCenterViewbtn3];
    __weak typeof(self) weakSelf = self;
    [ServicesUser updateUserInfo:@"" gender:nil birthday:@"" signature:_textViewSign.text headUrl:@"" model:^(RequestResult *model)
    {
        [weakSelf onButtonClose];
        
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:1];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textViewSign resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
