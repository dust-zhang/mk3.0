//
//  CitySelectCollectionViewCell.h
//  supercinema
//
//  Created by mapollo91 on 14/10/16.
//
//

#import <UIKit/UIKit.h>

@interface CitySelectCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel            *_labelTitle;
@property (nonatomic,strong) UIImageView        *_imageViewGPS;

-(void)isShowGPSStatus:(BOOL)isShow withLocationCityName:(NSString *)cityName;

@end
