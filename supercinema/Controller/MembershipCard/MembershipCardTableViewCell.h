//
//  MembershipCardTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
#import "MembershipCardDetailsViewController.h"


@protocol MembershipCardTableViewCellDelegate <NSObject>
-(void)cardTableViewCellSkip:(UIButton*)btn index:(NSInteger)row;
@end

@interface MembershipCardTableViewCell : UITableViewCell
{
    //背景View
    UIView          *_viewMembershipCardCellBG;
    
    //图标
    UIImageView     *_imageMembershipCardIcon;

    //名称
    UILabel         *_labelMembershipCardName;
    
    //描述
    UILabel         *_labelMembershipCardDescribe;
    
    //有效期
    UILabel         *_labelExpiryDate;
    
    //状态按钮
    UIButton        *_btnMembershipCardType;
    
    //cell的indexPath.row
    NSInteger       _index;
    
    CardListModel   *_cardListModel;
}

@property (nonatomic, weak) id<MembershipCardTableViewCellDelegate> cardListGotoDelegate;

//初始化（自定义）
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//tableView调用的方法
-(void)setMembershipCardTrendsTableCellData:(CardListModel*)cardListModel index:(NSInteger)indexPath memberModel:(MemberModel*)memberModel;

@end
