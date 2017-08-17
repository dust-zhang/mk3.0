//
//  ImageCut.h
//  movikr
//
//  Created by Mapollo27 on 15/7/3.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageOperation : NSObject

//判断图片是横图还是竖图
+(BOOL) JudgePictureAnyway:(UIImage *)image;
//等比缩放图片
+(UIImage*)scaleToSizeImage:(CGSize)size image:(UIImage *)image;
//剪切图片
+(UIImage*)cutImage:(CGRect)rect image:(UIImage *)image;
//获取等比缩放图片后的实际宽高位置
+(CGRect) getZoomImagePosyHeight:(CGSize)size image:(UIImage *)image;
//根据图片的不同返回不同图片
+(UIImage *) returnResutImage:(UIImage *)image zoomSize:(CGSize) sizeImage;
//获取图片宽度噶度
+(CGSize) getImageWidthHeight:(UIImage *)image;
///根据颜色生成图片
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
///改变图片大小
+(UIImage *) changeImageSize:(UIImage *)image  scaleToSize:(CGSize)size;
///上传头像留黑边
+(UIImage *) changeHeadImageSize:(UIImage *)image  scaleToSize:(CGSize)size;

//计算原图在裁剪区域的裁剪大小
+(CGRect)imageViewSize:(CGSize)imageViewSize cutImageSize:(CGSize)cutImageSize;
+(UIImage *)cutImageNew:(UIImage *)image cutFrame:(CGRect)cutFrame;
//将View生成图片
+(UIImage *)makeImageWithView:(UIView *)view;
@end
