//
//  MyCardViewController.h
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MyCardTableViewCell.h"
#import "MemberBenefitsInfoViewController.h"
#import "CouponInfoViewController.h"
#import "CouponInfoModel.h"

@interface MyCardViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource>
{
    //整体Tab
    UITableView     *_tabMyCardList;
    
    CardAndCouponCountModel *_cardAndCouponCountModel;
}


@end
