//
//  DynamicDetailViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/3.
//
//

#import "DynamicDetailViewController.h"

@interface DynamicDetailViewController ()

@end

@implementation DynamicDetailViewController
#define MAXHEIGHT   90
#define kTextViewMinHeight 34
#define SPACETEXTVIEW   (45-34)/2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._labelTitle.text = @"动态详情";
    
    _muArrData = [[NSMutableArray alloc]init];
    _curPage = [NSNumber numberWithInt:1];
    _lastCommentId = [NSNumber numberWithInt:0];
    _keyboardShowing = NO;
    
    [self registerForKeyboardNotifications];
    [self setOriginData];
    [self initControl];
    [self loadData];
}

-(void)loadData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserDynamicDetail:self._feedId model:^(FeedListModel *feedModel) {
        [_muArrData addObject:feedModel];
        [weakSelf loadUserFeedCommentList];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    }];
}

-(void)loadUserFeedCommentList
{
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserCommentList:self._feedId pageIndex:_curPage arr:^(UserDynamicDetailModel *model) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        _detailModel = model;
        [weakSelf setFooterState];
        [_muArrData addObjectsFromArray:model.commentList];
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
    [self initTable];
    [self initSendView];
}

-(void)initSendView
{
    _viewSend = [[UIView alloc]initWithFrame:_rectOriginSendView];
    _viewSend.backgroundColor = RGBA(251, 251, 253, 1);
    [self.view addSubview:_viewSend];
    
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
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height-10-45)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.backgroundColor = [UIColor clearColor];
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTable];
    
    [_myTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    [self setFooterState];
}

-(void)setFooterState
{
    if ([_curPage integerValue] == [_detailModel.pageTotal integerValue] || [_detailModel.pageTotal integerValue] == 0)
    {
        [_myTable.footer setState:MJRefreshFooterStateNoMoreData];
        [_myTable.footer setHidden:YES];
    }
    else
    {
        [_myTable.footer setHidden:NO];
        _curPage = [NSNumber numberWithInteger:[_curPage integerValue]+1];
    }
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _muArrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        FeedListModel* model = _muArrData[0];
        CGFloat originYDesc = 15+40+10;
        if (model.feedContent.length>0)
        {
            NSString* strContent = model.feedContent;
            if (strContent.length > 49)
            {
                //截取49个字符
                strContent = [strContent substringWithRange:NSMakeRange(0, 49)];
                strContent = [strContent stringByAppendingString:@"..."];
            }
            CGSize sizeContent = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-85];
            originYDesc =  15+40+10+sizeContent.height+10;
        }
        if (model.targetTitle.length>0)
        {
            originYDesc += 75;
        }
        return  originYDesc+12+15+42;
    }
    else
    {
        CommentListModel* model = _muArrData[indexPath.row];
        NSString* strContent = model.content;
        if (model.replyUser.nickname.length>0)
        {
            //有回复用户
            strContent = [NSString stringWithFormat:@"回复%@：%@",model.replyUser.nickname,model.content];
        }
        CGSize sizeContent = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-85];
        return 19+15+15+sizeContent.height+15+11+15;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_textView resignFirstResponder];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *identifier= [NSString stringWithFormat:@"DynDetailTableViewCell%ld",(long)indexPath.row];
    
    DynDetailTableViewCell *cell;//= (DynDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[DynDetailTableViewCell alloc] initWithReuseIdentifier:identifier index:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.detaildelegate = self;
    }
    if (indexPath.row == 0)
    {
        [cell setHeadData:_muArrData[0] index:0];
    }
    else
    {
        [cell setData:_muArrData[indexPath.row] index:indexPath.row curTime:_detailModel.currentTime];
        cell.canTouch = YES;
    }
    return cell;
}

-(void)loadNewData
{
    [self loadData];
    [self setFooterState];
    [_myTable reloadData];
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
    if (_muArrData.count>1)
    {
        for (int i = 1; i<_muArrData.count; i++)
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
            DynDetailTableViewCell* cell = (DynDetailTableViewCell*)[_myTable cellForRowAtIndexPath:path];
            cell.canTouch = NO;
        }
    }
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _viewSend.frame = CGRectMake(_viewSend.frame.origin.x, SCREEN_HEIGHT-_viewSend.frame.size.height-height, _viewSend.frame.size.width, _viewSend.frame.size.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (_muArrData.count>1)
    {
        for (int i = 1; i<_muArrData.count; i++)
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
            DynDetailTableViewCell* cell = (DynDetailTableViewCell*)[_myTable cellForRowAtIndexPath:path];
            cell.canTouch = YES;
        }
    }
    _viewSend.frame = CGRectMake(_viewSend.frame.origin.x, SCREEN_HEIGHT-_viewSend.frame.size.height, _viewSend.frame.size.width, _viewSend.frame.size.height);
}

-(void)onButtonSend
{
    NSString* strContent = _textView.text;
    //判断当前回复评论拼接字符串是否在textview的文本里
    if (_laststrResUser.length<=strContent.length)
    {
        if ([_laststrResUser isEqualToString:[_textView.text substringWithRange:NSMakeRange(0,_laststrResUser.length)]])
        {
            //当前回复评论拼接字符串在textview的文本里，说明是回复XXX的评论
            strContent = [_textView.text substringWithRange:NSMakeRange(_laststrResUser.length,_textView.text.length - _laststrResUser.length)];
        }
        else
        {
            //结构被破坏，直接评论动态
            _lastCommentId = [NSNumber numberWithInteger:0];
        }
    }
    else
    {
        _lastCommentId = [NSNumber numberWithInteger:0];
    }
    
    if ([[strContent  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)
    {
        //全是空格和换行符
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [Tool showWarningTipForView:@"内容不能为空" time:2 view:window];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [ServicesUser addUserComment:self._feedId commentContent:strContent commentId:_lastCommentId model:^(RequestResult *userList) {
            //发表评论成功
            _curPage = [NSNumber numberWithInt:1];
            [FVCustomAlertView showDefaultLoadingAlertOnView:weakSelf.view withTitle:@"发送中..." withBlur:NO allowTap:NO];
            [_muArrData removeAllObjects];
            _viewSend.frame = _rectOriginSendView;
            _textView.frame = _rectOriginSendText;
            _btnSend.frame = _rectOriginSendBtn;
            _textView.text = nil;
            _lastCommentId = [NSNumber numberWithInteger:0];
            _laststrResUser = @"";
            [weakSelf refreshState];
            [weakSelf loadData];
        } failure:^(NSError *error) {
            
        }];
        [_textView resignFirstResponder];
    }
}

#pragma mark DynDetailTableViewCellDelegate
-(void)toUserHome:(NSNumber *)uId
{
    if ([[Config getUserId] isEqualToString:[uId stringValue]])
    {
        //回到个人中心
//        NSDictionary* dictTab = @{@"tag":@2};
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        //切换tab
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchTab:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
        vc._strUserId = [uId stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)deleteCell:(NSInteger)index
{
    [_textView resignFirstResponder];
    
    _curIndex = index;
    
    if (index == 0)
    {
        NSMutableArray* arrDelete = [[NSMutableArray alloc] init];
        [arrDelete addObject:@{ @"name" : @"删除" }];
        FDActionSheet* sheetDelete = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrDelete];
        for (int i = 0; i < arrDelete.count; i++)
        {
            [sheetDelete setButtonTitleColor:RGBA(249, 81, 81, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
        }
        sheetDelete.delegate = self;
        [sheetDelete show];
    }
    else
    {
        CommentListModel* cModel = _muArrData[_curIndex];
        
        if ([cModel.canDelete intValue] == 0)
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
        //举报
        FDActionSheet* sheetJubaoDetail = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrJubaoDetail];
        sheetJubaoDetail.tag = 30;
        sheetJubaoDetail.delegate = self;
        for (int i = 0; i < arrJubaoDetail.count; i++)
        {
            [sheetJubaoDetail setButtonTitleColor:RGBA(117, 112, 255, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
        }
        [sheetJubaoDetail show];
    }
    else if (sheet.tag == 30)
    {
        //举报详细
        [ServicesMovie reportMovieOrComment:_deleteId reason:[arrJubaoDetail[buttonIndex] valueForKey:@"name"] model:^(RequestResult *model) {
            NSLog(@"举报成功");
            [Tool showSuccessTip:@"举报成功！" time:2.0];
        } failure:^(NSError *error) {
            [Tool showWarningTip:error.domain time:2.0];
        }];
    }
    else if (sheet.tag == 40)
    {
        //删除
        UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此回复吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertDelete show];
    }
    else
    {
        //删除
        UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"动态删除后，它的所有回复、点赞也将被删除。真的删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertDelete show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 998)
    {
        if (buttonIndex == 1)
        {
            [Config saveCinemaId:[_curModel.cinemaId stringValue]];
            [self changeToAct];
        }
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        if (buttonIndex == 1)
        {
            NSLog(@"删除cell");
            if (_curIndex == 0)
            {
                //整条动态删除
                FeedListModel* lModel = _muArrData[0];
                [ServicesUser deleteUserDynamic:lModel.id model:^(RequestResult *userList) {
                    NSLog(@"删除动态成功");
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHDYNLIST object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    [Tool showWarningTip:error.domain time:2.0];
                }];
            }
            else
            {
                CommentListModel* cModel = _muArrData[_curIndex];
                [ServicesUser deleteUserComment:cModel.id model:^(RequestResult *userList) {
                    NSLog(@"删除评论成功");
                    if ([_lastCommentId integerValue] == [cModel.id integerValue])
                    {
                        _textView.text = nil;
                        [weakSelf refreshState];
                    }
                    [_muArrData removeAllObjects];  //删除_data数组里的数据
                    [weakSelf loadData];
                } failure:^(NSError *error) {
                    NSLog(@"删除评论失败");
                    [Tool showWarningTip:error.domain time:2.0];
                }];
            }
        }
    }
}

-(void)respond:(CommentListModel *)model
{
    FeedUserModel* commentModel = model.commentUser;
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
            _curCommentModel = commentModel;
        }
    }
    else
    {
        //评论内容为空，直接把strRes赋值给textview.text
        _textView.text = strRes;
        _lastCommentId = model.id;
        _laststrResUser = strRes;
        _curCommentModel = commentModel;
    }
    
    [_textView becomeFirstResponder];
    [self refreshState];
}

-(void)hideKeyboard
{
    [_textView resignFirstResponder];
}

-(void)onButtonBack
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHDYNLIST object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextPage:(NSInteger)type feedModel:(FeedListModel*)model
{
    _curModel = model;
    
    if (type == 2)
    {
        return;
    }
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser checkFeedCanJump:model.intType objectId:model.contentId dataType:@1 model:^(RequestResult *userList)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         if (type == 1)
         {
             [MobClick event:myCenterViewbtn50];
             //想看电影，跳到影片详情页
             [FVCustomAlertView showDefaultLoadingAlertOnView:weakSelf.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
             [ServicesMovie getMovieDetail:[model.contentId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail) {
                 [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                 MoviePosterViewController* vc = [[MoviePosterViewController alloc]init];
                 vc.currentIndex = 0;
                 if ([movieDetail.buyTicketStatus integerValue] == 0)
                 {
                     //不能购票
                     vc.arrCommingMovieData = @[movieDetail];
                 }
                 else
                 {
                     vc.arrMovieData = @[movieDetail];
                 }
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             } failure:^(NSError *error) {
                 [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
             }];
         }
         else if (type == 4 )
         {
             [MobClick event:myCenterViewbtn51];
             //关注用户，跳到他人主页
             if ([[Config getUserId] isEqualToString:[model.contentId stringValue]])
             {
                 //回到个人中心
                 //切换tab
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 [appDelegate switchTab:2];
                 [weakSelf.navigationController popToRootViewControllerAnimated:NO];
             }
             else
             {
                 OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
                 vc._strUserId = [model.contentId stringValue];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             }
         }
         else if (type == 5 || type == 6)
         {
             [MobClick event:myCenterViewbtn52];
             //活动，跳到凑热闹
             if (![[model.cinemaId stringValue] isEqualToString:[Config getCinemaId]])
             {
                 [weakSelf changeCinema:[model.cinemaId stringValue]];
             }
             else
             {
                 [weakSelf changeToAct];
             }
         }
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [Tool showWarningTip:error.domain time:2.0];
     }];
}

-(void)changeToAct
{
    NSDictionary* dictTab = @{@"tag":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
    
    NSDictionary* dictHome = @{@"tag":@3,@"actId":_curModel.contentId};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [Tool showTabBar];
}

-(void) changeCinema:(NSString *)cinemaId
{
    __weak typeof(self) weakSelf = self;
    [ServicesCinema getCinemaDetail:cinemaId cinemaModel:^(CinemaModel *model)
     {
         UIAlertView* alterView = [[UIAlertView alloc ] initWithTitle:nil message:[NSString stringWithFormat:@"是否要切换影院『%@』",model.cinemaName] delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
         alterView.tag = 998;
         [alterView show];
         
     } failure:^(NSError *error) {
         
     }];
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
