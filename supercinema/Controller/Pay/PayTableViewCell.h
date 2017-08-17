//
//  PayTableViewCell.h
//  movikr
//
//  Created by Mapollo27 on 15/7/31.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"


@interface PayTableViewCell : UITableViewCell

@property (nonatomic ,strong)       UILabel         *_labelLine;
@property (nonatomic ,strong)       UIImageView     *_imageViewPayType;
@property (nonatomic ,strong)       UILabel         *_labelPayType;
//银联支付图标
@property (nonatomic ,strong)       UIImageView     *_imageViewUnionPay;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

-(void) setCellData:(PayTypeModel *)model;

@end
