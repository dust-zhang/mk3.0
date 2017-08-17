//
//  ExUISearchBar.m
//  supercinema
//
//  Created by dust on 16/11/10.
//
//

#import "ExUISearchBar.h"

@implementation ExUISearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:frame.size.height/2];
        [self setBackgroundColor:RGBA(246,246,251,1)];


        self._textFieldSearchInput = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-95, 30)];
        self._textFieldSearchInput.delegate = self;
        [self._textFieldSearchInput setFont:MKFONT(14) ];
        [self._textFieldSearchInput setBackgroundColor:[UIColor clearColor] ];
        [self._textFieldSearchInput setTextColor:RGBA(123, 122, 152, 1)];
        self._textFieldSearchInput.returnKeyType = UIReturnKeySearch;
        self._textFieldSearchInput.enablesReturnKeyAutomatically = YES;
        [self._textFieldSearchInput addTarget:self action:@selector(searchCinema:) forControlEvents:UIControlEventEditingDidEnd];
        [self._textFieldSearchInput setPlaceholder:@"搜索"];
        [self addSubview:self._textFieldSearchInput];
        
        self._imageViewSearch = [[UIImageView alloc ] initWithFrame:CGRectMake( 10, 6, 36/2,  36/2)];
        [self._imageViewSearch setImage:[UIImage imageNamed:@"image_CinemaSearch.png"]];
        [self addSubview:self._imageViewSearch];
        
        self._btnClear= [[UIButton alloc ] initWithFrame:CGRectMake( frame.size.width-25, 7, 15,  15)];
        [self._btnClear setImage:[UIImage imageNamed:@"image_CinemaClear.png"] forState:UIControlStateNormal];
        [self._btnClear addTarget:self action:@selector(onButtonClear) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self._btnClear];
        [self._btnClear setHidden:YES];
        
    }
    return self;
}


-(void)searchCinema:(UITextField *)sender
{
    NSString *keyWords = [sender text];
    NSString *temp = [keyWords  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([temp length] == 0)
    {
        self._textFieldSearchInput.text = temp;
        return ;
    }
    self._textFieldSearchInput.text = temp;
    
    if(keyWords.length >= 1)
    {
        [self._labelSearch setHidden:YES];
        [self._btnClear setHidden:NO];
    }
    else
    {
        [self._labelSearch setHidden:NO];
        [self._btnClear setHidden:YES];
    }
        
    if ([self.seatchBarDelegate respondsToSelector:@selector(searchCinema:)])
    {
        [self.seatchBarDelegate searchCinema:self._textFieldSearchInput.text];
    }
}

#pragma mark 清空输入内容
-(void)onButtonClear
{
    self._textFieldSearchInput.text = @"";
    [self._labelSearch setHidden:NO];
    [self._btnClear setHidden:YES];
    
    if ([self.seatchBarDelegate respondsToSelector:@selector(searchCinema:)])
    {
        [self.seatchBarDelegate searchCinema:self._textFieldSearchInput.text];
    }
}

-(void)hideLabelAndClearbutton
{
    [self._labelSearch setHidden:YES];
    [self._btnClear setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.seatchBarDelegate respondsToSelector:@selector(textFieldReturn)])
    {
        [self.seatchBarDelegate textFieldReturn];
        [self._textFieldSearchInput resignFirstResponder];
    }
    
    return TRUE;
}

@end
