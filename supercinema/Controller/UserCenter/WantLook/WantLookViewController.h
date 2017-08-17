//
//  WantLookViewController.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <UIKit/UIKit.h>
#import "WantLookTableViewCell.h"

@interface WantLookViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *_arrWangLook;
    UITableView         *_tableViewMyWantLook;
    
    UIImageView         *_imageLoadFailed;
    UILabel             *_labelDescLoadFailed;
    NSNumber            *_systemTime;
    
    int                 _pageIndex;//分页显示的页码
    
    //加载失败
    LoadFailedView      *_viewLoadFailed;
}

//@property (nonatomic,strong) NSNumber * _wangLookCount;
@property (nonatomic,strong) NSString * _userId;

@end
