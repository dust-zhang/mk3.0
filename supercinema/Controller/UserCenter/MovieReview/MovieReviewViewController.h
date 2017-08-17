//
//  MovieReviewViewController.h
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import <UIKit/UIKit.h>
#import "MovieReviewTableViewCell.h"

@interface MovieReviewViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray      *_arrMovieReview;
    UITableView         *_tableViewMyMovieReview;
    
    int                 _pageIndex; //分页显示的页码
    int                 _totalPage;
    
    UIImageView         *_imageLoadFailed;
    UILabel             *_labelDescLoadFailed;
    NSNumber            *_systemTime;

    //加载失败
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,strong) NSString * _userId;
@end
