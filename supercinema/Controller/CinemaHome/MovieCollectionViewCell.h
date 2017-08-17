//
//  MovieCollectionViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 16/8/9.
//
//

#import <UIKit/UIKit.h>
#import "HotMovieListModel.h"

@protocol MovieCollectionViewCellDelegate <NSObject>

- (void)buyTicket:(MovieModel*)model;

@end

@interface MovieCollectionViewCell : UICollectionViewCell
{
    UIImageView*   _imageLogo;      //电影logo
    UIImageView* _imgBack;
    UIImageView*    _imageScore;
    UILabel* _labelScore;         //评分
    UILabel* _labelMovieName;       //电影名
    
//    UILabel* _labelHall;          //影厅特色
    UIButton* _btnTicket;           //购票按钮
    
    MovieModel*  _movieModel;
}
@property (nonatomic, assign) id<MovieCollectionViewCellDelegate> cellDelegate;
@property (nonatomic, assign) BOOL  isNoMoreCell;
@property (nonatomic, assign) BOOL  isHotMovie;
-(void)setData:(MovieModel*)model isNoMore:(BOOL)isNoMore;
-(void)layoutFrame:(BOOL)isLeft;
@end
