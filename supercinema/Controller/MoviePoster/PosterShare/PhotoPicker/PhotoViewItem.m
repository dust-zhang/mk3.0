//
//  PhotoViewItem.m
//  supercinema
//
//  Created by mapollo91 on 28/3/17.
//
//

#import "PhotoViewItem.h"


@implementation PhotoViewItem

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self._imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];;
       [self addSubview:self._imageView];
    }
    return self;
}

@end
