//
//  ImageBrowseViewController.m
//  supercinema
//
//  Created by lianyanmin on 17/3/24.
//
//

#import "ImageBrowseViewController.h"

@interface ImageBrowseViewController ()
@end

@implementation ImageBrowseViewController

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex
{
    self = [super initWithBrowseItemArray:browseItemArray currentIndex:currentIndex];
    if (self)
    {
        self._arrBrowseItem = browseItemArray;
        self._currentIndex = currentIndex;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
  
    [_labelCount removeFromSuperview];
    [_imgLineRight removeFromSuperview];
    [_imgLineLeft removeFromSuperview];
    
    [_imgViewUp addSubview:_labelCount];
    _labelCount.frame = CGRectMake(0, 32.5,SCREEN_WIDTH,20);
    _labelCount.textAlignment = NSTextAlignmentCenter;
    _labelCount.textColor = [UIColor whiteColor];
    _labelCount.font = MKFONT(20);
    _labelCount.text = [NSString stringWithFormat:@"%ld/%ld",self._currentIndex + 1,(unsigned long)self._arrBrowseItem.count];
    UILabel *countLabel = [self valueForKey:@"countLabel"];
    countLabel.hidden = YES;
    
  
    UIButton *btnSave = [[UIButton alloc]initWithFrame:CGRectMake(30,_imgViewDown.frame.size.height-40-15, 60,55/2)];
    btnSave.layer.borderWidth = 0.5;
    btnSave.layer.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
    btnSave.layer.cornerRadius = 2;
    btnSave.layer.masksToBounds = YES;
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = MKFONT(15);
    [btnSave addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [_imgViewDown addSubview:btnSave];
    
    _imgViewDown.userInteractionEnabled = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self._currentIndex = scrollView.contentOffset.x / (self.screenWidth + kBrowseSpace);
    _labelCount.text = [NSString stringWithFormat:@"%ld/%ld",(long)self._currentIndex + 1,(unsigned long)self._arrBrowseItem.count];
}

- (void)showBigImage:(UIImageView *)imageView browseItem:(MSSBrowseModel *)browseItem rect:(CGRect)rect
{
    
    // 取消当前请求防止复用问题
    [imageView sd_cancelCurrentImageLoad];
    // 如果存在直接显示图片
    imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:browseItem.bigImageUrl];
    // 当大图frame为空时，需要大图加载完成后重新计算坐标
    CGRect bigRect = [self getBigImageRectIfIsEmptyRect:rect bigImage:imageView.image];
    // 第一次打开浏览页需要加载动画
    if(self.isFirstOpen)
    {
        self.isFirstOpen = NO;
        imageView.frame = bigRect;
        imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        
        [UIView animateWithDuration:1 animations:^{
            imageView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    else
    {
        imageView.frame = bigRect;
    }
}

// 当大图frame为空时，需要大图加载完成后重新计算坐标
- (CGRect)getBigImageRectIfIsEmptyRect:(CGRect)rect bigImage:(UIImage *)bigImage
{
    if(CGRectIsEmpty(rect))
    {
        return [bigImage mss_getBigImageRectSizeWithScreenWidth:self.screenWidth screenHeight:self.screenHeight];
    }
    return rect;
}

- (void)tap:(MSSBrowseCollectionViewCell *)browseCell
{
//    if (_isHideView)
//    {
//        //隐藏view
//        [UIView animateWithDuration:0.2 animations:^{
//            _imgViewUp.backgroundColor = [UIColor clearColor];
//            _imgViewDown.backgroundColor = [UIColor clearColor];
//        }];
//    }
//    else
//    {
//        //显示view
//        [UIView animateWithDuration:0.2 animations:^{
//            _imgViewUp.backgroundColor = [UIColor blackColor];
//            _imgViewDown.backgroundColor = [UIColor blackColor];
//        }];
//        
//    }
//    _isHideView = !_isHideView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MSSBrowseCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _curCell = cell;
}


- (void)onSaveButton
{
     UIImageWriteToSavedPhotosAlbum(_curCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"无法保存" message:@"请在\"设置-隐私-照片\"选项中，允许超级电影院访问您的照片。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else
    {
        [Tool showSuccessTip:@"保存图片成功" time:2.0];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)longPress:(MSSBrowseCollectionViewCell *)browseCell
{

}

-(void)toucheUpClose
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        _curCell.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}


@end
