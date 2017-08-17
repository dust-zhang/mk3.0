//
//  SearchResultTableViewCell.m
//  movikr
//
//  Created by zeyuan on 15/6/16.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor] ];
        //影院名称
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH-130, 15)];
        [_titleLabel setTextColor:RGBA(51, 51, 51,1)];
        [_titleLabel setFont:MKFONT(14) ];
        [self.contentView addSubview:_titleLabel];
        
        _imageViewPiao = [[UIImageView alloc ] initWithFrame:CGRectZero];
        [_imageViewPiao setImage:[UIImage imageNamed:@"image_piao.png"]];
        [self.contentView addSubview:_imageViewPiao];
        [_imageViewPiao setHidden:YES];
        
        
        _imageViewGoods = [[UIImageView alloc ] initWithFrame:CGRectZero];
        [_imageViewGoods setImage:[UIImage imageNamed:@"image_shi.png"]];
        [self.contentView addSubview:_imageViewGoods];
        [_imageViewGoods setHidden:YES];
        
        _imageViewCard = [[UIImageView alloc ] initWithFrame:CGRectZero];
        [_imageViewCard setImage:[UIImage imageNamed:@"image_card.png"]];
        [self.contentView addSubview:_imageViewCard];
        [_imageViewCard setHidden:YES];

           //地址
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+10, _titleLabel.frame.size.width, 12)];
        [_addressLabel setTextColor:RGBA(123, 122, 152,1)];
        [_addressLabel setFont:MKFONT(12) ];
        [_addressLabel setBackgroundColor:[UIColor clearColor]];
        [_addressLabel setNumberOfLines:0];
        [_addressLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:_addressLabel];
        
        //距离
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-15, _addressLabel.frame.origin.y, 80, 12)];
        [_distanceLabel setTextAlignment:NSTextAlignmentRight];
        [_distanceLabel setTextColor:RGBA(123, 122, 152,1)];
        [_distanceLabel setFont:MKFONT(12) ];
        [self.contentView addSubview:_distanceLabel];
        
    }
    return self;
}

-(void)setSearchCinemaCellText:(CinemaModel*) model key:(NSString *)strKey
{
    if ([model.cinemaName length] > 15)
    {
        model.cinemaName = [model.cinemaName substringToIndex:15];
    }
    [_titleLabel setText:model.cinemaName];
    //设置关键字
    [_titleLabel setAttributedText:[Tool setKeyAttributed:model.cinemaName key:strKey fontSize:MKFONT(14)]];
    [_titleLabel sizeToFit];
    
    if([model.distance intValue] > 0)
    {
        float distan = [model.distance floatValue];
        if (distan >= 1000)
        {
            distan = distan/1000;
            [_distanceLabel setText:[[@"<" stringByAppendingString:[NSString stringWithFormat:@"%.2f",distan]] stringByAppendingString:@"km"]];
        }
        else
        {
            [_distanceLabel setText:[[@"<" stringByAppendingString:[model.distance stringValue]] stringByAppendingString:@"m"]];
        }
       
    }
    else
    {
        [_distanceLabel setText:@""];
    }
    
    [_addressLabel setText:model.address];
    //设置关键字
    [_addressLabel setAttributedText:[Tool setKeyAttributed:model.address key:strKey fontSize:MKFONT(12)]];
    
    CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
    _addressLabel.frame =  CGRectMake(15, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+10,SCREEN_WIDTH-100,size.height );

    _imageViewPiao.frame  = CGRectMake(_titleLabel.frame.size.width+_titleLabel.frame.origin.x+20 ,1, 15, 15);
    _imageViewGoods.frame = CGRectMake(_imageViewPiao.frame.size.width+_imageViewPiao.frame.origin.x+10, _imageViewPiao.frame.origin.y, 15, 15);
    _imageViewCard.frame = CGRectMake(_imageViewGoods.frame.size.width+_imageViewGoods.frame.origin.x+10, _imageViewGoods.frame.origin.y, 15, 15);
    
   
    //只显示票
    if ([model.canBuyTicket boolValue] && ![model.canBuyCard boolValue] && ![model.canBuyGoods boolValue])
    {
        [_imageViewPiao setHidden:NO];
    }
    //只显示卡
    if (![model.canBuyTicket boolValue] && [model.canBuyCard boolValue] && ![model.canBuyGoods boolValue])
    {
        [_imageViewCard setHidden:NO];
        _imageViewCard.frame =_imageViewPiao.frame;
    }
    //只显示小卖
    if (![model.canBuyTicket boolValue] && ![model.canBuyCard boolValue] && [model.canBuyGoods boolValue])
    {
        [_imageViewGoods setHidden:NO];
        _imageViewGoods.frame =_imageViewPiao.frame;

    }
    //显示票和小卖
    if ([model.canBuyTicket boolValue] && ![model.canBuyCard boolValue] && [model.canBuyGoods boolValue])
    {
        [_imageViewGoods setHidden:NO];
        [_imageViewPiao setHidden:NO];
    }
    //显示票和卡
    if ([model.canBuyTicket boolValue] && [model.canBuyCard boolValue] && ![model.canBuyGoods boolValue])
    {
        _imageViewCard.frame =_imageViewGoods.frame;
        [_imageViewCard setHidden:NO];
        [_imageViewPiao setHidden:NO];
    }
    //显示票和卡
    if (![model.canBuyTicket boolValue] && [model.canBuyCard boolValue] && [model.canBuyGoods boolValue])
    {
        _imageViewCard.frame =_imageViewGoods.frame;
        [_imageViewCard setHidden:NO];
      
        _imageViewGoods.frame =_imageViewPiao.frame;
        [_imageViewGoods setHidden:NO];
    }
    //全部显示
     if ([model.canBuyTicket boolValue] && [model.canBuyCard boolValue] && [model.canBuyGoods boolValue])
    {
        [_imageViewPiao setHidden:NO];
        [_imageViewGoods setHidden:NO];
        [_imageViewCard setHidden:NO];
    }

}


@end
