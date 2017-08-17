//
//  ExchangeVoucherDetailsViewController.h
//  supercinema
//
//  Created by mapollo91 on 28/11/16.
//
//

#import <UIKit/UIKit.h>

@interface ExchangeVoucherDetailsViewController : HideTabBarViewController <UIScrollViewDelegate>
{
    UIScrollView *_scrollViewWhole;
    UIView       *_viewWhiteBg;
    
    //Logo
    UIImageView     *_imageLogo;
    //往期中得使用标识Logo
    UIImageView     *_imageType;//1:已使用; 2:未使用; 3:已过期
    //通票名称
    UILabel         *_labelName;
    //余额
    UILabel         *_labelRemainder;
    //描述（自适应）
    UILabel         *_labelDescribe;
    //有效期
    UILabel         *_labelDate;

    //适用影片
    UILabel         *_labelMovie;
    UILabel         *_labelMovieName;
    //分割线
    UIImageView     *_imageLine;
    //使用说明
    UILabel         *_labelInstructions;
    UILabel         *_labelInstructionsContent;
    //客服电话
    UILabel         *_labelPhone;
    //失效的蒙版
    UIView          *_viewMask;
    
}
@property (nonatomic, strong)TongPiaoInfoModel *_tongPiaoInfoModel;
@property(nonatomic)        int                     _myOrderType;          //有效往期标识

@end
