//
//  CitySelectHeadCollectionReusableView.m
//  supercinema
//
//  Created by mapollo91 on 14/10/16.
//
//

#import "CitySelectHeadCollectionReusableView.h"

@implementation CitySelectHeadCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self._labelSectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, frame.size.width-5, frame.size.height)];
        self._labelSectionTitle.font = MKFONT(13);
        self._labelSectionTitle.textColor = RGBA(123, 122, 152, 1);
        self._labelSectionTitle.backgroundColor = RGBA(246, 246, 251, 1);
        [self addSubview:self._labelSectionTitle];
    }
    return self;
}
@end
