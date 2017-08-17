//
//  CardOrderViewController.h
//  supercinema
//
//  Created by mapollo91 on 10/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
#import "CardOrderRightsTableViewCell.h"
#import "BuildOrderModel.h"
#import "PayViewController.h"
#import "BuyCardSuccessViewController.h"

/***用于测试**/
#import "BuyTicketSuccessViewController.h"
#import "SaleSuccessViewController.h"
#import "PayFaildVIew.h"
#import "AwardView.h"
/***用于测试**/

@interface CardOrderViewController : HideTabBarViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CardOrderRightsTableViewCellDelegate, ExAlertViewDelegate, reLoadMemberDelegate, UIScrollViewDelegate>
{
    //整体ScrollView
    UIScrollView    *_scrollViewWholeBG;
    //整体View背景
    UIView          *_viewWholeBG;
    
    //卡背景
//    UIImageView     *_imageCardLogo;    //卡Logo
    UILabel         *_labelCardName;    //卡名称
    UILabel         *_labelCardDescribe;//卡描述
    UILabel         *_labelDate;        //有效期
    UILabel         *_labelSubtotal;    //小计：金额
    
    //权益优惠
    UILabel         *_labelRightType;   //有无优惠 标识
    UIButton        *_btnRight;         //权益按钮
    
    //手机号
    UITextField     *_textFieldPhone;
    UILabel         *_labelPhonePrompt;
    UIButton        *_btnCancel;        

    //确认订单背景
    UIView          *_viewConfirmOrderBG;
    UILabel         *_labelActualMoney; //实付金额：金额
    UIButton        *_btnLookDetail;    //查看明细按钮
    UIImageView     *_imageArrowUp;     //上箭头图
    UIButton        *_btnConfirmOrder;  //确认订单按钮
    
    //查看明细
    CGFloat         heightLookDetail;
    UILabel         *_labelLine;                         //分割线
    UILabel         *_labelLookDetailInOrder;
    UILabel         *_labelLookDetailInOrderTotalPrice;  //订单总价
    UILabel         *_labelLookDetailDeduction;
    UILabel         *_labelLookDetailDeductionPrice;      //优惠券
    UILabel         *_labelTip;                           //支付提示
    UIView          *_footerAlpha;                        //底部梦层
    
    //实付按钮
    UIButton        *_btnRealPricePay;
    UILabel         *_labelBtnPricePay;
    
    UIImageView     *_imgShadow;                        //按钮上的投影
    
    UITableView         *_tabRight;
    RedPacketPriceVO    *priceDetail;                   //历史价格详情
    RedPacketPriceVO    *tempPriceDetail;               //当前价格详情
    NSMutableArray      *_arrRedPackIds;                //红包ID数组
    NSMutableArray      *arrCacheData;                  //历史VO缓存数据
    NSMutableArray      *tempArrCachePacket;            //当前VO缓存数据
    
    NSMutableArray      *_arrayPacketLimit;             //红包使用限制数组
    NSMutableArray      *_arrayUsedCardIndex;
    BOOL                isCanUseCardPack;               //是否可再用会员卡红包
    BOOL                isHaveUseNotLimitPack;          //是否用过不限制红包
    BOOL                isHaveUseOrderPack;             //是否用过订单红包
    
    NSArray             *_packetArr;
    NSMutableArray      *arrayPacket;
    
    
    NSMutableArray      *_arrayMemberCard;
    int                 _lockSeatTimeCount;
    
    float               _fWholeHeight;           //整体内容控件的高度
    
    float               defaultTotalPrice;
    
    float               _priceDikou;            //抵扣金额
    float               _priceZongji;           //总计价格
    float               _priceCardZongji;       //卡总计价格
    
    float               _confirmOrderBGHigh;    //查看明细背景View的高
    
    MemberCardDetailModel       *_memberDetailModel;

    PayFaildVIew *              _payFaildView;
    AwardView                   *awardView;
    
    
}

@property(nonatomic, strong)MemberCinemaModel       *_cinema;
@property(nonatomic, strong)CardListModel           *_cardListModel;
@property(nonatomic, strong)MemberCardDetailModel   *_memberCardDetailModel;
@property(nonatomic, assign)float                 smallSalePrice;
@property(nonatomic, strong)BuildOrderModel       *_orderModel;
@property(nonatomic,strong)NSString*  strTel;
@property(nonatomic, strong)NSArray         *arrGoodsList;    //选中的小卖集合
@property(nonatomic, strong)NSArray         *_arrGoods;       //选中的小卖集合
@property(nonatomic, strong)NSArray         *_arrayGoods;     //选中的小卖的id－count集合
@property(nonatomic, assign)int             smallSaleCount;   //小卖总份数
@property (nonatomic,strong)NSNumber        *cinemaCardId;
@end
