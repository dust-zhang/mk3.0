//
//  AwardDetailView.m
//  supercinema
//
//  Created by mapollo91 on 22/11/16.
//
//

#import "AwardDetailView.h"

@implementation AwardDetailView
-(instancetype)initWithFrame:(CGRect)frame orderModel:(activityGrantListModel *)model hiddenLine:(BOOL)hiddenLine
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _modelActivityGrantList = model;
        _arrGrantList = model.grantList;
        [self initCtrl:hiddenLine];
    }
    return self;
}

-(void)initCtrl:(BOOL)hiddenLine
{
    UILabel* _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.frame.size.width-30, 15)];
    [_labelTitle setTextColor:RGBA(0, 0, 0,1)];
    [_labelTitle setFont:MKFONT(15) ];
    [_labelTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTitle setText:_modelActivityGrantList.activity.activityTitle];
    [self addSubview:_labelTitle];
    
    for (int j = 0; j<_arrGrantList.count; j++)
    {
        grantListModel *modelGrantList = _arrGrantList[j];
        
        //奖励个数
        UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-15-70, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+15+22*j, 70, 12)];
        [labelCount setTextColor:RGBA(122, 123, 152,1)];
        [labelCount setFont:MKFONT(12) ];
        [labelCount setBackgroundColor:[UIColor clearColor]];
        [labelCount setTextAlignment:NSTextAlignmentRight];
        [labelCount setText:[NSString stringWithFormat:@"x%@",modelGrantList.grantCount]];
        [labelCount sizeToFit];
        [self addSubview:labelCount];
        labelCount.frame = CGRectMake(self.frame.size.width-15-labelCount.frame.size.width, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+15+22*j, labelCount.frame.size.width, 12);
        
        //奖励详情描述
        UILabel *labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(15, labelCount.frame.origin.y, self.frame.size.width-15*2-labelCount.frame.size.width, 12)];
        [labelDetail setTextColor:RGBA(122, 123, 152,1)];
        [labelDetail setFont:MKFONT(12) ];
        [labelDetail setBackgroundColor:[UIColor clearColor]];
        [labelDetail setTextAlignment:NSTextAlignmentLeft];
        [labelDetail setText:modelGrantList.name];
        [self addSubview:labelDetail];
        
        if (j == _arrGrantList.count-1)
        {
            UIImageView* _imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelDetail.frame.origin.y+labelDetail.frame.size.height+14.5, self.frame.size.width, 0.5)];
            [_imageLine setBackgroundColor:[UIColor clearColor]];
            [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
            _imageLine.hidden = hiddenLine;
            [self addSubview:_imageLine];
        }
    }
}


@end
