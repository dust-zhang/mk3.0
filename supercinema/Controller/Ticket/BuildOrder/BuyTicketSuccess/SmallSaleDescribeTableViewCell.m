//
//  SmallSaleDescribeTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import "SmallSaleDescribeTableViewCell.h"

@implementation SmallSaleDescribeTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self._strGoodsOrderId = @"";
        _goodsListCardPackModel = [[GoodsListCardPackModel alloc] init];
        
        //背景
        _viewInformationBG = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 118)];
        [_viewInformationBG setBackgroundColor:RGBA(255, 255, 255, 1)];
        _viewInformationBG.layer.borderWidth = 0.5;//边框宽度
        _viewInformationBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
        _viewInformationBG.layer.cornerRadius = 2.f;//圆角
        [self.contentView addSubview:_viewInformationBG];
        
        _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLogo setBackgroundColor:[UIColor clearColor]];
        [_viewInformationBG addSubview:_imageLogo];
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelName setBackgroundColor:[UIColor clearColor]];
        [_labelName setFont:MKBOLDFONT(15)];
        [_labelName setTextColor:RGBA(51, 51, 51, 1)];
        [_labelName setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelName];
        
        //描述
        _labelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
        [_labelDetail setFont:MKFONT(12)];
        [_labelDetail setTextColor:RGBA(102, 102, 102, 1)];
        [_labelDetail setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelDetail];
        
        //数量
        _labelCount =[[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCount setBackgroundColor:[UIColor clearColor]];
        [_labelCount setFont:MKFONT(12)];
        [_labelCount setTextColor:RGBA(51, 51, 51, 1)];
        [_labelCount setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelCount];
        
        //分割线
        _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLine setBackgroundColor:[UIColor clearColor]];
        [_viewInformationBG addSubview:_imageLine];
        
        //领取按钮
        _btnReceive = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnReceive setBackgroundColor:RGBA(0, 0, 0, 1)];
        [_btnReceive setTitle:@"立即领取" forState:UIControlStateNormal];
        [_btnReceive setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
        [_btnReceive.titleLabel setFont:MKFONT(15)];//按钮字体大小
        [_btnReceive.layer setCornerRadius:20.f];//按钮设置圆角
        [_btnReceive addTarget:self action:@selector(onButtonReceiveSmallSale:) forControlEvents:UIControlEventTouchUpInside];
        [_viewInformationBG addSubview:_btnReceive];
        
        //提示
        _labelPrompt = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPrompt setBackgroundColor:[UIColor clearColor]];
        [_labelPrompt setFont:MKFONT(11)];
        [_labelPrompt setTextColor:RGBA(123, 122, 152, 1)];
        [_labelPrompt setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelPrompt];
        
        //退款状态
        _labelReimburseType = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelReimburseType setBackgroundColor:[UIColor clearColor]];
        [_labelReimburseType setFont:MKFONT(15)];
        [_labelReimburseType setTextColor:RGBA(51, 51, 51, 1)];
        [_labelReimburseType setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelReimburseType];
        
        //客服时间
        _labelServicePhone = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelServicePhone setBackgroundColor:[UIColor clearColor]];
        [_labelServicePhone setFont:MKFONT(11)];
        [_labelServicePhone setTextColor:RGBA(123, 122, 152, 1)];
        [_labelServicePhone setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelServicePhone];
        
        //分割线
        _imageLine1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLine1 setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
        [_imageLine1 setBackgroundColor:[UIColor clearColor]];
        [_viewInformationBG addSubview:_imageLine1];
        
        //有效期
        _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDate setBackgroundColor:[UIColor clearColor]];
        [_labelDate setFont:MKFONT(10)];
        [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDate setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelDate];
    }
    return self;
}

-(void)setIndex:(NSInteger)index
{
    if (_btnReceive != nil)
    {
        _btnReceive.tag = index;
    }
}

#pragma mark - 小卖Cell
-(void)setSmallSaleDescribeCellFrameData:(GoodsListCardPackModel *)model orderWhileModel:(OrderWhileModel *)orderWhileModel
{
    NSLog(@"%@",[model toJSONString]);
    NSLog(@"%@",model.goodsOrderId);
   
    
    self._strGoodsOrderId = model.goodsOrderId;
    _goodsListCardPackModel = model;
    
    //判断状态
    if ([orderWhileModel.orderStatus intValue ] == 30)
    {
        //领取按钮
        _btnReceive.frame = CGRectMake(15, 15, SCREEN_WIDTH-15*4, 40);
        //提示
        _labelPrompt.frame = CGRectMake(0, _btnReceive.frame.origin.y+_btnReceive.frame.size.height+10, SCREEN_WIDTH-15*2, 11);
        
        //30出票成功；显示：订单号 验证码
        //判断是否领取过
        if ([model.exchangeTime intValue] >0)
        {
            //领取时间大于0
            [_btnReceive setBackgroundColor:[UIColor clearColor]];
            [_btnReceive setTitle:@"已领取" forState:UIControlStateNormal];
            [_btnReceive setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
            
            [_labelPrompt setText:[NSString stringWithFormat:@"%@",[Tool returnTime:model.exchangeTime format:@"yyyy年MM月dd日 HH:mm"]]];
        }
        else
        {
            if ([model.useStatus intValue] == 1)
            {
                //已经兑换
                [_btnReceive setBackgroundColor:[UIColor clearColor]];
                [_btnReceive setTitle:@"已领取" forState:UIControlStateNormal];
                [_btnReceive setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色

            }
            else if ([model.useStatus intValue] == 0)
            {
                //未兑换
                _btnReceive.frame = CGRectMake(15, 15, SCREEN_WIDTH-15*4, 40);
                [_btnReceive setBackgroundColor:RGBA(0, 0, 0, 1)];
                [_btnReceive setTitle:@"立即领取" forState:UIControlStateNormal];
                [_btnReceive setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色

                [_labelPrompt setText:@"到影院卖品柜台请工作人员输入4位核销码"];
            }
            else
            {
                //已经过期
                [_btnReceive setBackgroundColor:[UIColor clearColor]];
                [_btnReceive setTitle:@"已过期" forState:UIControlStateNormal];
                [_btnReceive setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
            }
            
//            if (isReceiveSuccess == YES)
//            {
//                //当时领取
//                [_btnReceive setBackgroundColor:[UIColor clearColor]];
//                [_btnReceive setTitle:@"已领取" forState:UIControlStateNormal];
//                [_btnReceive setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
//            }
//            else
//            {
//                //未领取
//                _btnReceive.frame = CGRectMake(15, 15, SCREEN_WIDTH-15*4, 40);
//                [_btnReceive setBackgroundColor:RGBA(0, 0, 0, 1)];
//                [_btnReceive setTitle:@"立即领取" forState:UIControlStateNormal];
//                [_btnReceive setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
//                
//                [_labelPrompt setText:@"到影院卖品柜台请工作人员输入4位核销码"];
//            }
        }
        
        _imageLine.frame = CGRectMake(15, _labelPrompt.frame.origin.y+_labelPrompt.frame.size.height+15, SCREEN_WIDTH-15*4, 0.5);
    }
    else if ([orderWhileModel.orderStatus intValue ] == 20  ||
             [orderWhileModel.orderStatus intValue ] == 40  ||
             [orderWhileModel.orderStatus intValue ] == 100 ||
             [orderWhileModel.orderStatus intValue ] == 110 )
    {
        //20出票失败；显示：正在退款
        _labelReimburseType.frame = CGRectMake((_viewInformationBG.frame.size.width-140)/2, 15, 140, 15);
        _labelReimburseType.text = @"正在退款";
        
        _labelServicePhone.frame = CGRectMake(0, _labelReimburseType.frame.origin.y+_labelReimburseType.frame.size.height+10, _viewInformationBG.frame.size.width, 11);
        _labelServicePhone.text = [NSString stringWithFormat:@"客服工作时间 %@",[Config getConfigInfo:@"movikrPhoneNumberDesc"]];
        
        _imageLine.frame = CGRectMake(0, _labelServicePhone.frame.origin.y+_labelServicePhone.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
        
    }
    else
    {
        //默认显示 正在出票
        _labelReimburseType.frame = CGRectMake((_viewInformationBG.frame.size.width-140)/2, 15, 140, 15);
        _labelReimburseType.text = @"正在出票";
        
        _labelServicePhone.frame = CGRectMake(0, _labelReimburseType.frame.origin.y+_labelReimburseType.frame.size.height+10, _viewInformationBG.frame.size.width, 11);
        _labelServicePhone.text = @"出票结果，请稍后查看";
        
        _imageLine.frame = CGRectMake(0, _labelServicePhone.frame.origin.y+_labelServicePhone.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
    }
    
    [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    
    //小卖Logo
    _imageLogo.frame = CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+15, 135/2, 135/2);
    //判断图片是不是下载过，如果缓存中有，那么就不下载，直接用缓存的
    [Tool downloadImage:model.goodsLogoUrl button:nil imageView:_imageLogo defaultImage:@"image_saleList_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:model.goodsLogoUrl] placeholderImage:[UIImage imageNamed:@"img_sale_default.png"]];
    
    //小卖名称
    _labelName.numberOfLines = 0;
    _labelName.lineBreakMode = NSLineBreakByCharWrapping;
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, _viewInformationBG.frame.size.width-15-_imageLogo.frame.size.width-15-15, 15);
    _labelName.text = model.goodsName;
    [_labelName sizeToFit];
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, _viewInformationBG.frame.size.width-15-_imageLogo.frame.size.width-15-15, _labelName.frame.size.height);
    
    //描述
    _labelDetail.numberOfLines = 0;
    _labelDetail.lineBreakMode = NSLineBreakByCharWrapping;
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, _viewInformationBG.frame.size.width-15-_imageLogo.frame.size.width-15-15, 12);
    _labelDetail.text = model.goodsDesc;
    [_labelDetail sizeToFit];
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, _viewInformationBG.frame.size.width-15-_imageLogo.frame.size.width-15-15, _labelDetail.frame.size.height);
    
    //数量
    _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, 110, 12);
    _labelCount.text = [NSString stringWithFormat:@"￥%@（%@%@）",[Tool PreserveTowDecimals:model.totalPrice],model.sellCount,model.unit];
    
    _imageLine1.frame = CGRectMake(15, _labelCount.frame.origin.y+_labelCount.frame.size.height+10, SCREEN_WIDTH-15*4, 0.5);
    
    //有效期
    _labelDate.frame = CGRectMake(15, _imageLine1.frame.origin.y+_imageLine1.frame.size.height+10, SCREEN_WIDTH-15*4, 10);
    [_labelDate setText:[NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:model.validEndTime format:@"yyyy年MM月dd日"]]];
    
    //背景
    _viewInformationBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelDate.frame.origin.y+_labelDate.frame.size.height+10);
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,_labelDate.frame.origin.y+_labelDate.frame.size.height+10+12);
}

#pragma mark - 领取小卖
-(void)onButtonReceiveSmallSale:(UIButton *)sender
{
    NSLog(@"领取小卖");
    if ([self.smallSaleCellDelegate respondsToSelector:@selector(onButtonReceiveSmallSale:exchangeType:Index:)])
    {
        [self.smallSaleCellDelegate onButtonReceiveSmallSale:self._strGoodsOrderId exchangeType:_goodsListCardPackModel.exchangeType Index:sender.tag];
    }
}





@end
