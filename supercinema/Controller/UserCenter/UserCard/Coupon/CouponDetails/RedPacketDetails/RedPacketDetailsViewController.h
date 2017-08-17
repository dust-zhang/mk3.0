//
//  RedPacketDetailsViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/11/16.
//
//

#import <UIKit/UIKit.h>
#import "CheckAllCinemaView.h"


@interface RedPacketDetailsViewController : HideTabBarViewController <UIScrollViewDelegate,PopMessageViewDelegate>
{
    UIScrollView    *_scrollViewWhole;
    UIView          *_viewWhiteBg;
    
    //Logo
    UIImageView     *_imageLogo;
    //红包面值
    UILabel         *_labelRedPacketPrice;
    //红包名称
    UILabel         *_labelName;
    //红包可用数
    UILabel         *_labelLeft;
    //描述（自适应）
    UILabel         *_labelDescribe;
    //有效期
    UILabel         *_labelDate;
    //适用影院(自适应)
    UILabel         *_labelCinema;
    UILabel         *_labelCinemaName;
    //查看全部影院按钮
    UIButton        *_btnInquireCinema;
    UIImageView     *_imageCheckArrow;
    //适用影片
    UILabel         *_labelMovie;
    UILabel         *_labelMovieName;
    //分割线
    UIImageView     *_imageLine;
    //使用说明
    UILabel         *_labelInstructions;
    UILabel         *_labelInstructionsContent;
    //失效的蒙版
    UIView          *_viewMask;
    //往期中得使用标识Logo
    UIImageView     *_imageType;//1:已使用; 2:未使用; 3:已过期
    //通用标识
    UIImageView     *_imageGeneralType;
}

@property (nonatomic, strong)CheckAllCinemaView *_checkAllCinemaView;

@property (nonatomic, strong)RedPacketModel     *_redPacketModel;
@property(nonatomic)        int                     _myOrderType;          //有效往期标识


@end
