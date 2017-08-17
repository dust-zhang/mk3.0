//
//  OfflineCouponDetailsViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/11/16.
//
//

#import <UIKit/UIKit.h>
#import "CouponInfoModel.h"

#define editWidthHegiht     40
#define inputTextCount      5
#define posXOffline    (SCREEN_WIDTH-editWidthHegiht*4 - 30)/2

@interface OfflineCouponDetailsViewController : HideTabBarViewController <UIScrollViewDelegate, UITextFieldDelegate>
{
    UIScrollView    *_scrollViewWhole;
    UIView          *_viewWhiteBg;
    
    //Logo
    UIImageView     *_imageLogo;
    //往期中得使用标识Logo
    UIImageView     *_imageType;//1:已使用; 2:未使用; 3:已过期
    //分割线（虚线）
    UIImageView     *_imageLine;
    //优惠券名称
    UILabel         *_labelName;
    //描述（自适应）
    UILabel         *_labelDescribe;
    //有效期
    UILabel         *_labelDate;
    //影院名称
    UILabel         *_labelCinemaName;
    //影院地址
    UILabel         *_labelCinemaAddress;
    //分割线
    UIImageView     *_imageLine1;
    //客服电话
    UILabel         *_labelPhone;
    //失效的蒙版
    UIView          *_viewMask;
    
    //弹起的View
    UIView          *_contentSetView;
    UILabel             *_textFieldCode[4];     //输入框
    UILabel             *_labelTopLine;         //输入框的线（上部分）
    UILabel             *_labelDownLine;        //输入框的线（下部分）
    UITextField         *_textField;            //输入核销码
    NSMutableArray      *_arrayVerticalLine;    //画框存线的字典（竖线）
    
    UIImageView         *_imageSuccess;         //领取成功标识
    UILabel             *_labelPrompt;          //提示信息
    UIButton            *_btnReceive;           //领取按钮
    BOOL                _isReceiveSuccess;      //是否领取成功标识
    
    
}
@property(nonatomic, strong)GoodsListCardPackModel  *_modeGoodsListCardPack;
@property(nonatomic, strong)CouponInfoModel         *_couponInfoModel;
@property(nonatomic, strong)CommonListModel         *_commonListModel;
@property(nonatomic)        int                     _myOrderType;          //有效往期标识

@end
