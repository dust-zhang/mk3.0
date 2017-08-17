//
//  MoviePosterView.m
//  supercinema
//
//  Created by Mapollo28 on 2017/3/28.
//
//

#import "MoviePosterView.h"

@implementation MoviePosterView
-(id)initWithFrame:(CGRect)frame model:(MovieModel*)mModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.movieModel = mModel;
        
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = CGRectZero;
        _btnPlay.backgroundColor = [UIColor clearColor];
        [_btnPlay setBackgroundImage:[UIImage imageNamed:@"poster_play.png"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(onButtonPlayVideo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnPlay];
        
        if (_movieModel.trailer.videoUrl.length==0)
        {
            _btnPlay.hidden = YES;
        }
        
        _labelMovieName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 0)];
        _labelMovieName.font = MKFONT(24);
        _labelMovieName.textColor = [UIColor whiteColor];
        _labelMovieName.backgroundColor = [UIColor clearColor];
        _labelMovieName.lineBreakMode = NSLineBreakByCharWrapping;
        _labelMovieName.numberOfLines = 0;
        [self addSubview:_labelMovieName];
        
        _imageDouban = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageDouban.backgroundColor = [UIColor clearColor];
        _imageDouban.image = [UIImage imageNamed:@"poster_douban.png"];
        [self addSubview:_imageDouban];
        
        _labelScoreDouban = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelScoreDouban.textColor = RGBA(255, 255, 255, 0.8);
        _labelScoreDouban.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelScoreDouban];
        
        _imageIMDb = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageIMDb.backgroundColor = [UIColor clearColor];
        _imageIMDb.image = [UIImage imageNamed:@"poster_imdb.png"];
        [self addSubview:_imageIMDb];
        
        _labelScoreIMDb = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelScoreIMDb.textColor = [UIColor whiteColor];
        _labelScoreIMDb.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelScoreIMDb];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTime.font = MKFONT(12);
        _labelTime.textColor = [UIColor whiteColor];
        _labelTime.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelTime];
        
        _viewVersion = [[UIView alloc]initWithFrame:CGRectZero];
        _viewVersion.backgroundColor = [UIColor clearColor];
        [self addSubview:_viewVersion];
        
        _imageShowTime = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageShowTime.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageShowTime];
        
        _labelShowTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelShowTime.font = MKFONT(9);
        _labelShowTime.textColor = [UIColor whiteColor];
        _labelShowTime.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelShowTime];
        
        _labelMovieFlag = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMovieFlag.font = MKFONT(15);
        _labelMovieFlag.textColor = [UIColor whiteColor];
        _labelMovieFlag.backgroundColor = [UIColor clearColor];
        _labelMovieFlag.text = @"影片印象";
        [self addSubview:_labelMovieFlag];
        
        _viewFlag = [[UIView alloc]initWithFrame:CGRectZero];
        _viewFlag.backgroundColor = [UIColor whiteColor];
        [self addSubview:_viewFlag];
        
        _labelTeam = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTeam.font = MKFONT(15);
        _labelTeam.textColor = [UIColor whiteColor];
        _labelTeam.backgroundColor = [UIColor clearColor];
        _labelTeam.text = @"主创团队";
        [self addSubview:_labelTeam];
        
        _scrollTeam = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollTeam.backgroundColor = [UIColor clearColor];
        _scrollTeam.pagingEnabled = NO;
        _scrollTeam.showsHorizontalScrollIndicator = NO;
        _scrollTeam.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollTeam];
        
        _labelMoviePhoto = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMoviePhoto.font = MKFONT(15);
        _labelMoviePhoto.textColor = [UIColor whiteColor];
        _labelMoviePhoto.backgroundColor = [UIColor clearColor];
        _labelMoviePhoto.text = @"电影图片";
        [self addSubview:_labelMoviePhoto];
        
        _viewScan = [[UIView alloc]initWithFrame:CGRectZero];
        _viewScan.backgroundColor = [UIColor clearColor];
        _viewScan.userInteractionEnabled = YES;
        [self addSubview:_viewScan];
        
        _labelScan = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelScan.font = MKFONT(14);
        _labelScan.textColor = RGBA(123, 122, 152, 1);
        _labelScan.backgroundColor = [UIColor clearColor];
        _labelScan.userInteractionEnabled = YES;
        [_viewScan addSubview:_labelScan];
        
        _imageScan = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageScan.image = [UIImage imageNamed:@"poster_more_pic.png"];
        _imageScan.userInteractionEnabled = YES;
        [_viewScan addSubview:_imageScan];
        
        UITapGestureRecognizer* tapScan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScanPhoto)];
        [_viewScan addGestureRecognizer:tapScan];
        
        _labelTip = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTip.font = MKFONT(15);
        _labelTip.textColor = [UIColor whiteColor];
        _labelTip.backgroundColor = [UIColor clearColor];
        _labelTip.text = @"观影提示";
        [self addSubview:_labelTip];
        
        _imageArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageArrow.backgroundColor = [UIColor clearColor];
        _imageArrow.image = [UIImage imageNamed:@"poster_pull_up.png"];
        [self addSubview:_imageArrow];
        
        _labelPull = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelPull.font = MKFONT(14);
        _labelPull.textColor = RGBA(255, 255, 255, 0.6);
        _labelPull.backgroundColor = [UIColor clearColor];
        _labelPull.text = @"上拉查看短评";
        [self addSubview:_labelPull];
        
        [self refreshData];
        [self refreshFrame];
    }
    return self;
}

-(void)refreshData
{
    _labelMovieName.text = self.movieModel.movieTitle;
    
    if (self.movieModel.doubanRate.length > 0)
    {
        NSString* strDouban = [self.movieModel.doubanRate stringByAppendingString:@"分"];
        NSMutableAttributedString* stringDouban = [[NSMutableAttributedString alloc]initWithString:strDouban];
        [stringDouban addAttribute:NSFontAttributeName value:MKFONT(25) range:NSMakeRange(0, strDouban.length-1)];
        [stringDouban addAttribute:NSFontAttributeName value:MKFONT(12) range:NSMakeRange(strDouban.length-1, 1)];
        [_labelScoreDouban setAttributedText:stringDouban];
    }
    
    if (self.movieModel.imdbRate.length>0)
    {
        NSString* strIMDb = [self.movieModel.imdbRate stringByAppendingString:@"分"];
        NSMutableAttributedString* stringIMDb = [[NSMutableAttributedString alloc]initWithString:strIMDb];
        [stringIMDb addAttribute:NSFontAttributeName value:MKFONT(25) range:NSMakeRange(0, strIMDb.length-1)];
        [stringIMDb addAttribute:NSFontAttributeName value:MKFONT(12) range:NSMakeRange(strIMDb.length-1, 1)];
        [_labelScoreIMDb setAttributedText:stringIMDb];
    }
    
    if ([self.movieModel.duration integerValue] > 0)
    {
        if (self.movieModel.releaseDate.length >0)
        {
            _labelTime.text = [NSString stringWithFormat:@"时长：%@分钟   上映：%@",[self.movieModel.duration stringValue],self.movieModel.releaseDate];
        }
        else
        {
            _labelTime.text = [NSString stringWithFormat:@"时长：%@分钟",[self.movieModel.duration stringValue]];
        }
    }
    else
    {
        if (self.movieModel.releaseDate.length >0)
        {
            _labelTime.text = [NSString stringWithFormat:@"上映：%@",self.movieModel.releaseDate];
        }
    }
}

-(void)refreshFrame
{
    CGFloat widthPlay = 60;
    _btnPlay.frame = CGRectMake((SCREEN_WIDTH-widthPlay)/2, 200, widthPlay, widthPlay);
    [_labelMovieName sizeToFit];
    _labelMovieName.frame = CGRectMake(20, _btnPlay.frame.origin.y+_btnPlay.frame.size.height+298/2, SCREEN_WIDTH-40, _labelMovieName.frame.size.height);
    CGFloat originY = _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+45;
    CGFloat backViewH = _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+64;
    //评分
    if (_labelScoreDouban.text.length>0)
    {
        //有豆瓣评分
        _imageDouban.frame = CGRectMake(20, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+45, 20, 20);
        [_labelScoreDouban sizeToFit];
        _labelScoreDouban.frame = CGRectMake(_imageDouban.frame.origin.x+_imageDouban.frame.size.width+15, _imageDouban.frame.origin.y-2.5, _labelScoreDouban.frame.size.width, 25);
        if (_labelScoreIMDb.text.length>0)
        {
            //有imdb评分
            _imageIMDb.frame = CGRectMake(_labelScoreDouban.frame.origin.x+_labelScoreDouban.frame.size.width+30, _imageDouban.frame.origin.y, 20, 20);
            [_labelScoreIMDb sizeToFit];
            _labelScoreIMDb.frame = CGRectMake(_imageIMDb.frame.origin.x+_imageIMDb.frame.size.width+15, _labelScoreDouban.frame.origin.y, _labelScoreIMDb.frame.size.width, 25);
        }
        originY += 50;
        backViewH += 50;
    }
    else
    {
        //没有豆瓣评分
        if (_labelScoreIMDb.text.length>0)
        {
            //有imdb评分
            _imageIMDb.frame = CGRectMake(20, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+45, 20, 20);
            [_labelScoreIMDb sizeToFit];
            _labelScoreIMDb.frame = CGRectMake(_imageIMDb.frame.origin.x+_imageIMDb.frame.size.width+15, _imageIMDb.frame.origin.y-2.5, _labelScoreIMDb.frame.size.width, 25);
            originY += 50;
            backViewH += 50;
        }
    }
    if (_labelTime.text.length>0)
    {
        _labelTime.frame = CGRectMake(20,originY, SCREEN_WIDTH-40, 12);
        originY += 27;
        backViewH += 27;
    }
    if (self.movieModel.versionList.count>0)
    {
        _viewVersion.frame = CGRectMake(0, originY, SCREEN_WIDTH, 15);
        if (self.movieModel.versionList.count>0)
        {
            //版本
            CGFloat originX = 20;
            CGFloat versionY = _viewVersion.frame.origin.y;
            CGFloat leftVWidth = SCREEN_WIDTH-40;
            for (int k = 0 ; k<self.movieModel.versionList.count; k++)
            {
                CGRect rectFeature = CGRectZero;
                NSString* strFeature = self.movieModel.versionList[k];
                CGFloat featureWidth = [Tool calStrWidth:strFeature height:15] + 10;
                if (featureWidth>leftVWidth)
                {
                    //折行
                    originX = 20;
                    versionY += 25;
                    _viewVersion.frame = CGRectMake(0, originY, SCREEN_WIDTH, _viewVersion.frame.size.height+25);
                }
                rectFeature = CGRectMake(originX, versionY, featureWidth, 15);
                UILabel* labelFeature = [[UILabel alloc]initWithFrame:rectFeature];
                labelFeature.text = strFeature;
                labelFeature.textAlignment = NSTextAlignmentCenter;
                labelFeature.font = MKFONT(9);
                labelFeature.textColor = RGBA(255, 255, 255, 1);
                labelFeature.backgroundColor = RGBA(255, 255, 255, 0.1);
                labelFeature.layer.masksToBounds = YES;
                labelFeature.layer.cornerRadius = 2.0;
                [self addSubview:labelFeature];
                originX += featureWidth+7;
//                if (originX>leftVWidth)
//                {
//                    versionY += 25;
//                    leftVWidth = SCREEN_WIDTH-40;
//                    originX = 20;
//                    _viewVersion.frame = CGRectMake(0, originY, SCREEN_WIDTH, _viewVersion.frame.size.height+25);
//                }
//                else
//                {
                    leftVWidth-=(featureWidth+7);
//                }
            }
        }
        originY += (45+_viewVersion.frame.size.height);
        backViewH += (45+_viewVersion.frame.size.height);
    }
    NSArray* arrTag = self.movieModel.tagList;
    if (arrTag.count>0)
    {
        UIImageView* iconFlag = [self getImageTitleIcon:CGRectMake(20, originY, 2, 14)];
        [self addSubview:iconFlag];
        _labelMovieFlag.frame = CGRectMake(iconFlag.frame.origin.x+iconFlag.frame.size.width+10, iconFlag.frame.origin.y-0.5, 200, 15);
        
        CGFloat flagY = _labelMovieFlag.frame.origin.y+_labelMovieFlag.frame.size.height+15;
        CGFloat leftWidth = SCREEN_WIDTH - 40;
        CGFloat originFlag = 20;
        for (int i = 0; i<arrTag.count; i++)
        {
            UIView* viewFlag = [[UIView alloc]initWithFrame:CGRectZero];
            viewFlag.layer.masksToBounds = YES;
            viewFlag.layer.cornerRadius = 11;
            viewFlag.backgroundColor = RGBA(123, 122, 152, 0.3);
            
            UILabel* labelFlag = [[UILabel alloc]initWithFrame:CGRectZero];
            labelFlag.text = [arrTag[i] tagName];
            labelFlag.font = MKFONT(12);
            labelFlag.textColor = RGBA(255, 255, 255, 0.7);
            [labelFlag sizeToFit];
            if (i<3)
            {
                UIImageView* imageFlag = [[UIImageView alloc]initWithFrame:CGRectMake(10, (22-15)/2, 15, 15)];
                imageFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"poster_tag_%d",i+1]];
                [viewFlag addSubview:imageFlag];
                
                labelFlag.frame = CGRectMake(imageFlag.frame.origin.x+imageFlag.frame.size.width+5, (22-12)/2, labelFlag.frame.size.width, 12);
            }
            else
            {
                labelFlag.frame = CGRectMake(10, (22-12)/2, labelFlag.frame.size.width, 12);
            }
            [viewFlag addSubview:labelFlag];
            
            CGFloat flagW = labelFlag.frame.origin.x+labelFlag.frame.size.width+10;
            if (flagW>leftWidth)
            {
                flagY += (10+44/2);
                leftWidth = SCREEN_WIDTH - 40;
                originFlag = 20;
            }
            viewFlag.frame = CGRectMake(originFlag, flagY, flagW, 22);
            leftWidth -= (flagW+15);
            originFlag += (flagW+15);
            [self addSubview:viewFlag];
        }
        originY = flagY+22+45;
        backViewH = flagY+22+64;
    }
    
    NSMutableArray* arrFirst = [NSMutableArray array];
    NSMutableArray* arrSecond = [NSMutableArray array];
    for (NSString* strDirector in self.movieModel.directorList)
    {
        [arrFirst addObject:@"导演"];
        [arrSecond addObject:strDirector];
    }
    for (NSString* producer in self.movieModel.producerList)
    {
        [arrFirst addObject:@"制片"];
        [arrSecond addObject:producer];
    }
    for (NSString* stractor in self.movieModel.actorList)
    {
        [arrFirst addObject:@"主演"];
        [arrSecond addObject:stractor];
    }
    if (arrFirst.count>0)
    {
        UIImageView* iconTeam = [self getImageTitleIcon:CGRectMake(20, originY, 2, 14)];
        [self addSubview:iconTeam];
        _labelTeam.frame = CGRectMake(iconTeam.frame.origin.x+iconTeam.frame.size.width+10, iconTeam.frame.origin.y-0.5, 200, 15);
        
        CGFloat teamX = 20;
        _scrollTeam.frame = CGRectMake(0, _labelTeam.frame.origin.y+_labelTeam.frame.size.height+15, SCREEN_WIDTH, 34);
        for (int i = 0; i<arrFirst.count; i++)
        {
            UILabel* labelSecond = [[UILabel alloc]initWithFrame:CGRectZero];
            labelSecond.text = arrSecond[i];
            labelSecond.textColor = RGBA(255, 255, 255, 1);
            labelSecond.font = MKFONT(12);
            labelSecond.numberOfLines = 1;
            labelSecond.lineBreakMode = NSLineBreakByTruncatingTail;
            [labelSecond sizeToFit];
            labelSecond.frame = CGRectMake(teamX, 12+10, labelSecond.frame.size.width, 12);
            if (labelSecond.frame.size.width>90)
            {
                labelSecond.frame = CGRectMake(teamX, 12+10, 90, 12);
            }
            [_scrollTeam addSubview:labelSecond];
            
            UILabel* labelFirst = [[UILabel alloc]initWithFrame:CGRectMake(teamX, 0, labelSecond.frame.size.width, 12)];
            labelFirst.text = arrFirst[i];
            labelFirst.textColor = RGBA(255, 255, 255, 0.6);
            labelFirst.font = MKFONT(12);
            labelFirst.textAlignment = NSTextAlignmentCenter;
            [_scrollTeam addSubview:labelFirst];
            
            if (i<arrFirst.count-1)
            {
                teamX += labelSecond.frame.size.width+30;
            }
            else
            {
                teamX += labelSecond.frame.size.width;
            }
        }
        _scrollTeam.contentSize = CGSizeMake(teamX+20, 34);
        originY = _scrollTeam.frame.origin.y+_scrollTeam.frame.size.height+45;
        backViewH = _scrollTeam.frame.origin.y+_scrollTeam.frame.size.height+64;
    }
    
    NSArray* arrStill = self.movieModel.stillList;
    if (arrStill.count>0)
    {
        UIImageView* iconPhoto = [self getImageTitleIcon:CGRectMake(20, originY, 2, 14)];
        [self addSubview:iconPhoto];
        _labelMoviePhoto.frame = CGRectMake(iconPhoto.frame.origin.x+iconPhoto.frame.size.width+10, iconPhoto.frame.origin.y-0.5, 200, 15);

        ScrollViewForStill* scrollPhoto = [[ScrollViewForStill alloc]initWithFrame:CGRectMake(0, _labelMoviePhoto.frame.origin.y+_labelMoviePhoto.frame.size.height+15, SCREEN_WIDTH, 100) arrStill:(NSMutableArray*)arrStill];
        scrollPhoto.backgroundColor = [UIColor clearColor];
        scrollPhoto.pagingEnabled = NO;
        scrollPhoto.showsHorizontalScrollIndicator = NO;
        scrollPhoto.showsVerticalScrollIndicator = NO;
        scrollPhoto._openStillDelegate = self;
        [self addSubview:scrollPhoto];
        
        if (arrStill.count>3)
        {
            //大于3个才显示更多
            _labelScan.text = [NSString stringWithFormat:@"查看全部%lu张图片",(unsigned long)arrStill.count];
            [_labelScan sizeToFit];
            CGFloat scanW = _labelScan.frame.size.width;
            _labelScan.frame = CGRectMake(0, 0, scanW, 20);
            _imageScan.frame = CGRectMake(_labelScan.frame.origin.x+scanW+5, 11/2, 9/2, 18/2);
            _viewScan.frame = CGRectMake(20, scrollPhoto.frame.origin.y+scrollPhoto.frame.size.height+12, _imageScan.frame.origin.x+_imageScan.frame.size.width, 20);
            originY = _viewScan.frame.origin.y+_viewScan.frame.size.height+45;
            backViewH = _viewScan.frame.origin.y+_viewScan.frame.size.height+64;
        }
        else
        {
            originY = scrollPhoto.frame.origin.y+scrollPhoto.frame.size.height+45;
            backViewH = scrollPhoto.frame.origin.y+scrollPhoto.frame.size.height+64;
        }
    }
    
    NSArray* arrTip = self.movieModel.movieViewTipList;
    if (arrTip.count>0)
    {
        UIImageView* iconTip = [self getImageTitleIcon:CGRectMake(20, originY, 2, 14)];
        [self addSubview:iconTip];
        _labelTip.frame = CGRectMake(iconTip.frame.origin.x+iconTip.frame.size.width+10, iconTip.frame.origin.y-0.5, 200, 15);
        
        CGFloat tipY = _labelTip.frame.origin.y+_labelTip.frame.size.height+15;
        for (int i = 0; i<arrTip.count; i++)
        {
            UILabel* labelTip = [[UILabel alloc]initWithFrame:CGRectMake(23+17/2, 0, SCREEN_WIDTH-(23+17/2+20), 0)];
            labelTip.text = arrTip[i];
            labelTip.font = MKFONT(12);
            labelTip.lineBreakMode = NSLineBreakByTruncatingTail;
            labelTip.numberOfLines = 0;
            [Tool setLabelSpacing:labelTip spacing:5 alignment:NSTextAlignmentLeft];
            labelTip.textColor = RGBA(123, 122, 152, 1);
            labelTip.backgroundColor = [UIColor clearColor];
            labelTip.frame = CGRectMake(23+17/2, tipY, SCREEN_WIDTH-(23+17/2+20), labelTip.frame.size.height);
            [self addSubview:labelTip];
            
            UIView* viewPoint = [[UIView alloc]initWithFrame:CGRectMake(20, tipY+6, 3, 3)];
            viewPoint.backgroundColor = RGBA(123, 122, 152, 1);
            viewPoint.layer.masksToBounds = YES;
            viewPoint.layer.cornerRadius = 1.5;
            [self addSubview:viewPoint];
            
            tipY += (labelTip.frame.size.height+8);
        }
        backViewH = 64 + tipY - 8;
    }
    if (backViewH<=SCREEN_HEIGHT)
    {
        backViewH = SCREEN_HEIGHT+1;
    }
    [self initBackView:backViewH];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewH);
    
    [_labelPull sizeToFit];
    _labelPull.frame = CGRectMake((SCREEN_WIDTH-_labelPull.frame.size.width)/2, self.frame.size.height-28, _labelPull.frame.size.width, 14);
    _imageArrow.frame = CGRectMake(_labelPull.frame.origin.x-5-16, _labelPull.frame.origin.y+5/2, 16, 9);
}

-(void)initBackView:(CGFloat)height
{
    UIView* viewAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-883/2, SCREEN_WIDTH, 883/2)];
    UIColor *colorOne = RGBA(20, 24, 28, 0);
    UIColor *colorTwo = RGBA(20, 24, 28, 1);
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, 883/2);
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    [viewAlpha.layer insertSublayer:gradient atIndex:0];
    [self addSubview:viewAlpha];
    
    UIView* backV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height-SCREEN_HEIGHT)];
    backV.backgroundColor = RGBA(20, 24, 28, 1);
    [self addSubview:backV];
    
    [self sendSubviewToBack:viewAlpha];
    [self sendSubviewToBack:backV];
}

-(void)refreshPull:(BOOL)isPull
{
    if (isPull)
    {
        _imageArrow.image = [UIImage imageNamed:@"poster_pull_up.png"];
        _labelPull.text = @"上拉查看短评";
    }
    else
    {
        _imageArrow.image = [UIImage imageNamed:@"poster_pull_down.png"];
        _labelPull.text = @"下拉查看影片详情";
    }
    [_labelPull sizeToFit];
    _labelPull.frame = CGRectMake((SCREEN_WIDTH-_labelPull.frame.size.width)/2, self.frame.size.height-28, _labelPull.frame.size.width, 14);
    _imageArrow.frame = CGRectMake(_labelPull.frame.origin.x-5-16, _labelPull.frame.origin.y+5/2, 16, 9);
}

-(void)tapScanPhoto
{
    if (self.scanStillBlock)
    {
        self.scanStillBlock(self.movieModel);
    }
}

-(UIImageView*)getImageTitleIcon:(CGRect)rect
{
    UIImageView* imageTag = [[UIImageView alloc]initWithFrame:rect];
    imageTag.backgroundColor = [UIColor clearColor];
    imageTag.image = [UIImage imageNamed:@"poster_title_icon.png"];
    return imageTag;
}

-(void)onButtonPlayVideo
{
    if (self.playVideoBlock)
    {
        self.playVideoBlock();
    }
}

-(void)onButtonScan
{
    
}

#pragma mark 打开剧照
-(void)OpenStill:(NSArray *)arrStills ImageIndex:(NSInteger)index
{
    if ([arrStills count] > 20)
    {
        if (index == 19 )
        {
            if (self.scanStillBlock)
            {
                self.scanStillBlock(self.movieModel);
            }
        }
        else
        {
            ImageBrowseViewController *imageBrowseController = [[ImageBrowseViewController alloc]initWithBrowseItemArray:arrStills currentIndex:index];
            imageBrowseController.isEqualRatio = NO;
            [imageBrowseController showBrowseViewController];
        }
    }
    else
    {
        ImageBrowseViewController *imageBrowseController = [[ImageBrowseViewController alloc]initWithBrowseItemArray:arrStills currentIndex:index];
        imageBrowseController.isEqualRatio = NO;
        [imageBrowseController showBrowseViewController];
        
    }
   
}

@end
