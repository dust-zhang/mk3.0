//
//  TicketGoodsDetailViewController.h
//  supercinema
//
//  Created by dust on 16/11/24.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PWAlertView.h"
#import "ShareRedPacketView.h"

@interface TicketGoodsDetailViewController : HideTabBarViewController<UIScrollViewDelegate,UITextFieldDelegate,ShareRedPacketViewDelegate>
{
    UIScrollView    *_scrollView;
    
    UILabel         *_labelTicketsNumber;
    //票的状态
    UIView          *_viewTicketStatusBg;
    UILabel         *_labelTicketStatus;
    UILabel         *_labelGetTicketTip;
    
    //票
    UIImageView     *_imageViewTicket;
    UILabel         *_labelFilmName;
    UILabel         *_labelVer;
    UILabel         *_labelTime;
    UILabel         *_labelSeat;
    UILabel         *_labePrice;
    
    //    小卖
    UIButton        *_btnShareRedPaket;
    
    UIView          *_viewGoods;
    UIButton        *_btnGet;
    UILabel         *_labelTip;
    UILabel         *_labelGetDate;
    UIImageView     *_imageViewCutLine;
    UIImageView     *_imageViewCutLine1;
    UIImageView     *_imageViewGoods;
    UILabel         *_labelStatus;
    UILabel         *_labelGetTime;
    UILabel         *_labelGoodsName;
    UILabel         *_labelGoodsDesc;
    UILabel         *_labelGoodsPrice;
    UILabel         *_labelValidityDate;

    //会员卡
    UIImageView     *_imageViewCard;
    UILabel         *_labelCardName;
    UILabel         *_labelCardCinemaName;
    UILabel         *_labelCardValidityTime;
    UILabel         *_labelCardValidityDate;
    UILabel         *_labelCardSum;
    
    //合计金额
    UIView          *_viewSumBg;
    UILabel         *_labelSum;
    UILabel         *_labelSumMoeny;
    UILabel         *_labelOtherFavorable;
    UILabel         *_labelOtherFavorablemoney;
  
    //影院位置 客服电话
    UIView          *_viewCinemaAddrsssBg;
    UILabel         *_labelCinemaName;
    UILabel         *_labelCinemaAddress;
    UILabel         *_labelTel;
    UILabel         *_labelWorkTime;
    
    //分割线
    UIImageView     *_imageLine;
    
    UIWebView       *_phoneCallWebView;
    UITextField     *_textField;
    UILabel         *_textFieldCode[4];     //输入框
    
    OrderInfoModel  *_orderDetail;
    NSInteger       _nGoodsIndex;
    
    GoodsListCardPackModel *_goodsModel;
    ShareRedPacketView      *_shareRedPacketView;
    
}

@property(nonatomic, strong) MyOrderListModel       *_orderDetialModel;
@property(nonatomic,strong) NSMutableArray          *_arrayMap;


@end
