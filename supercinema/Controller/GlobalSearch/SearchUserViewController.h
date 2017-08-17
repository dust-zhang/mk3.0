//
//  UserSearchViewController.h
//  supercinema
//
//  Created by dust on 16/11/9.
//
//

#import <UIKit/UIKit.h>
#import "UserTableViewCell.h"
#import "ExUISearchBar.h"
#import "SearchHistoryTableViewCell.h"
#import "OtherCenterViewController.h"
#import "LoadFailedView.h"

@protocol SearchUserDelegate<NSObject>
- (void)searchContent:(NSString*)text;
@end


@interface SearchUserViewController : HideTabBarViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ExUISearchBarDelegate,clearHistoryDelegate>
{
    UITableView         *_tableviewUser;
    NSMutableArray      *_arrUser;
    ExUISearchBar       *_searchBar;
    NSString            *_strSearchContent;
    int                 _pageIndex;
    UIImageView         *_imageView;
    UILabel             *_labelDesc;
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,strong) NSString                   *_strSearchCondition;
@property (nonatomic,assign) id <SearchUserDelegate>     _searchUserDelegate;

@end
