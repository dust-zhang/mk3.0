//
//  CitySelectCollectionViewCell.m
//  supercinema
//
//  Created by mapollo91 on 14/10/16.
//
//

#import "CitySelectCollectionViewCell.h"

@implementation CitySelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self._imageViewGPS = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 36/2, 36/2)];
        [self._imageViewGPS setImage:[ UIImage imageNamed:@"image_gps.png"] ];
        self._imageViewGPS.animationDuration = 1;
        self._imageViewGPS.animationRepeatCount = INT_MAX;
        
        self._labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(self._imageViewGPS.frame.size.width +self._imageViewGPS.frame.origin.x+5, 0, frame.size.width, frame.size.height)];
        self._labelTitle.textColor = RGBA(51, 51, 51, 1);
        self._labelTitle.font = MKFONT(15);
        self._labelTitle.backgroundColor = [UIColor whiteColor];
        self._labelTitle.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self._imageViewGPS];
        [self addSubview:self._labelTitle];
    }
    return self;
}

-(void)isShowGPSStatus:(BOOL)isShow withLocationCityName:(NSString *)cityName
{
    self._labelTitle.text = cityName;
}

@end
