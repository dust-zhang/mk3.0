
//
//  CinemaDetailTagsView.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "CinemaDetailTagsView.h"


@interface CinemaDetailTagsView ()

@end

@implementation CinemaDetailTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createdSubviews];
    }
    return self;
}

- (void)createdSubviews
{
    _viewWhiteLine = [[UIView alloc] init];
    _viewWhiteLine.backgroundColor = RGBA(255, 255, 255, 1);
    [self addSubview:_viewWhiteLine];
    
    _labelTitle = [[UILabel alloc]init];
    _labelTitle.textColor = RGBA(255, 255, 255, 1);
    _labelTitle.font = [UIFont systemFontOfSize:15];
    _labelTitle.text = @"特色设施";
    [self addSubview:_labelTitle];
    
    _imageViewLamp = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageViewLamp setImage:[UIImage imageNamed:@"image_lamp@2x.png"]];
    [self addSubview:_imageViewLamp];
    
    _layout = [[YYCollectionViewWaterLayout alloc]init];
    _layout.type = YYCollectionViewWaterLayoutHorizontalLimit;
    _layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:_layout];
    [self addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CinemaDetailTagCell class] forCellWithReuseIdentifier:@"CinemaDetailTagCell"];
    [_collectionView registerClass:[CinemaFacilityTagCell class] forCellWithReuseIdentifier:@"CinemaFacilityTagCell"];
    _collectionView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayTags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:_isCinemaTags ? @"CinemaDetailTagCell" : @"CinemaFacilityTagCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isCinemaTags)
    {
        CinemaDetailTagCell *cinemaTagCell = (CinemaDetailTagCell *)cell;
        cinemaTagCell.tagString = _arrayTags[indexPath.item];
        
    }
    else
    {
        CinemaFacilityTagCell *facilityTagCell = (CinemaFacilityTagCell *)cell;
        facilityTagCell.tagString = _arrayTags[indexPath.item];
    }
}

- (CGFloat)itemWitdhForWaterLayout:(YYCollectionViewWaterLayout *)waterLayout forItemHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isCinemaTags)
    {
        return [Tool CalcString:[_arrayTags[indexPath.item]  stringByAppendingString:@"；" ] fontSize:MKFONT(12) andWidth:MAXFLOAT].width;
    }
    else
    {
        return [Tool CalcString:_arrayTags[indexPath.item] fontSize:MKFONT(12) andWidth:MAXFLOAT].width+20;
    }
    return 0;
}

- (void)setIsCinemaTags:(BOOL)isCinemaTags
{
    _isCinemaTags = isCinemaTags;
    _labelTitle.hidden = isCinemaTags;
    _viewWhiteLine.hidden = isCinemaTags;
    _imageViewLamp.hidden = !isCinemaTags;
    
    if (_isCinemaTags)
    {
        _layout.arrangeMargin = 0;
        _layout.rowMargin = 0;
        _layout.itemHeight = 20;
        _layout.sectionInset = UIEdgeInsetsMake(0,0, 0,0);
    }
    else
    {
        _layout.arrangeMargin = 15;
        _layout.rowMargin = 10.5;
        _layout.itemHeight = 20;
        _layout.sectionInset = UIEdgeInsetsMake(1,10,0,10);
    }
}

- (CGFloat)heightWithTags:(NSArray*)tags
{
    _arrayTags = [[NSMutableArray alloc ] initWithArray:tags];
    _collectionView.frame = CGRectMake(33, 10, self.mssWidth - 40.5,90);
    [_collectionView reloadData];
    [_collectionView layoutSubviews];
    
    if (!_isCinemaTags)
    {
        _viewWhiteLine.frame = CGRectMake(15,0,2,14);
        _labelTitle.frame = CGRectMake(27,-0.5, 80,15);
        _collectionView.frame = CGRectMake(5,30 - 2, self.mssWidth,[_layout contentSize].height);
    }
    else if (_isCinemaTags)
    {
        
        _imageViewLamp.frame = CGRectMake(15,0,15.5,16);
        _collectionView.frame = CGRectMake(15+15.5+10,0, self.mssWidth - 40.5,[_layout contentSize].height);
    }
    return CGRectGetMaxY(_collectionView.frame);
}

@end
