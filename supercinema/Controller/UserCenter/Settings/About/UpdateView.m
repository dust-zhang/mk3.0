//
//  UpdateViewController.m
//  supercinema
//
//  Created by dust on 16/11/30.
//
//

#import "UpdateView.h"

@implementation UpdateView


-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic showHideBackBtn:(BOOL)status
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self._dicVer = dic;
        self.backgroundColor = RGBA(246, 246, 251,1);    //设置背景颜色
        
        [self initCtrlshowHideBackBtn:status];
    }
    return self;
}

//渲染UI
-(void)initCtrlshowHideBackBtn:(BOOL)status
{
    //顶部View
    UIView *_viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _viewTop.backgroundColor = RGBA(255, 255, 255, 1);
    [self addSubview:_viewTop];
    
    //标题
    UILabel *_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 30, 180, 17)];//23+15;SCREEN_WIDTH-(23+15)*2
    [_labelTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTitle setTextColor:RGBA(51, 51, 51,1)];
    [_labelTitle setTextAlignment:NSTextAlignmentCenter];
    [_labelTitle setFont:MKFONT(17)];
    [_labelTitle setUserInteractionEnabled:YES];
    [_labelTitle setText:@"更新"];
    [_viewTop addSubview:_labelTitle];
    
    //描边
    UILabel *_labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    [_labelLine setBackgroundColor:RGBA(0, 0, 0, 0.05)];
    [_viewTop addSubview:_labelLine];
    
    //返回按钮
    UIButton *_btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 82/2, 30)];
    [_btnBack setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(onButtonCloseView) forControlEvents:UIControlEventTouchUpInside];
    [_viewTop addSubview:_btnBack];
    [_viewTop setHidden:status];
    
    
    UIImageView *imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, _viewTop.frame.origin.y+_viewTop.frame.size.height+60, 60, 60)];
    imageViewLogo.backgroundColor = [UIColor clearColor];
    [imageViewLogo setImage:[UIImage imageNamed:@"image_about.png"]];
    [self addSubview:imageViewLogo];
    
    UILabel *labelVerDesc = [[UILabel alloc ] initWithFrame:CGRectMake(0, imageViewLogo.frame.origin.y+imageViewLogo.frame.size.height+15, SCREEN_WIDTH, 15)];
    [labelVerDesc setFont:MKFONT(15)];
    [labelVerDesc setTextAlignment:NSTextAlignmentCenter];
    [labelVerDesc setTextColor:RGBA(51, 51, 51, 1)];
    [self addSubview:labelVerDesc];
    [labelVerDesc setText:[NSString stringWithFormat:@"当前版本V%@，可更新到V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[self._dicVer objectForKey:@"versionNew"]  ]];
    
    UILabel *labelTitle = [[UILabel alloc ] initWithFrame:CGRectMake(33, labelVerDesc.frame.origin.y+labelVerDesc.frame.size.height+60, SCREEN_WIDTH, 14)];
    [labelTitle setFont:MKFONT(14)];
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    [labelTitle setTextColor:RGBA(51, 51, 51, 1)];
    [labelTitle setText:@"更新内容："];
    [self addSubview:labelTitle];
    
    UITextView  *textViewContent= [[UITextView alloc ] initWithFrame:CGRectMake(33, labelTitle.frame.origin.y+labelTitle.frame.size.height+5, SCREEN_WIDTH-30,150)];
    [textViewContent setBackgroundColor:[UIColor clearColor]];
    [textViewContent setTextColor:RGBA( 102, 102, 102, 1)];
    [textViewContent setTextAlignment:NSTextAlignmentLeft];
    [textViewContent setText:[self._dicVer objectForKey:@"updateDescription"]];
    [textViewContent setFont:MKFONT(13) ];
    [textViewContent setEditable:false];
    textViewContent.showsVerticalScrollIndicator = YES;
    textViewContent.showsHorizontalScrollIndicator = YES;
    [self addSubview:textViewContent];

    //立即更新
    UIButton *btnUpdate = [[UIButton alloc ] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-170, SCREEN_WIDTH-20, 40)];
    [btnUpdate setTitle:@"立即更新" forState:UIControlStateNormal];
    [btnUpdate setBackgroundColor:RGBA(0, 0, 0,1)];
    [btnUpdate.titleLabel setFont:MKBOLDFONT(15)];
    btnUpdate.layer.masksToBounds = YES;
    btnUpdate.layer.cornerRadius = 5;
    [btnUpdate addTarget:self action:@selector(onButtonDownLoadApp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnUpdate];
 
    _btnCancel = [[UIButton alloc ] initWithFrame:CGRectMake(10, btnUpdate.frame.origin.y+btnUpdate.frame.size.height+30, SCREEN_WIDTH-20, 12)];
    [_btnCancel setBackgroundColor:[UIColor clearColor] ];
    [_btnCancel setTitleColor:RGBA(123, 122, 152, 0.6) forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:MKFONT(12)];
    [_btnCancel setTitle:@"下次再说>>" forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(onButtonCloseView) forControlEvents:UIControlEventTouchUpInside];
    //    1 强制更新 ，0手动更新
    if([[self._dicVer objectForKey:@"mustUpdate"] intValue]== 0)
        [self addSubview:_btnCancel];
    _isUpdate =[[self._dicVer objectForKey:@"mustUpdate"] intValue ];
    
}

-(void)onButtonCloseView
{
    [MobClick event:myCenterViewbtn123];
    if (self)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }
}

-(void)onButtonDownLoadApp
{
    if ([[self._dicVer objectForKey:@"updateClientUrl"] length] <= 0 )
    {
        
        if (self)
        {
            [MobClick event:myCenterViewbtn122];
            [self removeFromSuperview];
        }
    }
    else
    {
        [MobClick event:myCenterViewbtn121];
        if (_isUpdate == 1)
        {
            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:[self._dicVer objectForKey:@"updateClientUrl"]]];
        }
        else
        {
            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:[self._dicVer objectForKey:@"updateClientUrl"]]];
        }
    }
}



@end
