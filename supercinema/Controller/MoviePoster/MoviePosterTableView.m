//
//  MoviePosterTableView.m
//  supercinema
//
//  Created by Mapollo28 on 2017/3/22.
//
//

#import "MoviePosterTableView.h"

@implementation MoviePosterTableView

-(id)initWithFrame:(CGRect)frame movieModel:(MovieModel*)mModel navigation:(UINavigationController *)navigation
{
    self = [super initWithFrame:frame];
    self.movieModel = mModel;
    _nav = navigation;
    self.isLoadUI = NO;
    return self;
}

-(void)initUI
{
    _muArrData = [[NSMutableArray alloc]init];
    _curPageIndex = [NSNumber numberWithInteger:1];
    _arrIcon = @[@[@"img_user_lan.png",@"烂！"],@[@"img_user_e.png",@"呃..."],@[@"img_user_haixing.png",@"还行"],@[@"img_user_tuijian.png",@"推荐"],@[@"img_user_dianzan.png",@"超赞"]];
    
    [self initVariable];
    
    UIView* viewPoster = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    viewPoster.backgroundColor = [UIColor clearColor];
    [self addSubview:viewPoster];
    
    UIImageView*  imagePoster = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imagePoster.backgroundColor = [UIColor clearColor];
    [Tool downloadImage:self.movieModel.logoUrlOfBig button:nil imageView:imagePoster defaultImage:nil];
    if (self.movieModel.logoUrlOfBig.length==0)
    {
        imagePoster.frame = CGRectMake((SCREEN_WIDTH-330/2)/2, 120, 330/2, 425/2);
        imagePoster.image = [UIImage imageNamed:@"poster_default.png"];
    }
    [viewPoster addSubview:imagePoster];
    
    UIBlurEffect* realTimeBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:realTimeBlur];
    _effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _effectview.alpha = 0;
    [viewPoster addSubview:_effectview];
    
    //    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    NSMutableArray* arr = [NSMutableArray array];
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    for (int i = 1; i<=31; i++)
    //    {
    //        NSString* str = [NSString stringWithFormat:@"图层 %d.png",i];
    //        NSString *path = [bundle pathForResource:str ofType:nil];
    //
    //        UIImage *image = [UIImage imageWithContentsOfFile:path];
    ////        UIImage *image = [UIImage imageNamed:str];
    //        [arr addObject:image];
    //    }
    //    gifImageView.animationImages = arr; //将图片数组加入UIImageView动画数组中
    //    gifImageView.animationDuration = 3; //每次动画时长
    //    [gifImageView startAnimating];         //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
    //    [self addSubview:gifImageView];
    
    //    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    AnimatedGif * gif = [AnimatedGif getAnimationForGifWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"transformers-31-" ofType:@"gif"]]];//[AnimatedGif getAnimationForGifAtUrl:[NSURL URLWithString:artInfoModel.imageUrl]];
    //    gif.delegate = self;
    //    [imageV setAnimatedGif:gif];
    //    [gif start];
    //    [self addSubview:imageV];
    
    self.wholeScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.wholeScroll.backgroundColor = [UIColor clearColor];
    self.wholeScroll.pagingEnabled = NO;
    self.wholeScroll.showsHorizontalScrollIndicator = NO;
    self.wholeScroll.showsVerticalScrollIndicator = NO;
    self.wholeScroll.delegate = self;
    self.wholeScroll.bounces = NO;
    [self addSubview:self.wholeScroll];
    
    [self initPosterView];
    [self initTable];
    
    _btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnComment.frame = CGRectMake(SCREEN_WIDTH-30-51,self.posterView.frame.size.height+SCREEN_WIDTH/2-51/2, 51, 51);
    [_btnComment setImage:[UIImage imageNamed:@"poster_comment.png"] forState:UIControlStateNormal];
    [_btnComment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
    [self.wholeScroll addSubview:_btnComment];
    [self.wholeScroll bringSubviewToFront:_btnComment];
}

-(void)initVariable
{
    self.isSecondSection = NO;
    self.isFirstLoadList = YES;
    _haveScrollToBottom = NO;
    _isTableScrollToTop = NO;
    _isBeginTouch = NO;
    _isDecelerating = NO;
}



-(void)initPosterView
{
    self.posterView = [[MoviePosterView alloc]initWithFrame:CGRectZero model:self.movieModel];
    __weak typeof(self) weakSelf = self;
    //打开播放器
    [self.posterView setPlayVideoBlock:^{
        [weakSelf playVideo];
    }];
    //跳到剧照页
    self.posterView.scanStillBlock = ^(MovieModel* model)
    {
        MovieStillsViewController* stillVC = [[MovieStillsViewController alloc]init];
        stillVC.movieModel = model;
        [weakSelf.nav pushViewController:stillVC animated:YES];
    };
    
    [self.wholeScroll addSubview:self.posterView];
    [self.wholeScroll addSubview:[self getHeaderV]];

    self.wholeScroll.contentSize = CGSizeMake(0, self.posterView.frame.size.height);
}

-(void)playVideo
{
    switch ([MKNetWorkState getNetWorkState])
    {
        case ReachableViaWWAN:
            //运营商网络
        {
            UIAlertView* netAlert = [[UIAlertView alloc]initWithTitle:nil message:@"您正在使用非WIFI网络，继续观看可能会消耗较多流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续观看", nil];
            netAlert.tag = 300;
            [netAlert show];
        }
            break;
        case ReachableViaWiFi:
            //Wi-Fi
            [self startPlayVideo];
            break;
        default:
            //无网络
            [FVCustomAlertView showDefaultErrorAlertOnView:self withTitle:requestErrorTip withBlur:NO allowTap:YES];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
            break;
    }
}

-(void)hideAlert
{
    [FVCustomAlertView hideAlertFromView:self fading:NO];
}

-(void)startPlayVideo
{
    [MobClick event:mainViewbtn130];
    //影片播放
    if (!self.videoController) {
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];//SCREEN_WIDTH/PLAYERSCALE
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoController];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController stop];
            weakSelf.videoController = nil;
            if (weakSelf.showHideBlock)
            {
                weakSelf.showHideBlock(YES);
            }
        }];
        
        //        [self.videoController setBackPortraitBlock:^{
        //            [weakSelf.videoController.view removeFromSuperview];
        //            [weakSelf.videoController showInView:weakSelf.movieTopView];
        //        }];
    }
    self.videoController.contentURL = [NSURL URLWithString:self.movieModel.trailer.videoUrl];//self.hotMovieModel.trailer_url;
    //    [movieImgView setHidden:YES];
    //    [moviePlayBtn setHidden:YES];
    [self.videoController showInView:self.window];//_movieTopView
    if (self.showHideBlock)
    {
        self.showHideBlock(NO);
    }
}

-(void)moviePlayBackDidFinish{
    //    [movieImgView setHidden:NO];
    //    [moviePlayBtn setHidden:NO];
    [self.videoController dismiss];
}

-(void)initTable
{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.posterView.frame.size.height+SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/2) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [_table setBackgroundColor:[UIColor whiteColor]];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.bounces = NO;
    [self.wholeScroll addSubview:_table];
    
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_table.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_table.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    [self setFooterState];
}

-(void)refreshData
{
    [_muArrData removeAllObjects];
    _curPageIndex = @1;
    [self loadCommentHeadData];
}

#pragma mark 加载短评接口
-(void)loadCommentHeadData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieReviewSummary:[self.movieModel.movieId stringValue] model:^(MovieReviewSummaryModel *movieDetail) {
        weakSelf.commentHeadModel = movieDetail;
        [weakSelf loadCommentListData];
        [weakSelf refreshHeadV];
    } failure:^(NSError *error) {
        [weakSelf initListFailure];
        [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
    }];
}

-(void)loadCommentListData
{
    __weak typeof(self) weakSelf = self;
    [ServicesMovie getMovieReviewList:self.movieModel.movieId pageIndex:_curPageIndex model:^(MovieReviewModel *movieDetail) {
        [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
        [weakSelf hideFailureView];
        weakSelf.commentListModel = movieDetail;
        [weakSelf setFooterState];
        [_muArrData addObjectsFromArray:movieDetail.reviewList];
        [weakSelf.table reloadData];
        if (weakSelf.isTableScrollToTop)
        {
            [weakSelf.table setContentOffset:CGPointMake(0,0) animated:NO];
            weakSelf.isTableScrollToTop = NO;
        }
    } failure:^(NSError *error) {
        [weakSelf initListFailure];
        if (weakSelf.isTableScrollToTop)
        {
            weakSelf.isTableScrollToTop = NO;
        }
        [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
    }];
}

-(void)initListFailure
{
    [_muArrData removeAllObjects];
    [_table reloadData];
    
    if (!_viewFailure)
    {
        CGFloat myCommentH = [self getMyCommentHeight];
        
        _viewFailure = [[UIView alloc]initWithFrame:CGRectMake(0, myCommentH, SCREEN_WIDTH, _table.frame.size.height-myCommentH)];
        _viewFailure.backgroundColor = RGBA(246, 246, 251, 1);
        [_table addSubview:_viewFailure];
        
        CGFloat failH = 134/2+15+14+30+24;
        _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-146/2)/2, (_viewFailure.frame.size.height-failH)/2, 146/2, 134/2)];
        _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
        [_viewFailure addSubview:_imageFailure];
        
        _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
        _labelFailure.text = @"加载失败";
        _labelFailure.textColor = RGBA(123, 122, 152, 1);
        _labelFailure.font = MKFONT(14);
        _labelFailure.textAlignment = NSTextAlignmentCenter;
        [_viewFailure addSubview:_labelFailure];
        
        _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+30, 146/2, 24);
        [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
        [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnTryAgain.titleLabel.font = MKFONT(14);
        _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
        _btnTryAgain.layer.masksToBounds = YES;
        _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
        [_btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
        [_viewFailure addSubview:_btnTryAgain];
    }
    else
    {
        _imageFailure.hidden = NO;
        _labelFailure.hidden = NO;
        _btnTryAgain.hidden = NO;
    }
}

-(void)hideFailureView
{
    if (_imageFailure)
    {
        _viewFailure.hidden = YES;
        _imageFailure.hidden = YES;
        _labelFailure.hidden = YES;
        _btnTryAgain.hidden = YES;
    }
}

-(void)onButtonTryAgain
{
    [self refreshData];
}

-(void)loadNewData
{
    if (!self.isSecondSection)
    {
        //当前在第二个section才上拉加载
        return;
    }
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesMovie getMovieReviewList:self.movieModel.movieId pageIndex:_curPageIndex model:^(MovieReviewModel *movieDetail) {
        [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
        weakSelf.commentListModel = movieDetail;
        [weakSelf setFooterState];
        [_muArrData addObjectsFromArray:movieDetail.reviewList];
        [weakSelf.table reloadData];
        [weakSelf.table.footer endRefreshing];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
        [weakSelf.table.footer endRefreshing];
    }];
}

-(void)setFooterState
{
    if ([_curPageIndex integerValue] == [self.commentListModel.pageTotal integerValue] || [self.commentListModel.pageTotal integerValue] == 0)
    {
        [self.table.footer setState:MJRefreshFooterStateNoMoreData];
        self.table.footer.hidden = YES;
    }
    else
    {
        self.table.footer.hidden = NO;
        _curPageIndex = [NSNumber numberWithInteger:[_curPageIndex integerValue]+1];
    }
}

-(void)initFailureView:(UITableViewCell*)cell
{
    CGFloat myCommentH = SCREEN_HEIGHT-[self getMyCommentHeight]-SCREEN_WIDTH/2;
    CGFloat failH = 167/2+15+14;
    UIImageView* imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-137/2)/2, (myCommentH-failH)/2, 137/2, 167/2)];
    imageFailure.image = [UIImage imageNamed:@"image_NoDataMovieReview.png"];
    [cell.contentView addSubview:imageFailure];
    
    UILabel* labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelFailure.text = @"看过这部电影？留个短评再走吧！";
    labelFailure.textColor = RGBA(123, 122, 152, 1);
    labelFailure.font = MKFONT(14);
    labelFailure.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:labelFailure];
}

-(CGFloat)getMyCommentHeight
{
    CGFloat heightDesc = 55+15;
    CGSize sizeDesc;
    if (_commentHeadModel.movieReview.content.length>0)
    {
//        NSString* strContent = _commentHeadModel.movieReview.content;
//        if (strContent.length>60)
//        {
//            strContent = [[strContent substringWithRange:NSMakeRange(0, 59)] stringByAppendingString:@"..."];
//        }
//        sizeDesc = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-30];
        CGFloat hDesc = [self calLabelH:_commentHeadModel.movieReview.content width:SCREEN_WIDTH-30];
        heightDesc = 55+15+hDesc;
    }
    else
    {
        sizeDesc = [Tool CalcString:@"说说你的看法，写条短评吧" fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-30];
        heightDesc = 55+15+14;
    }
    if ([_commentListModel.totalCount integerValue] == 0)
    {
        return heightDesc+15;
    }
    else
    {
        return heightDesc+15+42;
    }
}

-(CGFloat)calLabelH:(NSString*)str width:(CGFloat)maxWidth
{
    CGFloat height = 0;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    label.text = str;
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.font = MKFONT(14);
    [label sizeToFit];
    height = label.frame.size.height;
    label = nil;
    return height;
}

#pragma mark - TableViewDelegate
//Cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.commentHeadModel)
//    {
//        return SCREEN_HEIGHT-SCREEN_WIDTH/2;
//    }
    if (indexPath.row == 0)
    {
        return [self getMyCommentHeight];
    }
    else
    {
        if ([_commentListModel.totalCount integerValue] == 0)
        {
            return SCREEN_HEIGHT-[self getMyCommentHeight]-SCREEN_WIDTH/2;
        }
        else
        {
            MovieReviewListModel* model = _muArrData[indexPath.row-1];
            CGFloat cellH = 0;
//            NSString* strContent = model.content;
//            if (strContent.length>60)
//            {
//                strContent = [[strContent substringWithRange:NSMakeRange(0, 59)] stringByAppendingString:@"..."];
//            }
//            CGSize sizeDesc = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-15*4-40];
            CGFloat hDesc = [self calLabelH:model.content width:SCREEN_WIDTH-15*4-40];
            
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
                cellH = 30+15+hDesc+15+11+15+heightRes+15+15;
            }
            else
            {
                cellH = 30+15+hDesc+15+11+15+15;
            }
            if (indexPath.row == [self.commentListModel.totalCount integerValue])
            {
                cellH += 50;
            }
            return cellH;
        }
    }
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.commentHeadModel)
    {
        return 1;
    }
    if ([self.commentListModel.totalCount integerValue] == 0)
    {
        return 2;
    }
    else
    {
        return _muArrData.count+1;
    }
}

//Cell行数
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier2= [NSString stringWithFormat:@"CommentHeadTableViewCell%ld%d",(long)indexPath.row,self.curIndex];
    NSString *identifier3= [NSString stringWithFormat:@"CommentTableViewCell%ld%d",(long)indexPath.row,self.curIndex];
//    NSString *identifier4 = [NSString stringWithFormat:@"noCell%d",self.curIndex];
    
//    if (!self.commentHeadModel)
//    {
//        UITableViewCell* cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier4];
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier4];
//            cell.backgroundColor = RGBA(248, 248, 252, 1);
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return cell;
//    }
//    else
//    {
        if (indexPath.row == 0)
        {
            //头部cell
            CommentHeadTableViewCell *cell;// = (CommentHeadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell==nil)
            {
                cell = [[CommentHeadTableViewCell alloc] initWithReuseIdentifier:identifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                cell.cHDelegate = self;
            }
            cell.movieId = [self.movieModel.movieId stringValue];
            [cell setData:self.commentHeadModel icon:_arrIcon count:[self.commentListModel.totalCount integerValue]];
            return cell;
        }
        else
        {
            if ([self.commentListModel.totalCount integerValue] == 0)
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
                    cell = [[CommentTableViewCell alloc] initWithReuseIdentifier:identifier3];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.cDelegate = self;
                }
                [cell setData:_muArrData[indexPath.row-1] icon:_arrIcon curTime:self.commentListModel.currentTime];
                return cell;
            }
        }
//    }
}

-(UIImageView*)getHeaderV
{
    if (!_headerView)
    {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.posterView.frame.size.height, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.userInteractionEnabled = YES;
        [Tool downloadImage:self.movieModel.logoLandscapeUrl button:nil imageView:_headerView defaultImage:@"poster_landscape.png"];
        
        UIView* viewAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        viewAlpha.backgroundColor = RGBA(0, 0, 0, 0.6);
        [_headerView addSubview:viewAlpha];
        
        UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 60+24, SCREEN_WIDTH-30, 18)];
        labelName.text = self.movieModel.movieTitle;
        labelName.lineBreakMode = NSLineBreakByTruncatingTail;
        labelName.numberOfLines = 1;
        labelName.font = MKFONT(18);
        labelName.textColor = [UIColor whiteColor];
        [_headerView addSubview:labelName];
        
        if (SCREEN_WIDTH == 320)
        {
            labelName.frame = CGRectMake(15, 60+12, SCREEN_WIDTH-30, 18);
        }
        
        _labelFollowCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelFollowCount.font = MKFONT(12);
        _labelFollowCount.frame = CGRectMake(15, labelName.frame.origin.y+labelName.frame.size.height+20+(27-12)/2, 200, 12);
        _labelFollowCount.textColor = RGBA(255, 255, 255, 0.7);
        _labelFollowCount.backgroundColor = [UIColor clearColor];
        _labelFollowCount.text = @"暂无想看";
        [_headerView addSubview:_labelFollowCount];
        
        for (int i = 0; i<4; i++)
        {
            UIButton* btnFollowHead = [UIButton buttonWithType:UIButtonTypeCustom];
            btnFollowHead.frame = CGRectMake(15+29*i, labelName.frame.origin.y+labelName.frame.size.height+20, 27, 27);
            btnFollowHead.layer.masksToBounds = YES;
            btnFollowHead.layer.cornerRadius = btnFollowHead.frame.size.height/2;
            btnFollowHead.tag = 100+i;
            btnFollowHead.backgroundColor = [UIColor clearColor];
            [btnFollowHead addTarget:self action:@selector(onButtonFollowHead:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btnFollowHead];
        }
    }
    return _headerView;
}

-(void)changeFollowHead:(BOOL)isChange
{
    NSString* userHead = [Config getUserHeadImage];
    FollowUserListModel* fModel = [[FollowUserListModel alloc]init];
    fModel.portraitUrl = userHead;
    fModel.id = [NSNumber numberWithInteger:[[Config getUserId] integerValue]];
    
    NSMutableArray *arrFollowList = [NSMutableArray arrayWithArray:self.commentHeadModel.followUserList];
    if (isChange)
    {
        //将个人头像放到第一个
        self.movieModel.followCount = [NSNumber numberWithInteger:([self.movieModel.followCount integerValue]+1)];
        BOOL isHaveSelf = NO;
        if (arrFollowList.count>0)
        {
            for (int i = 0; i<arrFollowList.count; i++)
            {
                FollowUserListModel* firstModel = arrFollowList[i];
                if ([firstModel.id integerValue] == [fModel.id integerValue])
                {
                    isHaveSelf = YES;
                    break;
                }
            }
        }
        if (!isHaveSelf)
        {
            [arrFollowList insertObject:fModel atIndex:0];
        }
    }
    else
    {
        //将个人头像从前四个移除
        self.movieModel.followCount = [NSNumber numberWithInteger:([self.movieModel.followCount integerValue]-1)];
        if (arrFollowList.count>0)
        {
            for (int i = 0; i<arrFollowList.count; i++)
            {
                FollowUserListModel* firstModel = arrFollowList[i];
                if ([firstModel.id integerValue] == [fModel.id integerValue])
                {
                    [arrFollowList removeObjectAtIndex:i];
                }
            }
        }
    }
    [self refreshFollowHead:arrFollowList];
}

-(void)refreshHeadV
{
    //更新想看人数
    NSArray* followList = self.commentHeadModel.followUserList;
    [self refreshFollowHead:followList];
}

-(void)refreshFollowHead:(NSArray*)followList
{
    if (!_headerView)
    {
        [self getHeaderV];
    }
    if ([self.movieModel.followCount integerValue]==0)
    {
        _labelFollowCount.text = @"暂无想看";
        _labelFollowCount.frame = CGRectMake(15, _labelFollowCount.frame.origin.y, 200, 12);
        for (int i = 0; i<4; i++)
        {
            UIButton* btnFollow = (UIButton*)[_headerView viewWithTag:100+i];
            [btnFollow setBackgroundImage:nil forState:UIControlStateNormal];
        }
        return;
    }
    CGRect labelFrame = CGRectMake(15, _labelFollowCount.frame.origin.y, 200, 12);
    for (int i = 0; i<followList.count; i++)
    {
        if (i<4)
        {
            UIButton* btnFollow = (UIButton*)[_headerView viewWithTag:100+i];
            FollowUserListModel* fModel = followList[i];
            objc_setAssociatedObject(btnFollow, "uId", fModel.id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [Tool downloadImage:[fModel portraitUrl] button:btnFollow imageView:nil defaultImage:@"image_defaultHead1.png"];
            if (i == followList.count-1)
            {
                labelFrame = CGRectMake(btnFollow.frame.origin.x+btnFollow.frame.size.width+10, _labelFollowCount.frame.origin.y, 200, 12);
            }
        }
        else
        {
            UIButton* btnF = (UIButton*)[_headerView viewWithTag:103];
            labelFrame = CGRectMake(btnF.frame.origin.x+btnF.frame.size.width+10, _labelFollowCount.frame.origin.y, 200, 12);
        }
    }
    for (NSInteger j = followList.count; j<4; j++)
    {
        UIButton* btnFollow = (UIButton*)[_headerView viewWithTag:100+j];
        objc_setAssociatedObject(btnFollow, "uId", 0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btnFollow setBackgroundImage:nil forState:UIControlStateNormal];
    }
    NSNumber* count = self.movieModel.followCount;
    if (!self.commentHeadModel)
    {
        count = @1;
    }
    NSString* followCount = [Tool getPersonCount:count];
    _labelFollowCount.text = [NSString stringWithFormat:@"%@人想看",followCount];
    _labelFollowCount.frame = labelFrame;
}

-(void)onButtonFollowHead:(UIButton*)sender
{
    NSNumber* uId = objc_getAssociatedObject(sender, "uId");
    [self toUserHome:[uId integerValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row>0 && _muArrData.count>0)
        {
            MovieReviewListModel* model = _muArrData[indexPath.row-1];
            [self commentElse:model.id];
        }
    }
}

#pragma mark - 写短评=
-(void)toComment
{
    if( ![Config getLoginState])
    {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [_nav pushViewController:loginViewController animated:YES];
        return ;
    }
    
    UIViewController *viewController = self.nav.topViewController;
    CommentMovieView *commentMovieView = [[CommentMovieView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) movieId:self.movieModel.movieId];
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
    __weak typeof(self) weakSelf = self;
    [commentMovieView setRefreshListBlock:^{
        [Tool showSuccessTip:@"发布成功!" time:2];
        weakSelf.isTableScrollToTop = YES;
        [weakSelf refreshData];
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
        __weak typeof(self) weakSelf = self;
        [cEVC setRefreshListBlock:^{
            [weakSelf refreshData];
        }];
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
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:YES];
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
    if (alertView.tag == 300)
    {
        if (buttonIndex == 1)
        {
            //运营商网络下仍然播放视频
            [self startPlayVideo];
        }
    }
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
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:YES];
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

-(void)scrollToCommentList
{
    self.wholeScroll.contentSize = CGSizeMake(0, self.posterView.frame.size.height+SCREEN_HEIGHT);
    [self.wholeScroll setContentOffset:CGPointMake(0, self.posterView.frame.size.height)];
    [self.table setContentOffset:CGPointMake(0, 0)];
    self.isSecondSection = YES;
    self.haveScrollToBottom = NO;
    if (self.isFirstLoadList)
    {
        //首次加载短评列表接口
        self.isFirstLoadList = NO;
        [self loadCommentHeadData];
    }
    //设置scroll不能左右滑
    if (self.isCanScroll)
    {
        self.isCanScroll(NO);
    }
}

#pragma mark -scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll");
    if (self.showHideBlock)
    {
        self.showHideBlock(NO);
    }
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.wholeScroll)
    {
        if (offset<=300)
        {
            _effectview.alpha = offset/600;
        }
        if (_isBeginTouch)
        {
            [self isScrollToBottom:offset];
        }
        if (offset < self.posterView.frame.size.height-SCREEN_HEIGHT-0.5)
        {
            self.haveScrollToBottom = NO;
            self.wholeScroll.contentSize = CGSizeMake(0, self.posterView.frame.size.height);
        }
        if (self.isDecelerating && [self changeScrollState:offset isEndDragging:NO isSection:self.isSecondSection])
        {
            self.isDecelerating = NO;
        }
    }
}

-(void)isScrollToBottom:(CGFloat)offset
{
    if (!self.isSecondSection && offset >= self.posterView.frame.size.height-SCREEN_HEIGHT-0.5)
    {
        //NSLog(@"到底部了");
        self.haveScrollToBottom = YES;
        self.wholeScroll.contentSize = CGSizeMake(0, self.posterView.frame.size.height+SCREEN_HEIGHT);
        _isBeginTouch = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
    _isBeginTouch = YES;
    _isDecelerating = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"手势离开");
    //NSLog(@"%@",decelerate?@"减速":@"匀速");
    _isBeginTouch = NO;
    _isDecelerating = decelerate;
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.wholeScroll)
    {
        if (![self changeScrollState:offset isEndDragging:NO isSection:self.isSecondSection])
        {
            [self backToTop:offset];
        }
    }
    if (self.showHideBlock)
    {
        self.showHideBlock(YES);
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"开始减速");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"减速结束");
    CGFloat offset = scrollView.contentOffset.y;
    [self isScrollToBottom:offset];
    
    if (scrollView == self.wholeScroll)
    {
        [self backToTop:offset];
    }
    
    if (self.showHideBlock)
    {
        self.showHideBlock(YES);
    }
}

-(BOOL)changeScrollState:(CGFloat)offset isEndDragging:(BOOL)isEndDragging isSection:(BOOL)isSec
{
    __weak typeof(self) weakSelf = self;
    if (offset >= self.posterView.frame.size.height-SCREEN_HEIGHT+SCREEN_WIDTH/2)
    {
        //当前在第一屏
        if (!isSec && self.haveScrollToBottom)
        {
            //第二屏滑到顶
            self.isSecondSection = YES;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.wholeScroll setContentOffset:CGPointMake(0, weakSelf.posterView.frame.size.height)];
            } completion:^(BOOL finished) {
                [weakSelf.table setContentOffset:CGPointMake(0, 0)];
                [weakSelf.posterView refreshPull:NO];
                weakSelf.haveScrollToBottom = NO;
                if (weakSelf.isFirstLoadList)
                {
                    //首次加载短评列表接口
                    weakSelf.isFirstLoadList = NO;
                    [weakSelf loadCommentHeadData];
                }
                //设置scroll不能左右滑
                if (weakSelf.isCanScroll)
                {
                    weakSelf.isCanScroll(NO);
                }
            }];
            return YES;
        }
    }
    if (offset <= self.posterView.frame.size.height-SCREEN_WIDTH/2)
    {
        //当前在第二屏
        if (isSec)
        {
            //第一屏滑到顶
            self.isSecondSection = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.wholeScroll setContentOffset:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                [weakSelf.posterView refreshPull:YES];
                weakSelf.wholeScroll.contentSize = CGSizeMake(0, weakSelf.posterView.frame.size.height);
                //设置scroll能左右滑
                if (weakSelf.isCanScroll)
                {
                    weakSelf.isCanScroll(YES);
                }
            }];
            return YES;
        }
    }
    return NO;
}

-(void)backToTop:(CGFloat)offset
{
    __weak typeof(self) weakSelf = self;
    if (offset > self.posterView.frame.size.height-SCREEN_WIDTH/2 && self.isSecondSection)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.wholeScroll setContentOffset:CGPointMake(0, weakSelf.posterView.frame.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
    if (offset < self.posterView.frame.size.height-SCREEN_HEIGHT+SCREEN_WIDTH/2 && offset>self.posterView.frame.size.height-SCREEN_HEIGHT && !self.isSecondSection)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.wholeScroll setContentOffset:CGPointMake(0, weakSelf.posterView.frame.size.height - SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
