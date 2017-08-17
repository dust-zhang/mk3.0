//
//  NotifiViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/1.
//
//

#import "HideTabBarViewController.h"
#import "SocietyTableView.h"


@interface NotifiViewController : HideTabBarViewController
{
    SocietyTableView*         _viewSociety;
    UIView*         _viewNoti;
    UILabel*        _labelSCount;
    UILabel*        _labelNCount;
    
    SystemNoticeModel*  _sModel;
}

@end
