//
//  AwardView.h
//  supercinema
//
//  Created by dust on 16/11/17.
//
//

#import <UIKit/UIKit.h>
#import "ActivityAwardModel.h"
#import "AwardDetailView.h"
#import "ThirdShareFactory.h"

@interface AwardView : UIView <UIGestureRecognizerDelegate>
{
    AwardDetailView *awardDetailView[50];
    
    NSArray *_arrActivityGrantList;
    
    activityGrantListModel  *_modelActivityGrantList;
    
    //分享到...
    UIView          *_viewShareToBG;          //分享到背景
    UIImageView     *_imageShadow;            //渐变蒙层
    
    BOOL            _isClickBlank;            //是否点击过空白
    float           _fViewShareToBGHeight;    //分享背景高度
    NSNumber        *_shareRedpackFee;        //分享红包金额
}

@property (nonatomic, strong)NSNumber          *_orderId;


-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arrModel shareRedpackFee:(NSNumber *)shareRedpackFee;

@end
