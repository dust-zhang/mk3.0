//
//  ActivityView.h
//  supercinema
//
//  Created by dust on 16/11/18.
//
//

#import <UIKit/UIKit.h>

#import "ActivityViewModel.h"
#import "LoginViewController.h"
#import "AwardView.h"
#import "NotifyH5ViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityDetailsViewController.h"

@protocol ActivityViewDelegate <NSObject>
//凑热闹跳转到看电影
-(void)ActivityJumpLookMovie:(UIButton *)btnTage;
@end

@interface ActivityView : UIView <UITableViewDelegate, UITableViewDataSource , ActivityTableViewCellDelegate>
{
    int                     frameHeight;
    
    UIImageView             *_imageView;

    //加载失败
    UIImageView             *_imageFailure;
    UILabel                 *_labelFailure;
    UIButton                *_btnTryAgain;
    
    NSMutableArray          *_arrayActivity;        //整体活动列表
    NSMutableArray          *_arrCurrentActivity;   //当前活动
    NSMutableArray          *_arrOverdueActivity;   //往期活动
}

@property (nonatomic ,strong)   UINavigationController      *_navigationController;
@property (nonatomic ,strong)   NSNumber                    *activityId;
@property (nonatomic ,assign)   CGFloat                     _lastScrollContentOffset;
@property (nonatomic ,assign)   BOOL                        _isScrollTop;
@property (nonatomic ,strong)   UITableView                 *tableViewActive;
@property (nonatomic ,weak)   id <ActivityViewDelegate>     activityViewDelegate;

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation;

//清理缓存数据
-(void)removeAllObjectsActivity;


@end
