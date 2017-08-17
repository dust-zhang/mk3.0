//
//  enum
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//
typedef enum
{
    OPEN_APP                = 1,                    //打开app
    WAKEUP_APP              = 2,                    //唤起app
    OPEN_CINEMA_HOMEPAGE    = 3,                    //打开影院首页
    OPEN_MOVIE_CENTER       = 4,                    //打开影片首页
    OPEN_USER_CENTER        = 5,                    //打开个人中心
    OPEN_TOPIC              = 6,                    //打开晨钟暮鼓
    OPEN_CARDPACK           = 7,                    //打开卡包
    OPEN_FRIENDSSHIP_STATUS_PAGE = 8,               //打开好友动态
    OPEN_MOVIE_STATUS_PAGE  = 9                     //打开影片动态
}NoticeOpenType;


//分享枚举
typedef enum
{
    weixinShare             = 1,
    weixinFriendsShare      = 2,
    weiboShare              = 3,
    qqShare                 = 4,
    qqZoneShare             = 5,
    copyLink                = 6,
    unknow                  = 10000,
}shareType;
