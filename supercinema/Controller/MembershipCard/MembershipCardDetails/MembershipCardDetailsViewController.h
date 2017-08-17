//
//  MembershipCardDetailsViewController.h
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
#import "BuyCardViewController.h"
#import "ServicesMember.h"
#import "LoginViewController.h"

//#import "BuyCardSuccessViewController.h"
//#import "PayFaildVIew.h"

@interface MembershipCardDetailsViewController : HideTabBarViewController <UIScrollViewDelegate>
{
    //整体的ScrollView
    UIScrollView    *_scrollViewContent;
    //整体的View背景
    UIView          *_viewWholeBG;
    
    //会员卡Logo
    UIImageView     *_imageCardIcon;
    //会员卡名称
    UILabel         *_labelCardName;
    
    //权益描述
    UILabel         *_labelCardDescribe;
    UILabel         *_labelLeftDescribe;    //卡描述后几行
    UILabel         *_labelPoints;          //省略号
    float           _fOriginallyHeight;     //原本卡的高度
    float           fCardDescribeHeight;    //当前卡的高度
    
    //展开收起按钮
    UIButton        *_btnUnfold;

    //分割线(实线)
    UILabel         *_labelEntityLine;
    
    //影院限制
    UILabel         *_labelCinemaLimit;
    
    //开通标识
    UIImageView     *_imageOpenType;
    
    //次数
    UILabel         *_labelCount;
    //有效期
    UILabel         *_labelDate;
    
    //整体开通按钮背景
    UIView          *_viewBuyCardButtonBG;
    UIButton        *_btnDredgeCard;
    //蒙层
    UIImageView     *_imageShadow;
    
    //活动描述
//    UILabel         *_labelActivity;
//    UILabel         *_labelActivityDescribe;
}


@property(nonatomic, strong)MemberModel         *_memberModel;
@property(nonatomic, strong)CardListModel       *_cardListModel;
@property(nonatomic, strong)MemberCinemaModel   *_cinema;
@property(nonatomic)        BOOL                _isAllPastDue;


@end



