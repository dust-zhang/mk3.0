//
//  ShareReasonViewController.m
//  supercinema
//
//  Created by mapollo91 on 23/3/17.
//
//

#import "ShareReasonViewController.h"

@interface ShareReasonViewController ()

@end

@implementation ShareReasonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.view setBackgroundColor:RGBA(246, 246, 250, 1)];
    [Tool hideTabBar];
    [self initController];
}

//初始化控件
-(void)initController
{
    //返回按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 82/2, 30)];
    [btnClose setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    //标题
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(41, 30, SCREEN_WIDTH-41*2, 17)];//23+15;SCREEN_WIDTH-(23+15)*2
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setTextColor:RGBA(51, 51, 51,1)];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:MKFONT(17)];
    [labelTitle setUserInteractionEnabled:YES];
    [labelTitle setText:@"推荐理由"];
    [self.view addSubview:labelTitle];
    
    //确认按钮
    _btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-55,67/2, 40, 15)];
    [_btnEnsure setTitle:@"确认" forState:UIControlStateNormal];
    [_btnEnsure setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    [_btnEnsure.titleLabel setFont:MKFONT(15)];
    [_btnEnsure addTarget:self action:@selector(onButtonEnsure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEnsure];
//    [_btnEnsure setEnabled:NO];
//    if([self._strSign length] > 0)
//    {
        [_btnEnsure setEnabled:YES];
        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
//    }
    
    //输入的白色背景
    UIView *viewbg = [[UIView alloc ] initWithFrame:CGRectMake(0, _btnEnsure.frame.origin.y+_btnEnsure.frame.size.height+25, SCREEN_WIDTH, 200)];
    [viewbg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewbg];
    
    //输入框
    _textViewSign = [[UITextView alloc ] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-30, 170)];
    _textViewSign.delegate = self;
    [_textViewSign setKeyboardType:UIKeyboardTypeDefault];
    [_textViewSign setReturnKeyType:UIReturnKeyDone];
    [_textViewSign setFont:MKFONT(15)];
    if ([self._strSign isEqualToString:@"写下你的精彩推荐语吧！"])
    {
        self._strSign = @"";
    }
    
    _textViewSign.text = self._strSign;
    
    [viewbg addSubview:_textViewSign];
    
    //提示语
    _labelShowContent = [[UILabel alloc ] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 15)];
    [_labelShowContent setFont:MKFONT(15) ];
    if( [_textViewSign.text isEqualToString:@""])
    {
        [_labelShowContent setText:@"  写下你的精彩推荐语吧!"];
    }
    [_labelShowContent setTextColor:RGBA(180, 180, 180,1)];
    [_labelShowContent setBackgroundColor:[UIColor clearColor]];
    [viewbg addSubview:_labelShowContent];
    
    //输入字数
    _labelTextCount= [[UILabel alloc ] initWithFrame:CGRectMake(0, 200-30, SCREEN_WIDTH-15, 15)];
    [_labelTextCount setFont:MKFONT(15) ];
    [_labelTextCount setText:@"0/20"];
    [_labelTextCount setTextColor:RGBA(51, 51, 51,0.7)];
    [_labelTextCount setBackgroundColor:[UIColor clearColor]];
    [_labelTextCount setTextAlignment:NSTextAlignmentRight];
    
    NSInteger strACout = self._strSign.length;
    NSString * str = [NSString stringWithFormat:@"%ld/20",(long)strACout];
    [_labelTextCount setText:str];
    if((int)strACout < 0 )
    {
        [_labelTextCount setTextColor:[UIColor redColor]];
    }
    else
    {
        [_labelTextCount setTextColor:RGBA(51, 51, 51,0.7)];
    }
    [viewbg addSubview:_labelTextCount];
}

#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //    NSLog(@"%@",textView.text);
    if([textView.text length] > 20)
    {
        _textViewSign.text = [textView.text substringToIndex:20 ];
    }
    if([textView.text length] == 0)
    {
//        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
//        [_btnEnsure setEnabled:NO];
        _labelShowContent.hidden = NO;
    }
    else
    {
//        [_btnEnsure setEnabled:YES];
//        [_btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        _labelShowContent.hidden = YES;
    }
    
    if ([textView.text length] >= 20)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [Tool showWarningTipForView:@"别写啦!写太多装不下了!" time:1 view:window];
        [_textViewSign setText:[_textViewSign.text substringToIndex:20]];
    }
    
    NSInteger strACout = textView.text.length;
    NSString * str = [NSString stringWithFormat:@"%ld/20",(long)strACout];
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

//取消按钮
-(void) onButtonClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确认按钮
-(void) onButtonEnsure
{
    if ([_textViewSign.text isEqualToString:@""])
    {
        _textViewSign.text = @"写下你的精彩推荐语吧！";
    }
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:_textViewSign.text forKey:@"textViewSign"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_POSTERSHARETEXTSIGN object:dic];
    
    if ([self.delegate respondsToSelector:@selector(ShareReasonTextDelegate:)])
    {
        [self.delegate ShareReasonTextDelegate:_textViewSign.text];
    }
    
    [self onButtonClose];
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
