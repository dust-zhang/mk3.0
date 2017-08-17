//
//  ShowTimeHeadCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/20.
//
//

#import "ShowTimeHeadCell.h"

@implementation ShowTimeHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(!self) return self;
    
    _viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _viewTop.backgroundColor = RGBA(248, 248, 252, 1);
    [self.contentView addSubview:_viewTop];
    
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 16)];
    [_labelCinemaName setTextColor:RGBA(51, 51, 51,1)];
    [_labelCinemaName setFont:MKFONT(16)];
    _labelCinemaName.numberOfLines = 0;
    _labelCinemaName.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_labelCinemaName];
    
    _labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0)];
    [_labelAddress setTextColor:RGBA(123, 122, 152,1)];
    [_labelAddress setFont:MKFONT(12)];
    _labelAddress.numberOfLines = 0;
    _labelAddress.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_labelAddress];
    
    _viewLine1 = [[UIView alloc]initWithFrame:CGRectZero];
    _viewLine1.backgroundColor = RGBA(0, 0, 0, 0.05);
    [self.contentView addSubview:_viewLine1];
    
    return self;
}

-(void)setData:(CinemaInfoModel*)cinema
{
    _labelCinemaName.text = cinema.cinemaName;
    [_labelCinemaName sizeToFit];
    
    _labelAddress.frame = CGRectMake(15, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+15, SCREEN_WIDTH-30, 0);
    _labelAddress.text = cinema.cinemaAddress;
    [_labelAddress sizeToFit];
    
    _viewLine1.frame = CGRectMake(15, _labelAddress.frame.origin.y+_labelAddress.frame.size.height+14, SCREEN_WIDTH-15, 0.5);
}

@end
