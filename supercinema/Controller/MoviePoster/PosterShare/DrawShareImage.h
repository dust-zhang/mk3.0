//
//  DrawShareImage.h
//  supercinema
//
//  Created by dust on 2017/3/28.
//
//

#import <Foundation/Foundation.h>

@interface DrawShareImage : NSObject
//海报分享
+ (UIImage *)createShareImage:(UIImage *)movieImage movieName:( NSString *)movieName userImage:(UIImage *)userImage userNick:( NSString *)nick movieCommit:(NSString *)commit shareUrl:(NSString *)url;
+ (UIImage *)drawUserImage:(UIImage *)userImage;
+ (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size;
+ (UIImage *)drawLastImage:(UIImage *)movieImage shareUrl:(NSString *)Url userImage:(UIImage *)userImage movieCommit:(NSString *)commit;

//影院分享_绘制文字
+ (UIImage *)createShareCinemaAddress:(NSString *)cinemaAddress cinemaReaso:(NSString *)cinemaReaso Image:(UIImage *)movieImage date:(NSString *)date week:(NSString *)week festival:(NSString *)festival shareUrl:(NSString *)url;
//影院分享_绘制图片
+ (UIImage *)drawLastImage:(UIImage *)movieImage shareUrl:(NSString *)Url userImage:(UIImage *)userImage;

@end
