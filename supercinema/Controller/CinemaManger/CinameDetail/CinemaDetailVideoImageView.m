//
//  CinemaDetailVideoImageView.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "CinemaDetailVideoImageView.h"
#import "CinemaModel.h"

@interface CinemaDetailVideoImageView ()
@end

@implementation CinemaDetailVideoImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _viewWhiteLine = [[UIView alloc] initWithFrame:CGRectMake(15,0,2,14)];
    _viewWhiteLine.backgroundColor = RGBA(255, 255, 255, 1);
    [self addSubview:_viewWhiteLine];
    
    _labelVideo = [[UILabel alloc] initWithFrame:CGRectMake(27,0,180,15)];
    _labelVideo.text = @"影院视频和图片";
    _labelVideo.font = MKFONT(15);
    _labelVideo.textColor = RGBA(255, 255, 255, 1);
    [self addSubview:_labelVideo];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CinemaDetailVideoCell class] forCellWithReuseIdentifier:@"CinemaDetailVideoCell"];
    [_collectionView registerClass:[CinemaDetailImageCell class] forCellWithReuseIdentifier:@"CinemaDetailImageCell"];
    [_collectionView registerClass:[MoreMovieStillsCell class] forCellWithReuseIdentifier:@"MoreMovieStillsCell"];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _buttonVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonVideo setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
    _buttonVideo.titleLabel.font = [UIFont systemFontOfSize:12];
    [_buttonVideo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _buttonVideo.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0,-15);
    [self addSubview:_buttonVideo];
    
    _buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonImage setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
    _buttonImage.titleLabel.font = [UIFont systemFontOfSize:12];
    [_buttonImage setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _buttonImage.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, -15);
    [self addSubview:_buttonImage];
    
    _imageViewVideoArraw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_LookVideoPicture"]];
    [_buttonVideo addSubview:_imageViewVideoArraw];
    
    _imageViewImageArraw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_LookVideoPicture"]];
    [_buttonImage addSubview:_imageViewImageArraw];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _videoModels.count;
    }
    else if (_imageModels.count >=20)
    {
        return 20;
    
        
    }
    return _imageModels.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSString *iden = nil;
    if (indexPath.section == 0)
    {
        iden = @"CinemaDetailVideoCell";
    }
    else
    {
        if (indexPath.row < 19 ||  _imageModels.count <= 20)
        {
            iden = @"CinemaDetailImageCell";
        }
        else
        {
            iden = @"MoreMovieStillsCell";
        }
    }

    return [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (section == 0)
    {
        return UIEdgeInsetsMake(0,15,0,10);
    }
    else
    {
        
        return  UIEdgeInsetsMake(0,0, 0,15);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CinemaDetailVideoCell *videoCell = (CinemaDetailVideoCell *)cell;
        videoCell._videoModel = _videoModels[indexPath.item];
        [videoCell setData:_videoModels[indexPath.item]];
        
    }
    else
    {
       
        if (indexPath.row < 19 ||  _imageModels.count <= 20)
        {
            CinemaDetailImageCell *imageCell = (CinemaDetailImageCell *)cell;
            imageCell.model = _imageModels[indexPath.item];
            [imageCell setData:_imageModels[indexPath.item]];
            
        }
        else
        {
            MoreMovieStillsCell *imageCell = (MoreMovieStillsCell *)cell;
            [imageCell setData:_imageModels[indexPath.item]];
           
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delagate respondsToSelector:@selector(videoImageViewClick:imageIndex:)])
    {
        [self.delagate videoImageViewClick:indexPath.section imageIndex:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(334/2,200/2);
    }
    return CGSizeMake(100, 100);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;

    if (x  > 0)
    {
        [_buttonVideo setMssX:-x];
    }
    else
    {
        [_buttonVideo setMssX:15];
        
    }
    if (x - ((167 + 10) * _videoModels.count) < 0)
    {
        [_buttonImage setMssX: -x + ((167 + 10) *_videoModels.count) + 15];
    }
    else if (x - ((167 + 10) * _videoModels.count) < 140)
    {
        [_buttonImage setMssX:10];
        
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(0,25 + 8 - 4,self.mssWidth,100);
}

- (void)configWithVideos:(CinemaModel*)model
{
    self._cinemaModel = model;
    _videoModels = [[NSMutableArray alloc ] initWithObjects:model.cinemaVideoInfo, nil];
    _imageModels = [[NSMutableArray alloc ] initWithArray:model.images];
    
    [self refreshUI:model];
}

- (void)refreshUI:(CinemaModel*)model
{
    
    [_collectionView reloadData];
    BOOL haveVideo = NO;
    if ([model.videoCount integerValue]> 1)
    {
        haveVideo = YES;
    }
    
    BOOL haveImage = NO;
    if ([model.imageCount integerValue] > 4) {
        
        haveImage = YES;
    }
    

    if (haveVideo)
    {
        _buttonVideo.frame = CGRectMake(15,115 + 12 + 10 + 13/2 - 3.5, 120, 20);

        [_buttonVideo setTitle:[NSString stringWithFormat:@"查看全部%@部视频",model.videoCount] forState:UIControlStateNormal];
        _imageViewVideoArraw.frame = CGRectMake([Tool CalcString:[_buttonVideo titleForState:UIControlStateNormal] fontSize:_buttonVideo.titleLabel.font andWidth:MAXFLOAT].width + 5,5.5, 4.5, 9);
    }
    _buttonVideo.hidden = !haveVideo;
    
    [_collectionView reloadData];
    if (haveImage)
    {

        _buttonImage.frame = CGRectMake(15 + (167 + 10) * _videoModels.count, 115 + 12 +10 + 13/2 - 7/2, 120, 20);
        [_buttonImage setTitle:[NSString stringWithFormat:@"查看全部%zd张图片",_imageModels.count] forState:UIControlStateNormal];
        _imageViewImageArraw.frame = CGRectMake([Tool CalcString:[_buttonImage titleForState:UIControlStateNormal] fontSize:_buttonImage.titleLabel.font andWidth:MAXFLOAT].width + 5, 5.5, 4.5, 9);
        if (_imageModels.count == 0)
        {
            _buttonImage.frame = CGRectMake(15 + 10+ (167 + 10) * _videoModels.count, 115 + 12 +10 + 13/2, 120, 20);
        }
    }

    _buttonImage.hidden = !haveImage;
    
}

- (void)videoAddTarget:(id)target action:(SEL)action
{
    
    [_buttonVideo addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)imageAddTarget:(id)target action:(SEL)action 
{
    
    [_buttonImage addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
