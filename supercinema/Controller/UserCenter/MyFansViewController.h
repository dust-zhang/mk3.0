//
//  MyFansViewController.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <UIKit/UIKit.h>
#import "UserTableViewCell.h"
#import "OtherCenterViewController.h"


@interface MyFansViewController : HideTabBarViewController<attentionDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray      *_arrayFans;
    int                 _pageIndex;
    NSMutableDictionary *_dic;
    UITableView         *_tableViewMyfans;
    UIImageView         *_imageLoadFailed;
    UILabel             *_labelDescLoadFailed;
   
    
    //加载失败
    LoadFailedView      *_viewLoadFailed;
}
@property (nonatomic,strong) NSNumber * _fansCount;
@property (nonatomic,strong) NSString * _userId;
@end
