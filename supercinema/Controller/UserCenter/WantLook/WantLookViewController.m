//
//  WantLookViewController.m
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import "WantLookViewController.h"

@interface WantLookViewController ()

@end

@implementation WantLookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self._labelTitle setText:[NSString stringWithFormat:@"想看（%d）",0]];
    _arrWangLook = [[NSMutableArray alloc ] initWithCapacity:0];
    _systemTime = @0;
    _pageIndex = 1;
    [self initController];
//    [self initFailureView];
    [self loadWantLookData];
    [self loadFailed:YES];
}

#pragma mark 加载失败 显示UI
-(void) loadFailed:(BOOL) showHide
{
    _imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(98/4),self._viewTop.frame.size.height+ 200/2, 98/2, 139/2)];
    [_imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataWangLook.png"]];
    [self.view addSubview:_imageLoadFailed];
    _imageLoadFailed.hidden = showHide;
    
    _labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageLoadFailed.frame.origin.y+_imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [_labelDescLoadFailed setText:@"暂无想看"];
    [_labelDescLoadFailed setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [_labelDescLoadFailed setFont:MKFONT(14)];
    [self.view addSubview:_labelDescLoadFailed];
    _labelDescLoadFailed.hidden = showHide;
}

-(void)initController
{
    _tableViewMyWantLook = [[UITableView alloc] initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-(self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10) )];
    _tableViewMyWantLook.delegate = self;
    _tableViewMyWantLook.dataSource = self;
    _tableViewMyWantLook.backgroundColor = RGBA(246, 246, 251, 1);
    _tableViewMyWantLook.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewMyWantLook];
}

-(void)loadWantLookData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getFollowMovieList:[Config getCinemaId] homeUserId:self._userId pageIndex:[NSNumber numberWithInt:_pageIndex] model:^(FollowMovieListModel *movieDetail)
    {
        _viewLoadFailed.hidden = YES;
        _systemTime = movieDetail.currentTime;
        [weakSelf._labelTitle setText:[NSString stringWithFormat:@"想看（%d）",[movieDetail.totoalCount intValue]]];
        [_arrWangLook addObjectsFromArray:movieDetail.movieList];
        [_tableViewMyWantLook reloadData];
        
         if (_pageIndex < [movieDetail.pageTotal intValue])
         {
             [_tableViewMyWantLook addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadWantLookData)];
             [_tableViewMyWantLook.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
             [_tableViewMyWantLook.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
             [_tableViewMyWantLook.footer endRefreshing];
         }
         if (_pageIndex == [movieDetail.pageTotal intValue])
         {
             [_tableViewMyWantLook removeFooter];
              _pageIndex =[movieDetail.pageTotal intValue];
         }
        _pageIndex += 1;
        
         //没有数据
         if ([_arrWangLook count] == 0)
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
            [ws loadWantLookData];
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}

#pragma mark - TableViewDelegate
//Cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_arrWangLook count]-1)
    {
        return 160;
    }
    return 130;
}
//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrWangLook count];
}

//Cell行数
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"WantLookTableViewCell";
    WantLookTableViewCell *wantLookCell = (WantLookTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (wantLookCell==nil)
    {
        wantLookCell = [[WantLookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [wantLookCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    MovieModel *movieModel = _arrWangLook[indexPath.row];
    [wantLookCell setWantLookCellFrameAndData:movieModel sysTime:_systemTime];
    
    return wantLookCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:myCenterViewbtn17];
    
    MovieModel *movieModel = _arrWangLook[indexPath.row];
    
    //跳转到影片详情页
    [self pushToMovieDetailViewController:movieModel];
    
//    MovieModel *movieModel = _arrWangLook[indexPath.row];
//    MoviePosterViewController* vc = [[MoviePosterViewController alloc]init];
//    vc.currentIndex = 0;
//    if ([movieModel.buyTicketStatus integerValue] == 0)
//    {
//        //不能购票
//        vc.arrCommingMovieData = @[movieModel];
//    }
//    else
//    {
//        vc.arrMovieData = @[movieModel];
//    }
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转到影片详情
-(void)pushToMovieDetailViewController:(MovieModel*)model
{
    __weak typeof(self) weakSelf =self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesMovie getMovieDetail:[model.movieId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
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
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [Tool showWarningTip:@"影片不存在" time:1];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }

}

@end
