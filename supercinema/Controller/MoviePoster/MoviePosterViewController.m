//
//  MoviePosterViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2017/3/22.
//
//

#import "MoviePosterViewController.h"

@interface MoviePosterViewController ()

@end

@implementation MoviePosterViewController

- (void)viewWillAppear:(BOOL)animated
{
    //电池白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(28, 27, 30, 1);
    self._viewTop.hidden = YES;
    self.arrData = [[NSMutableArray alloc]init];
    [self.arrData addObjectsFromArray:self.arrMovieData];
    [self.arrData addObjectsFromArray:self.arrCommingMovieData];
    
//    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
//    __weak __typeof__(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI in UI thread here
        [self initScrollView];
        [self initHead];
//        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
//    });
}

-(void)initScrollView
{
    //添加最后一张图 用于循环
    int length = (int)[self.arrData count];
    _arrModel = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1)
    {
        [_arrModel addObject:self.arrData[length-1]];
    }
    for (int i = 0; i < length; i++)
    {
        [_arrModel addObject:self.arrData[i]];
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        [_arrModel addObject:self.arrData[0]];
        self.currentIndex += 1;
    }
    else
    {
        self.currentIndex = 0;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(_arrModel.count * SCREEN_WIDTH, 0);
    
    for (int i = 0; i<_arrModel.count; i++)
    {
        MoviePosterTableView* posterView = [[MoviePosterTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) movieModel:_arrModel[i] navigation:self.navigationController];
        posterView.movieModel = _arrModel[i];
        posterView.curIndex = i;
        posterView.tag = i+200;
        __weak __typeof__(self) weakSelf = self;
        posterView.isCanScroll = ^(BOOL isCanScroll){
            weakSelf.scrollView.scrollEnabled = isCanScroll;
        };
        posterView.showHideBlock = ^(BOOL showHide){
            if (showHide)
            {
                [weakSelf performSelector:@selector(showBtn) withObject:nil afterDelay:0.5];
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    [[UIApplication sharedApplication ] setStatusBarHidden:YES];
                    weakSelf.viewHead.frame = CGRectMake(0, -100, SCREEN_WIDTH, 100);
//                    weakSelf.btnTicket.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
                }];
            }
        };
        [_scrollView addSubview:posterView];
        if (self.isShowCommentList)
        {
            [posterView scrollToCommentList];
        }
        
        if (i == self.currentIndex)
        {
            [self initPosterViewUI:posterView];
        }
    }
    if (length > 1)
    {
        if (self.currentIndex == _arrModel.count -2)
        {
            MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:200];
            [self initPosterViewUI:posterView];
        }
        else if (self.currentIndex == 0)
        {
            MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:_arrModel.count -2+200];
            [self initPosterViewUI:posterView];
        }
        else if (self.currentIndex == 1)
        {
            MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:_arrModel.count -1+200];
            [self initPosterViewUI:posterView];
        }
        else if (self.currentIndex == _arrModel.count -1)
        {
            MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:1+200];
            [self initPosterViewUI:posterView];
        }
    }
    if (self.arrData.count>1)
    {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.currentIndex, 0)];
        _lastOffset = SCREEN_WIDTH*self.currentIndex;
    }
    _lastIndex = self.currentIndex;
}

-(void)showBtn
{
     __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [[UIApplication sharedApplication ] setStatusBarHidden:NO];
        weakSelf.viewHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
//        weakSelf.btnTicket.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
    }];
}

-(void)initHead
{
    _viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _viewHead.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewHead];
    
    UIView* viewAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIColor *colorOne = RGBA(0, 0, 0, 0.45);
    UIColor *colorTwo = RGBA(0, 0, 0, 0);
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    [viewAlpha.layer insertSublayer:gradient atIndex:0];
    [_viewHead addSubview:viewAlpha];
    
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"poster_back.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_btnBack];
    
    _btnShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-40, 20, 40, 40)];
    [_btnShare setBackgroundImage:[UIImage imageNamed:@"poster_share.png"] forState:UIControlStateNormal];
    [_btnShare addTarget:self action:@selector(onButtonShare) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_btnShare];
    
    _btnWantLook = [[UIButton alloc] initWithFrame:CGRectMake(_btnShare.frame.origin.x-10-40, 20, 40, 40)];
    [_btnWantLook setBackgroundImage:[UIImage imageNamed:@"img_want_gray.png"] forState:UIControlStateNormal];
    [_btnWantLook addTarget:self action:@selector(onButtonWantLook) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_btnWantLook];
    
    _imgWantLook = [[UIImageView alloc]initWithFrame:CGRectMake((40-48/2)/2, (40-43/2)/2, 48/2, 43/2)];
    _imgWantLook.backgroundColor = [UIColor clearColor];
    MovieModel* mModel = _arrModel[self.currentIndex];
    if ([mModel.userIsFollow boolValue])
    {
        [_imgWantLook setImage:[UIImage imageNamed:@"gif_want_9.png"]];
    }
    else
    {
        [_imgWantLook setImage:[UIImage imageNamed:@"poster_weixihuan.png"]];
    }
    [_btnWantLook addSubview:_imgWantLook];
    
    //影片详情按钮
    _btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(_btnWantLook.frame.origin.x-10-40, 20, 40, 40)];
    [_btnDetail setBackgroundImage:[UIImage imageNamed:@"poster_detail.png"] forState:UIControlStateNormal];
    [_btnDetail addTarget:self action:@selector(onButtonDetail) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_btnDetail];
    if([mModel.plot length] == 0)
    {
        [_btnDetail setHidden:YES];
    }
    
    [self.view bringSubviewToFront:_viewHead];

    _btnTicket = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTicket.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
    [_btnTicket addTarget:self action:@selector(onButtonTicket) forControlEvents:UIControlEventTouchUpInside];
    _btnTicket.backgroundColor = RGBA(253, 189, 34, 1);
    [_btnTicket setTitle:@"购票" forState:UIControlStateNormal];
    [_btnTicket setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnTicket.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnTicket.titleLabel.font = MKFONT(18);
    [self.view addSubview:_btnTicket];
    [self.view bringSubviewToFront:_btnTicket];
    
    if ([mModel.buyTicketStatus integerValue] == 0)
    {
        _btnTicket.hidden = YES;
    }
    else
    {
        _btnTicket.hidden = NO;
    }
}

-(void)toLogin
{
    if ( ![Config getLoginState ] )
    {
        LoginViewController *loginControlller = [[LoginViewController alloc ] init];
        [self.navigationController pushViewController:loginControlller animated:YES];
        return;
    }
}

-(void)refreshFollowState
{
    MovieModel* mModel = _arrModel[self.currentIndex];
    if ([mModel.userIsFollow boolValue])
    {
        [_imgWantLook setImage:[UIImage imageNamed:@"gif_want_9.png"]];
    }
    else
    {
        [_imgWantLook setImage:[UIImage imageNamed:@"poster_weixihuan.png"]];
    }
    
    //显示隐藏影片详情button
    if([mModel.plot length] == 0)
    {
        [_btnDetail setHidden:YES];
    }
    else
    {
        [_btnDetail setHidden:NO];
    }
    
    if ([mModel.buyTicketStatus integerValue] == 0)
    {
        _btnTicket.hidden = YES;
    }
    else
    {
        _btnTicket.hidden = NO;
    }
    if (self.currentIndex != _lastIndex)
    {
        MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:self.currentIndex+200];
        [posterView.wholeScroll setContentOffset:CGPointMake(0, 0)];
        [self showBtn];
        [posterView initVariable];
    }
}

#pragma mark 分享海报按钮
-(void)onButtonShare
{
    MovieModel* mModel = _arrModel[self.currentIndex];
    _posterShareView = [[PosterShareView alloc]initWithParentView:self.view navigation:self.navigationController];
    _posterShareView._movieModel = mModel;
//    _posterShareView.delegate = self;
    [_posterShareView showView];
}

////修改图片
//-(void)pushToChangeShareImageViewController
//{
//    MovieModel* mModel = _arrModel[self.currentIndex];
//    ChangeShareImageViewController *changeShareImageViewController = [[ChangeShareImageViewController alloc] init];
//    changeShareImageViewController._movidId = mModel.movieId;
//    changeShareImageViewController._isPosters = mModel.haibaoUrl.length > 0;
//    [self.navigationController pushViewController:changeShareImageViewController animated:YES];
//}
//
////修改推荐语
//-(void)pushToShareReasonViewController:(NSString *)shareReasoText
//{
//    ShareReasonViewController *shareReasonViewController = [[ShareReasonViewController alloc] init];
//    shareReasonViewController._strSign = shareReasoText;
//    [self.navigationController pushViewController:shareReasonViewController animated:YES];
//}


-(void)onButtonWantLook
{
    [self toLogin];
    __weak typeof(self) weakSelf = self;
    MovieModel* mModel = _arrModel[self.currentIndex];
    if ([mModel.userIsFollow boolValue])
    {
        //已想看，取消想看
        [MobClick event:mainViewbtn119];
        [self animationLookButton:NO];
        [ServicesMovie cancelFollowMovie:[mModel.movieId stringValue] model:^(RequestResult *movieDetail) {
            
        } failure:^(NSError *error) {
            [weakSelf animationLookButton:YES];
        }];
    }
    else
    {
        //未想看
        [MobClick event:mainViewbtn118];
        [self animationLookButton:YES];
        [ServicesMovie followMovie:[mModel.movieId stringValue] model:^(RequestResult *movieDetail) {
            
        } failure:^(NSError *error) {
            [weakSelf animationLookButton:NO];
        }];
    }
}

-(void)animationLookButton:(BOOL)isWant
{
    [self changeFollowHead:isWant];
    
    MovieModel* mModel = _arrModel[self.currentIndex];
    mModel.userIsFollow = [NSNumber numberWithBool:isWant];
    if (isWant)
    {
        timerNumber = 1;
        if (lookTimer)
        {
            [lookTimer invalidate];
            lookTimer = nil;
        }
        lookTimer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                     target:self
                                                   selector:@selector(changeLookButton:)
                                                   userInfo:nil
                                                    repeats:YES];
        [_imgWantLook setImage:[UIImage imageNamed:@"gif_want_9.png"]];
    }
    else
    {
        if (lookTimer)
        {
            [lookTimer invalidate];
            lookTimer = nil;
        }
        [_imgWantLook setImage:[UIImage imageNamed:@"poster_weixihuan.png"]];
    }
}

-(void)changeLookButton:(NSTimer*) timer
{
    [_imgWantLook setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gif_want_%ld.png",(long)timerNumber]]];
    timerNumber += 1;
    if (timerNumber == 10)
    {
        [lookTimer invalidate];
        lookTimer = nil;
    }
}

-(void)changeFollowHead:(BOOL)isChange
{
    MoviePosterTableView* posterV = (MoviePosterTableView*)[_scrollView viewWithTag:(self.currentIndex+200)];
    [posterV changeFollowHead:isChange];
}

-(void)onButtonDetail
{
    MovieModel* mModel = _arrModel[self.currentIndex];
    
    __weak typeof(self) weakSelf = self;
    
    self.viewCover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewCover.backgroundColor = RGBA(0, 0, 0, 0.6);
    self.viewCover.hidden = YES;
    [self.view addSubview:self.viewCover];
    
    self.movieDetialView = [[MovieDetialView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) model:mModel];
    self.movieDetialView.hidden=YES;
    self.movieDetialView.alpha = 0;
    self.movieDetialView.transform = CGAffineTransformMakeScale(0.7,0.7);
    [self.movieDetialView setHideDetail:^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.movieDetialView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                             weakSelf.movieDetialView.hidden=NO;
                             weakSelf.movieDetialView.alpha=0;
                         }completion:^(BOOL finish){
                             weakSelf.movieDetialView.hidden = YES;
                             weakSelf.viewCover.hidden = YES;
                             [weakSelf.movieDetialView removeFromSuperview];
                         }];
    }];
    [self.view addSubview:self.movieDetialView];
    self.viewCover.hidden = NO;
    [UIView animateWithDuration:0.3
                  animations:^{
                      weakSelf.movieDetialView.transform = CGAffineTransformMakeScale(1,1);
                      weakSelf.movieDetialView.hidden=NO;
                      weakSelf.movieDetialView.alpha=1;
                  }completion:^(BOOL finish){

                  }];    
}

-(void)onButtonTicket
{
    ShowTimeViewController* showTime = [[ShowTimeViewController alloc]init];
    showTime.hotMovieModel = _arrModel[self.currentIndex];
    [self.navigationController pushViewController:showTime animated:YES];
}

-(void)onButtonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    _isCalLastOffset = YES;
    if ([_arrModel count]>=3)
    {
        if (targetX >= SCREEN_WIDTH * ([_arrModel count] -1))
        {
            targetX = SCREEN_WIDTH;
            _lastOffset = targetX;
            _isCalLastOffset = NO;
            [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = SCREEN_WIDTH *([_arrModel count]-2);
            _lastOffset = targetX;
            _isCalLastOffset = NO;
            [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    
    int scrollPhotoNumber = MAX(0, MIN(_arrModel.count-1, (_scrollView.contentOffset.x / self.view.frame.size.width)));
    self.currentIndex = scrollPhotoNumber;
    [self refreshFollowState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    BOOL isLeftScroll = NO;
    
    if (_isCalLastOffset)
    {
        //计算最后偏移量
        _lastOffset = scrollView.contentOffset.x;
    }
//    NSLog(@"_lastIndex:  %d \ncurIndex:   %d",_lastIndex,curIndex);
    if (_lastIndex<curIndex)
    {
        isLeftScroll = YES;
    }
    
    _lastIndex = self.currentIndex;
    
    if (curIndex == 0 || curIndex == _arrModel.count-1)
    {
        if (!isLeftScroll)
        {
            [self initTwoPosterUI:0];
        }
        else
        {
            [self initTwoPosterUI:1];
        }
    }
    else if (curIndex == _arrModel.count -2 || curIndex == 1)
    {
        if (!isLeftScroll)
        {
            [self initTwoPosterUI:1];
        }
        else
        {
            [self initTwoPosterUI:0];
        }
    }
    else
    {
        MoviePosterTableView* posterView = (MoviePosterTableView*)[self.scrollView viewWithTag:curIndex+200];
        [self initPosterViewUI:posterView];
    }
}

-(void)initTwoPosterUI:(NSInteger)curTag
{
    NSInteger otherTag = curTag == 0 ? (_arrModel.count-2+200) : (_arrModel.count-1+200);
    MoviePosterTableView* posterView1 = (MoviePosterTableView*)[self.scrollView viewWithTag:otherTag];
    MoviePosterTableView* posterView2 = (MoviePosterTableView*)[self.scrollView viewWithTag:200+curTag];
    [self initPosterViewUI:posterView1];
    [self initPosterViewUI:posterView2];
}

-(void)initPosterViewUI:(MoviePosterTableView*)posterView
{
    if (!posterView.isLoadUI)
    {
        [posterView initUI];
        posterView.isLoadUI = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
