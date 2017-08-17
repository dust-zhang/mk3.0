//
//  MSSBrowseBaseViewController.m
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBrowseBaseViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+MSSScale.h"
#import "MSSBrowseActionSheet.h"
#import "MSSBrowseDefine.h"

@interface MSSBrowseBaseViewController ()

@property (nonatomic,strong)NSArray *browseItemArray;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)BOOL isRotate;// 判断是否正在切换横竖屏
@property (nonatomic,strong)UILabel *countLabel;// 当前图片位置
@property (nonatomic,strong)UIView *snapshotView;
@property (nonatomic,strong)NSMutableArray *verticalBigRectArray;
@property (nonatomic,strong)NSMutableArray *horizontalBigRectArray;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)UIDeviceOrientation currentOrientation;
@property (nonatomic,strong)MSSBrowseActionSheet *browseActionSheet;

@end

@implementation MSSBrowseBaseViewController

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if(self)
    {
        _browseItemArray = browseItemArray;
        _currentIndex = currentIndex;
        _isEqualRatio = YES;
        _isFirstOpen = YES;
        _screenWidth = MSS_SCREEN_WIDTH;
        _screenHeight = MSS_SCREEN_HEIGHT;
        _currentOrientation = UIDeviceOrientationPortrait;
        _verticalBigRectArray = [[NSMutableArray alloc]init];
        _horizontalBigRectArray = [[NSMutableArray alloc]init];
        _isHideView = NO;
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)showBrowseViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        _snapshotView = [rootViewController.view snapshotViewAfterScreenUpdates:NO];
    }
    [rootViewController presentViewController:self animated:NO completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createBrowseView];
}

- (void)initData
{
    for (MSSBrowseModel *browseItem in _browseItemArray)
    {
        CGRect verticalRect = CGRectZero;
        CGRect horizontalRect = CGRectZero;
        // 等比可根据小图宽高计算大图宽高
        if(_isEqualRatio)
        {
            if(browseItem.smallImageView)
            {
                verticalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:MSS_SCREEN_WIDTH screenHeight:MSS_SCREEN_HEIGHT];
                horizontalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:MSS_SCREEN_HEIGHT screenHeight:MSS_SCREEN_WIDTH];
            }
        }
        NSValue *verticalValue = [NSValue valueWithCGRect:verticalRect];
        [_verticalBigRectArray addObject:verticalValue];
        NSValue *horizontalValue = [NSValue valueWithCGRect:horizontalRect];
        [_horizontalBigRectArray addObject:horizontalValue];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)createBrowseView
{
    self.view.backgroundColor = [UIColor blackColor];
    if(_snapshotView)
    {
        _snapshotView.hidden = YES;
        [self.view addSubview:_snapshotView];
    }
    
    _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 每行的间距
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _screenWidth + kBrowseSpace, _screenHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[MSSBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"MSSBrowserCell"];
    _collectionView.contentOffset = CGPointMake(_currentIndex * (_screenWidth + kBrowseSpace), 0);
    [_bgView addSubview:_collectionView];
    
    _imgViewUp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    _imgViewUp.image = [UIImage imageNamed:@"img_photo_up.png"];
    _imgViewUp.userInteractionEnabled = YES;
    [_bgView addSubview:_imgViewUp];
    
    _btnClose = [[UIButton alloc] init];
    [_btnClose setImage:[UIImage imageNamed:@"btn_still_close.png"] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(toucheUpClose) forControlEvents:UIControlEventTouchUpInside];
    [_btnClose setFrame:CGRectMake(0, 35/2, 75, 50)];
    _btnClose.backgroundColor=[UIColor clearColor];
    [_imgViewUp addSubview:_btnClose];
    
    _imgViewDown = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-125, SCREEN_WIDTH, 125)];
    _imgViewDown.image = [UIImage imageNamed:@"img_photo_down.png"];
    [_bgView addSubview:_imgViewDown];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)_currentIndex + 1];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font= MKFONT(24);
    [_imgViewDown addSubview:_countLabel];
    
    _labelCount = [[UILabel alloc]init];
    _labelCount.textColor = RGBA(255, 255, 255, 0.3);
    _labelCount.text = [NSString stringWithFormat:@"/%ld",(long)_browseItemArray.count];
    _labelCount.textAlignment = NSTextAlignmentCenter;
    _labelCount.font = MKFONT(15);
    [_imgViewDown addSubview:_labelCount];
    
    CGFloat widthCountLabel = [Tool calStrWidth:_countLabel.text height:24];
    CGFloat widthLabelCount = [Tool calStrWidth:_labelCount.text height:15];
    CGFloat space = (SCREEN_WIDTH-widthCountLabel-widthLabelCount-178-30-5)/2;
    _countLabel.frame = CGRectMake(space+178/2, _imgViewDown.frame.size.height-90/2-24, widthCountLabel+30, 24);
    _labelCount.frame = CGRectMake(SCREEN_WIDTH-space-178/2-30/2-widthLabelCount, _imgViewDown.frame.size.height-90/2-15, widthLabelCount+5, 15);
    
    _imgLineLeft = [[UIView alloc]initWithFrame:CGRectMake(space, _imgViewDown.frame.size.height-105/2-5, 178/2, 0.5)];
    _imgLineLeft.backgroundColor = RGBA(255, 255, 255, 0.3);
    [_imgViewDown addSubview:_imgLineLeft];
    
    _imgLineRight = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - space - 178/2, _imgLineLeft.frame.origin.y, 178/2, 0.5)];
    _imgLineRight.backgroundColor = RGBA(255, 255, 255, 0.3);
    [_imgViewDown addSubview:_imgLineRight];

}

-(void)toucheUpClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSBrowserCell" forIndexPath:indexPath];
    if(cell)
    {        
        MSSBrowseModel *browseItem = [_browseItemArray objectAtIndex:indexPath.row];
        // 还原初始缩放比例
        cell.zoomScrollView.frame = CGRectMake(0, 0, _screenWidth, _screenHeight);
        cell.zoomScrollView.zoomScale = 1.0f;
        // 将scrollview的contentSize还原成缩放前
        cell.zoomScrollView.contentSize = CGSizeMake(_screenWidth, _screenHeight);
        cell.zoomScrollView.zoomImageView.contentMode = browseItem.smallImageView.contentMode;
        cell.zoomScrollView.zoomImageView.clipsToBounds = browseItem.smallImageView.clipsToBounds;
        [cell.loadingView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(30, 30)];
        CGRect bigImageRect = [_verticalBigRectArray[indexPath.row] CGRectValue];
        if(_currentOrientation != UIDeviceOrientationPortrait)
        {
            bigImageRect = [_horizontalBigRectArray[indexPath.row] CGRectValue];
        }
        [self loadBrowseImageWithBrowseItem:browseItem Cell:cell bigImageRect:bigImageRect];
        
        __weak __typeof(self)weakSelf = self;
        [cell tapClick:^(MSSBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf tap:browseCell];
        }];
        [cell longPress:^(MSSBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([[SDImageCache sharedImageCache]diskImageExistsWithKey:browseItem.bigImageUrl])
            {
                [strongSelf longPress:browseCell];
            }
        }];
    }
    return cell;
}

// 子类重写此方法
- (void)loadBrowseImageWithBrowseItem:(MSSBrowseModel *)browseItem Cell:(MSSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect
{

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _browseItemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_screenWidth + kBrowseSpace, _screenHeight);
}

#pragma mark UIScrollViewDeletate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_isRotate)
    {
        _currentIndex = scrollView.contentOffset.x / (_screenWidth + kBrowseSpace);
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)_currentIndex + 1];
    }
    _isRotate = NO;
}

#pragma mark Tap Method
- (void)tap:(MSSBrowseCollectionViewCell *)browseCell
{
    if (_isHideView)
    {
        //隐藏view
        [UIView animateWithDuration:0.2 animations:^{
            _imgViewUp.frame = CGRectMake(0, -125, _imgViewUp.frame.size.width, 125);
            _imgViewDown.frame = CGRectMake(0, _screenHeight, _imgViewDown.frame.size.width, 125);
        }];
    }
    else
    {
        //显示view
        [UIView animateWithDuration:0.2 animations:^{
            _imgViewUp.frame = CGRectMake(0, 0, _imgViewUp.frame.size.width, 125);
            _imgViewDown.frame = CGRectMake(0, _screenHeight-125, _imgViewDown.frame.size.width, 125);
        }];
    }
    _isHideView = !_isHideView;
}

- (void)longPress:(MSSBrowseCollectionViewCell *)browseCell
{
    _curCell = browseCell;
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:nil, nil];
    [sheet showInView:_bgView];
    
//    [_browseActionSheet removeFromSuperview];
//    _browseActionSheet = nil;
//    __weak __typeof(self)weakSelf = self;
//    _browseActionSheet = [[MSSBrowseActionSheet alloc]initWithTitleArray:@[@"保存图片"] cancelButtonTitle:@"取消" didSelectedBlock:^(NSInteger index) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf browseActionSheetDidSelectedAtIndex:index currentCell:browseCell];
//    }];
//    [_browseActionSheet showInView:_bgView];
}

#pragma mark StatusBar Method
- (BOOL)prefersStatusBarHidden
{
    if(!_collectionView.userInteractionEnabled)
    {
        return NO;
    }
    return YES;
}

#pragma mark Orientation Method
- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        _isRotate = YES;
        _currentOrientation = orientation;
        if(_currentOrientation == UIDeviceOrientationPortrait)
        {
            _screenWidth = MSS_SCREEN_WIDTH;
            _screenHeight = MSS_SCREEN_HEIGHT;
            [UIView animateWithDuration:0.5 animations:^{
                _bgView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        else
        {
            _screenWidth = MSS_SCREEN_HEIGHT;
            _screenHeight = MSS_SCREEN_WIDTH;
            if(_currentOrientation == UIDeviceOrientationLandscapeLeft)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    _bgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    _bgView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
                }];
            }
        }
        _bgView.frame = CGRectMake(0, 0, MSS_SCREEN_WIDTH, MSS_SCREEN_HEIGHT);
        
        if(_browseActionSheet)
        {
            [_browseActionSheet updateFrame];
        }
        
        _imgViewUp.frame = CGRectMake(0, 0, _screenWidth, 125);
        _imgViewDown.frame = CGRectMake(0, _screenHeight-125, _screenWidth, 125);
        CGFloat widthCountLabel = [Tool calStrWidth:_countLabel.text height:24];
        CGFloat widthLabelCount = [Tool calStrWidth:_labelCount.text height:15];
        CGFloat space = (_screenWidth-widthCountLabel-widthLabelCount-178-30-5)/2;
        _countLabel.frame = CGRectMake(space+178/2, _imgViewDown.frame.size.height-90/2-24, widthCountLabel+30/2, 24);
        _labelCount.frame = CGRectMake(_screenWidth-space-178/2-30/2-widthLabelCount, _imgViewDown.frame.size.height-90/2-15, widthLabelCount+5, 15);
        _imgLineLeft.frame = CGRectMake(space, _imgViewDown.frame.size.height-105/2-5, 178/2, 0.5);
        _imgLineRight.frame = CGRectMake(_screenWidth - space - 178/2, _imgLineLeft.frame.origin.y, 178/2, 0.5);
        
        [_collectionView.collectionViewLayout invalidateLayout];
        _collectionView.frame = CGRectMake(0, 0, _screenWidth + kBrowseSpace, _screenHeight);
        _collectionView.contentOffset = CGPointMake((_screenWidth + kBrowseSpace) * _currentIndex, 0);
        [_collectionView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImageWriteToSavedPhotosAlbum(_curCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

#pragma mark MSSActionSheetClick
- (void)browseActionSheetDidSelectedAtIndex:(NSInteger)index currentCell:(MSSBrowseCollectionViewCell *)currentCell
{    // 保存图片
    if(index == 0)
    {
        UIImageWriteToSavedPhotosAlbum(currentCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    // 复制图片地址
    else if(index == 1)
    {
        MSSBrowseModel *currentBwowseItem = _browseItemArray[_currentIndex];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = currentBwowseItem.bigImageUrl;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        [Tool showWarningTip:@"保存图片失败" time:2.0];
    }
    else
    {
        [Tool showSuccessTip:@"保存图片成功" time:2.0];
    }
}


@end
