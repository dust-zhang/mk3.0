//
//  ActivityTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 7/3/17.
//
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initController];
        self._activityModel = [[ActivityModel alloc] init];
        _isTailor = NO;
        
    }
    return self;
}

//初始化
-(void)initController
{
    [self setBackgroundColor:RGBA(246, 246, 251, 1)];
    
    //整体View的背景
    self._viewWholeBG = [[UIView alloc] initWithFrame:CGRectZero];
    self._viewWholeBG.backgroundColor = [UIColor whiteColor];
    self._viewWholeBG .layer.borderWidth = 0.5;//边框宽度
    self._viewWholeBG .layer.borderColor = [RGBA(255, 255, 255, 1) CGColor];//边框颜色
    self._viewWholeBG .layer.cornerRadius = 2.f;//圆角
    [self.contentView addSubview:self._viewWholeBG];
    
    //活动的图
    self._imageActivity = [[UIImageView alloc] initWithFrame:CGRectZero];
    self._imageActivity.backgroundColor = [UIColor clearColor];
    self._imageActivity.userInteractionEnabled = YES;//图片可以响应点击事件
    [self._viewWholeBG addSubview:self._imageActivity];
    
   
    //添加点击事件
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewClick)];
    [click setNumberOfTapsRequired:1];//点击一次
    click.cancelsTouchesInView = NO;//设置可点击
    [self._imageActivity addGestureRecognizer:click];
    
    //活动图下面的阴影
    self._imageShadow = [[UIImageView alloc] initWithFrame:CGRectZero];
    self._imageShadow.backgroundColor = [UIColor clearColor];
    [self._imageShadow setImage:[UIImage imageNamed:@"image_Activity_titleShadow.png"]];
    [self._imageActivity addSubview:self._imageShadow];
    
    //活动标题
    self._labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    self._labelTitle.backgroundColor = [UIColor clearColor];
    [self._labelTitle setFont:MKFONT(15)];
    [self._labelTitle setTextColor:RGBA(255, 255, 255, 1)];
    [self._labelTitle setTextAlignment:NSTextAlignmentLeft];
    [self._imageActivity addSubview:self._labelTitle];
    
    //活动说明
    self._labelDetails = [[UILabel alloc] initWithFrame:CGRectZero];
    self._labelDetails.backgroundColor = [UIColor clearColor];
    [self._labelDetails setFont:MKFONT(12)];
    [self._labelDetails setTextColor:RGBA(255, 255, 255, 0.6)];
    [self._labelDetails setTextAlignment:NSTextAlignmentLeft];
    [self._imageActivity addSubview:self._labelDetails];
    
    //活动结束日期
    self._labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self._labelTime.backgroundColor = [UIColor clearColor];
    [self._labelTime setFont:MKFONT(12)];
    [self._labelTime setTextColor:RGBA(255, 255, 255, 1)];
    [self._labelTime setTextAlignment:NSTextAlignmentLeft];
    [self._imageActivity addSubview:self._labelTime];
    
    //参加按钮
    self._btnJoin = [[UIButton alloc] initWithFrame:CGRectZero];
    self._btnJoin.backgroundColor = [UIColor clearColor];
    [self._btnJoin .titleLabel setFont:MKFONT(14)];//按钮字体大小
    [self._btnJoin.layer setCornerRadius:13.5];//按钮设置圆角
    [self._btnJoin addTarget:self action:@selector(onButtonJoin) forControlEvents:UIControlEventTouchUpInside];
    [self._viewWholeBG addSubview:self._btnJoin];
    
    //去参加活动箭头
    self._imageGoToJoinArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    self._imageGoToJoinArrow.backgroundColor = [UIColor clearColor];
    [self._imageGoToJoinArrow setImage:[UIImage imageNamed:@"image_Activity_goutoJoinArrow.png"]];
    [self._btnJoin addSubview:self._imageGoToJoinArrow];
    
    //往期中参加人数
    self._labelJoinPeopleNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    self._labelJoinPeopleNumber.backgroundColor = [UIColor clearColor];
    [self._labelJoinPeopleNumber setFont:MKFONT(12)];
    [self._labelJoinPeopleNumber setTextColor:RGBA(153, 153, 153, 1)];
    [self._labelJoinPeopleNumber setTextAlignment:NSTextAlignmentCenter];
    [self._viewWholeBG addSubview:self._labelJoinPeopleNumber];
    
    //往期活动分割线
    //单元格的高78/2
    self._labelOverdueTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [self._labelOverdueTitle setBackgroundColor:[UIColor clearColor]];
    [self._labelOverdueTitle setFont:MKFONT(14)];
    [self._labelOverdueTitle setTextColor:RGBA(102, 102, 102, 1)];
    [self._labelOverdueTitle setTextAlignment:NSTextAlignmentCenter];
    self._labelOverdueTitle.text = @"往期活动";
    [self.contentView addSubview:self._labelOverdueTitle];
    
    //分割线
    self._labelLineLeft = [[UILabel alloc] initWithFrame:CGRectZero];
    [self._labelLineLeft setBackgroundColor:RGBA(102, 102, 102, 1)];
    [self.contentView addSubview:self._labelLineLeft];
    
    self._labelLineRight = [[UILabel alloc] initWithFrame:CGRectZero];
    [self._labelLineRight setBackgroundColor:RGBA(102, 102, 102, 1)];
    [self.contentView addSubview:self._labelLineRight];
    
}

#pragma mark 有效活动
-(void)setCurrentActivityCellFrameAndData:(ActivityModel *)activityModel indexPath:(NSInteger)row
{
    
    self._activityModel = activityModel;
    //当前活动图片相差高度
    float fDifferHigh;
    if (row == 0)
    {
        fDifferHigh = 102.5;//图片加横条{"(550+116)-(345+116)"}
    }
    else
    {
        fDifferHigh = 0;
    }
    //整体View的背景
    self._viewWholeBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 230.5+fDifferHigh);
    
    //活动的图
    self._imageActivity.frame = CGRectMake(0, 0, self._viewWholeBG.frame.size.width, 172.5+fDifferHigh);
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //保存图片URL
    NSURL* url = [NSURL URLWithString:activityModel.activityImageUrl];
    BOOL existBool = [manager diskImageExistsForURL:url];
    if (existBool)
    {
        UIImage* image =  [[manager imageCache]imageFromDiskCacheForKey:url.absoluteString];
        self._imageActivity.image = image;
        if (row == 0)
        {
            [self cutImage];
        }
    }
    else
    {
        [manager downloadImageWithURL:[NSURL URLWithString:activityModel.activityImageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (!error && image)
                                {
                                    self._imageActivity.image = image;
                                    if (row == 0)
                                    {
                                        [self cutImage];
                                    }
                                }
                                else
                                {
                                    self._imageActivity.image = [UIImage imageNamed:@"image_Activity_finishBG.png"];
                                    if (row == 0)
                                    {
                                        [self cutImage];
                                    }
                                }
                                
                            }];
    }
   
//    [self._imageActivity sd_setImageWithURL:[NSURL URLWithString:activityModel.activityImageUrl] placeholderImage:[UIImage imageNamed:@"image_Activity_finishBG.png"]];
//    if (row == 0)
//    {
//        if (_isTailor == NO)
//        {
//            _isTailor = YES;
//            //等比缩放图片
//            [self._imageActivity setImage:[ImageOperation scaleToSizeImage:CGSizeMake(self._imageActivity.frame.size.width/375 * self._imageActivity.image.size.width,
//                                                                                      self._imageActivity.frame.size.width/375 * self._imageActivity.image.size.height)
//                                                                     image:self._imageActivity.image]];
//            //剪切图片
//            [self._imageActivity setImage:[ImageOperation cutImage:CGRectMake((self._imageActivity.image.size.width-self._viewWholeBG.frame.size.width)/2,
//                                                                              0,
//                                                                              self._imageActivity.frame.size.width,
//                                                                              self._imageActivity.frame.size.height)
//                                                             image:self._imageActivity.image]];
//        }
//    }
    
    
    //活动图下面的阴影
    self._imageShadow.frame = CGRectMake(0, self._imageActivity.frame.size.height-105, self._viewWholeBG.frame.size.width, 105);
    
    //活动标题
    self._labelTitle.frame = CGRectMake(15, self._imageActivity.frame.size.height-70, self._viewWholeBG.frame.size.width-15*2, 15);
    self._labelTitle.text = activityModel.activityTitle;
    
    //活动说明
    self._labelDetails.frame = CGRectMake(self._labelTitle.frame.origin.x, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+8, self._labelTitle.frame.size.width, 12);
    self._labelDetails.text = activityModel.activityDescription;
    
    //活动结束日期
    self._labelTime.frame = CGRectMake(self._labelDetails.frame.origin.x, self._labelDetails.frame.origin.y+self._labelDetails.frame.size.height+15, self._labelDetails.frame.size.width, 12);
    self._labelTime.text = activityModel.activityDaysDesc;
//    long  currentTime = [curTime longValue];
//    long  endTime = [model.endValidTime longValue];
//    long  leftTime = (endTime - currentTime)/1000/24/60/60;
//    if (currentTime < endTime)
//    {
//        if (leftTime == 0)
//        {
//            self._labelTime.text = @"今日结束";
//        }
//        else
//        {
//            self._labelTime.text = [NSString stringWithFormat:@"%ld天后结束",leftTime];
//        }
//    }
//    else
//    {
//        self._labelTime.text = @"活动已结束";
//    }
    
    //当前活动参加人数
    if ([activityModel.joinType intValue] == 0)
    {
        //领取
        if ([activityModel.receiveCount intValue] >= 10)
        {
            [self setJoinPersonCount:activityModel.receiveCount activityModel:activityModel];
        }
    }
    else
    {
        //参加
        if ([activityModel.joinCount intValue] >= 10)
        {
            [self setJoinPersonCount:activityModel.joinCount activityModel:activityModel];
        }
    }
        
    //参加按钮
    self._btnJoin.frame = CGRectMake(self._viewWholeBG.frame.size.width-15-80, self._imageActivity.frame.origin.y+self._imageActivity.frame.size.height+15, 80, 27);
    [self setButtonJoinType:[activityModel.listShowStatus intValue]];
    
    NSLog(@"%@",activityModel.listShowStatus);
}

//等比缩放裁剪
-(void)cutImage
{
    if (_isTailor == NO)
    {
        _isTailor = YES;
        //等比缩放图片
        CGRect sizeImage= [ImageOperation imageViewSize:self._imageActivity.image.size cutImageSize:self._imageActivity.frame.size];
        [self._imageActivity setImage:[ImageOperation cutImageNew:self._imageActivity.image cutFrame:sizeImage]];
    }
}

//参加按钮显示状态
-(void)setButtonJoinType:(int)btnJoinType
{
    //列表的显示状态 1:即将开始 2:去参加 3:已参加 4:已结束

    switch (btnJoinType)
    {
        case 1:
            //即将开始
            [self._btnJoin setTitle:@"即将开始" forState:UIControlStateNormal];
            [self._btnJoin setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
            [self._btnJoin setBackgroundImage:[UIImage imageNamed:@"btn_Activity_goutoBegin.png"] forState:UIControlStateNormal];
            //去参加活动箭头
            self._imageGoToJoinArrow.hidden = YES;
            break;
            
        case 2:
            //去参加
            [self._btnJoin setTitle:@"去参加   " forState:UIControlStateNormal];
            [self._btnJoin setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
            [self._btnJoin setBackgroundImage:[UIImage imageNamed:@"btn_Activity_goutoJoin.png"] forState:UIControlStateNormal];
            
            //去参加活动箭头
            self._imageGoToJoinArrow.hidden = NO;
            self._imageGoToJoinArrow.frame = CGRectMake(self._btnJoin.frame.size.width-13-6, 8, 6, 11);
        
            break;
            
        case 3:
            //已参加
            [self._btnJoin setTitle:@"已参加" forState:UIControlStateNormal];
            [self._btnJoin setTitleColor:RGBA(249, 81, 81, 1) forState:UIControlStateNormal];//按钮文字颜色
            //去参加活动箭头
            self._imageGoToJoinArrow.hidden = YES;
            break;
            
        case 4:
            //已结束
            [self._btnJoin setTitle:@"已结束" forState:UIControlStateNormal];
            [self._btnJoin setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];//按钮文字颜色
            //去参加活动箭头
            self._imageGoToJoinArrow.hidden = YES;
            break;
            
        default:
            break;
    }
}

//当前活动参加人数
-(void)setJoinPersonCount:(NSNumber *)personCount activityModel:(ActivityModel *)activityModel
{
    //参加人数
    int countIcon = 0;
    if ([personCount intValue] < 10)
    {
        countIcon = 0;
    }
    else
    {
        countIcon = 4;
    }

    //参加人物头像
    for (int i = 0; i < activityModel.userList.count; i++)
    {
        ActivityUserListModel *userListModel = activityModel.userList[i];
        
        //参加人物头像
        UIButton *btnJoinPeopleIcon = [[UIButton alloc] initWithFrame:CGRectMake(15+i*(27+4), self._imageActivity.frame.origin.y+self._imageActivity.frame.size.height+15, 27, 27)];
        btnJoinPeopleIcon.backgroundColor = [UIColor clearColor];
        [btnJoinPeopleIcon.layer setCornerRadius:13.5];//设置圆角
        btnJoinPeopleIcon.layer.masksToBounds = YES;
        [self._viewWholeBG addSubview:btnJoinPeopleIcon];
        objc_setAssociatedObject(btnJoinPeopleIcon, "id", userListModel.id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btnJoinPeopleIcon addTarget:self action:@selector(onButtonJoinPeopleIcon:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageJoinPeopleIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, btnJoinPeopleIcon.frame.size.width, btnJoinPeopleIcon.frame.size.height)];
        imageJoinPeopleIcon.backgroundColor = [UIColor clearColor];
        [imageJoinPeopleIcon sd_setImageWithURL:[NSURL URLWithString:userListModel.portraitUrl] placeholderImage:[UIImage imageNamed:@"image_defaultHead1"]];
        [btnJoinPeopleIcon addSubview:imageJoinPeopleIcon];
        
        
    }
    UIButton *btnJoinPeopleCount = [[UIButton alloc] initWithFrame:CGRectMake(15+activityModel.userList.count*(27+4), self._imageActivity.frame.origin.y+self._imageActivity.frame.size.height+15, 27, 27)];
    btnJoinPeopleCount.backgroundColor = RGBA(0, 0, 0, 1);
    [btnJoinPeopleCount setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnJoinPeopleCount.layer setCornerRadius:13.5];//设置圆角
    [btnJoinPeopleCount .titleLabel setFont:MKFONT(9)];//按钮字体大小
    
    if ([activityModel.joinType intValue] == 0)
    {
        //领取
        [btnJoinPeopleCount setTitle:[Tool getPersonCount:activityModel.receiveCount] forState:UIControlStateNormal];
    }
    else
    {
        //参加
        [btnJoinPeopleCount setTitle:[Tool getPersonCount:activityModel.joinCount] forState:UIControlStateNormal];
    }
    [self._viewWholeBG addSubview:btnJoinPeopleCount];
    
//    if ([personCount intValue] < 1000)
//    {
//        if ([activityModel.joinType intValue] == 0)
//        {
//            //领取
//            [btnJoinPeopleCount setTitle:[activityModel.receiveCount stringValue] forState:UIControlStateNormal];
//        }
//        else
//        {
//            //参加
//            [btnJoinPeopleCount setTitle:[activityModel.joinCount stringValue] forState:UIControlStateNormal];
//        }
//    }
//    else
//    {
//        [btnJoinPeopleCount setTitle:@"999+" forState:UIControlStateNormal];
//    }
    
    //如果参加人数超过10人，开始展示用户头像
//    if ([personCount intValue] >= 10)
//    {
//        
//    }
}

#pragma mark 点击了参加头像
-(void)onButtonJoinPeopleIcon:(UIButton *)sender
{
    id userId = objc_getAssociatedObject(sender, "id");
    
    if ([self.activityDelegate respondsToSelector:@selector(pushUserOrOtherCenterViewController:)])
    {
        [self.activityDelegate pushUserOrOtherCenterViewController:[NSString stringWithFormat:@"%@", userId]];
    }
}

#pragma mark 往期分割线
-(void)setOverdueSegmentationLine
{
    //往期活动分割线
    //单元格的高78/2
    self._labelOverdueTitle.frame = CGRectMake((SCREEN_WIDTH-70)/2, 20, 70, 14);
    
    //分割线
    self._labelLineLeft.frame = CGRectMake(self._labelOverdueTitle.frame.origin.x-15-100,self._labelOverdueTitle.frame.origin.y+6.5, 100, 1);
    
    self._labelLineRight.frame = CGRectMake(self._labelOverdueTitle.frame.origin.x+self._labelOverdueTitle.frame.size.width+15,self._labelLineLeft.frame.origin.y, 100, 1);
}

#pragma mark 往期活动
-(void)setOverdueActivityCellFrameAndData:(ActivityModel *)activityModel
{
    
    self._activityModel = activityModel;
    //整体View的背景
    self._viewWholeBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 230.5-16);
    
    //活动的图
    self._imageActivity.frame = CGRectMake(0, 0, self._viewWholeBG.frame.size.width, 172.5);
    
    UIView *viewStillsShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self._viewWholeBG.frame.size.width,172)];
    viewStillsShadow.userInteractionEnabled = YES;
    viewStillsShadow.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self._imageActivity addSubview:viewStillsShadow];
    
    
    //图片去色置灰处理
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //保存图片URL
    NSURL* url = [NSURL URLWithString:activityModel.activityImageUrl];
    BOOL existBool = [manager diskImageExistsForURL:url];
    if (existBool)
    {
        UIImage* image =  [[manager imageCache]imageFromDiskCacheForKey:url.absoluteString];
//        self._imageActivity.image = [self grayImage:image];
        self._imageActivity.image = image;
    }
    else
    {
        [manager downloadImageWithURL:[NSURL URLWithString:activityModel.activityImageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (!error && image)
                                {
//                                    self._imageActivity.image = [self grayImage:image];
                                    self._imageActivity.image = image;
                                }
                                else
                                {
//                                    self._imageActivity.image = [self grayImage:[UIImage imageNamed:@"image_Activity_finishBG.png"]];
                                    self._imageActivity.image = [UIImage imageNamed:@"image_Activity_finishBG.png"];
                                }
                            }];
    }
    
    //活动图下面的阴影
    self._imageShadow.frame = CGRectMake(0, self._imageActivity.frame.size.height-105, self._viewWholeBG.frame.size.width, 105);
    
    
    //活动标题
    self._labelTitle.frame = CGRectMake(15, self._imageActivity.frame.size.height-70, self._viewWholeBG.frame.size.width-15*2, 15);
    self._labelTitle.text = activityModel.activityTitle;
    
    //活动说明
    self._labelDetails.frame = CGRectMake(self._labelTitle.frame.origin.x, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+8, self._labelTitle.frame.size.width, 12);
    self._labelDetails.text = activityModel.activityDescription;
    
    //活动结束日期
    self._labelTime.frame = CGRectMake(self._labelDetails.frame.origin.x, self._labelDetails.frame.origin.y+self._labelDetails.frame.size.height+15, self._labelDetails.frame.size.width, 12);
    self._labelTime.text = activityModel.activityDaysDesc;
    
    //往期中参加人数
    self._labelJoinPeopleNumber.frame = CGRectMake(0, self._imageActivity.frame.origin.y+self._imageActivity.frame.size.height+15, self._viewWholeBG.frame.size.width, 12);
    
    if ([activityModel.joinType intValue] == 0)
    {
        //领取
        if ([activityModel.receiveCount intValue] < 10)
        {
            self._labelJoinPeopleNumber.text = @"已结束";
        }
        else
        {
            self._labelJoinPeopleNumber.text = [NSString stringWithFormat:@"领取人数%@人/已结束",[Tool getPersonCount:activityModel.receiveCount]];
        }
//        if ([activityModel.receiveCount intValue] < 10)
//        {
//            self._labelJoinPeopleNumber.text = @"已结束";
//        }
//        else if ([activityModel.receiveCount intValue] < 1000)
//        {
//            self._labelJoinPeopleNumber.text = [NSString stringWithFormat:@"领取人数%@人/已结束",activityModel.receiveCount];
//        }
//        else
//        {
//            self._labelJoinPeopleNumber.text = @"领取人数999+人/已结束";
//        }
    }
    else
    {
        //参加
        if ([activityModel.joinCount intValue] < 10)
        {
            self._labelJoinPeopleNumber.text = @"已结束";
        }
        else
        {
            self._labelJoinPeopleNumber.text = [NSString stringWithFormat:@"参加人数%@人/已结束",[Tool getPersonCount:activityModel.joinCount]];
        }
//        if ([activityModel.joinCount intValue] < 10)
//        {
//            self._labelJoinPeopleNumber.text = @"已结束";
//        }
//        else if ([activityModel.joinCount intValue] < 1000)
//        {
//            self._labelJoinPeopleNumber.text = [NSString stringWithFormat:@"参加人数%@人/已结束",activityModel.joinCount];
//        }
//        else
//        {
//            self._labelJoinPeopleNumber.text = @"参加人数999+人/已结束";
//        }
    }
}

-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
    
}

#pragma mark 点击图片进行跳转
-(void)onImageViewClick
{
    [self onButtonJoin];
}

#pragma mark 去参加按钮
-(void)onButtonJoin
{
    if ([self.activityDelegate respondsToSelector:@selector(openJoinDetails:)])
    {
        [self.activityDelegate openJoinDetails:self._activityModel];
    }
    NSLog(@"点击了去参加按钮 - 跳转到详情");
}




@end
