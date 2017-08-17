//
//  MovieStillsViewController.m
//  supercinema
//
//  Created by lianyanmin on 17/3/23.
//
//

#import "MovieStillsViewController.h"
#import "MovieStillsCell.h"
#import "MoreMovieStillsCell.h"
#import "IMageBrowseViewController.h"

#define pageSize (30)
@interface MovieStillsViewController ()
@end

@implementation MovieStillsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏线（导航栏）
    self._labelLine.hidden = YES;
    
    _arrStill = [[NSMutableArray alloc ] initWithCapacity:0];
    self._labelTitle.text = self.movieModel.movieTitle;
    
    [self initContorller];
    [self initFailureView];
    [self loadStillImageData];

}

- (void)setIsCinameImage:(BOOL)isCinameImage {
    
    _isCinameImage = isCinameImage;
    
}
-(void) loadStillImageData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:YES];
    if (_isCinameImage == YES)
    {
         __weak MovieStillsViewController *weakself = self;
        self._labelTitle.text = @"影院图片";
        [ServicesCinema getCinemaImageList:[Config getCinemaId] model:^(CinemaImageListModel *model) {
            
            [FVCustomAlertView hideAlertFromView:self.view fading:YES];
            [weakself hideFailureview:YES];
           
            _cinameStill = [[NSMutableArray alloc] initWithArray:model.images];
            _currentPageIndex = 0;
            [_collectionView reloadData];
            if (_cinameStill.count > pageSize)
            {
                [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreImageData)];
                
                [_collectionView.footer setTitle:@"加载更多" forState:MJRefreshFooterStateIdle];
                [_collectionView.footer setTitle:@"加载更多" forState:MJRefreshFooterStateRefreshing];
                [_collectionView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
                [_collectionView removeImage];
            }
            else
            {
                [_collectionView removeFooter];
            }
            
        } failure:^(NSError *error) {
            
            [FVCustomAlertView hideAlertFromView:self.view fading:YES];
            [_labelFailure setText:@"加载失败"];
            [weakself hideFailureview:NO];
        }];
    }
    else if (_isCinameImage == NO)
    {
        __weak MovieStillsViewController *weakself = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:YES];
        [ServiceStills getStills:self.movieModel.movieId includeMainHaibao:@0 array:^(NSArray *arrStills)
         {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             [weakself hideFailureview:YES];
             
             _arrStill = [[NSMutableArray alloc ] initWithArray:arrStills];
             _currentPageIndex = 0;
             [_collectionView reloadData];
             if (_arrStill.count > pageSize)
             {
                 [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreImageData)];
                 [_collectionView.footer setTitle:@"加载更多" forState:MJRefreshFooterStateIdle];
                 [_collectionView.footer setTitle:@"加载更多" forState:MJRefreshFooterStateRefreshing];
                 [_collectionView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
                 [_collectionView removeImage];
             }
             else
             {
                 [_collectionView removeFooter];
             }
             
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             [weakself hideFailureview:NO];
         }];
    }
}

- (void)loadMoreImageData {
    
    if (_isCinameImage)
    {
        
        if ((_currentPageIndex + 1) * pageSize >= _cinameStill.count || _currentPageIndex < 0)
        {
            [_collectionView removeFooter];
            return;
        }
        _currentPageIndex ++;
        [_collectionView.footer beginRefreshing];
        
        if ((_currentPageIndex + 1) * pageSize >= _cinameStill.count)
        {
            _currentPageIndex = -1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
                [_collectionView.footer endRefreshing];
                [_collectionView removeFooter];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView.footer endRefreshing];
                [_collectionView reloadData];
            });
        }

        
    }
    else
    {
        
        if ((_currentPageIndex + 1) * pageSize >= _arrStill.count || _currentPageIndex < 0)
        {
            [_collectionView removeFooter];
            return;
        }
        _currentPageIndex ++;
        [_collectionView.footer beginRefreshing];
        
        if ((_currentPageIndex + 1) * pageSize >= _arrStill.count)
        {
            _currentPageIndex = -1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
                [_collectionView.footer endRefreshing];
                [_collectionView removeFooter];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView.footer endRefreshing];
                [_collectionView reloadData];
            });
        }
    }
    
}

-(void) hideFailureview:(BOOL)showHide
{
    [_imageFailure setHidden:showHide];
    [_labelFailure setHidden:showHide];
    [_btnTryAgain setHidden:showHide];
}

-(void)initFailureView
{
    self.view.backgroundColor = RGBA(248, 248, 252, 1);
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, self._viewTop.frame.size.height+ 100, 60, 60)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    [self.view addSubview:_imageFailure];
    [_imageFailure setHidden:YES];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    [_labelFailure setText:@"剧照加载失败"];
    [self.view addSubview:_labelFailure];
    [_labelFailure setHidden:YES];
    
    _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+30, 146/2, 24);
    [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnTryAgain.titleLabel.font = MKFONT(14);
    _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    _btnTryAgain.layer.masksToBounds = YES;
    _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
    [_btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTryAgain];
    [_btnTryAgain setHidden:YES];
}

-(void)onButtonTryAgain
{
    [self loadStillImageData];
}

- (void)initContorller
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 3)/3,(SCREEN_WIDTH - 3)/3);
    flowLayout.minimumLineSpacing = 1.5;
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[MovieStillsCell class] forCellWithReuseIdentifier:@"MovieStillsCell"];
    [self.view addSubview:_collectionView];
    _collectionView.bounces = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_isCinameImage) {
        
        if (_currentPageIndex >= 0 && _cinameStill.count > pageSize)
        {
            return (_currentPageIndex + 1) * pageSize;
        }
        else
        {
            return _cinameStill.count;
        }
    }
    else
    {
        
        if (_currentPageIndex >= 0 && _arrStill.count > pageSize)
        {
            return (_currentPageIndex + 1) * pageSize;
        }
        else
        {
            return _arrStill.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isCinameImage) {
      
        MovieStillsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieStillsCell" forIndexPath:indexPath];
        [cell setData:_cinameStill[indexPath.item]];
        return cell;
    }
    else
    {
        
        MovieStillsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieStillsCell" forIndexPath:indexPath];
        [cell setData:_arrStill[indexPath.item]];
        return cell;
    }
//    return;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isCinameImage) {
        
        // 加载网络图片
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < [_cinameStill count];i++)
        {
            StillModel* model = [[StillModel alloc]init];
            model = _cinameStill[i];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            
            browseItem.bigImageUrl = model.urlOfBig;
            [browseItemArray addObject:browseItem];
        }
        ImageBrowseViewController *imageBrowseController = [[ImageBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.item];
        imageBrowseController.isEqualRatio = NO;
        [imageBrowseController showBrowseViewController];
    }
    else
    {
     
        // 加载网络图片
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < [_arrStill count];i++)
        {
            StillModel* model = [[StillModel alloc]init];
            model = _arrStill[i];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            
            browseItem.bigImageUrl = model.urlOfBig;
            [browseItemArray addObject:browseItem];
        }
        ImageBrowseViewController *imageBrowseController = [[ImageBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.item];
        imageBrowseController.isEqualRatio = NO;
        [imageBrowseController showBrowseViewController];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
