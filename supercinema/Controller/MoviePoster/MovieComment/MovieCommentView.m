//
//  MovieCommentView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import "MovieCommentView.h"

@implementation MovieCommentView

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation movieId:(NSString*)movieId
{
    self = [super initWithFrame:frame];
    _nav = navigation;
    
    _movieId = movieId;
    _arrIcon = @[@[@"img_user_lan.png",@"烂！"],@[@"img_user_e.png",@"呃..."],@[@"img_user_haixing.png",@"还行"],@[@"img_user_tuijian.png",@"推荐"],@[@"img_user_dianzan.png",@"超赞"]];
    
    _muArrData = [[NSMutableArray alloc]init];
    _curPageIndex = [NSNumber numberWithInteger:1];
    [self initControl];
    [self loadData];
    return self;
}

-(void)refreshData
{
    [_muArrData removeAllObjects];
    _curPageIndex = @1;
    [self loadData];
}

-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieReviewSummary:_movieId model:^(MovieReviewSummaryModel *movieDetail) {
        _movieModel = movieDetail;
        weakSelf.intFollow = [movieDetail.followMovieStatus integerValue];
        [weakSelf loadListData];
        weakSelf.isNotFirst = YES;
    } failure:^(NSError *error) {
        weakSelf.isNotFirst = YES;
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
    }];
}

-(void)loadListData
{
    __weak typeof(self) weakSelf = self;
    [ServicesMovie getMovieReviewList:[NSNumber numberWithInteger:[_movieId integerValue]] pageIndex:_curPageIndex model:^(MovieReviewModel *movieDetail) {
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
        _movieListModel = movieDetail;
        [weakSelf setFooterState];
        [_muArrData addObjectsFromArray:movieDetail.reviewList];
        [_myTable reloadData];
    } failure:^(NSError *error) {
        [_myTable reloadData];
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
    }];
}

-(void)initFailureView:(UITableViewCell*)cell
{
    UIImageView* imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-137/2)/2, 50, 137/2, 167/2)];
    imageFailure.image = [UIImage imageNamed:@"image_NoDataMovieReview.png"];
    [cell.contentView addSubview:imageFailure];
    
    UILabel* labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelFailure.text = @"看过这部电影？留个短评再走吧！";
    labelFailure.textColor = RGBA(123, 122, 152, 1);
    labelFailure.font = MKFONT(14);
    labelFailure.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:labelFailure];
}

-(void)initControl
{
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [self addSubview:viewLine];
    
    [self initTable];
}

-(void)initTable
{
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, self.frame.size.height-1)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.backgroundColor = [UIColor clearColor];
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_myTable];
    
    [_myTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
}

-(void)setFooterState
{
    if ([_curPageIndex integerValue] == [_movieListModel.pageTotal integerValue] || [_movieListModel.pageTotal integerValue] == 0)
    {
        [_myTable.footer setState:MJRefreshFooterStateNoMoreData];
        _myTable.footer.hidden = YES;
    }
    else
    {
        _myTable.footer.hidden = NO;
        _curPageIndex = [NSNumber numberWithInteger:[_curPageIndex integerValue]+1];
    }
}

-(void)loadNewData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesMovie getMovieReviewList:[NSNumber numberWithInteger:[_movieId integerValue]] pageIndex:_curPageIndex model:^(MovieReviewModel *movieDetail) {
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
        _movieListModel = movieDetail;
        [weakSelf setFooterState];
        [_muArrData addObjectsFromArray:movieDetail.reviewList];
        [_myTable reloadData];
        [_myTable.footer endRefreshing];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
        [_myTable.footer endRefreshing];
    }];
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_movieListModel.totalCount integerValue] == 0)
    {
        return 2;
    }
    else
    {
        return _muArrData.count+1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        CGFloat heightDesc = 14;
        CGSize sizeDesc;
        if (_movieModel.movieReview.content.length>0)
        {
            NSString* strContent = _movieModel.movieReview.content;
            if (strContent.length>50)
            {
                strContent = [[strContent substringWithRange:NSMakeRange(0, 49)] stringByAppendingString:@"..."];
            }
            sizeDesc = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-30];
        }
        else
        {
            sizeDesc = [Tool CalcString:@"说说你的看法，写条短评吧" fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-30];
        }
        
        heightDesc = sizeDesc.height;
        if ([_movieListModel.totalCount integerValue] == 0)
        {
            return heightDesc + 282-42;
        }
        else
        {
            return heightDesc + 282;
        }
    }
    else
    {
        if ([_movieListModel.totalCount integerValue] == 0)
        {
            return 200+15;
        }
        else
        {
            MovieReviewListModel* model = _muArrData[indexPath.row-1];
            
            NSString* strContent = model.content;
            if (strContent.length>50)
            {
                strContent = [[strContent substringWithRange:NSMakeRange(0, 49)] stringByAppendingString:@"..."];
            }
            CGSize sizeDesc = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-15*4-40];
            
            
            if (model.commentList.count>0)
            {
                CGFloat heightLabelRes = 0;
                for (int i = 0 ; i<model.commentList.count; i++)
                {
                    MovieReviewCommentListModel* cModel = model.commentList[i];
                    MovieReviewUserModel* commentUser = cModel.publishUser;
                    MovieReviewUserModel* replyUser = cModel.replyUser;
                    NSString* stringContent = cModel.content;
                    if (stringContent.length>20)
                    {
                        stringContent = [[stringContent substringWithRange:NSMakeRange(0, 19)] stringByAppendingString:@"..."];
                    }
                    NSString* strNickName;
                    if (replyUser.nickname.length>0)
                    {
                        //回复用户
                        stringContent = [NSString stringWithFormat:@"回复%@：%@",replyUser.nickname,stringContent];
                        strNickName = [NSString stringWithFormat:@"%@：",replyUser.nickname];
                    }
                    else
                    {
                        //发布的评论
                        strNickName = [NSString stringWithFormat:@"%@：",commentUser.nickname];
                    }
                    NSString* str = [NSString stringWithFormat:@"%@%@",strNickName,stringContent];
                    CGSize sizeContent = [Tool CalcString:str fontSize:MKFONT(13) andWidth:SCREEN_WIDTH-47-30];
                    if (i == 0)
                    {
                        heightLabelRes = 15+sizeContent.height;
                    }
                    else
                    {
                        heightLabelRes += sizeContent.height+10;
                    }
                }
                CGFloat heightRes = 0;
                //有回复内容
                if ([model.commentCount intValue] > model.commentList.count)
                {
                    //有更多回复
                    heightRes = heightLabelRes + 15 + 13 +10;
                }
                else
                {
                    heightRes = heightLabelRes + 15;
                }
                return  30+15+sizeDesc.height+15+11+15+heightRes+15+15;
            }
            else
            {
                return 30+15+sizeDesc.height+15+11+15+15;
            }
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *identifier1= [NSString stringWithFormat:@"CommentHeadTableViewCell%ld",(long)indexPath.row];
    NSString *identifier2= [NSString stringWithFormat:@"CommentTableViewCell%ld",(long)indexPath.row];
    
    if (indexPath.row == 0)
    {
        //头部cell
        CommentHeadTableViewCell *cell;// = (CommentHeadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell==nil)
        {
            cell = [[CommentHeadTableViewCell alloc] initWithReuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.cHDelegate = self;
        }
        cell.movieId = _movieId;
        [cell setData:_movieModel icon:_arrIcon count:[_movieListModel.totalCount integerValue]];
        return cell;
    }
    else
    {
        if ([_movieListModel.totalCount integerValue] == 0)
        {
            UITableViewCell* cell;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellNoData"];
                cell.backgroundColor = RGBA(248, 248, 252, 1);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self initFailureView:cell];
            }
            return cell;
        }
        else
        {
            //短评cell
            CommentTableViewCell* cell;// = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell==nil)
            {
                cell = [[CommentTableViewCell alloc] initWithReuseIdentifier:identifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                cell.cDelegate = self;
            }
            [cell setData:_muArrData[indexPath.row-1] icon:_arrIcon curTime:_movieListModel.currentTime];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0 && _muArrData.count>0)
    {
        MovieReviewListModel* model = _muArrData[indexPath.row-1];
        [self commentElse:model.id];
    }
}

#pragma mark - CommentHeadTableViewCellDelegate
-(void)changeFollowStatus:(NSInteger)status
{
    self.intFollow = status;
}

//写短评
-(void)toComment
{
    if( ![Config getLoginState])
    {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [_nav pushViewController:loginViewController animated:YES];
        return ;
    }
    UIViewController *viewController = _nav.topViewController;
    CommentMovieView *commentMovieView = [[CommentMovieView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) movieId:[NSNumber numberWithInt:[_movieId intValue] ]];
    commentMovieView.hidden=YES;
    commentMovieView.alpha = 0;
    commentMovieView.transform = CGAffineTransformMakeScale(0.7,0.7);
    [viewController.view addSubview:commentMovieView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         commentMovieView.transform = CGAffineTransformMakeScale(1,1);
                         commentMovieView.hidden=NO;
                         commentMovieView.alpha=1;
                     }completion:^(BOOL finish){
                         
                     }];    
}

//删除自己的短评
-(void)threePoints:(NSNumber*)cId
{
    [MobClick event:mainViewbtn149];
    _deleteId = [NSNumber numberWithInteger:[cId integerValue]];
    
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

#pragma mark - CommentTableViewCellDelegate
//跳到个人主页
-(void)toUserHome:(NSInteger)uId
{
    //验证登录
    if ( ![Config getLoginState ] )
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[NSString stringWithFormat:@"%ld", (long)uId] forKey:@"_strUserId"];
        [self showLoginController:param controllerName:@"OtherCenterViewController"];
    }
    else
    {
        if ([[Config getUserId] isEqualToString:[NSString stringWithFormat:@"%ld",(long)uId]])
        {
            //回到个人中心
            //切换tab
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate switchTab:2];
            [_nav popToRootViewControllerAnimated:NO];
        }
        else
        {
            OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
            vc._strUserId = [NSString stringWithFormat:@"%ld",(long)uId];
            [_nav pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 弹出登录view
-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [_nav pushViewController:loginControlller animated:YES];
}

//评论短评
-(void)commentElse:(NSNumber *)cId
{
    if ( ![Config getLoginState ] )
    {
        LoginViewController *loginControlller = [[LoginViewController alloc ] init];
        [_nav pushViewController:loginControlller animated:YES];
    }
    else
    {
        CommentElseViewController* cEVC = [[CommentElseViewController alloc]init];
        cEVC.reviewId = cId;
        [_nav pushViewController:cEVC animated:YES];
    }
}

//举报他人的短评
-(void)threePointsElse:(NSNumber *)cId type:(int)type
{
    if ( ![Config getLoginState ] )
    {
        LoginViewController *loginControlller = [[LoginViewController alloc ] init];
        [_nav pushViewController:loginControlller animated:YES];
    }
    else
    {
        _deleteId = [NSNumber numberWithInteger:[cId integerValue]];
        
        if (type == 0)
        {
            [MobClick event:mainViewbtn152];
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
            [self threePoints:cId];
        }
    }
}

-(void)toLoginVC
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    [_nav pushViewController:loginControlller animated:YES];
}

-(void)headToLoginVC
{
    [self toLoginVC];
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
        if (buttonIndex == 0)
        {
            [MobClick event:mainViewbtn153];
        }
        if (buttonIndex == 1)
        {
            [MobClick event:mainViewbtn154];
        }
        if (buttonIndex == 2)
        {
            [MobClick event:mainViewbtn155];
        }
        //举报详细
        [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:YES];
        [ServicesMovie reportMovieOrComment:_deleteId reason:[arrJubaoDetail[buttonIndex] valueForKey:@"name"] model:^(RequestResult *model) {
            NSLog(@"举报成功");
            [Tool showSuccessTip:@"举报成功" time:2.0];
        } failure:^(NSError *error) {
            [Tool showWarningTip:error.domain time:2.0];
        }];
    }
    if (sheet.tag == 40)
    {
        //删除
        UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短评删除后，它的所有回复、点赞也将被删除。真的要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertDelete.tag = 201;
        [alertDelete show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200)
    {
//        //删除alert
//        if (buttonIndex == 1)
//        {
//            //删除提示alert
//            UIAlertView* alertDeleteDetail = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短评删除后，它的所有回复、点赞也将被删除。是否继续删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//            alertDeleteDetail.tag = 201;
//            [alertDeleteDetail show];
//        }
    }
    if (alertView.tag == 201)
    {
        //删除提示alert
        if (buttonIndex == 1)
        {
            [MobClick event:mainViewbtn150];
            //删除
            __weak typeof(self) weakSelf = self;
            [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:YES];
            [ServicesMovie deleteMovieReviewOrComment:_deleteId model:^(RequestResult *movieDetail) {
                NSLog(@"删除成功");
                [weakSelf refreshData];
//                [_muArrData removeAllObjects];
//                [weakSelf loadData];
                [Tool showSuccessTip:@"删除成功！" time:2.0];
            } failure:^(NSError *error) {
                [Tool showWarningTip:error.domain time:2.0];
            }];
        }
    }
}

@end
