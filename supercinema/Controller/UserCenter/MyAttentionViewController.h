//
//  MyAttentionViewController.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <UIKit/UIKit.h>
#import "UserTableViewCell.h"
#import "OtherCenterViewController.h"
#import "LoadFailedView.h"

@interface MyAttentionViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource,attentionDelegate,UIAlertViewDelegate>
{
    NSMutableArray      *_arrayAttentionUser;
    int                 _pageIndex;
    UITableView         *_tableViewAttention;
    NSMutableDictionary *_dic;
    UIImageView         *_imageLoadFailed;
    UILabel             *_labelDescLoadFailed;
    
    //加载失败
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,strong) NSNumber *_attentionCount;
@property (nonatomic,strong) NSString *_userId;
@end
