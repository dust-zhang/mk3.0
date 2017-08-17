//
//  UrlAddress.h
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//
//#define     URL_NEWADDRESS                  @"http://172.16.30.53:10080/api2"
#define     URL_NEWADDRESS                  @"http://acs.movikr.com:10080/api2"
//#define     URL_NEWADDRESS                  @"http://172.16.28.174:18080/api2"


//使用协议
#define     URL_USERLICENSE                 [URL_NEWADDRESS stringByAppendingString:@"/home/getUseLicense"]
//请求验证密码
#define     URL_REQUIREPWD                  [URL_NEWADDRESS stringByAppendingString:@"/account/passwordRequireCode"]
//上传头像
#define     URL_UPDATEUSERHEAD              [URL_NEWADDRESS  stringByAppendingString:@"/user/updateUserPortrait"]
//修改密码
#define     URL_USERCHANGEPWD               [URL_NEWADDRESS stringByAppendingString:@"/account/changePassword"]
//上传图片到又拍
#define     URL_ARTUPLOADIMAGE              [URL_NEWADDRESS stringByAppendingString:@"/image/getUploadImageData"]
//设置分享统计
#define     URL_CONTENTSHARE                [URL_NEWADDRESS stringByAppendingString:@"/content/share"]
//获取剧照
#define     URL_STILLS                      [URL_NEWADDRESS stringByAppendingString:@"/movie/still"]
//检查版本更新
#define     URL_VERSIONUPDATE               [URL_NEWADDRESS stringByAppendingString:@"/home/checkClientVersion"]
//保持登录
#define     URL_ACCOUNTKEEPALIVE            [URL_NEWADDRESS stringByAppendingString:@"/account/keepalive"]
//请求登陆
#define     URL_REQUESTLOGIN                [URL_NEWADDRESS stringByAppendingString:@"/account/require"]
//登陆
#define     URL_LOGIN                       [URL_NEWADDRESS stringByAppendingString:@"/account/login"]
//登陆退出
#define     URL_LOGINLOGOUT                 [URL_NEWADDRESS stringByAppendingString:@"/account/accountLogout"]
//设置个人资料
#define     URL_USERINFOSET                 [URL_NEWADDRESS stringByAppendingString:@"/user/updateUserInfo"]
//查看个人资料
#define     URL_GETUSERINFO                 [URL_NEWADDRESS stringByAppendingString:@"/user/getUserInfo"]
//默认头像列表
#define     URL_GETDEFAULTHEADIMGLIST       [URL_NEWADDRESS stringByAppendingString:@"/user/getDefaultHeadImgList"]
//获取配置信息
#define     URL_SYSTEMCONFIG                [URL_NEWADDRESS stringByAppendingString:@"/home/systemConfig"]
//根据id获取影院list
#define     URL_GETCINEMALIST               [URL_NEWADDRESS stringByAppendingString:@"/cinema/getCinemaList"]
//获取影片详情
#define     URL_MOVIEGET                    [URL_NEWADDRESS stringByAppendingString:@"/movie/getMovie"]
//获取影院消费提醒
#define     URL_GETCONSUMETIPS              [URL_NEWADDRESS stringByAppendingString:@"/cinema/getConsumeTips"]
//获取指定影院+指定电影的所有排期
#define     URL_SHOWTIME                    [URL_NEWADDRESS stringByAppendingString:@"/showtime/ShowtimesByCinemaIdAndMovieId"]
//获取排期的详细信息
#define     URL_SHOWTIMEDETAIL              [URL_NEWADDRESS stringByAppendingString:@"/showtime/OnlineSeatsByShowtimeId"]
//创建订单
#define     URL_CREATEORDER                 [URL_NEWADDRESS stringByAppendingString:@"/order/CreateOrder"]
//获取订单信息
#define     URL_GETORDERINFO                [URL_NEWADDRESS stringByAppendingString:@"/order/GetOrderInfo"]
//获取支付方式列表
#define     URL_GETPAYWAYLIST               [URL_NEWADDRESS stringByAppendingString:@"/pay/OnlineTicketPayTypeList"]
//第三方支付
#define     URL_THIRDPAY                    [URL_NEWADDRESS stringByAppendingString:@"/pay/GetThirdPartyPayData"]
//App支付回调
#define     URL_PAYRETURN                   [URL_NEWADDRESS stringByAppendingString:@"/pay/PayReturnNotification"]
//轮询订单
#define     URL_ORDERCYCLE                  [URL_NEWADDRESS stringByAppendingString:@"/order/GetOrderStatus"]
//取消订单
#define     URL_CANCELORDER                 [URL_NEWADDRESS stringByAppendingString:@"/order/CancelOrder"]
//删除子订单
#define     URL_DELETEORDER                 [URL_NEWADDRESS stringByAppendingString:@"/order/DeleteSubOrderById"]
//删除优惠券
//#define     URL_DELETECOUPON                [URL_NEWADDRESS stringByAppendingString:@"/cardPack/deleteCoupon"]
//获取订单列表
#define     URL_GETORDERLIST                [URL_NEWADDRESS stringByAppendingString:@"/order/OnlineTicketList"]
//获取卡包订单新接口
#define     URL_CARDPAGELIST                [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getCardPackList"]
//获取优惠券
#define     URL_GETCOUPONINFONEW            [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getCouponInfo"]
//使用优惠
#define     URL_USECOUPONNEW                [URL_NEWADDRESS stringByAppendingString:@"/cardPack/useCoupon"]
//获取用户在影院中的会员信息
#define     URL_MEMBERINFO                  [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/getCinemaCardCollectionByCinemaId"]
//购买会员卡
#define     URL_BUYMEMBERCARD               [URL_NEWADDRESS stringByAppendingString:@"/order/createCinemaCardOrder"]
//检查第三方登录用户
#define     URL_CHECKTHIRDLOGIN             [URL_NEWADDRESS stringByAppendingString:@"/thirdPartyLogin/checkThirdLoginData"]
//获取短信验证码
#define     URL_ACCOUNTSENDSMS              [URL_NEWADDRESS stringByAppendingString:@"/account/sendSms"]
//用户注册
#define     URL_ACCOUNTREGISTER             [URL_NEWADDRESS stringByAppendingString:@"/account/register"]
//重置密码(忘记密码)
#define     URL_RESETPASSWORD               [URL_NEWADDRESS stringByAppendingString:@"/account/resetPassword"]
//修改手机号
#define     URL_CHANGEMOBILENUMBER          [URL_NEWADDRESS stringByAppendingString:@"/account/changeMobileNumber"]
//请求验证密码
#define     URL_PWDREQUIREDCODE             [URL_NEWADDRESS stringByAppendingString:@"/account/passwordRequireCode"]
//用户头像
#define     URL_GETUSERHEAD                 [URL_NEWADDRESS stringByAppendingString:@"/user/getUserHead"]
//获取用户未使用的礼品
#define     URL_GETUSEUNUSERCARD            [URL_NEWADDRESS stringByAppendingString:@"/growingUp/getValidGrowingUpGiftByCinemaId"]
//获取用户在影院下的所有的礼品
#define     URL_GETCINEMAALLRCARD           [URL_NEWADDRESS stringByAppendingString:@"/growingUp/getAllCouponByCinemaId"]
//获取小卖列表
#define     URL_GETGOODLIST                 [URL_NEWADDRESS stringByAppendingString:@"/goods/getValidGoodsListByCinemaId"]
//获取小卖库存
#define     URL_GETGOODSLISTREMAINCOUNT     [URL_NEWADDRESS stringByAppendingString:@"/goods/checkGoodsListRemainCount"]
//获取小卖详情
#define     URL_GETGOODDETAIL               [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getGoodsOrderInfo"]
//兑换小卖
#define     URL_GETEXCHANGEGOODS            [URL_NEWADDRESS stringByAppendingString:@"/cardPack/exchangeGoods"]
//意见反馈
#define     URL_FEEDBACK                    [URL_NEWADDRESS stringByAppendingString:@"/feedback/addFeedback"]
//第一次启动
#define     URL_FIRSTSTARTAPP               [URL_NEWADDRESS stringByAppendingString:@"/home/firstStartUp"]
//获取指定影院下的活动列表
#define     URL_GETACTIVITYLISTFORCINEMA    [URL_NEWADDRESS stringByAppendingString:@"/activity/getActivityListByCinemaId"]
//获取用户在活动的参加情况
#define     URL_GETUSERINACTIVITY           [URL_NEWADDRESS stringByAppendingString:@"/activity/getJoinInfoListByActivityIds"]
//立即参加
#define     URL_JOINACTIVITY                [URL_NEWADDRESS stringByAppendingString:@"/activity/joinActivity"]
//立即领取
#define     URL_RECEVICEACTIVITY            [URL_NEWADDRESS stringByAppendingString:@"/activity/receiveActivity"]
//内部消息通知接口
#define     URL_MESSAGENOTICE               [URL_NEWADDRESS stringByAppendingString:@"/notify/getNotifyList"]
//获取通知详情
#define     URL_NOTICEDETAIL                [URL_NEWADDRESS stringByAppendingString:@"/notify/getNotifyInfo"]
//获取红包详情
#define     URL_GETREDPACKETDETAIL          [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getRedPacketInfo"]
//获取红包列表
#define     URL_GETREDPACKETLIST            [URL_NEWADDRESS stringByAppendingString:@"/activity/getValidCombineRedPacket"]
//获取奖品列表(购票购卡)
#define     URL_GETAWARDLIST                [URL_NEWADDRESS stringByAppendingString:@"/order/getOrderActivityGoods"]
//通知统计
#define     URL_NOTICECOUNT                 [URL_NEWADDRESS stringByAppendingString:@"/counter/addCount"]
//订单确认页获取可用的卡列表
#define     URL_GETCANUSERCINEMACARDLIST    [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/getOrderCanUseCinemaCardList"]
//获取红吧适用影院列表
#define     URL_GETREDUSECINEMALIST         [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getRedPacketUseCinemaList"]
//获取通票详情
#define     URL_GETTONGPIAODETAIL           [URL_NEWADDRESS stringByAppendingString:@"/cardPack/getTongPiaoDetail"]
//获取小卖列表
#define     URL_GETSNACKLIST                [URL_NEWADDRESS stringByAppendingString:@"/goods/getLowPriceGoodsListByCinemaId"]
//获取小卖详情
#define     URL_GETSNACKDETAIL              [URL_NEWADDRESS stringByAppendingString:@"/goods/getLowPriceGoodsByGoodsId"]
//创建小卖
#define     URL_GETCREATESNACK              [URL_NEWADDRESS stringByAppendingString:@"/goods/createGoodsOrder"]
//获取会员卡Item的优惠信息
#define     URL_GETVIPCARDREDPACKETINFO     [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/getCinemaCardItemUseRedpacketStatusList"]
//添加访问影院记录
#define     URL_ADDBROWSECINEMARECORD       [URL_NEWADDRESS stringByAppendingString:@"/user/addVisitData"]
//第三方账户绑定手机号
#define     URL_THIRDUSERBINGDMOBILE        [URL_NEWADDRESS stringByAppendingString:@"/account/thirdUserBindMobile"]
//搜索所有
#define     URL_SEARCHALLDATA               [URL_NEWADDRESS stringByAppendingString:@"/search/searchDataByKey"]
//搜索影院
#define     URL_SEARCHCINEMA                [URL_NEWADDRESS stringByAppendingString:@"/search/searchCinemas"]
//搜索影片
#define     URL_SEARCHMOVIES                [URL_NEWADDRESS stringByAppendingString:@"/search/searchMovies"]
//搜索用户
#define     URL_SEARCHUSER                  [URL_NEWADDRESS stringByAppendingString:@"/search/searchUsers"]
//获取常去+推荐影院
#define     URL_GETOFTENANDRECOMMENDCINEMA  [URL_NEWADDRESS stringByAppendingString:@"/search/getMostVisitAndRecommendCinemaList"]
//获取影院正在热映电影+即将上映
#define     URL_HOTMOVIES                   [URL_NEWADDRESS stringByAppendingString:@"/movie/getCinemaHotAndComingSoonMovieList"]
//获取用户所有 有效的卡
#define     URL_GETUSERALLVALIDCARD         [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/getUserAllValidCinemaCardList"]
//获取用户所有 过期的卡
#define     URL_GETUSERALLEXPIREDCARD       [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/getUserAllExpiredCinemaCardList"]
//删除用户的卡
#define     URL_DELETEUSERCARD              [URL_NEWADDRESS stringByAppendingString:@"/cinemaCard/deleteUserCinemaCardItem"]
//全部订单
#define     URL_GETMYALLORDER               [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getMyOrderListOfAll"]
//未支付订单
#define     URL_GETMYUNPAIDORDER            [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getMyOrderListOfUnPaid"]
//未使用订单
#define     URL_GETUNUSEDORDER              [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getMyOrderListOfUnUsed"]
//退款订单
#define     URL_GETREFUNDEDORDER            [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getMyOrderListOfRefunded"]
//删除订单
#define     URL_DELETEMYORDER               [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/deleteOrderListByIds"]
//获取优惠券列表
#define     URL_GETCOUPONLIST               [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getUserCouponList"]
//删除优惠券
#define     URL_DELETECOUPON                [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/deleteCouponList"]
//获取影院详情
#define     URL_GETCINEMADETAIL             [URL_NEWADDRESS stringByAppendingString:@"/cinema/getCinemaDetail"]
//获取影院图片列表
#define     URL_GETCINEMAIMAGE             [URL_NEWADDRESS stringByAppendingString:@"/cinema/images"]
//获取影院视频列表
#define     URL_GETCINEMAVIDEO             [URL_NEWADDRESS stringByAppendingString:@"/cinema/videos"]
//获取影院分享信息
#define     URL_CINEMASHAREINFO             [URL_NEWADDRESS stringByAppendingString:@"/cinema/shareInfo"]
//获取卡包优惠券和会员卡数量
#define     URL_GETCARDANDCOUPONCOUNT       [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getValidCinemaCardAndCouponCount"]
//获取个人中心各项未读数量
#define     URL_GETUSERCENTERUNREADCOUNT    [URL_NEWADDRESS stringByAppendingString:@"/cardPackage/getCardPackageSummary"]
//获取社交通知列表
#define     URL_GETNOTICTIONLIST            [URL_NEWADDRESS stringByAppendingString:@"/notify/getSocietyNotifyList"]
//批量设置社交通知为已读
#define     URL_SETNOTIFYREAD               [URL_NEWADDRESS stringByAppendingString:@"/notify/setSocietyNotifyListReaded"]
//批量删除社交通知
#define     URL_DELETENOTIFYLIST            [URL_NEWADDRESS stringByAppendingString:@"/notify/deleteSocietyNotifyList"]
//获取热门城市
#define     URL_GETHOTCITY                  [URL_NEWADDRESS stringByAppendingString:@"/home/getHotCityList"]
//关注用户
#define     URL_ATTENTIONUSER               [URL_NEWADDRESS stringByAppendingString:@"/followPerson/follow"]
//取消关注用户
#define     URL_CANCELATTENTIONUSER         [URL_NEWADDRESS stringByAppendingString:@"/followPerson/cancelFollow"]
//获取用户的关注列表
#define     URL_GETATTENTONUSERLIST         [URL_NEWADDRESS stringByAppendingString:@"/followPerson/getFollowPersonList"]
//获取用户的粉丝列表
#define     URL_GETFANSLIST                 [URL_NEWADDRESS stringByAppendingString:@"/followPerson/getFansList"]
//获取个人动态列表
#define     URL_GETUSERFEEDLIST             [URL_NEWADDRESS stringByAppendingString:@"/feedUser/getUserFeedList"]
//获取个人动态详情
#define     URL_GETFEEDDETAIL               [URL_NEWADDRESS stringByAppendingString:@"/feedUser/getFeedDetail"]
//删除个人动态
#define     URL_DELETEFEED                  [URL_NEWADDRESS stringByAppendingString:@"/feedUser/deleteFeed"]
//赞个人动态
#define     URL_LAUNFEED                    [URL_NEWADDRESS stringByAppendingString:@"/feedUser/launFeed"]
//取消赞个人动态
#define     URL_CANCELLAUDFEED              [URL_NEWADDRESS stringByAppendingString:@"/feedUser/cancelLaudFeed"]
//对个人动态发表评论
#define     URL_FEEDADDCOMMENT              [URL_NEWADDRESS stringByAppendingString:@"/feedUser/addUserFeedComment"]
//删除个人动态发表的评论
#define     URL_DELETEFEEDCOMMENT           [URL_NEWADDRESS stringByAppendingString:@"/feedUser/deleteFeedComment"]
//获取个人动态的评论列表
#define     URL_GETUSERFEEDCOMMENTLIST      [URL_NEWADDRESS stringByAppendingString:@"/feedUser/getUserFeedCommentList"]
//检查个人动态能否跳转
#define     URL_CHECKFEEDCANJUMP            [URL_NEWADDRESS stringByAppendingString:@"/feedUser/checkFeedCanJump"]
//想看电影
#define     URL_FOLLOWMOVIW                 [URL_NEWADDRESS stringByAppendingString:@"/movieReview/followMovie"]
//取消想看电影
#define     URL_CANCELFOLLOWMOVIW           [URL_NEWADDRESS stringByAppendingString:@"/movieReview/cancelFollowMovie"]
//获取想看电影列表
#define     URL_GETGETFOLLOWMOVIELIST       [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getFollowMovieList"]
//发表短评、回复短评、回复评论
#define     URL_ADDMOVIEREVIEW              [URL_NEWADDRESS stringByAppendingString:@"/movieReview/addMovieReview"]
//获取短评列表
#define     URL_GETMOVIEREVIEWLIST          [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getMovieReviewListByMovieId"]
//短评/评论点赞
#define     URL_LIKEMOVIECOMMENT            [URL_NEWADDRESS stringByAppendingString:@"/movieReview/likeMovieReviewOrComment"]
//短评/评论取消赞1
#define     URL_UNLIKEMOVIECOMMENT          [URL_NEWADDRESS stringByAppendingString:@"/movieReview/unlikeMovieReviewOrComment"]
//删除短评/评论
#define     URL_DELMOIVECOMMENT             [URL_NEWADDRESS stringByAppendingString:@"/movieReview/deleteMovieReviewOrComment"]
//获取短评的评论列表
#define     URL_GETMOVIECOMMENTLIST         [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getMovieReviewCommentList"]
//获取电影的短评摘要
#define     URL_GETMOVIEREVIEWSUMMARY       [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getMovieReviewSummary"]
//举报短评或者评论
#define     URL_REPORTMOVIEORCOMMENT        [URL_NEWADDRESS stringByAppendingString:@"/movieReview/reportMovieReviewOrComment"]
//获取单个短评的详情
#define     URL_GETMOVIEREVIEWDETAIL        [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getMovieReviewDetail"]
//获取用户的短评列表
#define     URL_GETUSERMOVIEREVIEWLIST      [URL_NEWADDRESS stringByAppendingString:@"/movieReview/getMovieReviewListByUserId"]
//影片标签
#define     URL_GETMOVIETAGS                [URL_NEWADDRESS stringByAppendingString:@"/movie/getMovieTagListByMovieId"]
//添加扫描结果
#define     URL_ADDSCANLOG                  [URL_NEWADDRESS stringByAppendingString:@"/notify/addScanLog"]
//*************************游戏接口*********************
//获取用户在游戏中的信息
#define     URL_GETGAMEINFO                 [URL_NEWADDRESS stringByAppendingString:@"/pastime/getUserGameData"]
//开始游戏
#define     URL_GAMESTART                   [URL_NEWADDRESS stringByAppendingString:@"/pastime/startPlayGame"]
//结束游戏
#define     URL_GAMEFINISH                  [URL_NEWADDRESS stringByAppendingString:@"/pastime/finishPlayGame"]
//取消回合
#define     URL_GAMECANCELROUND             [URL_NEWADDRESS stringByAppendingString:@"/pastime/cancelRound"]
//领取宝箱
#define     URL_GAMERECEIVECHEST            [URL_NEWADDRESS stringByAppendingString:@"/pastime/receiveChest"]
//获取商城可售列表
#define     URL_GAMEGETGROUPGOODSLIST       [URL_NEWADDRESS stringByAppendingString:@"/mall/getGroupGoodsList"]
//购买商城商品
#define     URL_GAMEBUYGOODS                [URL_NEWADDRESS stringByAppendingString:@"/mall/buyGoods"]
//获取订单红包的分享信息
#define     URL_GETORDERREDPACKSHAREINFO    [URL_NEWADDRESS stringByAppendingString:@"/order/getOrderRedpackShareInfo"]









