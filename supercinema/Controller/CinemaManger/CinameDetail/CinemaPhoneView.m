//
//  CinemaPhoneView.m
//  supercinema
//
//  Created by lianyanmin on 2017/4/19.
//
//

#import "CinemaPhoneView.h"
#import "YYCollectionViewWaterLayout.h"

@implementation CinemaPhoneViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _labelText = [[UILabel alloc] init];
        _labelText.textColor = RGBA(117, 112, 255, 1);
        _labelText.font = MKFONT(14);
        _labelText.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelText];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _labelText.text = text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _labelText.frame = self.contentView.bounds;
}



@end


@implementation CinemaPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _labelTitle = [[UILabel alloc]init];
    [self addSubview:_labelTitle];
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.font = MKFONT(14);
    _labelTitle.text = @"影院电话：";
    CGSize size = [Tool CalcString:@"影院电话：" fontSize:MKFONT(14) andWidth:MAXFLOAT];
    _labelTitle.frame = CGRectMake(0, 0, size.width, size.height);
    
    _layout = [[YYCollectionViewWaterLayout alloc]init];
    _layout.type = YYCollectionViewWaterLayoutHorizontalLimit;
    _layout.delegate = self;
    _layout.arrangeMargin = 0;
    _layout.rowMargin = 4;
    _layout.itemHeight = 16;
    _layout.sectionInset = UIEdgeInsetsMake(0,0, 0,0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_labelTitle.mssRight, 0, self.mssWidth - _labelTitle.mssRight, self.mssHeight) collectionViewLayout:_layout];
    [self addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CinemaPhoneViewCell class] forCellWithReuseIdentifier:@"CinemaPhoneViewCell"];
    
    _collectionView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _phone.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CinemaPhoneViewCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(CinemaPhoneViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _phone.count - 1) {//最后一个不加逗号
        cell.text = _phone[indexPath.item];
    } else {
        cell.text = [_phone[indexPath.item] stringByAppendingString:@"，"];
    }
}

- (CGFloat)itemWitdhForWaterLayout:(YYCollectionViewWaterLayout *)waterLayout forItemHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _phone.count - 1) {//最后一个不加逗号
        return [Tool CalcString:_phone[indexPath.item] fontSize:MKFONT(14) andWidth:MAXFLOAT].width;
    } else {
        return [Tool CalcString:[_phone[indexPath.item] stringByAppendingString:@"，"] fontSize:MKFONT(14) andWidth:MAXFLOAT].width;
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)setPhone:(NSArray<__kindof NSString *> *)phone
{
    _phone = phone;
    [_collectionView reloadData];
    [_collectionView layoutSubviews];
    _collectionView.frame = CGRectMake(_labelTitle.mssRight, 0, self.mssWidth - _labelTitle.mssRight, [self contentHeight]);
}

- (CGFloat)contentHeight
{
    return [_layout contentSize].height;
}

@end
