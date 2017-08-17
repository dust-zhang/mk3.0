//
//  ItemPreview.h
//  movikr
//
//  Created by Mapollo27 on 15/6/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreviewModel : JSONModel

@property(nonatomic,strong) UIImage<Optional>*  previewImage;    
@property(nonatomic,strong) NSString<Optional>*  previewTitle;   
@property(nonatomic,strong) NSString<Optional>*  previewContent; 


@end


