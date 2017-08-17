//
//  BuyCardViewController.h
//  supercinema
//
//  Created by mapollo91 on 8/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
#import "CardOrderViewController.h"
//#import "BuildOrderModel.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTFramesetter.h>

@interface BuyCardViewController : HideTabBarViewController <UIScrollViewDelegate>
{
    //整体的ScrollView
    UIScrollView         *_scrollViewBuyCard;
    
    //卡基本信息View
    UIImageView               *_viewBasicInformation;
    UIImageView               *_viewBasicInformationLine;
//    UIBezierPath         *maskPath;
//    CAShapeLayer         *maskLayer;
    
    //卡图标
    UIImageView          *_imageCardIcon;
    //卡名字
    UILabel              *_labelCardName;
    //卡描述（自适应）
    UILabel              *_labelCardDescribe;    //前两行卡描述
    UILabel              *_labelLeftDescribe;    //后几行卡描述
    UILabel              *_labelPoints;          //省略号
    float                _fOriginallyHeight;     //原本卡的高度
    float                fCardDescribeHeight;    //当前卡的高度
    float                _fBuyCardBGHeight;      //买卡背景的高
    
    //展开收起按钮
    UIButton        *_btnUnfold;
    
    //分割线(实线)
    UILabel          *_labelEntityLine;
    
    //影院限制
    UILabel              *_labelCinemaLimit;
    
    //整体买卡的背景
    UIView               *_viewBuyCardBG;
    //分割线（锯齿线）
    UIImageView          *_imageLine;
    
    //整体开通按钮背景
    UIView               *_viewBuyCardButtonBG;
    UIButton             *_btnBuyCard;
    //蒙层
    UIImageView          *_imageShadow;
    
    BOOL                _isHavePreferential;    //是否有优惠
    NSInteger           btnTag;
    
}

@property(nonatomic, strong)MemberCinemaModel   *_cinema;
@property(nonatomic, strong)CardListModel       *_cardListModel;    //卡列表
@property (nonatomic,strong)NSNumber *cinemaCardId;

@end
