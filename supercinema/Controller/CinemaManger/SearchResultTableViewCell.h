//
//  SearchResultTableViewCell.h
//  movikr
//
//  Created by zeyuan on 15/6/16.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchResultTableViewCell : UITableViewCell
{
    UILabel             *_titleLabel;
    UILabel             *_distanceLabel;
    UILabel             *_addressLabel;

    UIImageView         *_imageViewPiao;
    UIImageView         *_imageViewGoods;
    UIImageView         *_imageViewCard;
}

-(void)setSearchCinemaCellText:(CinemaModel*) model key:(NSString *)strKey;

@end
