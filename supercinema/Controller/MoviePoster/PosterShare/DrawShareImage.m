//
//  DrawShareImage.m
//  supercinema
//
//  Created by dust on 2017/3/28.
//
//

#import "DrawShareImage.h"

@implementation DrawShareImage


+(UIImage *)drawUserImage:(UIImage *)userImage
{
    UIImage *imgUser = userImage;
    // borderWidth 表示边框的宽度
    CGFloat imageW = imgUser.size.width ;
    CGFloat imageH = imgUser.size.height ;
    UIGraphicsBeginImageContextWithOptions(imgUser.size,NO,0.0);
    //获得上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    //添加一个圆
    CGRect rect =CGRectMake(0,0,imageW,imageH);
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);
    //将图片画上去
    [imgUser drawInRect:rect];
    //获得图片
    UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

//绘制图片
+ (UIImage *)drawLastImage:(UIImage *)movieImage shareUrl:(NSString *)Url userImage:(UIImage *)userImage movieCommit:(NSString *)commit
{
    //以image_back.png 的图大小为底图
    UIImage *imageBack = nil;
    if ([commit length] == 0 )
    {
        imageBack = [UIImage imageNamed:@"image_shareNoContentBackground.png"];
    }
    else
    {
        imageBack = [UIImage imageNamed:@"image_shareBackground.png"];
    }
    
    CGImageRef imgBack = imageBack.CGImage;
    CGFloat imgBackWidth = CGImageGetWidth(imgBack);
    CGFloat imgBackHeight = CGImageGetHeight(imgBack);
    UIGraphicsBeginImageContext(CGSizeMake(imgBackWidth, imgBackHeight));
    [imageBack drawInRect:CGRectMake(0, 0, imgBackWidth, imgBackHeight)];
    [movieImage drawInRect:CGRectMake(30, 30, imgBackWidth-60, 386)];
    [[self drawUserImage:userImage] drawInRect:CGRectMake(imgBackWidth/2-(70/2), 386+30 -70/2, 70, 70)];
    //二维码
    [[self encodeQRImageWithContent:Url size:CGSizeMake(99, 99)] drawInRect:
     CGRectMake(30, imgBackHeight-99-30, 99, 99) ];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

//绘制文字
+ (UIImage *)createShareImage:(UIImage *)movieImage movieName:( NSString *)movieName userImage:(UIImage *)userImage userNick:( NSString *)nick movieCommit:(NSString *)commit shareUrl:(NSString *)url
{
    UIImage *image = [self drawLastImage:movieImage shareUrl:url userImage:userImage movieCommit:commit];
    CGSize size= CGSizeMake (image. size . width , image. size . height );
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
   
    //电影名称（能换行）
    CGSize movieNameSize=[movieName sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.numberOfLines = 0;
    paragraphStyle.alignment = NSTextAlignmentCenter;
        [movieName drawInRect:CGRectMake(50, 194, size.width-100, movieNameSize.height*4) withAttributes:
         @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
            NSForegroundColorAttributeName :[UIColor whiteColor],
            NSParagraphStyleAttributeName:paragraphStyle}];

    
    //计算文字宽度（昵称_单行显示）
    CGSize sizeNick=[nick sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    //绘制文字（昵称）
    [nick drawAtPoint : CGPointMake ( image.size.width/2 - sizeNick.width/2+3 , 386+30 +70/2 +7 )
       withAttributes : @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
                           NSForegroundColorAttributeName :[ UIColor blackColor ]
                           } ];
    //评论（能换行）
    CGSize commitSize=[commit sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    [commit drawInRect:CGRectMake(50, image.size.height/2+ 125, size.width-100, commitSize.height*4) withAttributes:
     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
        NSForegroundColorAttributeName :RGBA(123, 122, 152, 1) }];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}
//生成二维码
+ (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size
{
    UIImage *codeImage = nil;
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    return image;
}

//影院分享_绘制文字
+ (UIImage *)createShareCinemaAddress:(NSString *)cinemaAddress cinemaReaso:(NSString *)cinemaReaso Image:(UIImage *)movieImage date:(NSString *)date week:(NSString *)week festival:(NSString *)festival shareUrl:(NSString *)url
{
    //计算文字高度
    int lineAddressCount = 1;
    if (cinemaAddress.length > 16)
    {
        lineAddressCount = 2;
    }
    
    int lineReasoCount = 1;
    if (cinemaReaso.length > 20)
    {
        lineReasoCount = 2;
    }
    
    //画画布背景
    UIImage *imageBack = [self imageWithColor:RGBA(255, 255, 255, 1) imageSize:CGSizeMake(612.0f, 1200.0f)];
    CGImageRef imgBack = imageBack.CGImage;
    CGFloat imgBackWidth = CGImageGetWidth(imgBack);
    CGFloat imgBackHeight = CGImageGetHeight(imgBack);
    UIGraphicsBeginImageContext(CGSizeMake(imgBackWidth, imgBackHeight));
    [imageBack drawInRect:CGRectMake(0, 0, imgBackWidth, imgBackHeight)];
    
    CGSize size= CGSizeMake (imageBack.size.width , imageBack.size.height );
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [imageBack drawAtPoint : CGPointMake ( 0 , 0 )];
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    
    //影院地址（能换行）
    CGSize cinemaAddressSize=[cinemaAddress sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    [cinemaAddress drawInRect:CGRectMake(60,
                                         40,
                                         size.width-60*2,
                                         cinemaAddressSize.height*4) withAttributes:
     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 30 ],
        NSForegroundColorAttributeName :RGBA(51, 51, 51, 1) }];
    
    float intervalCinemaReaso = 40+cinemaAddressSize.height*lineAddressCount;
    //影院推荐（能换行）
    CGSize cinemaReasoSize=[cinemaReaso sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    [cinemaReaso drawInRect:CGRectMake(60,
                                       intervalCinemaReaso + 16,
                                       size.width-60*2,
                                       cinemaReasoSize.height*4) withAttributes:
     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
        NSForegroundColorAttributeName :RGBA(51, 51, 51, 1) }];
    
    float intervalMovieImage = intervalCinemaReaso + cinemaReasoSize.height*lineReasoCount;
    //海报
    [movieImage drawInRect:CGRectMake(60,
                                      intervalMovieImage + 30,
                                      size.width-60*2,
                                      size.width-60*2)];
    
    float intervalDataBG = intervalMovieImage + (size.width-60*2);
    /*日期画布*/
//    UIImage *imageDataBG = [self imageWithColor:[UIColor redColor] imageSize:CGSizeMake(300.0f, 100.0f)];
//    CGImageRef imgBackDataBG = imageDataBG.CGImage;
//    CGFloat imgBackDataBGWidth = CGImageGetWidth(imgBackDataBG);
//    CGFloat imgBackDataBGHeight = CGImageGetHeight(imgBackDataBG);
//    UIGraphicsBeginImageContext(CGSizeMake(imgBackDataBGWidth, imgBackDataBGHeight));
//    [imageDataBG drawInRect:CGRectMake(30,
//                                       intervalDataBG + 30,
//                                       imgBackDataBGWidth,
//                                       imgBackDataBGHeight)];
    
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.画矩形
    CGContextAddRect(ctx, CGRectMake(60, intervalDataBG+30, size.width-60*2, 100));
    // set : 同时设置为实心和空心颜色
    // setStroke : 设置空心颜色
    // setFill : 设置实心颜色
    [RGBA(254, 254, 255, 1) set];
    CGContextSetRGBFillColor(ctx, 200, 0, 1, 1);
    // 3.绘制图形
    CGContextFillPath(ctx);
    
    
//    float intervalDate = intervalDataBG + movieImage.size.height;
//    //日期（单行显示）
//    [date drawInRect:CGRectMake(30,
//                                intervalDate + 20,
//                                imageDataBG.size.width/2,
//                                24)
//      withAttributes:
//     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
//        NSForegroundColorAttributeName :RGBA(123, 122, 152, 1)}];
//    
//    //星期（单行显示）
//    [week drawInRect:CGRectMake(30,
//                                intervalDate + 20+24+16,
//                                imageDataBG.size.width/2,
//                                24)
//      withAttributes:
//     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 24 ],
//        NSForegroundColorAttributeName :RGBA(123, 122, 152, 1)}];
//    
//    //节假日（单行显示）
//    [festival drawInRect:CGRectMake(imageDataBG.size.width/2,
//                                intervalDate + 33,
//                                imageDataBG.size.width/3,
//                                34)
//      withAttributes:
//     @{ NSFontAttributeName :[ UIFont systemFontOfSize: 34 ],
//        NSForegroundColorAttributeName :RGBA(51, 51, 51, 1)}];

    
    //保存图片
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}


//影院分享_绘制图片
+ (UIImage *)drawLastImage:(UIImage *)movieImage shareUrl:(NSString *)Url userImage:(UIImage *)userImage
{
    //以image_back.png 的图大小为底图
    UIImage *imageBack = [UIImage imageNamed:@"image_shareBackground.png"];
    
    CGImageRef imgBack = imageBack.CGImage;
    CGFloat imgBackWidth = CGImageGetWidth(imgBack);
    CGFloat imgBackHeight = CGImageGetHeight(imgBack);
    UIGraphicsBeginImageContext(CGSizeMake(imgBackWidth, imgBackHeight));
    [imageBack drawInRect:CGRectMake(0, 0, imgBackWidth, imgBackHeight)];
    [movieImage drawInRect:CGRectMake(30, 30, imgBackWidth-60, 386)];
    [[self drawUserImage:userImage] drawInRect:CGRectMake(imgBackWidth/2-(70/2), 386+30 -70/2, 70, 70)];
    //二维码
    [[self encodeQRImageWithContent:Url size:CGSizeMake(99, 99)] drawInRect:
     CGRectMake(30, imgBackHeight-99-30, 99, 99) ];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}


@end
