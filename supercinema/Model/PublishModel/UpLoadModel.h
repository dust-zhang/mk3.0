//
//  UPUpLoadModel.h
//  movikr
//
//  Created by zeyuan on 15/7/24.
//  Copyright (c) 2015年 movikr. All rights reserved.
//


@interface UpLoadModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>*  code;
@property(nonatomic,strong) NSString<Optional>*  message;
@property(nonatomic,strong) NSString<Optional>*  sign;
@property(nonatomic,strong) NSString<Optional>*  time;
@property(nonatomic,strong) NSString<Optional>*  url;
@end



//又拍
@interface upLoadImageModel : JSONModel
@property(nonatomic,strong) NSString<Optional>*  upload_url;
@property(nonatomic,strong) NSString<Optional>*  image_key;
@property(nonatomic,strong) NSString<Optional>*  path;
@property(nonatomic,strong) NSString<Optional>*  policyKey;
@property(nonatomic,strong) NSString<Optional>*  policyValue;
@property(nonatomic,strong) NSString<Optional>*  signatureKey;
@property(nonatomic,strong) NSString<Optional>*  signatureValue;
@end



//本地缓存
@interface publishCacheModel : JSONModel
@property(nonatomic,strong) NSString<Optional>*  movie_id;      //影片id
@property(nonatomic,strong) NSString<Optional>*  title;         //标题
@property(nonatomic,strong) NSString<Optional>*  content;       //内容
@property(nonatomic,strong) NSData<Optional>*  imageData;      //相册图片
//@property(nonatomic,strong) NSString<Optional>*  stills;        //剧照
@property(nonatomic,strong) NSString<Optional>*  aside;         //旁白
@property(nonatomic,strong) NSString<Optional>*  asideContent;  //旁白内容
@property(nonatomic,strong) NSString<Optional>*  sendFlag;      //是否发送标示（0.不发送，1发送了没成功，等待网络继续重发）

@end


