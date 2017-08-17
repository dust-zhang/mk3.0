//
//  ChooseSeatShowView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "ChooseSeatShowView.h"

@implementation ChooseSeatShowView

-(id)initWithFrame:(CGRect)frame movieId:(NSNumber*)movieId
{
    self = [super initWithFrame:frame];
    myFrame = frame;
    _movieId = movieId;
    return self;
}

#pragma mark - 加载排期数据
-(void)loadShowtimeData
{
    __weak ChooseSeatShowView *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesShowTime getCinemaMovieShowTime:_movieId cinemaId:[Config getCinemaId] model:^(ShowTimeModel *model)
     {
         [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:NO];
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
         [weakself initControl];
         [weakself refreshData];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1.0];
         //初始化场次获取失败view
         [weakself initFailureView];
     }];
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

-(void)initFailureView
{
    if (!imageFailure)
    {
        imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 60, 60, 60)];
        imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
        [self addSubview:imageFailure];
        
        labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
        labelFailure.text = @"场次加载失败";
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
    }
    else
    {
        imageFailure.hidden = NO;
        labelFailure.hidden = NO;
        btnTryAgain.hidden = NO;
    }
}

-(void)onButtonTryAgain
{
    [self loadShowtimeData];
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
    [_myTable reloadData];
}

#pragma mark - 初始化UI
-(void)initControl
{
    NSMutableArray* dateArray = [[NSMutableArray alloc]init];
    for (NSNumber* number in arrShowDates)
    {
        NSString* theWeekday = [Tool getShowTimeDate:number endTime:showtimeModel.currentTime];//[Tool returnWeek:number];
        NSString* theDate = [Tool returnTime:number format:@"MM月dd日"];
        
//        if ([theWeekday isEqualToString:@"周五"] || [theWeekday isEqualToString:@"周六"] || [theWeekday isEqualToString:@"周日"])
//        {
            theDate = [NSString stringWithFormat:@"%@ %@",theWeekday,theDate];
//        }
        [dateArray addObject:theDate];
    }
    
//    if (!_segmentedControl)
//    {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:dateArray];
//        [self addSubview:_segmentedControl];
//    }
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected)
     {
         NSMutableAttributedString *currAttributeString;
         if(selected)
         {
             NSDictionary *dic1 = [NSDictionary
                                   dictionaryWithObjectsAndKeys:MKFONT(13), NSFontAttributeName,
                                   RGBA(0, 0, 0,1),NSForegroundColorAttributeName,
                                   nil];
             currAttributeString = [[NSMutableAttributedString alloc]initWithString:title attributes:dic1];
         }
         else
         {
             NSDictionary *dic1 = [NSDictionary
                                   dictionaryWithObjectsAndKeys:MKFONT(13), NSFontAttributeName,
                                   RGBA(123, 122, 152, 0.6),NSForegroundColorAttributeName,
                                   nil];
             currAttributeString = [[NSMutableAttributedString alloc]initWithString:title attributes:dic1];
         }
         return currAttributeString;
     }];
    
    _segmentedControl.frame = CGRectMake(0 ,0, SCREEN_WIDTH, 40);
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _segmentedControl.selectionIndicatorColor = RGBA(117, 112, 255, 1);
    _segmentedControl.selectionIndicatorHeight = 2.0f;
    _segmentedControl.selectedSegmentIndex = self.dateSelectedIndex;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *titleTextAttributes = [NSDictionary
                                         dictionaryWithObjectsAndKeys:MKFONT(15), NSFontAttributeName,
                                         RGBA(135, 132, 130,1),NSForegroundColorAttributeName,
                                         nil];
    
    NSDictionary *titleSelectedTextAttributes = [NSDictionary
                                                 dictionaryWithObjectsAndKeys:MKFONT(15), NSFontAttributeName,
                                                 RGBA(51, 51, 51,1),NSForegroundColorAttributeName,
                                                 nil];
    
    _segmentedControl.titleTextAttributes = titleTextAttributes;
    _segmentedControl.selectedTitleTextAttributes = titleSelectedTextAttributes;
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(20, 15, 20, 15);
    [self addSubview:_segmentedControl];
    
    [_segmentedControl scrollDate:_dateSelectedIndex];
    
    [self initTable];
}

#pragma mark - segmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl
{
    _dateSelectedIndex = segmentedControl.selectedSegmentIndex;
    
    if (arrShowTimes.count > _dateSelectedIndex)
    {
        _myTable.hidden = NO;
        [_myTable setContentOffset:CGPointMake(0,0) animated:NO];
        [_myTable reloadData];
    }
}

-(void)initTable
{
    if (!_myTable)
    {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, myFrame.size.height-40)];
        _myTable.dataSource = self;
        _myTable.delegate = self;
        _myTable.backgroundColor = [UIColor clearColor];
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_myTable];
    }
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrShowTimes[_dateSelectedIndex] showtimes] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"ChooseSeatTableViewCell%ld%ld",(long)_dateSelectedIndex,(long)indexPath.row];
    ChooseSeatTableViewCell *cell = (ChooseSeatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[ChooseSeatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:[arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row]];
    BOOL isLastCell = NO;
    if (indexPath.row == [[arrShowTimes[_dateSelectedIndex] showtimes] count] - 1)
    {
        isLastCell = YES;
    }
    [cell layoutFrame:isLastCell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLastCell = NO;
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
    if (isLastCell)
    {
        return space+150+27/2;
    }
    else
    {
        return space+90;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:mainViewbtn29];
    ShowTimesModel* showTModel = [arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row];
    if ([self.showViewDelegate respondsToSelector:@selector(reloadSeat:)])
    {
        [self.showViewDelegate reloadSeat:showTModel];
    }
//    ChooseSeatViewController *chooseSeat = [[ChooseSeatViewController alloc]init];
//    ShowTimesModel* showTModel = [arrShowTimes[_dateSelectedIndex] showtimes][indexPath.row];
//    chooseSeat.showtimeId = [showTModel.showtimeId integerValue];
//    chooseSeat.movieId = _hotMovieModel.movieId;
//    [_nav pushViewController:chooseSeat animated:YES];
}

@end
