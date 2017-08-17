//
//  CinemaVideoListViewController.h
//  supercinema
//
//  Created by dust on 2017/4/13.
//
//

#import <UIKit/UIKit.h>
#import "CinemaVideoTableViewCell.h"


@interface CinemaVideoListViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView                 *_tableViewVideo;
    
    UIImageView                 *_imageFailure;
    UILabel                     *_labelFailure;
    UIButton                    *_btnTryAgain;
    NSMutableArray              *_arrAllVideo;
    NSInteger                   _index;
    
}

@property(nonatomic,strong) KrVideoPlayerController             *_videoController;
@property(nonatomic,strong) NSMutableArray                      *_arrVideo;
@end
