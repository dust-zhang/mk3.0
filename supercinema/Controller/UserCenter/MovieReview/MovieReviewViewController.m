//
//  MovieReviewViewController.m
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import "MovieReviewViewController.h"

@interface MovieReviewViewController ()

@end

@implementation MovieReviewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self._labelTitle setText:[NSString stringWithFormat:@"短评（%d）",0]];
    _arrMovieReview = [[NSMutableArray alloc ] initWithCapacity:0];
    _systemTime = nil;
    _pageIndex = 1;
    
    [self initController];
    [self loadFailed:YES];
    [self loadMovieReviewData];
}

#pragma mark 加载失败 显示UI
-(void) loadFailed:(BOOL) showHide
{
    _imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(162/4),self._viewTop.frame.size.height+ 200/2, 162/2, 122/2)];
    [_imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataMovieComment.png"]];
    [self.view addSubview:_imageLoadFailed];
    [_imageLoadFailed setHidden:showHide];
    
    _labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageLoadFailed.frame.origin.y+_imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [_labelDescLoadFailed setText:@"暂无短评"];
    [_labelDescLoadFailed setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [_labelDescLoadFailed setFont:MKFONT(14)];
    [self.view addSubview:_labelDescLoadFailed];
    [_labelDescLoadFailed setHidden:showHide];
}

-(void)initController
{
    _tableViewMyMovieReview = [[UITableView alloc] initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-(self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10) )];
    _tableViewMyMovieReview.delegate = self;
    _tableViewMyMovieReview.dataSource = self;
    _tableViewMyMovieReview.backgroundColor = RGBA(246, 246, 251, 1);
    _tableViewMyMovieReview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewMyMovieReview];
}

-(void)loadMovieReviewData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMyMovieList:[NSNumber numberWithInt:_pageIndex] homeUserId:self._userId lastVisitCinemaId:[Config getCinemaId] model:^(MyMovieListModel *model)
     {
          _viewLoadFailed.hidden = YES;
         _systemTime = model.currentTime;

         [weakSelf._labelTitle setText:[NSString stringWithFormat:@"短评（%d）",[model.totalCount intValue]]];
         [_arrMovieReview addObjectsFromArray:model.movieList];
         [_tableViewMyMovieReview reloadData];
         
         if (_pageIndex < [model.pageTotal intValue])
         {
             [_tableViewMyMovieReview addLegendFooterWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMovieReviewData)];
             [_tableViewMyMovieReview.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
             [_tableViewMyMovieReview.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
             [_tableViewMyMovieReview.footer endRefreshing];
         }
         if (_pageIndex == [model.pageTotal intValue])
         {
             [_tableViewMyMovieReview removeFooter];
             _pageIndex =[model.pageTotal intValue];
         }
         _pageIndex += 1;
         //没有数据
         if ([_arrMovieReview count] == 0)
         {
             [weakSelf loadFailed:NO];
         }
         
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    } failure:^(NSError *error) {
        
        
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:error.domain time:1];
        _viewLoadFailed.hidden = NO;
        [self initFailureView];
        
    }];
}

-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,103, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            //刷新数据
            [ws loadMovieReviewData];
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}


#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_arrMovieReview count]-1)
    {
        return 160;
    }
    return 130;
}

//Cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrMovieReview count];
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"MovieReviewTableViewCell";
    MovieReviewTableViewCell *movieReviewCell = (MovieReviewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (movieReviewCell==nil)
    {
        movieReviewCell = [[MovieReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [movieReviewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    MyMovieModel *myMovieModel = _arrMovieReview[indexPath.row];
    [movieReviewCell setMovieReviewCellFrameAndData:myMovieModel sysTime:_systemTime];
    
    return movieReviewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:myCenterViewbtn20];
    //跳转到短评列表
    MyMovieModel *myMovieModel = _arrMovieReview[indexPath.row];
    //想看电影，跳到影片详情页
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieDetail:[myMovieModel.movieId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail) {
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
        vc.isShowCommentList = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
