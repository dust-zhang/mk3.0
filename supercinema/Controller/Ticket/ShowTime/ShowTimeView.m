//
//  ShowTimeView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/7.
//
//

#import "ShowTimeView.h"

@interface ShowTimeView ()

@end

@implementation ShowTimeView

-(id)initWithFrame:(CGRect)frame movieListModel:(MovieModel*)hotMovieModel navigation:(UINavigationController *)navigation
{
    self = [super initWithFrame:frame];
    self.myFrame = frame;
    _nav = navigation;
    self.backgroundColor = [UIColor whiteColor];
    _hotMovieModel = hotMovieModel;
    _dateSelectedIndex = 0;
    return self;
}

#pragma mark - 加载排期数据
-(void)loadShowtimeData
{
    __weak ShowTimeView *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载排期，请稍候" withBlur:NO allowTap:NO];
    [ServicesShowTime getCinemaMovieShowTime:_hotMovieModel.movieId cinemaId:[Config getCinemaId] model:^(ShowTimeModel *model)
     {
         arrShowDates = model.showDates;
         arrShowTimes = model.showtimes;
         movieInfo = model.movie;
         showtimeModel = model;
         for (DateShowTimeModel* dataSTModel in arrShowTimes)
         {
             for (ShowTimesModel* model in dataSTModel.showtimes)
             {
                 model.showTimeType = @"3";
             }
         }
         [weakself getMorningAndNight];
         [ServicesMovie getConsumeTips:[Config getCinemaId] arrTips:^(NSArray *array) {
             [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
             weakself.arrRemind = array;
             [weakself initControl];
             [weakself refreshData];
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
             [weakself initControl];
             [weakself refreshData];
         }];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.superview fading:YES];
         //初始化场次获取失败view
         [weakself initFailureView:error.code];
     }];
}

-(void)initFailureView:(NSInteger)code
{
    if (!imageFailure)
    {
        self.backgroundColor = RGBA(248, 248, 252, 1);
        
        imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 100, 60, 60)];
        imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
        [self addSubview:imageFailure];
        
        labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
        labelFailure.textColor = RGBA(123, 122, 152, 1);
        labelFailure.font = MKFONT(14);
        labelFailure.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelFailure];
        
        btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, labelFailure.frame.origin.y+labelFailure.frame.size.height+30, 146/2, 24);
        [btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
        [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnTryAgain.titleLabel.font = MKFONT(14);
        btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
        btnTryAgain.layer.masksToBounds = YES;
        btnTryAgain.layer.cornerRadius = btnTryAgain.frame.size.height/2;
        [btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTryAgain];
        
        if (code == -19)
        {
            //影院没有排期页面
            btnTryAgain.hidden = YES;
            labelFailure.text = @"本影院暂无该片排期";
        }
        else
        {
            //场次加载失败
            labelFailure.text = @"场次加载失败";
        }
    }
    else
    {
        if (code == -19)
        {
            //影院没有排期页面
            btnTryAgain.hidden = YES;
            labelFailure.text = @"本影院暂无该片排期";
        }
        else
        {
            //场次加载失败
            labelFailure.text = @"场次加载失败";
        }
        imageFailure.hidden = NO;
        labelFailure.hidden = NO;
    }
}

-(void)onButtonTryAgain
{
    [self loadShowtimeData];
}

-(void)getMorningAndNight
{
    for (DateShowTimeModel* dataSTModel in arrShowTimes)
    {
        for (ShowTimesModel* model in dataSTModel.showtimes)
        {
            //算出第一场早场
            NSString *strHour = [Tool returnTime:model.startPlayTime format:@"HH"];
            if ([strHour intValue] < 18 && [strHour intValue] >= 6)
            {
                model.showTimeType = @"0";
                break;
            }
        }
        for (ShowTimesModel* model in dataSTModel.showtimes)
        {
            //算出第一场晚场
            NSString *strHour = [Tool returnTime:model.startPlayTime format:@"HH"];
            if ([strHour intValue] >= 18 && [strHour intValue] < 24)
            {
                model.showTimeType = @"1";
                break;
            }
        }
        for (ShowTimesModel* model in dataSTModel.showtimes)
        {
            //算出第一场次日
            NSString *strHour = [Tool returnTime:model.startPlayTime format:@"HH"];
            if ([strHour intValue] >= 0 && [strHour intValue] < 6)
            {
                model.showTimeType = @"2";
                break;
            }
        }
    }
}

#pragma mark - 刷新数据
-(void)refreshData
{
    if (imageFailure)
    {
        imageFailure.hidden = YES;
        labelFailure.hidden = YES;
        btnTryAgain.hidden = YES;
    }
    self.backgroundColor = [UIColor whiteColor];
    
    [_myTable reloadData];
    
//    [self setScrollContentHeight];
}

//-(void)setScrollContentHeight
//{
//    CGFloat tableContentHeight = [self getTableViewHeight];
//    NSLog(@"%f",tableContentHeight);
//}
//
//-(float)getTableViewHeight
//{
//    [_myTable layoutIfNeeded];
//    return _myTable.contentSize.height;
//}

#pragma mark - 初始化UI
-(void)initControl
{
    //
    CGFloat tableY = 0;
    if (_arrRemind.count>0)
    {
        UIView* viewRemind = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        viewRemind.backgroundColor = [UIColor whiteColor];
        [self addSubview:viewRemind];
        
        UIImageView* imageRemind = [[UIImageView alloc]initWithFrame:CGRectMake(15, (viewRemind.frame.size.height-29/2)/2, 35/2, 29/2)];
        imageRemind.userInteractionEnabled = YES;
        imageRemind.image = [UIImage imageNamed:@"img_showtime_notify.png"];
        [viewRemind addSubview:imageRemind];
        
        CGFloat scrollX = imageRemind.frame.origin.x+imageRemind.frame.size.width+10;
        VierticalScrollView *scroView = [VierticalScrollView initWithTitleArray:_arrRemind AndFrame:CGRectMake(scrollX, 0, SCREEN_WIDTH-scrollX-10, viewRemind.frame.size.height)];
        scroView.userInteractionEnabled = YES;
        scroView.delegate =self;
        [viewRemind addSubview:scroView];
        
        UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, scroView.frame.origin.y+scroView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
        viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
        [viewRemind addSubview:viewLine];
        
        UITapGestureRecognizer* tapRemind = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showRemind)];
        [viewRemind addGestureRecognizer:tapRemind];
        
        tableY = viewRemind.frame.size.height;
    }
    
    if (!_myTable)
    {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, self.myFrame.size.height-tableY)];
        _myTable.dataSource = self;
        _myTable.delegate = self;
        //    _myTable.separatorColor = _defaultColor;
        _myTable.backgroundColor =  RGBA(248, 248, 252, 1);
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self addSubview:_myTable];
}

-(void)showRemind
{
    __weak typeof(self) weakSelf = self;
    
    self.viewCover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewCover.backgroundColor = RGBA(0, 0, 0, 0.6);
    self.viewCover.hidden = YES;
    [self.window addSubview:self.viewCover];
    
    self.spendView = [[SpendRemindView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) arrRemind:_arrRemind];
    self.spendView.hidden=YES;
    self.spendView.alpha = 0;
    self.spendView.transform = CGAffineTransformMakeScale(0.7,0.7);
    [self.spendView setHideSpend:^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.spendView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                             weakSelf.spendView.hidden=NO;
                             weakSelf.spendView.alpha=0;
                         }completion:^(BOOL finish){
                             weakSelf.spendView.hidden = YES;
                             weakSelf.viewCover.hidden = YES;
                             [weakSelf.spendView removeFromSuperview];
                         }];
    }];
    [self.window addSubview:self.spendView];
    self.viewCover.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.spendView.transform = CGAffineTransformMakeScale(1,1);
                         weakSelf.spendView.hidden=NO;
                         weakSelf.spendView.alpha=1;
                     }completion:^(BOOL finish){
                         
                     }];
}

-(void)clickTitleButton:(UIButton *)button
{
    [self showRemind];
}

-(UIView*)getHeaderV
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        scrollDate = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 57.5)];
        scrollDate.backgroundColor = [UIColor clearColor];
        scrollDate.showsHorizontalScrollIndicator = NO;
        [_headerView addSubview:scrollDate];
        
        _viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, scrollDate.frame.origin.y+scrollDate.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
        _viewLine2.backgroundColor = RGBA(0, 0, 0, 0.05);
        [_headerView addSubview:_viewLine2];
        
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 57.5+15);
        
        [self initDateUI];
    }
    return _headerView;
}

#pragma mark - 初始化日期UI
-(void)initDateUI
{
    [arrWeek removeAllObjects];
    
    NSMutableArray* arrDateBtn = [[NSMutableArray alloc]init];
    arrWeek = [[NSMutableArray alloc]init];
    for (NSNumber* number in arrShowDates)
    {
        NSString* theWeekday = [Tool returnWeek:number];
        NSString* theDate = [Tool returnTime:number format:@"dd"];
        [arrDateBtn addObject:theDate];
        [arrWeek addObject:theWeekday];
    }
    
    CGFloat spaceDateBtn = (SCREEN_WIDTH-30-36*5)/4;
    
    [scrollDate setContentSize:CGSizeMake(30+arrDateBtn.count*36+(arrDateBtn.count-1)*spaceDateBtn, 57.5)];
    
    for (int i = 0; i<arrWeek.count; i++)
    {
        UILabel* labelDate = [[UILabel alloc]initWithFrame:CGRectMake(15+(36+spaceDateBtn)*i, 0, 36, 10)];
        labelDate.text = [Tool getShowTimeDate:arrShowDates[i] endTime:showtimeModel.currentTime];//arrWeek[i];
        labelDate.textAlignment = NSTextAlignmentCenter;
        labelDate.textColor = RGBA(123, 122, 152, 1);
        labelDate.font = MKFONT(10);
        [scrollDate addSubview:labelDate];
        
        UIButton* btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDate.frame = CGRectMake(labelDate.frame.origin.x, labelDate.frame.size.height+12-(36-15)/2, 36, 36);
        [btnDate setTitle:arrDateBtn[i] forState:UIControlStateNormal];
        [btnDate setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
        btnDate.titleLabel.font = MKFONT(15);
        btnDate.layer.masksToBounds = YES;
        btnDate.layer.cornerRadius = btnDate.frame.size.height/2;
        [btnDate setBackgroundImage:[UIImage imageNamed:@"btn_dateBack.png"] forState:UIControlStateSelected];
        btnDate.tag = 100+i;
        [btnDate addTarget:self action:@selector(onButtonDate:) forControlEvents:UIControlEventTouchUpInside];
        [scrollDate addSubview:btnDate];
        
        if (i == 0)
        {
            btnDate.selected = YES;
            labelDate.textColor = RGBA(123, 122, 152, 1);
            [btnDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        if ([arrWeek[i] isEqualToString:@"周五"] || [arrWeek[i] isEqualToString:@"周六"] || [arrWeek[i] isEqualToString:@"周日"])
        {
            [btnDate setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
            if (i == 0)
            {
                [btnDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            labelDate.textColor = RGBA(117, 112, 255, 1);
        }
    }
}

-(void)onButtonDate:(UIButton*)btn
{
    [MobClick event:mainViewbtn24];
    _dateSelectedIndex = btn.tag - 100;
    for (int i = 0; i<arrShowDates.count; i++)
    {
        UIButton* buttonDate = (UIButton*)[self viewWithTag:(100+i)];
        if (buttonDate.tag == btn.tag)
        {
            buttonDate.selected = YES;
            [buttonDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            buttonDate.selected = NO;
            if ([arrWeek[i] isEqualToString:@"周五"] || [arrWeek[i] isEqualToString:@"周六"] || [arrWeek[i] isEqualToString:@"周日"])
            {
                [buttonDate setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
            }
            else
            {
                [buttonDate setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
            }
        }
    }
    [_myTable reloadData];
    
//    [self setScrollContentHeight];
}

#pragma mark TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [[arrShowTimes[_dateSelectedIndex] showtimes] count];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString* iden = @"ShowTimeHeadCell";
        ShowTimeHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil)
        {
            cell = [[ShowTimeHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:showtimeModel.cinema];
        
        return cell;
    }
    else
    {
        NSString* identifier = [NSString stringWithFormat:@"ShowTimeCell%ld%ld",(long)_dateSelectedIndex,(long)indexPath.row];
        ShowTimeCell* cell = (ShowTimeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[ShowTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:[arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row]] ;//str:str];
        int isLastCell = 3;
        if ([[arrShowTimes[_dateSelectedIndex] showtimes] count] == 1)
        {
            //唯一一个cell
            isLastCell = 2;
        }
        else
        {
            if (indexPath.row == [[arrShowTimes[_dateSelectedIndex] showtimes] count] - 1)
            {
                isLastCell = 1;
            }
            if (indexPath.row == 0)
            {
                isLastCell = 0;
            }
        }
        [cell layoutFrame:isLastCell];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CGSize sizeCinema = [Tool CalcString:showtimeModel.cinema.cinemaName fontSize:MKFONT(16) andWidth:SCREEN_WIDTH-30];
        CGSize sizeAddress = [Tool CalcString:showtimeModel.cinema.cinemaAddress fontSize:MKFONT(12) andWidth:SCREEN_WIDTH-30];
        return 10+10+sizeCinema.height+15+sizeAddress.height+15;
    }
    else
    {
        int isLastCell = 3;
        if ([[arrShowTimes[_dateSelectedIndex] showtimes] count] == 1)
        {
            //唯一一个cell
            isLastCell = 2;
        }
        else
        {
            if (indexPath.row == [[arrShowTimes[_dateSelectedIndex] showtimes] count] - 1)
            {
                isLastCell = 1;
            }
            if (indexPath.row == 0)
            {
                isLastCell = 0;
            }
        }
        
        ShowTimesModel* model = [arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row];
        CGFloat space = 0;
        if (![model.showTimeType isEqualToString:@"3"])
        {
            space = 32;
        }
        if (indexPath.row == [[arrShowTimes[_dateSelectedIndex] showtimes] count] - 1)
        {
            isLastCell = YES;
        }
        if (isLastCell == 1)
        {
            //最后一个cell
            return space+150+27/2;
        }
        else if (isLastCell == 0)
        {
            //第一个cell
            return space+90+30;
        }
        else if (isLastCell == 2)
        {
            //唯一cell
            return space+150+27/2+30;
        }
        else
        {
            return space+90;
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 57.5+15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        return [self getHeaderV];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [MobClick event:mainViewbtn25];
        ChooseSeatViewController *chooseSeat = [[ChooseSeatViewController alloc]init];
        ShowTimesModel* showTModel = [arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row];
//        displayPriceListModel* firstPriceModel = [showTModel.displayPriceList objectAtIndex:0];
        chooseSeat.showTimesModel = showTModel;
        chooseSeat.movieId = _hotMovieModel.movieId;
//        chooseSeat.cardId = [firstPriceModel.cinemaCardId integerValue];
//        chooseSeat.ticketPrice = [firstPriceModel.priceBasic integerValue] + [firstPriceModel.priceService integerValue];
//        chooseSeat.servicePrice = [firstPriceModel.priceService integerValue];
        chooseSeat.dataModel = showtimeModel;
        chooseSeat.isFirstLoad = YES;
        chooseSeat.dateIndex = _dateSelectedIndex;
        __weak ShowTimeView *weakself = self;
        [chooseSeat setLoginBackBlock:^{
            [_myTable removeFromSuperview];
            [weakself loadShowtimeData];
        }];
        [_nav pushViewController:chooseSeat animated:YES];
    }
}

@end
