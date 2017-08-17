//
//  CommentMovieViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/29.
//
//

#import "CommentMovieView.h"

@implementation CommentMovieView


-(instancetype) initWithFrame:(CGRect)frame movieId:(NSNumber *)id
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        self.backgroundColor =[UIColor whiteColor];
        isFirst = TRUE;
        _movieId = id;
        [Tool hideTabBar];
        _btnPre = nil;
        _arrIconDefault = @[@"btn_comment_chaozan_default.png",@"btn_comment_tuijian_default.png",@"btn_comment_haixing_default.png",@"btn_comment_e_default.png",@"btn_comment_lan_default.png"];
        _arrIconSelected = @[@"btn_comment_chaozan.png",@"btn_comment_tuijian.png",@"btn_comment_haixing.png",@"btn_comment_e.png",@"btn_comment_lan.png"];
        _arrText = @[@"超赞",@"推荐",@"还行",@"呃...",@"烂 !"];
        _arrScore = @[@"10分",@"8分",@"6分",@"4分",@"2分"];
        _arrScoreText = @[@10,@8,@6,@4,@2];
        _isSelectIcon = NO;
        _curIndex = 5;
        _arrSaveSeleteTag = [[NSMutableArray alloc ] initWithCapacity:0];
        
        [self registerForKeyboardNotifications];
        [self loadTagData:id];
    }
    return self;
}
#pragma mark 加载标签数据
-(void)loadTagData:(NSNumber *)id
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieTags:id arrTags:^(NSArray *array)
    {
        [FVCustomAlertView hideAlertFromView:self fading:YES];
        _arrMovieTag = [[NSMutableArray alloc ] initWithArray:array];
        
        [self initControl];
        
    } failure:^(NSError *error) {
        [self initControl];
//        [Tool showWarningTip:error.domain time:1];
    }];
}

-(void)registerForKeyboardNotifications
{
    //键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //键盘显示
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)initControl
{
    _viewWhiteTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115/2)];
    _viewWhiteTop.backgroundColor = [UIColor whiteColor];
    [self addSubview:_viewWhiteTop];
    
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose setBackgroundImage:[UIImage imageNamed:@"btn_closeBlack.png"] forState:UIControlStateNormal];
    _btnClose.frame = CGRectMake(0, 27, 94/2, 60/2);
    [_btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [_viewWhiteTop addSubview:_btnClose];
    
    _btnRelease = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRelease.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, _btnClose.frame.origin.y + (_btnClose.frame.size.height-15)/2, 60, 15);
    [_btnRelease setTitle:@"发布" forState:UIControlStateNormal];
    [_btnRelease setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _btnRelease.titleLabel.textAlignment = NSTextAlignmentRight;
    [_btnRelease.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_btnRelease setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    [_btnRelease addTarget:self action:@selector(onButtonRelease) forControlEvents:UIControlEventTouchUpInside];
    [_viewWhiteTop addSubview:_btnRelease];

    
    _scrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0,_btnClose.frame.origin.y+_btnClose.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT- _btnClose.frame.origin.y-_btnClose.frame.size.height)];
    [_scrollView setBackgroundColor:RGBA(246, 246, 251, 1)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setUserInteractionEnabled:YES];
    [self addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT)];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagHideKeyboard)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    [_scrollView addGestureRecognizer:tapGesture];
    
    
    _viewWhite = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    _viewWhite.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_viewWhite];
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 14)];
    _labelTitle.text = @"你觉得这部电影怎么样呢？";
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.font = MKFONT(14);
    _labelTitle.textColor = RGBA(180, 180, 180, 1);
    [_scrollView addSubview:_labelTitle];

    _labelCommentText = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 100, 18)];
    _labelCommentText.font = MKFONT(18);
    _labelCommentText.textColor = RGBA(123, 122, 152, 1);
    [_scrollView addSubview:_labelCommentText];
    
    _labelScore = [[UILabel alloc]initWithFrame:CGRectMake(0, _labelCommentText.frame.origin.y, 100, 10)];
    _labelScore.font = MKFONT(10);
    _labelScore.textColor = RGBA(123, 122, 152, 1);
    _labelScore.backgroundColor = RGBA(244, 215, 57, 1);
    _labelScore.layer.masksToBounds = YES;
    _labelScore.layer.cornerRadius = 5;
    _labelScore.hidden = YES;
    [_scrollView addSubview:_labelScore];
    
    _spaceIcon = (SCREEN_WIDTH - 34*5 - 85)/4;
    _heightDefault = _labelCommentText.frame.origin.y+_labelCommentText.frame.size.height+30;
    UILabel* labelComment;
    for (int i = 0; i<5; i++)
    {
        UIButton* btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnComment setBackgroundImage:[UIImage imageNamed:_arrIconDefault[i]] forState:UIControlStateNormal];
        btnComment.frame = CGRectMake(85/2+(34+_spaceIcon)*i, _heightDefault, 34, 34);
        btnComment.tag = i+100;
        [btnComment addTarget:self action:@selector(onButtonComment:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btnComment];
        
        labelComment = [[UILabel alloc]initWithFrame:CGRectMake(btnComment.frame.origin.x, btnComment.frame.origin.y+btnComment.frame.size.height+15, 34, 12)];
        labelComment.text = _arrText[i];
        labelComment.textAlignment = NSTextAlignmentCenter;
        labelComment.font = MKFONT(12);
        labelComment.textColor = RGBA(123, 122, 152, 1);
        [_scrollView addSubview:labelComment];
    }
//
    [self initMovieTag:_viewWhite labelComment:labelComment];
}

#pragma mark 创建电影标签
-(void) initMovieTag:(UIView*)viewWhite labelComment:(UILabel *)labelComment
{
    UILabel *labelWriteTag;
    if([_arrMovieTag count] > 0)
    {
        labelWriteTag = [[UILabel alloc ] initWithFrame:CGRectMake(0, labelComment.frame.origin.y+labelComment.frame.size.height+30, SCREEN_WIDTH, 12)];
        [labelWriteTag setFont:MKFONT(12)];
        [labelWriteTag setTextColor:RGBA(51, 51, 51, 0.8)];
        [labelWriteTag setText:@"选择你对影片的印象"];
        [labelWriteTag setTextAlignment:NSTextAlignmentCenter];
        [_scrollView addSubview:labelWriteTag];
    }
    
    int _nCountRow = 0;
    for (int i = 0; i < _arrMovieTag.count; i ++)
    {
        TagModel *tagModel = [[TagModel alloc ] init];
        tagModel =_arrMovieTag[i];
        NSString *name = tagModel.tagName;
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",name] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [btn.titleLabel setFont:MKFONT(12) ];
        btn.layer.cornerRadius = 11;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGBA(123, 122, 152,1).CGColor;
        btn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        CGRect rect = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 22) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        CGFloat BtnW = rect.size.width;
        
        if (BtnW < SCREEN_WIDTH-45)
        {
            BtnW = rect.size.width+30;
        }
        
        CGFloat BtnH = 22;
        
        if (i == 0)
        {
            if([_arrMovieTag count] > 0)
            {
                 ++_nCountRow;
                 btn.frame =CGRectMake(15, labelWriteTag.frame.origin.y+labelWriteTag.frame.size.height+15, BtnW, BtnH);
            }
            else
            {
                 btn.frame =CGRectMake(15, labelComment.frame.origin.y+labelComment.frame.size.height+30, BtnW, BtnH);
            }
           
        }
        else
        {
            CGFloat yuWidth = SCREEN_WIDTH - 30 -45 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width)
            {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }
            else
            {
                ++_nCountRow;
                btn.frame =CGRectMake(15, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
            }
        }
        [_scrollView addSubview:btn];
        recordBtn = btn;
        btn.tag = i;
        [btn addTarget:self action:@selector(onButtonTag:) forControlEvents:UIControlEventTouchUpInside];
    }

    if ( _nCountRow  == 0 )
    {
        viewWhite.frame = CGRectMake(0, 0, SCREEN_WIDTH, 118+(60)/2);
    }
    else if ( _nCountRow  == 1 )
    {
        viewWhite.frame = CGRectMake(0, 0, SCREEN_WIDTH, 118+(60+24+30+44+60)/2);
    }
    else
    {
        if (_nCountRow > 0 )
        {
            viewWhite.frame = CGRectMake(0, 0, SCREEN_WIDTH, 118+(60+24+30+44+60)/2+ (_nCountRow -1)*32 );
        }
    }
    
    //输入框位置
    _originYTextView = viewWhite.frame.origin.y+viewWhite.frame.size.height+10;
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, _originYTextView, SCREEN_WIDTH-30, 100)];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView setTextColor:RGBA(51, 51, 51, 1)];
    _textView.scrollEnabled = YES;
    _textView.font = MKFONT(15);
    _textView.delegate = self;
    [_scrollView addSubview:_textView];
    
    _labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(15+5, _textView.frame.origin.y+10, 200, 15)];
    _labelDefault.font = MKFONT(15);
    _labelDefault.textColor = RGBA(180, 180, 180, 1);
    _labelDefault.text = @"评价一下这部电影吧";
    [_scrollView  addSubview:_labelDefault];
    
    _labelCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, SCREEN_HEIGHT-20-15, 100, 15)];
    _labelCount.font = MKFONT(15);
    _labelCount.textColor = RGBA(51, 51, 51, 0.8);
    _labelCount.text = @"0/300";
    _labelCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:_labelCount];
    
}
-(BOOL) isExistTags:(TagModel *)model
{
    if ([_arrSaveSeleteTag count]== 0)
    {
        [_arrSaveSeleteTag addObject:model.id];
        return FALSE;
    }
    for (NSNumber *tagId in _arrSaveSeleteTag)
    {
        if ( [tagId intValue] == [model.id intValue] )
        {
            [_arrSaveSeleteTag removeObject:model.id];
            return TRUE;
        }
    }
    [_arrSaveSeleteTag addObject:model.id];
    return FALSE;
}
#pragma mark 修改标签选中样式
-(void)onButtonTag:(UIButton *)btn
{
//    NSLog(@"%ld",btn.tag);
    TagModel *tagModel = [[TagModel alloc ] init];
    tagModel =_arrMovieTag[btn.tag];
    
    if ([self isExistTags:tagModel])
    {
        [btn setBackgroundColor:[UIColor clearColor] ];
        [btn setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGBA(123, 122, 152,1).CGColor;

    }
    else
    {
        [btn setBackgroundColor:RGBA(117, 112, 255, 1) ];
        btn.layer.borderWidth = 0;
        [btn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    }

}

#pragma mark 输入状态判断
-(void)textViewDidChange:(UITextView *)textView
{
    //去除掉首尾的空白字符和
    NSString *strContent = [Tool clearSpaceAndNewline:textView.text];
    
    if (strContent.length==0)
    {
        [_btnRelease setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    }
    else
    {
        [_btnRelease setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    }
    
    if (textView.text.length==0)
    {
        _labelDefault.hidden = NO;
    }
    else
    {
        _labelDefault.hidden = YES;
    }
    
//    if (textView.text.length>300)
//    {
//        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//        [Tool showWarningTipForView:@"别写啦！写太多装 不下了！" time:1 view:window];
//        textView.text = [textView.text substringToIndex:300];
//    }
//    _labelCount.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)textView.text.length];
    
  _labelCount.attributedText = [self wordNumAttributeString:_textView.text.length];
}

- (NSAttributedString *)wordNumAttributeString:(NSInteger)lenth
{
    UIColor *wordNumColor = RGBA(153, 153, 153, 1);
    if (lenth > 300)
    {
        wordNumColor = RGBA(249, 81, 81, 1);
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",lenth] attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : wordNumColor}];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/300" attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : RGBA(153, 153, 153, 1)}]];
    return attrStr;
}

#pragma mark 键盘弹起
- (void)keyboardWillShow:(NSNotification*)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;

    _labelCount.frame = CGRectMake(_labelCount.frame.origin.x, SCREEN_HEIGHT-_keyBoardHeight-30, 100, 15);
    _textView.frame= CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, _labelCount.frame.origin.y-_textView.frame.origin.y-15);
    
    float textViewY = _textView.frame.origin.y+_textView.frame.size.height;
    if ( ( (SCREEN_HEIGHT-textViewY )- (_keyBoardHeight+42) ) < 0)
    {
        [_scrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT+ ( (_keyBoardHeight+42) -(SCREEN_HEIGHT-textViewY ) ) )];
        [_scrollView setContentOffset: CGPointMake(0, (_keyBoardHeight+42) -(SCREEN_HEIGHT-textViewY ) +115/2 ) animated:YES];
    }
    else
    {
        [_scrollView setContentOffset: CGPointMake(0, 115/2 ) animated:YES];
    }
}

#pragma mark 键盘隐藏
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    _labelCount.frame =  CGRectMake(SCREEN_WIDTH - 15 - 100, SCREEN_HEIGHT-20-15, 100, 15);
}

#pragma mark 5个评分
-(void)onButtonComment:(UIButton*)btn
{
    [_labelTitle setHidden:YES];
    switch (btn.tag)
    {
        case 100:
            [MobClick event:mainViewbtn140];
            break;
        case 101:
            [MobClick event:mainViewbtn141];
            break;
        case 102:
            [MobClick event:mainViewbtn142];
            break;
        case 103:
            [MobClick event:mainViewbtn143];
            break;
        case 104:
            [MobClick event:mainViewbtn144];
            break;
        default:
            break;
    }
    
    _curIndex = btn.tag-100;
    _isSelectIcon = YES;
    
    _labelScore.hidden = NO;
    _labelCommentText.text = _arrText[btn.tag-100];
    _labelScore.text = _arrScore[btn.tag - 100];
    CGFloat widthText = [Tool calStrWidth:_labelCommentText.text height:18];
    CGFloat widthScore = [Tool calStrWidth:_labelScore.text height:10];
    CGFloat space = (SCREEN_WIDTH-widthText-widthScore)/2;
    _labelCommentText.frame = CGRectMake(space, _labelCommentText.frame.origin.y, widthText, 18);
    _labelScore.frame = CGRectMake(_labelCommentText.frame.origin.x+widthText, _labelScore.frame.origin.y, widthScore, 10);
  
    for (int i = 0; i<5; i++)
    {
        UIButton* button = (UIButton*)[_scrollView viewWithTag:i+100];
        if (i == btn.tag-100)
        {
            //当前选中的表情图
            button.frame = CGRectMake(85/2+(34+_spaceIcon)*i-(94/2-34)/2, _heightDefault-(94/2-34), 94/2, 104/2);
            [button setBackgroundImage:[UIImage imageNamed:_arrIconSelected[i]] forState:UIControlStateNormal];
        }
        else
        {
            button.frame = CGRectMake(85/2+(34+_spaceIcon)*i, _heightDefault, 34, 34);
            [button setBackgroundImage:[UIImage imageNamed:_arrIconDefault[i]] forState:UIControlStateNormal];
        }
    }
}

-(void)onButtonRelease
{
    
   
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (_textView.text.length > 300)
    {

        [Tool showWarningTipForView:@"别写了，写太多装不下了" time:1 view:window];
        return;
    }
    
    if ([[_textView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)
    {
        
//        [_btnRelease setEnabled:YES];
//        //全是空格和换行符
//        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//        [Tool showWarningTipForView:@"要写了评论才能发布哦~" time:2 view:window];
    }
    else
    {
        [_btnRelease setEnabled:NO];
        [MobClick event:mainViewbtn145];
        __weak typeof(self) weakSelf = self;
        NSNumber* score = _curIndex < 5 ? _arrScoreText[_curIndex] : @0;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"发送中..." withBlur:NO allowTap:NO];
        [ServicesMovie addMovieReview:[_movieId stringValue] content:_textView.text parentId:@0 score:score replyUserId:@0 tagIds:_arrSaveSeleteTag model:^(RequestResult *movieDetail)
        {
            [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
            if (weakSelf.refreshListBlock)
            {
                weakSelf.refreshListBlock();
            }
            [self performSelector:@selector(onButtonClose) withObject:self afterDelay:1];
        } failure:^(NSError *error) {
            [_btnRelease setEnabled:YES];
            [Tool showWarningTip:error.domain time:2];
        }];
    }
}

-(void)onButtonClose
{
    [MobClick event:mainViewbtn146];
    __weak typeof(self) weakSelf = self;
    if (weakSelf)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.transform = CGAffineTransformMakeScale(0.7, 0.7);
                             weakSelf.hidden=NO;
                             weakSelf.alpha=0;
                         }completion:^(BOOL finish){
                             weakSelf.hidden = YES;
                             [weakSelf removeFromSuperview];
                         }];

    }
    [_textView resignFirstResponder];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}



-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self tagHideKeyboard];
}

-(void) tagHideKeyboard
{
     [_scrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT+55)];
    [_scrollView setContentOffset: CGPointMake(0, 0) animated:YES];
    [_textView resignFirstResponder];
    
    _textView.frame= CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, SCREEN_HEIGHT-_textView.frame.origin.y);
}
@end
