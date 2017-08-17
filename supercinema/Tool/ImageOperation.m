//
//  ImageOperation.m
//  movikr
//
//  Created by Mapollo27 on 15/7/3.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ImageOperation.h"

@implementation ImageOperation

//判断图片是横图还是竖图,TRUE 横，FALSE 竖
+(BOOL) JudgePictureAnyway:(UIImage *)image
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    if (width > height)
        return TRUE;
    else
        return FALSE;
}

//等比缩放图片,返回等比缩放后的图片
+(UIImage*)scaleToSizeImage:(CGSize)size image:(UIImage *)image
{
    CGRect imageRect =  [self getZoomImagePosyHeight:size image:image];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
}

+(CGRect) getZoomImagePosyHeight:(CGSize)size image:(UIImage *)image
{
    CGRect imageRect; //= CGRectMake(100, 100, 100, 100);
    
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    imageRect.origin.x =xPos;
    imageRect.origin.y =yPos;
    imageRect.size.width = width;
    imageRect.size.height = height;
    
    return imageRect;
}


//剪切图片,返回剪切后的图片
+(UIImage*)cutImage:(CGRect)rect image:(UIImage *)image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

//根据图片的不同返回不同图片
+(UIImage *) returnResutImage:(UIImage *)image zoomSize:(CGSize) sizeImage
{
    UIImageView *imageview = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0,sizeImage.width, sizeImage.height)];
    //竖图
    if (![ImageOperation JudgePictureAnyway:image])
    {
        //先等比缩放
        [imageview setImage:[ImageOperation scaleToSizeImage:sizeImage image:image ] ];
        //裁图的宽高(宽：屏幕宽度，高，图片中间)
        [imageview setImage:[ImageOperation cutImage:CGRectMake(0, (sizeImage.height - 531)/2, sizeImage.width, 531 ) image:imageview.image] ];
        return imageview.image;
    }
    else
    {
        //先等比缩放
        [imageview setImage:[ImageOperation scaleToSizeImage:sizeImage image:image ] ];
        //获取横图的Y轴和高度
        CGRect imageRect = [ImageOperation getZoomImagePosyHeight:sizeImage image:image];
        //裁图的宽高(宽：屏幕宽度，高，图片实际高度)
        [imageview setImage:[ImageOperation cutImage:CGRectMake(0, imageRect.origin.y, sizeImage.width, imageRect.size.height)image:imageview.image ] ];
        return imageview.image;
    }
    return nil;
}

+(CGSize) getImageWidthHeight:(UIImage *)image
{
    CGSize size;
    size.width  = CGImageGetWidth(image.CGImage);
    size.height = CGImageGetHeight(image.CGImage);
    return size;
}


///根据颜色生成图片
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *) changeImageSize:(UIImage *)image  scaleToSize:(CGSize)size
{
    //size 为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//上传头像留黑边
+(UIImage *) changeHeadImageSize:(UIImage *)image  scaleToSize:(CGSize)size
{
    //size 为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContext(size);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddRect(con, CGRectMake(0,0,size.width,size.height));
    CGContextSetFillColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextFillPath(con);
    if ((int)image.size.height == (int)image.size.width)
    {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    else
    {
        if ((int)image.size.height < (int)image.size.width)
        {
            CGFloat targetHeight = image.size.height / (image.size.width / size.width);
            [image drawInRect:CGRectMake(0, (size.height-targetHeight)/2, size.width, targetHeight)];
        }
        if ((int)image.size.height > (int)image.size.width)
        {
            CGFloat targetWidth = image.size.width / (image.size.height / size.height);
            [image drawInRect:CGRectMake((size.width-targetWidth)/2, 0, targetWidth, size.height)];
        }
        
    }
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark 裁剪
+(CGRect)imageViewSize:(CGSize)imageViewSize cutImageSize:(CGSize)cutImageSize
{
    CGFloat imageViewWidth = imageViewSize.width;       //原图宽
    CGFloat imageViewHeight = imageViewSize.height;     //原图高
    CGFloat cutImageWidth = cutImageSize.width;         //裁剪图宽
    CGFloat cutImageHeight = cutImageSize.height;       //裁剪图高
    CGFloat rate = cutImageWidth/cutImageHeight;        //宽高比例 10：7
    
    //如果原图宽<裁剪图宽 && 原图高>裁剪图高
    if (imageViewWidth <= cutImageWidth && imageViewHeight >= cutImageHeight)
    {
        return CGRectMake(0, (imageViewHeight-cutImageHeight)/2, imageViewWidth, cutImageHeight);
    }
    //如果原图宽>裁剪图宽 && 原图高<裁剪图高
    if (imageViewWidth >= cutImageWidth && imageViewHeight <= cutImageHeight)
    {
        return CGRectMake((imageViewWidth-cutImageWidth)/2, 0, cutImageWidth, imageViewHeight);
    }
    //如果原图宽<裁剪图宽 && 原图高<裁剪图高
    if (imageViewWidth <= cutImageWidth && imageViewHeight <= cutImageHeight)
    {
        return CGRectMake((cutImageWidth-imageViewWidth)/2, (cutImageHeight-imageViewHeight)/2, imageViewWidth, imageViewHeight);
    }
    //如果原图宽>裁剪图宽 && 原图高>裁剪图高
    if (imageViewWidth >= cutImageWidth && imageViewHeight >= cutImageHeight)
    {
        //如果原图宽 > 原图高
        if (imageViewWidth >= imageViewHeight)
        {
            return CGRectMake((imageViewWidth-imageViewHeight*rate)/2, 0, imageViewHeight*rate, imageViewHeight);//X:(imageViewWidth-cutImageWidth)/2
        }
        //如果原图宽 < 原图高
        if (imageViewWidth <= imageViewHeight)
        {
            return CGRectMake(0, (imageViewHeight-imageViewWidth/rate)/2, imageViewWidth, imageViewWidth/rate);//Y:(imageViewHeight-cutImageHeight)/2
        }
        //        return CGRectMake((imageViewWidth-cutImageWidth)/2, (imageViewHeight-cutImageHeight)/2, cutImageWidth, cutImageHeight);
    }
    
    return  CGRectMake(0, 0, cutImageWidth, cutImageHeight);
}

+(UIImage *)cutImageNew:(UIImage *)image cutFrame:(CGRect)cutFrame
{
    //需要裁剪的宽高范围
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cutFrame);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
}


+(UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);//view.layer.contentsScale ;[UIScreen mainScreen].scale
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
//{
//    //上下文的大小
//    int w = img.size.width;
//    int h = img.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建颜色
//    //创建上下文
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace, kCGBitmapAlphaInfoMask);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);//将img绘至context上下文中
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);//设置颜色
//    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
////    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);//设置字体的大小
//    CGContextSetFontSize(context, 30);
//    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);//设置字体绘制的颜色
//    CGContextShowTextAtPoint(context, w/2-strlen(text)*5, h/2, text, strlen(text));//设置字体绘制的位置
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);//创建CGImage
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];//获得添加水印后的图片
//}


@end
