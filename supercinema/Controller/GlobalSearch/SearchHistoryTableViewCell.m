//
//  SearchHistoryTableViewCell.m
//  supercinema
//
//  Created by dust on 16/11/7.
//
//

#import "SearchHistoryTableViewCell.h"

@implementation SearchHistoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor] ];
        //影院名称
        self._labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-130, 42)];
        [self._labelName setTextColor:RGBA(123, 122, 152,1)];
        [self._labelName setFont:MKFONT(12) ];
        [self._labelName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self._labelName];
    
        self._imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-85,  self._labelName.frame.origin.y+19.5, 18/2, 10/2)];
        [self addSubview:self._imageView];
    
        self._btnClearOrLocation= [[UIButton alloc] initWithFrame:CGRectMake(self._imageView.frame.origin.x+14, self._labelName.frame.origin.y, 55, 44)];
        [self._btnClearOrLocation setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [self._btnClearOrLocation.titleLabel setFont:MKFONT(12) ];
        [self._btnClearOrLocation addTarget:self action:@selector(onButtonClear:) forControlEvents:UIControlEventTouchUpInside];
        [self._btnClearOrLocation setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self._btnClearOrLocation];
     
        self._labelClearOrLocation= [[UILabel alloc] initWithFrame:CGRectMake(self._imageView.frame.origin.x+14, self._labelName.frame.origin.y, 55, 44)];
        [self._labelClearOrLocation setTextColor:RGBA(51, 51, 51, 1)];
        [self._labelClearOrLocation setFont:MKFONT(12) ];
        [self._labelClearOrLocation setBackgroundColor:[UIColor clearColor]];
        [self._labelClearOrLocation setTextAlignment:NSTextAlignmentCenter];
        [self._labelClearOrLocation setUserInteractionEnabled:NO];
        [self addSubview:self._labelClearOrLocation];
        
    }
    return self;
}

-(void)setHistory:(NSMutableArray *)arrHistory
{
    [self._labelName setText:@"搜索历史"];
    [self._imageView setImage:[UIImage imageNamed:@"btn_cinemaClear.png"] ];
    self._imageView.frame  = CGRectMake(SCREEN_WIDTH-45-(28/2) -5,  self._labelName.frame.origin.y+14, 28/2, 28/2);
    
    [self._btnClearOrLocation setTitle:@"清空" forState:UIControlStateNormal];
    [self._btnClearOrLocation setTitleColor:RGBA(133, 128, 255, 1) forState:UIControlStateNormal];
    self._btnClearOrLocation.frame = CGRectMake(self._imageView.frame.origin.x+14, self._labelName.frame.origin.y, 55, 44);
    [self._labelClearOrLocation setHidden:YES];
    
    for (int i = 0; i < arrHistory.count; i ++)
    {
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",name] forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBA(246, 246, 251,1)];
        [btn setTitleColor:RGBA(51, 51, 51,0.8) forState:UIControlStateNormal];
        [btn.titleLabel setFont:MKFONT(13) ];
        btn.layer.cornerRadius = 3.0;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        CGRect rect = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        CGFloat BtnW = rect.size.width;
        NSLog(@"%f", SCREEN_WIDTH-60);
        if (BtnW < SCREEN_WIDTH-60)
        {
            BtnW = rect.size.width+30;
        }
        
        CGFloat BtnH = 30;
        
        if (i == 0)
        {
            btn.frame =CGRectMake(15, self._labelName.frame.origin.y+self._labelName.frame.size.height, BtnW, BtnH);
        }
        else
        {
            CGFloat yuWidth = self.frame.size.width - 20 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width)
            {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }
            else
            {
                btn.frame =CGRectMake(15, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
            }
        }
        [self addSubview:btn];
        
        self.frame = CGRectMake(15, self._labelName.frame.origin.y+self._labelName.frame.size.height, [UIScreen mainScreen].bounds.size.width - 20,CGRectGetMaxY(btn.frame)+10);
        recordBtn = btn;
        btn.tag = i;
        [btn addTarget:self action:@selector(onButtonHistory:) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void)setReommmedCinema:(NSString *)name showHideBtn:(BOOL) showHide cityName:(NSString*)cityName
{
    [self._labelName setText:name];
    [self._imageView setImage:[UIImage imageNamed:@"btn_CinemaCitySelect.png"] ];
    [self._imageView  setHidden:showHide];
    
    if ([name isEqualToString:@"推荐影院"] || [name isEqualToString:@"影院"])
    {
        [self._labelClearOrLocation setBackgroundColor:[UIColor whiteColor]];
        [self._btnClearOrLocation setTitle:cityName forState:UIControlStateNormal];
        [self._labelClearOrLocation setText:cityName ];
    }
    else
    {
        [self._btnClearOrLocation setTitle:@"" forState:UIControlStateNormal];
        [self._labelClearOrLocation setText:@"" ];
        [self._labelClearOrLocation setBackgroundColor:[UIColor clearColor]];
        [self._btnClearOrLocation setBackgroundColor:[UIColor clearColor]];
        
    }
    
}

-(void) onButtonClear:(UIButton*)sender
{
    if ([self.clearHistoryDelegate respondsToSelector:@selector(onButtonClear:)])
    {
        [self.clearHistoryDelegate onButtonClear:sender ];
    }
}
-(void)onButtonHistory:(UIButton*)sender
{
    if ([self.clearHistoryDelegate respondsToSelector:@selector(onButtonHistory:)])
    {
        for (int i = 0 ;i <= [[Config getSearchHistory ] count] ;i++)
        {
            if (sender.tag == i )
            {
                 [self.clearHistoryDelegate onButtonHistory:[Config getSearchHistory ][i] ];
            }
        }
       
    }
}

@end
