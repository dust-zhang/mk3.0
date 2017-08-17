//
//  SearchMovieViewController.h
//  supercinema
//
//  Created by dust on 16/11/9.
//
//

#import <UIKit/UIKit.h>
#import "MovieTableViewCell.h"
#import "ExUISearchBar.h"
#import "SearchHistoryTableViewCell.h"
#import "LoadFailedView.h"

@protocol SearchMovieDelegate<NSObject>
- (void)searchContent:(NSString*)text;
@end


@interface SearchMovieViewController : HideTabBarViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ExUISearchBarDelegate,clearHistoryDelegate,buyTicketDelegate>
{
    UITableView         *_tableviewMovie;
    NSMutableArray      *_arrMovie;
    ExUISearchBar       *_searchBar;
    NSString            *_strSearchContent;
    int                 _pageIndex;
    UIImageView         *_imageView;
    UILabel             *_labelDesc;
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,strong) NSString                   *_strSearchCondition;
@property (nonatomic,assign) id <SearchMovieDelegate>    _searchMovieDelegate;



@end
