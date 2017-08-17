//
//  CommentElseViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import "CommentElseViewController.h"

@interface CommentElseViewController ()

@end

@implementation CommentElseViewController

#define MAXHEIGHT   90
#define kTextViewMinHeight 34
#define SPACETEXTVIEW   (45-34)/2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self._labelTitle.text = @"短评";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerForKeyboardNotifications];
    [self setOriginData];
    [self initControl];
    _deleteAll = NO;
    _curPageIndex = @1;
    _lastCommentId = @0;
    _arrList = [[NSMutableArray alloc]init];
    _isKeyBoardShow = NO;
    _arrIcon = @[@[@"img_user_lan.png",@"烂！"],@[@"img_user_e.png",@"呃..."],@[@"img_user_haixing.png",@"还行"],@[@"img_user_tuijian.png",@"推荐"],@[@"img_user_dianzan.png",@"超赞"]];
    [self loadData];
}

-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieReviewDetail:[self.reviewId stringValue] model:^(MovieReviewDetailModel *model) {
        _movieModel = model;
//        _lastCommentId = _movieModel.movieReview.id;
        [weakSelf loadListData];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    }];
}

-(void)loadListData
{
    __weak typeof(self) weakSelf = self;
    [ServicesMovie getMovieCommentList:_curPageIndex movieReviewId:self.reviewId model:^(MovieReviewModel1 *model) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        _listModel = model;
        [weakSelf setFooterState];
        [_arrList addObjectsFromArray:model.commentList];
        [_myTable reloadData];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    }];
}

-(void)setOriginData
{
    _rectOriginSendView = CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45);
    _widthSendBtn = [Tool calStrWidth:@"发送" height:15] + 30;
    _rectOriginSendBtn = CGRectMake(SCREEN_WIDTH-_widthSendBtn, 15, _widthSendBtn, 15);
    _rectOriginSendText = CGRectMake(15, SPACETEXTVIEW, SCREEN_WIDTH-15-_widthSendBtn, kTextViewMinHeight);
}

-(void)registerForKeyboardNotifications
{
    //键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //键盘显示
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

-(void)initControl
{
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(SCREEN_WIDTH-15-30, self._btnBack.frame.origin.y+(self._btnBack.frame.size.height-30)/2, 45, 30);
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(onButtonRight) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:btnRight];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH, 0.5)];
    viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [self.view addSubview:viewLine];
    
    [self initTable];
    [self initSendView];
}

-(void)onButtonBack
{
    if (self.refreshListBlock)
    {
        self.refreshListBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initSendView
{
    _viewSend = [[UIView alloc]initWithFrame:_rectOriginSendView];
    _viewSend.backgroundColor = RGBA(251, 251, 253, 1);
    [self.view addSubview:_viewSend];
    
    UIView* viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    viewline.backgroundColor = RGBA(0, 0, 0, 0.05);
    [_viewSend addSubview:viewline];
    
    _textView = [[UITextView alloc]initWithFrame:_rectOriginSendText];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView setTextColor:RGBA(51, 51, 51, 1)];
    _textView.scrollEnabled = YES;
    _textView.font = MKFONT(15);
    _textView.delegate = self;
    _textView.scrollEnabled = NO;
    [_viewSend addSubview:_textView];
    
    _labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(_rectOriginSendText.origin.x+8, _rectOriginSendText.origin.y, 200, _rectOriginSendText.size.height)];
    _labelDefault.font = MKFONT(15);
    _labelDefault.textColor = RGBA(180, 180, 180, 1);
    _labelDefault.text = @"朕有话要说...";
    [_viewSend addSubview:_labelDefault];
    
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSend.frame = _rectOriginSendBtn;
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    _btnSend.enabled = NO;
    _btnSend.titleLabel.font = MKFONT(15);
    _btnSend.enabled = NO;
    [_btnSend setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
    [_btnSend addTarget:self action:@selector(onButtonSend) forControlEvents:UIControlEventTouchUpInside];
    [_viewSend addSubview:_btnSend];
}

-(void)initTable
{
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.size.height+0.5, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height-0.5-45)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.backgroundColor = [UIColor clearColor];
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTable];
    
    [_myTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
}

-(void)setFooterState
{
    if ([_curPageIndex integerValue] == [_listModel.pageTotal integerValue] || [_listModel.pageTotal integerValue] == 0)
    {
        [_myTable.footer setState:MJRefreshFooterStateNoMoreData];
        [_myTable.footer setHidden:YES];
    }
    else
    {
        [_myTable.footer setHidden:NO];
        _curPageIndex = [NSNumber numberWithInteger:[_curPageIndex integerValue]+1];
    }
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrList.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSString* strDescribe = _movieModel.movieReview.content;
        CGSize sizeDesc = [Tool CalcString:strDescribe fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-30];
        
        
        return sizeDesc.height + 193;
    }
    else
    {
        MovieReviewListModel* model = _arrList[indexPath.row-1];
        NSString* strDesc = model.content;
        if (model.replyUser.nickname.length>0)
        {
            strDesc = [NSString stringWithFormat:@"回复%@：%@",model.replyUser.nickname,strDesc];
        }
        CGSize sizeDesc = [Tool CalcString:strDesc fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-85];
        return sizeDesc.height+19+15+15+15+11+15;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && !_isKeyBoardShow)
    {
       [_textView becomeFirstResponder];
    }
    else
    {
        [_textView resignFirstResponder];
    }
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *identifier1= [NSString stringWithFormat:@"CDetailHeadTableViewCell%ld",(long)indexPath.row];
    NSString *identifier2= [NSString stringWithFormat:@"CDetailTableViewCell%ld",(long)indexPath.row];
    
    if (indexPath.row == 0)
    {
        //头部cell
        CDetailHeadTableViewCell *cell;//= (CDetailHeadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell==nil)
        {
            cell = [[CDetailHeadTableViewCell alloc] initWithReuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.cHDelegate = self;
        }
        [cell setData:_movieModel icon:_arrIcon count:_arrList.count];
        return cell;
    }
    else
    {
        //短评cell
        CDetailTableViewCell* cell; //= (CDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell==nil)
        {
            cell = [[CDetailTableViewCell alloc] initWithReuseIdentifier:identifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.cDelegate = self;
        }
        [cell setData:_arrList[indexPath.row-1] curTime:_listModel.currentTime];
        cell.canTouch = YES;
        return cell;
    }
}

-(void)loadNewData
{
    [self loadData];
    [_myTable.footer endRefreshing];
}

-(void)textViewDidChange:(UITextView *)textView
{
//    NSUInteger oldLength=textView.text.length;
//    NSString *newTextValue=[Tool disableEmoji:[textView text]];
//    if(newTextValue.length!=oldLength)
//    {
//        [textView setText:newTextValue];
//    }
    
    if (textView.text.length>300)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [Tool showWarningTipForView:@"最多300字" time:0.5 view:window];
        textView.text = [textView.text substringToIndex:300];
    }
    
    //折行重算高度
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= MAXHEIGHT)
    {
        textView.scrollEnabled = YES;
        size.height = MAXHEIGHT;
    }
    else
    {
        textView.scrollEnabled = NO;
    }
    CGFloat lastTVHeight = textView.frame.size.height;
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    _viewSend.frame = CGRectMake(_viewSend.frame.origin.x, _viewSend.frame.origin.y+lastTVHeight-size.height, _viewSend.frame.size.width, size.height+SPACETEXTVIEW*2);
    _btnSend.frame = CGRectMake(_btnSend.frame.origin.x, (_viewSend.frame.size.height-15)/2, _btnSend.frame.size.width, 15);
    
    [self refreshState];
}

-(void)refreshState
{
    if (_textView.text.length==0)
    {
        [_btnSend setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];
        _btnSend.enabled = NO;
        _labelDefault.hidden = NO;
    }
    else
    {
        [_btnSend setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        _btnSend.enabled = YES;
        _labelDefault.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    if (_arrList.count>0)
    {
        for (int i = 0; i<_arrList.count; i++)
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i+1 inSection:0];
            CDetailTableViewCell* cell = (CDetailTableViewCell*)[_myTable cellForRowAtIndexPath:path];
            cell.canTouch = NO;
        }
    }
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _viewSend.frame = CGRectMake(_viewSend.frame.origin.x, SCREEN_HEIGHT-_viewSend.frame.size.height-height, _viewSend.frame.size.width, _viewSend.frame.size.height);
    
    _isKeyBoardShow = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (_arrList.count>0)
    {
        for (int i = 0; i<_arrList.count; i++)
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i+1 inSection:0];
            CDetailTableViewCell* cell = (CDetailTableViewCell*)[_myTable cellForRowAtIndexPath:path];
            cell.canTouch = YES;
        }
    }
    
    _viewSend.frame = CGRectMake(_viewSend.frame.origin.x, SCREEN_HEIGHT-_viewSend.frame.size.height, _viewSend.frame.size.width, _viewSend.frame.size.height);
    
    _isKeyBoardShow = NO;
}

-(void)onButtonRight
{
    if ([_movieModel.followButtonStatus integerValue] == 0)
    {
        _deleteAll = YES;
        _deleteId = _movieModel.movieReview.id;
        //删除
        NSMutableArray* arrDelete = [[NSMutableArray alloc] init];
        [arrDelete addObject:@{ @"name" : @"删除" }];
        FDActionSheet* sheetDelete = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrDelete];
        sheetDelete.tag = 50;
        for (int i = 0; i < arrDelete.count; i++)
        {
            [sheetDelete setButtonTitleColor:RGBA(249, 81, 81, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
        }
        sheetDelete.delegate = self;
        [sheetDelete show];
    }
    else
    {
        [self jubaoUser:_movieModel.movieReview.id type:0];
    }
//   [self jubaoUser:_movieModel.movieReview.id type:[_movieModel.movieReview.userDeleteStatus intValue]];
}

-(void)onButtonSend
{
    NSString* strContent = _textView.text;
    NSNumber* replyId = @0;
    //判断当前回复评论拼接字符串是否在textview的文本里
    if (_laststrResUser.length<=strContent.length)
    {
        if ([_laststrResUser isEqualToString:[_textView.text substringWithRange:NSMakeRange(0,_laststrResUser.length)]])
        {
            //当前回复评论拼接字符串在textview的文本里，说明是回复XXX的评论
            strContent = [_textView.text substringWithRange:NSMakeRange(_laststrResUser.length,_textView.text.length - _laststrResUser.length)];
            replyId = _curCommentModel.publishUser.id;
        }
    }
    
    if ([[strContent  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)
    {
        //全是空格和换行符
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [Tool showWarningTipForView:@"内容不能为空" time:2 view:window];
    }
    else
    {
        [MobClick event:mainViewbtn159];
        __weak typeof(self) weakSelf = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"发送中..." withBlur:NO allowTap:NO];
        [ServicesMovie addMovieReview:nil content:strContent parentId:_movieModel.movieReview.id score:@0 replyUserId:replyId tagIds:nil model:^(RequestResult *movieDetail) {
            //发表评论成功
            _curPageIndex = [NSNumber numberWithInt:1];
            [_arrList removeAllObjects];
            _viewSend.frame = _rectOriginSendView;
            _textView.frame = _rectOriginSendText;
            _btnSend.frame = _rectOriginSendBtn;
            _textView.text = nil;
            _lastCommentId = [NSNumber numberWithInteger:0];
            _laststrResUser = @"";
            [weakSelf refreshState];
            [weakSelf loadData];
        } failure:^(NSError *error) {
            [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        }];
        [_textView resignFirstResponder];
    }
}

#pragma mark CDetailHeadTableViewCellDelegate
-(void)toUserHome:(NSNumber*)uId
{
    
}

-(void)focusComment:(NSNumber*)uId state:(BOOL)state
{
    if (state)
    {
        //关注
        [ServicesUser attentionUser:[uId stringValue] model:^(RequestResult *userList) {
            NSLog(@"关注成功");
            _movieModel.followPersonRelation = [NSNumber numberWithInt:1];
            [_myTable reloadData];
        } failure:^(NSError *error) {
            NSLog(@"关注失败");
        }];
    }
    else
    {
        //取消关注
        [ServicesUser cancelAttentionUser:[uId stringValue] model:^(RequestResult *userList) {
            NSLog(@"取消关注成功");
            _movieModel.followPersonRelation = [NSNumber numberWithInt:2];
            [_myTable reloadData];
        } failure:^(NSError *error) {
            NSLog(@"取消关注失败");
        }];
    }
}

-(void)zanComment:(NSNumber *)cId state:(BOOL)state
{
    if (state)
    {
        //点赞
        [ServicesMovie likeMovieReviewOrComment:[cId stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"点赞成功");
            _movieModel.movieReview.laudStatus = [NSNumber numberWithInt:1];
            _movieModel.movieReview.laudCount = [NSNumber numberWithInteger:[_movieModel.movieReview.laudCount integerValue]+1];
            [_myTable reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        //取消点赞
        [ServicesMovie cancelLikeMovieReviewOrComment:[cId stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"取消点赞成功");
            _movieModel.movieReview.laudStatus = [NSNumber numberWithInt:0];
            _movieModel.movieReview.laudCount = [NSNumber numberWithInteger:[_movieModel.movieReview.laudCount integerValue]-1];
            [_myTable reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark CDetailTableViewCellDelegate
-(void)respondUser:(MovieReviewCommentListModel *)model
{
    MovieReviewUserModel* commentModel = model.publishUser;
    NSString* strRes = [NSString stringWithFormat:@"回复%@：",commentModel.nickname];
    
    //算出当前的评论id
    //判断当前回复评论拼接字符串是否在textview的文本里
    if (_laststrResUser.length<=_textView.text.length)
    {
        if ([_laststrResUser isEqualToString:[_textView.text substringWithRange:NSMakeRange(0,_laststrResUser.length)]])
        {
            //回复结构没被破坏
            
        }
        else
        {
            //结构被破坏
            _lastCommentId = @0;
        }
    }
    else
    {
        _lastCommentId = @0;
    }
    
    if (_textView.text.length>0)
    {
        //有评论内容，判断评论的id和当前的id是不是相等
        if ([model.id integerValue] == [_lastCommentId integerValue])
        {
            //相等，textview.text不改值
            
        }
        else
        {
            //把strRes赋值给textview.text
            _textView.text = strRes;
            _lastCommentId = model.id;
            _laststrResUser = strRes;
            _curCommentModel = model;
        }
    }
    else
    {
        //评论内容为空，直接把strRes赋值给textview.text
        _textView.text = strRes;
        _lastCommentId = model.id;
        _laststrResUser = strRes;
        _curCommentModel = model;
    }
    
    [_textView becomeFirstResponder];
    [self refreshState];
}

-(void)toElseHome:(NSInteger)uId
{

}

-(void)jubaoUser:(NSNumber *)cId type:(int)type
{
    if (_isKeyBoardShow)
    {
        //键盘弹起
        [_textView resignFirstResponder];
    }
    else
    {
        _deleteId = [NSNumber numberWithInteger:[cId integerValue]];
        _deleteAll = NO;
        if (type == 0)
        {
            //举报
            NSMutableArray* arrJubao = [[NSMutableArray alloc] init];
            [arrJubao addObject:@{ @"name" : @"举报" }];
            FDActionSheet* sheetJubao = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrJubao];
            sheetJubao.tag = 20;
            for (int i = 0; i < arrJubao.count; i++)
            {
                [sheetJubao setButtonTitleColor:RGBA(51, 51, 51, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
            }
            sheetJubao.delegate = self;
            [sheetJubao show];
        }
        else
        {
            //删除
            NSMutableArray* arrDelete = [[NSMutableArray alloc] init];
            [arrDelete addObject:@{ @"name" : @"删除" }];
            FDActionSheet* sheetDelete = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrDelete];
            sheetDelete.tag = 40;
            for (int i = 0; i < arrDelete.count; i++)
            {
                [sheetDelete setButtonTitleColor:RGBA(249, 81, 81, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
            }
            sheetDelete.delegate = self;
            [sheetDelete show];
        }
    }
}

- (void)actionSheet:(FDActionSheet*)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    //举报
    NSMutableArray* arrJubaoDetail = [[NSMutableArray alloc] init];
    [arrJubaoDetail addObject:@{ @"name" : @"色情，淫秽或低俗内容" }];
    [arrJubaoDetail addObject:@{ @"name" : @"广告或垃圾信息" }];
    [arrJubaoDetail addObject:@{ @"name" : @"激进时政或者意识形态" }];
    [arrJubaoDetail addObject:@{ @"name" : @"其他原因" }];
    if (sheet.tag == 20)
    {
        FDActionSheet* sheetJubaoDetail = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrJubaoDetail];
        sheetJubaoDetail.tag = 30;
        sheetJubaoDetail.delegate = self;
        for (int i = 0; i < arrJubaoDetail.count; i++)
        {
            [sheetJubaoDetail setButtonTitleColor:RGBA(117, 112, 255, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
        }
        [sheetJubaoDetail show];
    }
    if (sheet.tag == 30)
    {
        //举报详细
        [ServicesMovie reportMovieOrComment:_deleteId reason:[arrJubaoDetail[buttonIndex] valueForKey:@"name"] model:^(RequestResult *model) {
            NSLog(@"举报成功");
            [Tool showSuccessTip:@"举报成功！" time:2.0];
        } failure:^(NSError *error) {
            [Tool showWarningTip:error.domain time:2.0];
        }];
        
    }
    if (sheet.tag == 40)
    {
        //删除
        UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此回复吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertDelete.tag = 201;
        [alertDelete show];
    }
    if (sheet.tag == 50)
    {
        //删除
        UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此短评吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertDelete.tag = 200;
        [alertDelete show];
    }
}

-(void)actionSheetCancel:(FDActionSheet *)actionSheet
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200)
    {
        //删除alert
        if (buttonIndex == 1)
        {
            //删除提示alert
            UIAlertView* alertDeleteDetail = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短评删除后，它的所有回复、点赞也将被删除。是否继续删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alertDeleteDetail.tag = 201;
            [alertDeleteDetail show];
        }
    }
    if (alertView.tag == 201)
    {
        //删除提示alert
        if (buttonIndex == 1)
        {
            //删除
            __weak typeof(self) weakSelf = self;
            if (_deleteAll)
            {
                [ServicesMovie deleteMovieReviewOrComment:_movieModel.movieReview.id model:^(RequestResult *movieDetail) {
                    NSLog(@"删除成功");
                    _deleteAll = NO;
                    [Tool showSuccessTip:@"删除成功！" time:2.0];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    _deleteAll = NO;
                    [Tool showWarningTip:error.domain time:2.0];
                }];
            }
            else
            {
                [ServicesMovie deleteMovieReviewOrComment:_deleteId model:^(RequestResult *movieDetail) {
                    NSLog(@"删除成功");
                    [_arrList removeAllObjects];
                    [weakSelf loadData];
                    [Tool showSuccessTip:@"删除成功！" time:2.0];
                } failure:^(NSError *error) {
                    [Tool showWarningTip:error.domain time:2.0];
                }];

            }
        }
    }
}

-(void)hideKeyboard
{
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
