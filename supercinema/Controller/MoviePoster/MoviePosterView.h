//
//  MoviePosterView.h
//  supercinema
//
//  Created by Mapollo28 on 2017/3/28.
//
//

#import <UIKit/UIKit.h>
#import "ScrollViewForStill.h"
#import "MovieStillsViewController.h"
#import "ImageBrowseViewController.h"

@interface MoviePosterView : UIView<openStillDelegate>
{
    UIButton*           _btnPlay;               //播放按钮
    UILabel*            _labelMovieName;        //电影名称
    UIImageView*        _imageDouban;           //豆瓣icon
    UILabel*            _labelScoreDouban;      //豆瓣评分
    UIImageView*        _imageIMDb;             //IMDb icon
    UILabel*            _labelScoreIMDb;        //IMDb评分
    UILabel*            _labelTime;             //片长
    UIView*             _viewVersion;           //版本背景
    UIImageView*        _imageShowTime;         //上映日期icon
    UILabel*            _labelShowTime;         //上映日期
    UILabel*            _labelMovieFlag;             //影片标签
    UIView*             _viewFlag;              //影片标签view
    UILabel*            _labelTeam;             //主创团队
    UIScrollView*       _scrollTeam;            //主创团队scroll
    UILabel*            _labelMoviePhoto;       //电影图片
    UIView*             _viewScan;
    UILabel*            _labelScan;
    UIImageView*        _imageScan;
    UILabel*            _labelTip;              //观影提示
    UIImageView*        _imageArrow;
    UILabel*            _labelPull;
}
@property (nonatomic,strong)MovieModel* movieModel;
@property (nonatomic, copy)void(^playVideoBlock)(void);
@property (nonatomic, copy)void(^scanStillBlock)(MovieModel* model);
-(id)initWithFrame:(CGRect)frame model:(MovieModel*)mModel;
-(void)refreshData;
-(void)refreshFrame;
-(void)refreshPull:(BOOL)isPull;
@end
