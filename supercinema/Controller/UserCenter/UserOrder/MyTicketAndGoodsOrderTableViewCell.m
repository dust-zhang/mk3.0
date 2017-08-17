//
//  MyTicketAndGoodsOrderTableViewCell.m
//  supercinema
//
//  Created by dust on 16/11/29.
//
//

#import "MyTicketAndGoodsOrderTableViewCell.h"
#define posx        15

@implementation MyTicketAndGoodsOrderTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _isRefresh   =FALSE;
        [self setBackgroundColor:RGBA(246, 246, 251,1)];
        [self initController];
    }
    return self;
}

-(void) initController
{
    self._viewWhiteBg = [[UIView alloc ] initWithFrame:CGRectMake(posx, 10, SCREEN_WIDTH-30, 450/2)];
    [self._viewWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [self._viewWhiteBg.layer setBorderWidth:0.5];
    [self._viewWhiteBg.layer setBorderColor:RGBA(0, 0, 0,0.05).CGColor];
    [self._viewWhiteBg.layer setMasksToBounds:YES ];
    [self._viewWhiteBg.layer setCornerRadius:2];
    [self.contentView addSubview:self._viewWhiteBg];
    
    self._labelCinemaName = [[UILabel alloc ] initWithFrame:CGRectMake(posx, 0, 200, 42)];
    [self._labelCinemaName setFont:MKFONT(12)];
    [self._labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [self._labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    [self._viewWhiteBg addSubview:self._labelCinemaName];
    
    self._labelPayStatus= [[UILabel alloc ] initWithFrame:CGRectMake(posx, 0, SCREEN_WIDTH-60, 42)];
    [self._labelPayStatus setFont:MKFONT(14)];
    [self._labelPayStatus setTextAlignment:NSTextAlignmentRight];
    [self._labelPayStatus setBackgroundColor:[UIColor clearColor]];
    [self._labelPayStatus setTextColor:[UIColor blackColor]];
    [self._viewWhiteBg addSubview:self._labelPayStatus];
    
    self._labelCutLine1 = [[UIImageView alloc ] initWithFrame:CGRectMake(posx, self._labelCinemaName.frame.origin.y+self._labelCinemaName.frame.size.height-1, SCREEN_WIDTH-60, 0.5)];
    [self._labelCutLine1 setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [self._viewWhiteBg addSubview:self._labelCutLine1];
    
    //票
    self._labelTicketsName = [[UILabel alloc ] initWithFrame:CGRectMake(posx, self._labelCutLine1.frame.origin.y+self._labelCutLine1.frame.size.height+15, SCREEN_WIDTH-60, 15)];
    [self._labelTicketsName setFont:MKBOLDFONT(15)];
    [self._labelTicketsName setBackgroundColor:[UIColor clearColor]];
    [self._labelTicketsName setTextColor:RGBA(51, 51, 51, 1)];
    [self._viewWhiteBg addSubview:self._labelTicketsName];

    self._labelTicketsDetail= [[UILabel alloc ] initWithFrame:CGRectMake(posx, self._labelTicketsName.frame.origin.y+self._labelTicketsName.frame.size.height+10, SCREEN_WIDTH-60, 15)];
    [self._labelTicketsDetail setFont:MKFONT(12)];
    [self._labelTicketsDetail setBackgroundColor:[UIColor clearColor]];
    [self._labelTicketsDetail setTextColor:RGBA(51, 51, 51, 1)];
    [self._viewWhiteBg addSubview:self._labelTicketsDetail];
    
    //小卖
    self._labelGoodsName = [[UILabel alloc ] initWithFrame:CGRectMake(posx, self._labelTicketsDetail.frame.origin.y+self._labelTicketsDetail.frame.size.height+15, SCREEN_WIDTH-60, 15)];
    [self._labelGoodsName setFont:MKBOLDFONT(15)];
    [self._labelGoodsName setBackgroundColor:[UIColor clearColor]];
    [self._labelGoodsName setTextColor:RGBA(51, 51, 51, 1)];
    [self._viewWhiteBg addSubview:self._labelGoodsName];
    
    self._labelSum = [[UILabel alloc ] initWithFrame:CGRectMake(posx, self._labelGoodsName.frame.origin.y+self._labelGoodsName.frame.size.height+15, SCREEN_WIDTH-60, 11)];
    [self._labelSum setFont:MKFONT(12)];
    [self._labelSum setBackgroundColor:[UIColor clearColor]];
    [self._labelSum setTextColor:RGBA(51, 51, 51, 1)];
    [self._viewWhiteBg addSubview:self._labelSum];
    
    self._labelCutLine2 = [[UIImageView alloc ] initWithFrame:CGRectMake(posx, self._labelSum.frame.origin.y+self._labelSum.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
    [self._labelCutLine2 setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [self._viewWhiteBg addSubview:self._labelCutLine2];
    
    self._labelOrderNo = [[UILabel alloc ] initWithFrame:CGRectMake(posx, self._labelCutLine2.frame.origin.y+self._labelCutLine2.frame.size.height, SCREEN_WIDTH-60, 60)];
    [self._labelOrderNo setFont:MKFONT(11)];
    [self._labelOrderNo setTextColor:RGBA(123,122, 152, 1)];
    [self._labelOrderNo setNumberOfLines:0];
    [self._labelOrderNo setLineBreakMode:NSLineBreakByWordWrapping];
    [self._viewWhiteBg addSubview:self._labelOrderNo];
    
    self._btnDelete = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-45 -(42/2), self._labelCutLine2.frame.origin.y-15-(42/2), 42/2, 43/2)];
    [self._btnDelete addTarget:self action:@selector(onButtonDeleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self._btnDelete.titleLabel setFont:MKBOLDFONT(12) ];
    [self._btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self._viewWhiteBg addSubview:self._btnDelete ];
}

-(void) setOrderCellText:(MyOrderListModel*)model index:(NSInteger)cellIndex time:(NSNumber *)currentTime
{
    [self._labelCinemaName  setText:model.cinema.cinemaName];

    //票名称
    [self._labelTicketsName setText:model.ticketOrder.movieTitle];
    [self._labelTicketsDetail setText:[NSString stringWithFormat:@"%@ 电影票(%@张)",
                                    [Tool returnTime:model.ticketOrder.startPlayTime format:@"yyyy年MM月dd日 HH:mm"],
                                    model.ticketOrder.ticketCount
                                    ] ];
    //组合小卖信息
    NSString *str=@"" ;
    for (int i=0; i < [model.goodsOrderList count]; i++)
    {
        MyGoodsOrderListModel *goodsModel = model.goodsOrderList[i];
        
        str = [NSString stringWithFormat:@"%@%@(%@份)",str,goodsModel.goodsName,goodsModel.goodsCount];
        
        if (i < [model.goodsOrderList count]-1)
        {
            str = [NSString stringWithFormat:@"%@ \n",str];
        }
    }
    CGSize size = [Tool CalcString:str fontSize:MKBOLDFONT(15) andWidth:SCREEN_WIDTH-60];
    self._viewWhiteBg.frame = CGRectMake(posx, 10, SCREEN_WIDTH-30, 3+426/2+ size.height+([model.goodsOrderList count] -1)*15);
    //小卖名称
    [self._labelGoodsName  setText:str];
 
    //小卖名称
    [self._labelGoodsName  setText:str];
    [self._labelGoodsName setNumberOfLines:0];
    [self._labelGoodsName setLineBreakMode:NSLineBreakByWordWrapping];
    
    self._labelGoodsName.frame =CGRectMake(posx, self._labelTicketsDetail.frame.origin.y+self._labelTicketsDetail.frame.size.height+15, SCREEN_WIDTH-60, size.height);
    if ([model.goodsOrderList count] >1)
    {
        [Tool setLabelSpacing:self._labelGoodsName spacing:10 alignment:NSTextAlignmentLeft];
    }

    NSUInteger joinCount =[[Tool PreserveTowDecimals:model.totalPrice] length];
    NSRange oneRange =NSMakeRange(0,5);
    NSRange twoRange =NSMakeRange(5,joinCount+1 );
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额：￥%@",[Tool PreserveTowDecimals:model.totalPrice]]];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:twoRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(17) range:twoRange];
    self._labelSum .attributedText = strAtt;
    
    [self._labelOrderNo  setText:[NSString stringWithFormat:@"订单编号：%@\n创建时间：%@",
                                  model.orderId,
                                  [Tool returnTime:model.createTime format:@"yyyy年MM月dd日 HH:mm:ss"] ] ];
    [Tool setLabelSpacing:self._labelOrderNo spacing:10 alignment:NSTextAlignmentLeft];

     [self layout];
    
    if ([model.orderShowStatus intValue] == 3 )
    {
        [self._labelPayStatus setTextColor:RGBA(249, 81, 81, 1)];
    }
    else
    {
        [self._labelPayStatus setTextColor:[UIColor blackColor] ];
    }
    if ([model.orderShowStatus intValue] == 1 )
    {
        //显示倒计时
        //显示倒计时
        if ([Tool calcSysTimeLength:model.payEndTime SysTime:currentTime] <=0)
        {
            [self._labelPayStatus  setText:[Tool returnPayRefundStatus:model.orderShowStatus] ];
        }
        else
        {
            [self setCountdown:[Tool calcSysTimeLength:model.payEndTime SysTime:currentTime] ];
        }
        //可以继续支付则显示支付按钮
        if([Tool calcSysTimeLength:model.payEndTime SysTime:currentTime] > 0)
        {
            [self._btnDelete setTitle:@"支付" forState:UIControlStateNormal];
            self._btnDelete.frame = CGRectMake(SCREEN_WIDTH-105, self._labelSum.frame.origin.y-12, 60, 24);
            [self._btnDelete.layer setCornerRadius:12];
            [self._btnDelete.layer setMasksToBounds:YES];
            [self._btnDelete setBackgroundColor:RGBA(117, 112, 255, 1) ];
            [self._btnDelete setHidden:NO];
            self._btnDelete.tag = cellIndex;
        }
    }
    else if(([model.orderShowStatus intValue] == 3) ||
            ([model.orderShowStatus intValue] == 6))
    {
        [self._btnDelete setHidden:YES];
        [self._labelPayStatus  setText:[Tool returnPayRefundStatus:model.orderShowStatus] ];
    }
    //可以删除
    else if( ([model.canDelete boolValue] && ([model.orderShowStatus intValue] == 5) ) || ( [model.canDelete boolValue] && ([model.orderShowStatus intValue] == 4)) )
    {
        [self._labelPayStatus  setText:[Tool returnPayRefundStatus:model.orderShowStatus] ];
        self._btnDelete.frame =  CGRectMake(SCREEN_WIDTH-45 -(42/2), self._labelCutLine2.frame.origin.y-15-(42/2), 42/2, 43/2);
        [self._btnDelete setImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
        [self._btnDelete setHidden:NO];
        self._btnDelete.tag = cellIndex;
    }
    //5 已完成
    else if ( [model.orderShowStatus intValue] == 2 )
    {
        [self._labelPayStatus  setText:[Tool returnPayRefundStatus:model.orderShowStatus] ];
        [self._btnDelete setTitle:@"领取" forState:UIControlStateNormal];
        self._btnDelete.frame = CGRectMake(SCREEN_WIDTH-105, self._labelSum.frame.origin.y-12, 60, 24);
        [self._btnDelete.layer setCornerRadius:12];
        [self._btnDelete.layer setMasksToBounds:YES];
        [self._btnDelete setBackgroundColor:[UIColor blackColor] ];
        [self._btnDelete setHidden:NO];
        self._btnDelete.tag = cellIndex;
    }

}

-(void)layout
{
    self._labelSum.frame = CGRectMake(posx, self._labelGoodsName.frame.origin.y+self._labelGoodsName.frame.size.height+15, SCREEN_WIDTH-60, 11);
    self._labelCutLine2.frame = CGRectMake (posx, self._labelSum.frame.origin.y+self._labelSum.frame.size.height+15, SCREEN_WIDTH-60, 0.5);
    self._labelOrderNo.frame = CGRectMake(posx, self._labelCutLine2.frame.origin.y+self._labelCutLine2.frame.size.height, SCREEN_WIDTH-60, 62.5);
}

-(void)onButtonDeleteOrder:(UIButton *)btn
{
    if ([self._deleteTicketAndGoodsDelegate respondsToSelector:@selector(onButtonDeleteOrder:)])
    {
        [self._deleteTicketAndGoodsDelegate onButtonDeleteOrder:btn ];
    }
}

-(void) refreshUnPayOrder
{
    if ([self._deleteTicketAndGoodsDelegate respondsToSelector:@selector(refreshUnPayOrder)])
    {
        [self._deleteTicketAndGoodsDelegate refreshUnPayOrder ];
    }
}


#pragma mark 倒计时
-(void)setCountdown:(NSInteger) time
{
    _serviceTime = time;
    self._labelPayStatus.text = [Tool convertTime:time];
    
    if (time >0)
    {
        [self._labelPayStatus setTextColor:[UIColor redColor]];
        [self killTimer];
        _serviceTime = time;
        _countTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)timeAction:(NSTimer *)timer
{
    if (_serviceTime <= 0 )
    {
        self._labelPayStatus.text = @"支付超时";
        [self killTimer];
        
        if (!_isRefresh)
        {
            _isRefresh = TRUE;
//            [self refreshUnPayOrder];
        }
        return;
    }
    self._labelPayStatus.text = [Tool convertTime: _serviceTime--];
}
-(void) killTimer
{
    if(_countTimer)
    {
        [_countTimer invalidate];
        _countTimer = nil;
    }
}


@end
