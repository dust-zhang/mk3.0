//
//  CinemaDetailTagCell.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import <UIKit/UIKit.h>

@interface CinemaDetailTagCell : UICollectionViewCell
{
    UILabel *_cinameLabelTag;
}
@property (strong, nonatomic) NSString *tagString;
@end


@interface CinemaFacilityTagCell : UICollectionViewCell
{
    UILabel *_labelTag;
}
@property (strong, nonatomic) NSString *tagString;

@end

@interface CinemaPhoneTagCell : UICollectionViewCell
{
    UILabel *_labelTag;
}
@property (strong, nonatomic) NSString *tagString;

@end
