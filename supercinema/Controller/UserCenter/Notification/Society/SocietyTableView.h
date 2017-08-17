//
//  SocietyTableView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/1.
//
//

#import <UIKit/UIKit.h>
#import "CommentElseViewController.h"
#import "SocietyTableViewCell.h"
#import "DynamicDetailViewController.h"

typedef enum {
    SocietyTypeFocus = 0,
    SocietyTypePraise = 1,
    SocietyTypeRespond = 2
} SocietyType;

@interface SocietyTableView : UIView<UITableViewDelegate,UITableViewDataSource,SocietyTableViewCellDelegate>
{
    UITableView* _myTable;
    UINavigationController* _nav;
    
    NSMutableArray*    _arrData;
    
    NSNumber* _pageIndex;
    SystemNoticeModel*  _sModel;
}
@property(nonatomic,assign)BOOL isFirst;
//加载失败
@property(nonatomic,strong)LoadFailedView    *viewLoadFailed;
-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController*)nav;
-(void)setPointsHidden;
-(void)loadData;
@end
