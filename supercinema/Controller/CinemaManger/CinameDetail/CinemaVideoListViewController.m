//
//  CinemaVideoListViewController.m
//  supercinema
//
//  Created by dust on 2017/4/13.
//
//

#import "CinemaVideoListViewController.h"

@interface CinemaVideoListViewController ()

@end

@implementation CinemaVideoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self._labelTitle setText:@"影院视频"];
    
    [self initController];
    [self loadCinemaVideoData];
    [self initFailureView];
}

-(void)initController
{
    _tableViewVideo = [[UITableView alloc] initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH,SCREEN_HEIGHT- self._viewTop.frame.origin.y-self._viewTop.frame.size.height)];
    _tableViewVideo.backgroundColor = RGBA(246, 246, 251, 1);
    [_tableViewVideo setSeparatorColor:[UIColor clearColor]];//隐藏线
    _tableViewVideo.delegate = self;
    _tableViewVideo.dataSource = self;
    [self.view addSubview:_tableViewVideo];
    [_tableViewVideo addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(reLoadVideos)];
    
}

-(void)reLoadVideos
{
    if ([_arrAllVideo count] < 60)
    {
        for (int i = 29 ; i < [_arrAllVideo count]; i++)
        {
            CinemaVideoModel *videoModel = _arrAllVideo[i];
            [self._arrVideo addObject:videoModel];
        }
        [_tableViewVideo reloadData];
        [_tableViewVideo removeFooter ];
    }
    
}
#pragma mark 加载影院视频数据
-(void)loadCinemaVideoData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCinema getCinemaMovieList:[Config getCinemaId] model:^(CinemaMovieListModel *model)
    {
        if ([model.videos count] > 30)
        {
            _arrAllVideo  = [[NSMutableArray alloc ] initWithArray:model.videos];
            weakSelf._arrVideo = [[NSMutableArray alloc ] initWithArray:[_arrAllVideo subarrayWithRange:NSMakeRange(0, 30)] ];
        }
        else
        {
            weakSelf._arrVideo = [[NSMutableArray alloc ] initWithArray:model.videos];
        }
        
        if([model.videos count] < 31)
        {
            [_tableViewVideo removeFooter ];
        }
        else
        {
            [_tableViewVideo addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(reLoadVideos)];
            [_tableViewVideo.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_tableViewVideo.footer setTitle:@"加载更多" forState:MJRefreshFooterStateRefreshing];
            [_tableViewVideo.footer endRefreshing];
        }
      
        [_tableViewVideo reloadData];
        [weakSelf hideFailureview:YES];
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        [Tool showWarningTip:error.domain time:1];
        [weakSelf hideFailureview:NO];
         [_tableViewVideo removeFooter ];
    }];
    
}

#pragma mark TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self._arrVideo count]-1)
    {
        return 414/2+20;
    }
   else
   {
       return 414/2+10;
   }
    return 0;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._arrVideo count];
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"CinemaVideoTableViewCell%ld",(long)indexPath.row];
    CinemaVideoTableViewCell *cinemaVideoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cinemaVideoCell == nil)
    {
        cinemaVideoCell = [[CinemaVideoTableViewCell alloc] initWithReuseIdentifier:identifier];
        cinemaVideoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cinemaVideoCell.backgroundColor = [UIColor clearColor];
    }
    CinemaVideoModel *model = [[CinemaVideoModel alloc ] init];
    model = self._arrVideo[indexPath.row];
    
    [cinemaVideoCell setVideoUrl:model];
    
    return cinemaVideoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    switch ([MKNetWorkState getNetWorkState])
    {
        case ReachableViaWWAN:
            //运营商网络
        {
            UIAlertView* netAlert = [[UIAlertView alloc]initWithTitle:nil message:@"您正在使用非WIFI网络，继续观看可能会消耗较多流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续观看", nil];
            [netAlert show];
        }
            break;
        case ReachableViaWiFi:
            [self startPlayVideo];
            break;
        default:
            //无网络
            [Tool showWarningTip:requestErrorTip time:2];
            break;
    }
}

-(void)startPlayVideo
{
    CinemaVideoModel *model = [[CinemaVideoModel alloc ] init];
    model = self._arrVideo[_index];
    
    UIWindow *lastWindow = [[UIApplication sharedApplication ].windows lastObject];
    if (!self._videoController)
    {
        self._videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cinemaVideoFinish)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self._videoController];
        __weak typeof(self)weakSelf = self;
        [self._videoController setDimissCompleteBlock:^{
            [weakSelf._videoController stop];
            weakSelf._videoController = nil;
        }];
    }
    self._videoController.contentURL = [NSURL URLWithString:model.videoUrl];
    [self._videoController showInView:lastWindow];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //运营商网络下仍然播放视频
        [self startPlayVideo];
    }
}

-(void) cinemaVideoFinish
{
    [self._videoController dismiss];
}

-(void) hideFailureview:(BOOL)showHide
{
    [_imageFailure setHidden:showHide];
    [_labelFailure setHidden:showHide];
    [_btnTryAgain setHidden:showHide];
}

-(void)initFailureView
{
    //加载失败
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-73)/2, 103, 73, 67)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    _imageFailure.hidden = YES;
    [self.view addSubview:_imageFailure];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    _labelFailure.text = @"加载失败";
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    _labelFailure.hidden = YES;
    [self.view addSubview:_labelFailure];
    
    _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+25, 146/2, 24);
    [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnTryAgain.titleLabel.font = MKFONT(14);
    _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    _btnTryAgain.layer.masksToBounds = YES;
    _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
    [_btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
    _btnTryAgain.hidden = YES;
    [self.view addSubview:_btnTryAgain];
}

-(void)onButtonTryAgain
{
    [self loadCinemaVideoData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
