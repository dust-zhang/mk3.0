//
//  GlobalSearchViewController.m
//  supercinema
//
//  Created by dust on 16/11/7.
//
//

#import "GlobalSearchViewController.h"

@interface GlobalSearchViewController ()

@end

@implementation GlobalSearchViewController

-(void) viewDidAppear:(BOOL)animated
{
    if( [[Config getLocationInfo] objectForKey:@"longitude"] ==nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] == 0 )
    {
        [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
    }
    
}
-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[[Config getLocationInfo] objectForKey:@"longitude"]);
    //本地存在定位信息
    if( [[Config getLocationInfo] objectForKey:@"longitude"] !=nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] >0 )
    {
        if ([self._searchBar._textFieldSearchInput.text length] == 0)
        {
            [self getCinemaList:[[Config getLocationInfo] objectForKey:@"longitude"] latitude:[[Config getLocationInfo] objectForKey:@"latitude"]];
        }
    }
    else
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self._window withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [self location];
        [self configLocationManager];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor] ];
    [self._labelTitle setText:@"搜索"];
    _strLocationCity = @"北京市";
    _strSelectCityId = @"1";
    _strLocationCityId=@"1";
    //读取本地最后选择城市
    [self readLocationCity];
    
    [self initController];
    //是否点击了搜索状态
    _isSearch = FALSE;
    self._window = [[UIApplication sharedApplication].windows lastObject];
    
    self._latitude = @"";
    self._longitude = @"";
    _arrHistory     = [[NSMutableArray alloc ] initWithCapacity:0];
    _arrHistory = [Config getSearchHistory];
    
    _arrOftenCinema = [[NSMutableArray alloc ] init];
    _arrMovie       = [[NSMutableArray alloc ] init];
    _arrUser        = [[NSMutableArray alloc ] init];
    _arrCinema      = [[NSMutableArray alloc ] init];
    
    [self initNoDataViewController];
}

-(void) readLocationCity
{
    NSMutableArray *arr = [[NSMutableArray alloc ] initWithArray:[Config getSearchCity]];
    
    if ([arr count] > 0)
    {
        _strLocationCity = arr[0];
        [ServicesSearch readCityList:^(CityModel *model)
         {
             citylistModel *cityModel = [[citylistModel alloc ] init];
             
             for (cityModel in model.citylist)
             {
                 if ([cityModel.name isEqualToString:_strLocationCity])
                 {
                     _strSelectCityId =[ cityModel.id stringValue];
                 }
             }
         } failure:^(NSError *error) {
             
         }];
    }
}
#pragma mark 配置定位信息
-(void)location
{
    __block GlobalSearchViewController  *weakSelf = self;
    self._completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
                if ([self._searchBar._textFieldSearchInput.text length] == 0)
                {
                    [weakSelf getCinemaList:@"" latitude:@""];
                    return;
                }
            }
        }
        //得到定位信息
        if (location)
        {
            [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
            [weakSelf getCityId:[NSString stringWithFormat:@"%@",regeocode.citycode]];
            weakSelf._longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            weakSelf._latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            if ([self._searchBar._textFieldSearchInput.text length] == 0)
            {
                [weakSelf getCinemaList:weakSelf._longitude latitude:weakSelf._latitude];
                [weakSelf saveLoacationPostion:weakSelf._longitude latitude:weakSelf._latitude citycode:[NSString stringWithFormat:@"%@",regeocode.citycode]];
            }
        }
    };
}

-(void)saveLoacationPostion:(NSString *)longitude latitude:(NSString *)latitude citycode:(NSString *)citycode
{
    NSDictionary *dic = @{@"longitude":longitude,
                          @"latitude":latitude,
                          @"citycode":citycode};
    
    if ([[Tool urlIsNull:longitude] length] > 0 &&
        [[Tool urlIsNull:latitude] length] > 0 &&
        [[Tool urlIsNull:citycode] length] > 0)
    {
        [Config saveLocationInfo:dic];
    }
}

-(void ) getCityId:(NSString *)cityCode
{
    [ServicesSearch readCityList:^(CityModel *model)
     {
         citylistModel *cityModel = [[citylistModel alloc ] init];
         
         for (cityModel in model.citylist)
         {
             if ([cityModel.cityCode isEqualToString:cityCode])
             {
                 _strLocationCityId =[ cityModel.id stringValue];
             }
         }
     } failure:^(NSError *error) {
         
     }];
    
}

- (void)configLocationManager
{
    self._locationManager = [[AMapLocationManager alloc] init];
    [self._locationManager setDelegate:self];
    //设置期望定位精度
    [self._locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self._locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    [self._locationManager setAllowsBackgroundLocationUpdates:NO];
    //设置定位超时时间
    [self._locationManager setLocationTimeout:6];
    //设置逆地理超时时间
    [self._locationManager setReGeocodeTimeout:3];
}


#pragma mark 创建无数据UI
-(void) initNoDataViewController
{
    _imageView= [[UIImageView alloc ] init];
    _imageView.frame = CGRectMake(SCREEN_WIDTH/2-(78/4),self._viewTop.frame.size.height+ 200, 78/2, 135/2);
    [_tableViewCinema addSubview:_imageView];
    [_imageView setHidden:YES];
    
    _labelDesc = [[UILabel alloc ] init];
    _labelDesc.frame = CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+15, SCREEN_WIDTH, 14);
    [_labelDesc setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDesc setTextAlignment:NSTextAlignmentCenter];
    [_labelDesc setFont:MKFONT(14)];
    [_tableViewCinema addSubview:_labelDesc];
    [_labelDesc setHidden:YES];
    
}

#pragma mark 加载失败 显示UI
-(void) loadNoSearchDataUI:(BOOL ) ShowHide
{
    int historyHeight=0;
    [_labelDesc setHidden:ShowHide];
    [_imageView setHidden:ShowHide];
    
    if(!_isSearch)
    {
        [_imageView setImage:[UIImage imageNamed:@"image_NoDataCinema.png"]];
        [_labelDesc setText:@"暂无当前城市影院信息"];
        if ([_arrHistory count]>3)
        {
            historyHeight = 150;
        }
       if ([_arrHistory count]>0 && [_arrHistory count] <= 3)
        {
            historyHeight = 100;
        }
        _imageView.frame = CGRectMake(SCREEN_WIDTH/2-(104/4),self._viewTop.frame.size.height+ [_arrOftenCinema count] *(IPhone5 ?85:90)+  historyHeight, 104/2, 152/2);
        _labelDesc.frame = CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+15, SCREEN_WIDTH, 40);
    }
    else
    {
        _imageView.frame = CGRectMake(SCREEN_WIDTH/2-(104/4),self._viewTop.frame.size.height+ 150, 104/2, 152/2);
        [_imageView setImage:[UIImage imageNamed:@"image_NoDataCinemaSearch.png"]];
        
        _labelDesc.frame = CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+15, SCREEN_WIDTH, 40);
        [_labelDesc setText:@"就算一无所获,也别放弃寻找。\n譬如：换个关键词试试......"];
        [_labelDesc setNumberOfLines:0];
        [_labelDesc setLineBreakMode:NSLineBreakByCharWrapping];
        [Tool setLabelSpacing:_labelDesc spacing:4 alignment:NSTextAlignmentCenter];
    }
}

#pragma mark 加载失败
-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/4, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            
            if ([ws._searchBar._textFieldSearchInput.text length] == 0 )
            {
                [ws getCinemaList:ws._longitude latitude:ws._latitude];
            }
            else
            {
                [ws inputSearchText:ws._searchBar._textFieldSearchInput.text];
            }
            
        }];
        [_tableViewCinema addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}


//创建UI控件
-(void)initController
{
    [self._labelLine setHidden:YES];
    self._searchBar = [[ExUISearchBar alloc ] initWithFrame:CGRectMake(15, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+16, SCREEN_WIDTH-30, 30)];
    self._searchBar.seatchBarDelegate = self;
    [self._searchBar._textFieldSearchInput addTarget:self action:@selector(searchChangeCinema:) forControlEvents:UIControlEventEditingChanged];
    [self._searchBar._textFieldSearchInput setPlaceholder:@"可搜索影院、最新电影以及用户"];
    [self.view addSubview:self._searchBar];
    
    UILabel *labelLine= [[UILabel alloc ] initWithFrame:CGRectMake(0, self._searchBar.frame.origin.y+self._searchBar.frame.size.height+5 , SCREEN_WIDTH, 0.5)];
    [labelLine setBackgroundColor:RGBA(0,0,0,0.05)];
    [self.view addSubview:labelLine];
    
    //搜索结果列表
    _tableViewCinema = [[UITableView alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(self._searchBar.frame.origin.y+self._searchBar.frame.size.height+15) )];
    _tableViewCinema.delegate = self;
    _tableViewCinema.dataSource = self;
    _tableViewCinema.backgroundColor =[UIColor whiteColor];
    _tableViewCinema.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewCinema];

}
-(void)searchChangeCinema:(UITextField *)TextField
{
    _arrHistory = [Config getSearchHistory];
    if ([TextField.text length] == 0)
    {
        _isSearch = FALSE;
        [_arrCinema removeAllObjects];
        [_arrUser removeAllObjects];
        [_arrOftenCinema removeAllObjects];
        [_arrMovie removeAllObjects];
        
        [self getCinemaList:self._longitude latitude:self._latitude];
        [self._searchBar._btnClear setHidden:YES];
    }
    else
    {
        [self._searchBar._btnClear setHidden:NO];
    }
}

#pragma mark 定位
-(void)onButtonLocation
{
    [MobClick event:mainViewbtn12];
    CitySelectViewController *citySelectVC = [[CitySelectViewController alloc]init];
    citySelectVC.hidesBottomBarWhenPushed = YES;
    //Block接收值
    citySelectVC.selectCity = ^(NSString *cityName)
    {
        if ([cityName length] > 0)
        {
            [_btnLocation setTitle:cityName forState:UIControlStateNormal];
        }
        else
        {
            [_btnLocation setTitle:[NSString stringWithFormat:@"请定位"] forState:UIControlStateNormal];
        }
    };
    
    [self.navigationController pushViewController:citySelectVC animated:YES];
}

#pragma mark 输入查找内容
-(void)searchCinema:(NSString *)inputContent
{
    _arrHistory = [Config getSearchHistory];
    NSString *keyWords = inputContent;
    if(keyWords.length >= 1)
    {
        _isSearch = TRUE;
        [self inputSearchText:inputContent];
    }
    else
    {
        _isSearch = FALSE;
        [_arrCinema removeAllObjects];
        [_arrOftenCinema removeAllObjects];
        [_arrMovie removeAllObjects];
        [_arrUser removeAllObjects];
        _arrHistory = [Config getSearchHistory];
        [self getCinemaList:self._longitude latitude:self._latitude];
    }
}

#pragma mark 获取推荐影院和常去影院
-(void)getCinemaList:(NSString *)longitude latitude:(NSString *)latitude
{
    NSLog(@"%@",self._searchBar._textFieldSearchInput.text);
    
    if ([self._searchBar._textFieldSearchInput.text length] == 0 )
    {
        __weak typeof(self) weakSelf = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:weakSelf._window withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [ServicesCinema getOftenRecommendCinema:_strSelectCityId latitude:latitude longitude:longitude locationCityId:_strLocationCityId model:^(OftenRecommendCinemaModel *model)
         {
             [_arrOftenCinema removeAllObjects];
             [_arrCinema removeAllObjects];
             
             _arrOftenCinema= [[NSMutableArray alloc ] initWithArray:model.mostVisitCinemaList];
             _arrCinema = [[NSMutableArray alloc ] initWithArray:model.recommendCinemaList];
             [_tableViewCinema reloadData];
             
             //没有数据
             if ([_arrCinema count] <= 0 )
             {
                 [weakSelf loadNoSearchDataUI:NO];
             }
             else
             {
                 [weakSelf loadNoSearchDataUI:YES];
             }
             _viewLoadFailed.hidden = YES;
             [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
             
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
             [Tool showWarningTip:error.domain time:1];
             [_tableViewCinema reloadData];
             [weakSelf initFailureView];
         }];
    }
   
}

#pragma mark 查找输入内容
-(void) inputSearchText:(NSString *) content
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:weakSelf._window withTitle:@"加载中..."  withBlur:NO allowTap:NO];
    [ServicesSearch searchAllInfo:content cityId:_strSelectCityId latitude:self._latitude longitude:self._longitude lastVisitCinemaId:[Config getCinemaId] model:^(SearchModel *model)
     {
         [_arrUser removeAllObjects];
         [_arrMovie removeAllObjects];
         [_arrCinema removeAllObjects];
         
         _searchModel = model;
         _totalUser = [model.totalOfUser intValue];
         _totalMovie = [model.totalOfMovie intValue];
         _totalCinema = [model.totalOfCinema intValue];
         
         _arrUser = [NSMutableArray arrayWithArray:model.userList];
         _arrMovie = [NSMutableArray arrayWithArray:model.movieList];
         _arrCinema =[NSMutableArray arrayWithArray:model.cinemaList];
         [_tableViewCinema reloadData];
         
         //没有数据
         if ([_arrUser count] <= 0 && [_arrMovie count] <= 0 && [_arrCinema count] <= 0 )
         {
             [weakSelf loadNoSearchDataUI:NO];
         }
         else
         {
             [weakSelf loadNoSearchDataUI:YES];
         }
         [weakSelf saveSearchRecord];
         _viewLoadFailed.hidden = YES;
         [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf._window fading:YES];
         [_arrUser removeAllObjects];
         [_arrMovie removeAllObjects];
         [_arrCinema removeAllObjects];
         [weakSelf saveSearchRecord];
         [weakSelf initFailureView];
         [_tableViewCinema reloadData];
         [Tool showWarningTip:error.domain time:1];
         
     }];
    
}

#pragma mark UITableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //没有点击搜索
    if(!_isSearch)
    {
        //只有搜索历史、没有常去影院
        if ([_arrHistory  count] > 0  && [_arrOftenCinema count] == 0)
        {
            return [_arrCinema count]+3;
        }//有搜索历史和常去影院
        else if([_arrHistory  count] > 0  && [_arrOftenCinema count] > 0)
        {
            return [_arrCinema count]+3 + [_arrOftenCinema count]+2;
        }//没有搜索历史、有常去影院
        else if([_arrHistory  count] == 0  && [_arrOftenCinema count] > 0)
        {
            return [_arrCinema count]+1 + [_arrOftenCinema count]+2;
        }
        else
        {
            return [_arrCinema count]+1;
        }
    }
    else
    {
        //只搜索到影院
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] == 0)
        {
            return [_arrCinema count]+2;
        }
        //只有影片
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
            return [_arrMovie count]+2;
        }
        //只有用户
        if ([_arrCinema count] == 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            return [_arrUser count]+2;
        }
        //只有影片和用户
        if( [_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] > 0)
        {
            return [_arrUser count]+ [_arrMovie count] +5;
        }
        if( [_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            return [_arrUser count]+ [_arrCinema count] +5;
        }
        if(  [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] == 0 )
        {
            return [_arrCinema count]+ [_arrMovie count] +5;
        }
        if(  [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] > 0 )
        {
            return [_arrCinema count]+ [_arrMovie count] + [_arrUser count]  +8;
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //没有点击搜索
    if(!_isSearch)
    {
        //有搜索记录,不存在常去影院
        if ([_arrHistory  count] > 0  && [_arrOftenCinema count] == 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setHistory:_arrHistory];
                return cell;
            }
            else if (indexPath.row == 1)
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
            }
            else if (indexPath.row == 2)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"推荐影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-3];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
        else if([_arrHistory  count] > 0  && [_arrOftenCinema count] > 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setHistory:_arrHistory];
                return cell;
            }
            else if (indexPath.row == 1)
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
            }
            else if (indexPath.row == 2)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"常去影院" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if (indexPath.row >2 && indexPath.row <= [_arrOftenCinema count]+2)
            {
                //                NSLog(@"%ld    %ld",indexPath.row,[_arrOftenCinema count]+2);
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-3];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
            else if (indexPath.row == [_arrOftenCinema count]+3)
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
            }
            else if (indexPath.row == [_arrOftenCinema count]+4)
            {
                //                NSLog(@"%ld    %ld",indexPath.row,[_arrOftenCinema count]+4);
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"推荐影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else
            {
                //                NSLog(@"%ld  %ld",indexPath.row,indexPath.row-([_arrOftenCinema count]+5));
                if ( (indexPath.row-([_arrOftenCinema count]+5) ) < [_arrCinema count])
                {
                    SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-([_arrOftenCinema count]+5)];
                    [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                    return cell;
                }
            }
        }
        else if([_arrHistory  count] == 0  && [_arrOftenCinema count] > 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"常去影院" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if (indexPath.row >0 && indexPath.row < [_arrOftenCinema count]+1)
            {
                //                NSLog(@"%ld    %ld",indexPath.row,indexPath.row-1);
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
            else if (indexPath.row == [_arrOftenCinema count]+1)
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
            }
            else if (indexPath.row == [_arrOftenCinema count]+2)
            {
                SearchHistoryTableViewCell *cell =[[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"推荐影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else
            {
                //                NSLog(@"%ld    %ld",indexPath.row,[_arrOftenCinema count]+3);
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-([_arrOftenCinema count]+3)];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell =[[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"推荐影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
    }
    else
    {
        //只搜索到影院
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] == 0)
        {
            if(indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if([_arrCinema count] <  [_searchModel.totalOfCinema intValue])
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                else
                {
                    [cell setReommmedCinema:@"" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
            else
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
        //只有影片
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
            if(indexPath.row == 0)
            {
                //                NSLog(@"%ld    %ld",indexPath.row,[_arrOftenCinema count]+4);
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"电影" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row == [_arrMovie count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if([_arrMovie count] <  [_searchModel.totalOfMovie intValue])
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                else
                {
                    [cell setReommmedCinema:@"" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
                
            }
            else
            {
                MovieTableViewCell *cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell._buyTicketDelegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                MovieModel * model = [_arrMovie objectAtIndex:indexPath.row-1];
                [cell setMovieText:model index:indexPath.row-1 key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
        //只有用户
        if ([_arrCinema count] == 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            if(indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"用户" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row == [_arrUser count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if([_arrUser count] <  [_searchModel.totalOfUser intValue])
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                else
                {
                    [cell setReommmedCinema:@"" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
                
            }
            else
            {
                UserTableViewCell *cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                FollowPersonListModel* model = [_arrUser objectAtIndex:indexPath.row-1];
                [cell setUserText:model key:self._searchBar._textFieldSearchInput.text];
                
                return cell;
            }
        }
        //只有影片和用户
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] > 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"电影" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row < [_arrMovie count]+1 &&  indexPath.row > 0 )
            {
                MovieTableViewCell *cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell._buyTicketDelegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                MovieModel * model = [_arrMovie objectAtIndex:indexPath.row-1];
                [cell setMovieText:model  index:indexPath.row-1 key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }
            else if(indexPath.row == [_arrMovie count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalMovie >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
                
            }
            else if(indexPath.row == [_arrMovie count]+2 )
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
                
            }
            else if (indexPath.row == [_arrMovie count] +3)//用户第一行
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"用户" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            //用户第2--n行
            else if ( (indexPath.row > [_arrMovie count] +3) && (indexPath.row < [_arrMovie count] + [_arrUser count] +4) )
            {
                //                NSLog(@"%ld    %ld",indexPath.row,([_arrCinema count]+4));
                UserTableViewCell *cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                FollowPersonListModel* model = [_arrUser objectAtIndex:indexPath.row-([_arrMovie count]+4) ];
                [cell setUserText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
            else
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalUser >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
        }
        //只有影院和用户
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"影院" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalCinema >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
                
            }
            else if (indexPath.row == [_arrCinema count] +3)//用户第一行
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"用户" showHideBtn:TRUE cityName:_strLocationCity];
                
                return cell;
            }
            //用户第2--n行
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrUser count] +4) )
            {
//                NSLog(@"%ld    %ld",(long)indexPath.row,([_arrCinema count]+4));
                UserTableViewCell *cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                FollowPersonListModel* model = [_arrUser objectAtIndex:indexPath.row-([_arrCinema count]+4) ];
                [cell setUserText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
            else
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalUser >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
        }
        //只有影院和影片
        if ([_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalCinema >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
                
            }
            else if (indexPath.row == [_arrCinema count] +3)//用户第一行
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"电影" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            //用户第2--n行
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
                MovieTableViewCell *cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell._buyTicketDelegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                MovieModel * model = [_arrMovie objectAtIndex:indexPath.row-([_arrCinema count]+4) ];
                [cell setMovieText:model index:indexPath.row-([_arrCinema count]+4) key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }
            else
            {
                //灰色分割线
                if (_totalMovie >3)
                {
                    [cell.textLabel setText:@"查看更多 >"];
                }
                [cell.textLabel setTextColor:RGBA(117, 112, 255, 1)];
                [cell.textLabel setFont:MKFONT(15)];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return cell;
            }
        }
        //同时存在
        if(  [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] > 0 )
        {
            if (indexPath.row == 0)
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"影院" showHideBtn:FALSE cityName:_strLocationCity];
                return cell;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalCinema >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
                
            }
            else if (indexPath.row == [_arrCinema count] +3)//用户第一行
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"电影" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            //用户第2--n行
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
                MovieTableViewCell *cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell._buyTicketDelegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                MovieModel * model = [_arrMovie objectAtIndex:indexPath.row-([_arrCinema count]+4) ];
                [cell setMovieText:model index:indexPath.row-([_arrCinema count]+4) key:self._searchBar._textFieldSearchInput.text];
                return cell;
                
            }//更多
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +4 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                if (_totalMovie >3)
                {
                    [cell setReommmedCinema:@"查看更多 >" showHideBtn:TRUE cityName:@""];
                }
                [cell._labelName setTextAlignment:NSTextAlignmentCenter];
                [cell._labelName setTextColor:RGBA(117, 112, 255, 1)];
                [cell._labelName setFont:MKFONT(15)];
                cell._labelName.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
                return cell;
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +5 )
            {
                //灰色分割线
                [cell setBackgroundColor:RGBA(246, 246, 251, 1)];
                return cell;
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +6 )
            {
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.clearHistoryDelegate = self;
                [cell setReommmedCinema:@"用户" showHideBtn:TRUE cityName:_strLocationCity];
                return cell;
            }
            else if ( (indexPath.row > [_arrCinema count] + [_arrMovie count] +6)
                     && (indexPath.row < [_arrCinema count] + [_arrMovie count] +[_arrUser count] +7) )
            {
                //用户头像
                //                NSLog(@"%ld    %ld",indexPath.row,([_arrMovie count]+[_arrCinema count] +7));
                UserTableViewCell *cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                FollowPersonListModel* model = [_arrUser objectAtIndex:indexPath.row-([_arrMovie count]+[_arrCinema count] +7) ];
                [cell setUserText:model key:self._searchBar._textFieldSearchInput.text];
                return cell;
            }
            else
            {
                //灰色分割线
                if (_totalUser >3)
                {
                   [cell.textLabel setText:@"查看更多 >"];
                }
                [cell.textLabel setTextColor:RGBA(117, 112, 255, 1)];
                [cell.textLabel setFont:MKFONT(15)];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return cell;
            }
            
        }
        
    }
    return cell;
}

-(float) calcHistoryHigth:(NSMutableArray *)arrHistory
{
    int _nCountRow = 0;
   
    for (int i = 0; i < arrHistory.count; i ++)
    {
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        CGFloat BtnW = rect.size.width;
        if (BtnW < SCREEN_WIDTH-60)
        {
            BtnW = rect.size.width+30;
        }
        CGFloat BtnH = 30;
        
        if (i == 0)
        {
            btn.frame =CGRectMake(15, 42, BtnW, BtnH);
        }
        else
        {
            CGFloat yuWidth = SCREEN_WIDTH - 20 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width)
            {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }
            else
            {
                ++_nCountRow;
                btn.frame =CGRectMake(15, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
            }
        }
        recordBtn = btn;
      
    }
    return _nCountRow+1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有点击搜索
    if(!_isSearch)
    {
        if ([_arrHistory  count] > 0  && [_arrOftenCinema count] == 0)
        {
            if (indexPath.row == 0)
            {
                if ( [self calcHistoryHigth:_arrHistory]  == 1 )
                {
                    return  90;
                }
                else
                {
                    return 90 + ([self calcHistoryHigth:_arrHistory]-1)*40;
                }
            }
            else if (indexPath.row == 1)
            {
                return 10;
            }
            else if (indexPath.row == 2)
            {
                return 50;
            }
            else
            {
//                return 134/2;
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-3 );
                CinemaModel *model =  _arrCinema[indexPath.row - 3];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
        }
        if ([_arrHistory  count] > 0  && [_arrOftenCinema count] > 0)
        {
            if (indexPath.row == 0)
            {
                if ( [self calcHistoryHigth:_arrHistory]  == 1 )
                {
                    return  90;
                }
                else
                {
                    return 90 + ([self calcHistoryHigth:_arrHistory]-1)*40;
                }
            }
            else if (indexPath.row == 1)
            {
                return 10;
            }
            else if (indexPath.row == 2)
            {
                return 44;
            }
            else if (indexPath.row >2 && indexPath.row <= [_arrOftenCinema count]+2)
            {
//                return 134/2;
//                NSLog(@"%ld",indexPath.row);
                CinemaModel *model =  _arrOftenCinema[indexPath.row-3];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
            else if (indexPath.row == [_arrOftenCinema count]+3)
            {
                return 10;
            }
            else if (indexPath.row == [_arrOftenCinema count]+4)
            {
                return 44;
            }
            else
            {
//                return 134/2;
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-([_arrOftenCinema count]+5));
                CinemaModel *model =  _arrCinema[indexPath.row-([_arrOftenCinema count]+5)];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
        }
        //没有搜索历史、有常去影院
        else if([_arrHistory  count] == 0  && [_arrOftenCinema count] > 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if (indexPath.row >0 && indexPath.row < [_arrOftenCinema count]+1)
            {
//                NSLog(@"%ld",indexPath.row);
                CinemaModel *model =  _arrOftenCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
            else if (indexPath.row == [_arrOftenCinema count]+1)
            {
                return 10;
            }
            else if (indexPath.row == [_arrOftenCinema count]+2)
            {
                return 44;
            }
            else
            {
                //常去影院
//                return 134/2;
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-([_arrOftenCinema count]+3));
                CinemaModel *model =  _arrCinema[indexPath.row-([_arrOftenCinema count]+3)];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                return 43;
            }
            else
            {
                return 134/2;
            }
        }
        
    }
    else
    {
        //只搜索到影院
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] == 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                return  15;
            }
            else
            {
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-1 );
                CinemaModel *model =  _arrCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
        }
        //只有影片
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row == [_arrMovie count]+1 )
            {
                return  15;
            }
            else
            {
                return 150;
            }
        }
        //只有用户
        if ([_arrCinema count] == 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row == [_arrUser count]+1 )
            {
                return  15;
            }
            else
            {
                return 134/2;
            }
        }
        //只有影片和用户
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] > 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row < [_arrMovie count]+1 &&  indexPath.row > 0 )
            {
                return  150;
            }
            else if(indexPath.row == [_arrMovie count]+1 )
            {
                if(_totalMovie >3)
                {
                    return 25;//更多
                }
                else
                {
                    return 0;
                }
            }
            else if(indexPath.row == [_arrMovie count]+2 )
            {
                return 10;
            }//用户第一行
            else if (indexPath.row == [_arrMovie count] +3)
            {
                return 44;
            }//用户第2--n行
            else if ( (indexPath.row > [_arrMovie count] +3) && (indexPath.row < [_arrMovie count] + [_arrUser count] +4) )
            {
                return 134/2;
            }
            else
            {
                return  15;
            }
        }
        //只有影院和用户
        if( [_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-1 );
                CinemaModel *model =  _arrCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                if(_totalCinema >3)
                {
                    return 25;//更多
                }
                else
                {
                    return 0;
                }
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                return 10;
            }
            else if (indexPath.row == [_arrCinema count] +3)
            {
                return 44;
            }
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrUser count] +4) )
            {
                return 134/2;
            }
            else
            {
                return  15;
            }
        }
        //只有影院和影片
        if( [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] == 0 )
        {
            if (indexPath.row == 0)
            {
                return 44;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-1 );
                CinemaModel *model =  _arrCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                if(_totalCinema >3)
                {
                    return 25;//更多
                }
                else
                {
                    return 0;
                }
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                return 10;
            }
            else if (indexPath.row == [_arrCinema count] +3)
            {
                return 44;
            }
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
                return 150;
            }
            else
            {
                return  15;
            }
        }
        //同时存在
        if(  [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] > 0 )
        {
            if (indexPath.row == 0)
            {
                return 43;
            }
            else if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
//                NSLog(@"\n%ld\n%ld",indexPath.row,indexPath.row-1 );
                CinemaModel *model =  _arrCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                if(_totalCinema >3)
                {
                     return 25;//更多
                }
                else
                {
                    return 0;
                }
            }
            else if(indexPath.row == [_arrCinema count]+2 )
            {
                return 10;
            }
            else if (indexPath.row == [_arrCinema count] +3)
            {
                return 44;
            }
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
                return 150;
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +4 )
            {
                if(_totalMovie >3)
                {
                    return 25;//更多
                }
                else
                {
                    return 0;
                }
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +5 )
            {
                return  10;
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +6 )
            {
                return  44;
            }
            else if ( ( indexPath.row > [_arrCinema count] + [_arrMovie count] +6)
                     && (indexPath.row < [_arrCinema count] + [_arrMovie count] +[_arrUser count] +7) )
            {
                //用户头像
                return  70;
            }
            else
            {
                if(_totalUser >3)
                {
                    return 50;//更多
                }
                else
                {
                    return 0;
                }
            }
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
    //没有点击搜索
    if(!_isSearch)
    {
        //只有推荐
        if ([_arrHistory count] == 0 && [_arrOftenCinema count] == 0 && [_arrCinema count] > 0)
        {
            if (indexPath.row > 0 )
            {
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [self changeCinema:model];
            }
        }
        //只有常去
        if ( [_arrOftenCinema count] > 0 && [_arrHistory count] == 0 && [_arrCinema count] == 0)
        {
//            NSLog(@"%ld ",indexPath.row);
            if (indexPath.row  >0 && indexPath.row  <= [_arrOftenCinema count])
            {
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-1];
                [self changeCinema:model];
            }
        }
        //历史和推荐
        if ([_arrHistory count] > 0 && [_arrOftenCinema count] == 0 && [_arrCinema count] > 0)
        {
//            NSLog(@"%ld",indexPath.row);
            if (indexPath.row  >2 )
            {
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-3];
                [self changeCinema:model];
            }
        }
        //历史和常去
        if ([_arrHistory count] > 0 && [_arrOftenCinema count] > 0 && [_arrCinema count] == 0)
        {
//            NSLog(@"%ld",indexPath.row);
            if (indexPath.row  >2 && indexPath.row  < [_arrOftenCinema count]+3)
            {
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-3];
                [self changeCinema:model];
            }
        }
       //推荐和常去
        if ([_arrHistory count] == 0 && [_arrOftenCinema count] > 0 && [_arrCinema count] > 0)
        {
//            NSLog(@"%ld ",indexPath.row);
            if (indexPath.row  >0 && indexPath.row  <= [_arrOftenCinema count]+1)
            {
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-1];
                [self changeCinema:model];
            }
            if (indexPath.row  >= [_arrOftenCinema count]+3  )
            {
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-( [_arrOftenCinema count]+3 )];
                [self changeCinema:model];
            }
        }
        //全存在
        if ([_arrHistory count] > 0 && [_arrOftenCinema count] > 0 && [_arrCinema count] > 0)
        {
//            NSLog(@"%ld  %ld",indexPath.row,[_arrOftenCinema count]+2);
            if (indexPath.row  >2 && indexPath.row  <= [_arrOftenCinema count]+2)
            {
                CinemaModel* model = [_arrOftenCinema objectAtIndex:indexPath.row-3];
                [self changeCinema:model];
            }
//            NSLog(@"%ld  %ld",indexPath.row, [_arrOftenCinema count]+4);
            if (indexPath.row  > [_arrOftenCinema count]+4  )
            {
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-( [_arrOftenCinema count]+5 )];
                [self changeCinema:model];
            }
        }
    }
    else
    {
        //只有影院
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] == 0)
        {
//            NSLog(@"%ld",indexPath.row);
            if (indexPath.row ==[_arrCinema count]+1 )
            {
                if(_totalCinema > 3)
                {
                    [self pushToSearchCinemaViewController];
                }
            }
            else
            {
                if(indexPath.row> 0)
                {
                    CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row -1 ];
                    [self changeCinema:model];
                }
            }
        }
        //只有影片
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
//            NSLog(@"%ld",indexPath.row);
            if (indexPath.row ==[_arrMovie count]+1 )
            {
                if(_totalMovie > 3)
                {
                    [self pushToSearchMovieViewController];
                }
            }
            else
            {
                if(indexPath.row> 0)
                {
                    //                   [Tool showSuccessTip:@"go movie" time:1];
//                    NSLog(@"%ld",indexPath.row);
                    [self pushToMovieDetailViewController:_arrMovie[indexPath.row  - 1] ];
                }
            }
        }
        //只有用户
        if ([_arrCinema count] == 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            if (indexPath.row ==[_arrUser count]+1 )
            {
                if(_totalUser > 3)
                {
                     [self pushToSearchUserViewController];
                }
            }
            else
            {
                if(indexPath.row> 0)
                {
                    FollowPersonListModel *model =_arrUser[indexPath.row-1];
                    [self pushUserView:[model.id stringValue] ];
                }
            }
        }
        //只有影片和用户
        if ([_arrCinema count] == 0 && [_arrMovie count] > 0 && [_arrUser count] > 0)
        {
            //            NSLog(@"%ld",indexPath.row);
            if(indexPath.row < [_arrMovie count]+1 &&  indexPath.row > 0 )
            {
                //                [Tool showSuccessTip:@"go movie" time:1];
//                NSLog(@"%ld",indexPath.row);
                [self pushToMovieDetailViewController:_arrMovie[indexPath.row  -1 ]];
            }
            if(indexPath.row == [_arrMovie count]+1 )
            {
                if(_totalMovie > 3)
                {
                    [self pushToSearchMovieViewController];
                }
                
            }
            if ( (indexPath.row > [_arrMovie count] +3) && (indexPath.row < [_arrMovie count] + [_arrUser count] +4) )
            {
                //                [Tool showSuccessTip:@"go user" time:1];
                FollowPersonListModel *model =_arrUser[indexPath.row - ([_arrMovie count] +4 )];
                [self pushUserView:[model.id stringValue] ];
            }
            if ( indexPath.row ==[_arrMovie count]+ [_arrUser count] +4)
            {
                if(_totalUser > 3)
                {
                    [self pushToSearchUserViewController];
                }
            }
        }
        //只有影院和用户
        if ([_arrCinema count] > 0 && [_arrMovie count] == 0 && [_arrUser count] > 0)
        {
            //            NSLog(@"%ld",indexPath.row);
            if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row -1 ];
                [self changeCinema:model];
            }
            if(indexPath.row == [_arrCinema count]+1 )
            {
                 if(_totalCinema >=3)
                 {
                     [self pushToSearchCinemaViewController];
                 }
            }
            if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrUser count] +4) )
            {
//                NSLog(@"%ld",indexPath.row);
                FollowPersonListModel *model =_arrUser[indexPath.row - ([_arrCinema count] +4 )];
                [self pushUserView:[model.id stringValue] ];
            }
            if ( indexPath.row ==[_arrCinema count]+ [_arrUser count] +4)
            {
                if(_totalUser >=3)
                {
                     [self pushToSearchUserViewController];
                }
            }
        }
        //只有影院和影片
        if ([_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] == 0)
        {
//            NSLog(@"%ld",indexPath.row);
            if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                //                [Tool showSuccessTip:@"切换影院" time:1];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row -1 ];
                [self changeCinema:model];
            }
            if(indexPath.row == [_arrCinema count]+1 )
            {
                if(_totalCinema > 3)
                {
                     [self pushToSearchCinemaViewController];
                }
            }
            if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
                //                [Tool showSuccessTip:@"go movie" time:1];
//                NSLog(@"%ld",indexPath.row);
                [self pushToMovieDetailViewController:_arrMovie[indexPath.row  - ([_arrCinema count] +4)] ];
            }
            if ( indexPath.row ==[_arrCinema count]+ [_arrMovie count] +4)
            {
                if(_totalMovie > 3)
                {
                     [self pushToSearchMovieViewController];
                }
            }
        }
        //同时存在
        if(  [_arrCinema count] > 0 && [_arrMovie count] > 0 && [_arrUser count] > 0 )
        {
            if(indexPath.row < [_arrCinema count]+1 &&  indexPath.row > 0 )
            {
                //               [Tool showSuccessTip:@"切换影院" time:1];
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row -1 ];
                [self changeCinema:model];
            }
            else if(indexPath.row == [_arrCinema count]+1 )
            {
                if(_totalCinema > 3)
                {
                    [self pushToSearchCinemaViewController];
                }
            }
            else if ( (indexPath.row > [_arrCinema count] +3) && (indexPath.row < [_arrCinema count] + [_arrMovie count] +4) )
            {
//                NSLog(@"%ld",indexPath.row);
                //                [Tool showSuccessTip:@"go movie" time:1];
                [self pushToMovieDetailViewController:_arrMovie[indexPath.row  -( [_arrCinema count] +4) ]];
            }
            else if ( indexPath.row == [_arrCinema count] + [_arrMovie count] +4 )
            {
                if(_totalMovie > 3)
                {
                     [self pushToSearchMovieViewController];
                }
            }
            else if ( (indexPath.row > [_arrCinema count] + [_arrMovie count] +6)
                     && (indexPath.row < [_arrCinema count] + [_arrMovie count] +[_arrUser count] +7) )
            {
//                NSLog(@"%ld",indexPath.row);
                FollowPersonListModel *model =_arrUser[indexPath.row - ([_arrCinema count] +4 ) -([_arrMovie count] +3 )];
                [self pushUserView:[model.id stringValue] ];
            }
            if ( indexPath.row ==  [_arrCinema count] + [_arrMovie count] +[_arrUser count] +7)
            {
                if(_totalUser > 3)
                {
                    [self pushToSearchUserViewController];
                }
            }
        }
    }
}

#pragma mark 切换影院
-(void) changeCinema:(CinemaModel*)cinemaModel
{
    [MobClick event:mainViewbtn8];
    //切换影院
    [self changeCinemaDetail:[cinemaModel.cinemaId stringValue]];
    //添加影院访问记录
//    [self addCinemaBrowsingHistory:[cinemaModel.cinemaId stringValue]];
}

#pragma mark 拉取消息通知
-(void)pullNotice:(NSString *)cinemaId
{
    //读取数据插入数据库
    [ServicesNotification getMessageNotfication:cinemaId trueFalse:^(NSNumber *trueFalse)
     {
         NSLog(@"write success");
     } failure:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
     }];
}

#pragma mark 获取影院详情
-(void) changeCinemaDetail:(NSString *)cinemaId
{
    __weak typeof(self) weakSelf = self;
    [ServicesCinema getCinemaDetail:cinemaId cinemaModel:^(CinemaModel *model)
     {
//         [weakSelf pullNotice:cinemaId];
         CinemaCountDownView *cinemaview = [[CinemaCountDownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cinemaModel:model navigation:weakSelf.navigationController];
         [weakSelf.view addSubview:cinemaview];
         
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1];
     }];
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(void)textFieldReturn
{
    
}
#pragma mark  保存搜索记录
-(void)saveSearchRecord
{
    [self hideKeyboard];
    if ([_arrUser count] >0 || [_arrMovie count] >0 || [_arrCinema count] >0 )
    {
//        NSLog(@"%ld",[[Config getSearchHistory] count]);
        
        if( [[Config getSearchHistory] count] <=5 )
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Config getSearchHistory]];
            if ([self._searchBar._textFieldSearchInput.text length]>0)
            {
                for(int i = 0 ;i < [arr count]; i++)
                {
                    if ([arr[i]  isEqualToString:self._searchBar._textFieldSearchInput.text])
                    {
                        [arr removeObjectAtIndex:i];
                        [arr insertObject:self._searchBar._textFieldSearchInput.text atIndex:0];
                        [Config saveSearchHistory:arr];
                        return ;
                    }
                }
                
                if ([arr count] == 5)
                {
                    [arr removeObjectAtIndex:[arr count]-1];
                    [arr insertObject:self._searchBar._textFieldSearchInput.text atIndex:0];
                    [Config saveSearchHistory:arr];
                    return;
                }
                else
                {
                    [arr insertObject:self._searchBar._textFieldSearchInput.text atIndex:0];
                    [Config saveSearchHistory:arr];
                }
            }
        }
    }
}

#pragma mark 清除历史记录
-(void) onButtonClear:(UIButton*)sender
{
    [MobClick event:mainViewbtn14];
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text length] == 0)
    {
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"清空"])
    {
        _arrHistory =[[NSMutableArray alloc ] initWithCapacity:0];
        [Config saveSearchHistory:nil];
        
        [_tableViewCinema reloadData];
    }
    else
    {
        CitySelectViewController *citySelectVC = [[CitySelectViewController alloc]init];
        citySelectVC.hidesBottomBarWhenPushed = YES;
        //Block接收值
        citySelectVC.selectCity = ^(NSString *cityName)
        {
            [self getCityCode:cityName];
        };
        [self.navigationController pushViewController:citySelectVC animated:YES];
    }
    
}

-(void) getCityCode:(NSString *)cityName
{
    if ([cityName length] > 2)
    {
        _strLocationCity = cityName;
    }
    else
    {
        _strLocationCity = @"请定位";
    }
    
    __weak typeof(self) weakSelf =self;
    [ServicesSearch readCityList:^(CityModel *model)
     {
         citylistModel *cityModel = [[citylistModel alloc ] init];
         
         for (cityModel in model.citylist)
         {
             if ([cityModel.name isEqualToString:cityName])
             {
                 //没有输入条件，选择了定位
                 if ([self._searchBar._textFieldSearchInput.text length]<=0)
                 {
                     _strSelectCityId =[ cityModel.id stringValue];
                     [weakSelf getCinemaList:weakSelf._longitude latitude:weakSelf._latitude];
                 }
                 else
                 {
                     _strSelectCityId =[ cityModel.id stringValue];
                     [_arrCinema removeAllObjects];
                     [weakSelf inputSearchText:self._searchBar._textFieldSearchInput.text];
                 }
                 return ;
             }
         }
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark -点击历史记录
-(void)onButtonHistory:(NSString *)strHistory
{
    [MobClick event:mainViewbtn13];
    [self._searchBar._textFieldSearchInput setText:strHistory];
    [self._searchBar hideLabelAndClearbutton];
    
    if (self._longitude.length<=0)
    {
        self._longitude = @"";
    }
    if (self._latitude.length<=0)
    {
        self._latitude = @"";
    }
    _isSearch = TRUE;
    
    [_arrUser removeAllObjects];
    [_arrMovie removeAllObjects];
    [_arrCinema removeAllObjects];
    [self inputSearchText:strHistory];
}

#pragma mark 跳转到查找影院
-(void)pushToSearchCinemaViewController
{
    CinemaSearchViewController *cinemaSearchController = [[CinemaSearchViewController alloc ] init];
    cinemaSearchController._strSearchCondition = self._searchBar._textFieldSearchInput.text;
    cinemaSearchController._cinemaSearchDelegate  = self;
    [self.navigationController pushViewController:cinemaSearchController animated:YES];
}

#pragma mark 跳转到查找用户
-(void)pushToSearchUserViewController
{
    [MobClick event:mainViewbtn11];
//    NSLog(@"%@",self._searchBar._textFieldSearchInput.text);
    SearchUserViewController *searchUserController = [[SearchUserViewController alloc ] init];
    searchUserController._searchUserDelegate  = self;
    searchUserController._strSearchCondition = self._searchBar._textFieldSearchInput.text;
    [self.navigationController pushViewController:searchUserController animated:YES];
}
#pragma mark 跳转到用户详情
-(void) pushUserView:(NSString *)userId
{
    //验证登录
    if ( ![Config getLoginState ] )
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:userId forKey:@"_strUserId"];
        [self showLoginController:param controllerName:@"OtherCenterViewController"];
    }
    else
    {
        if ([[Config getUserId] isEqualToString:userId])
        {
            //如果当前用户ID与跳转ID是同一ID，则跳转到个人中心
//            UserCenterViewController *userCenterController = [[UserCenterViewController alloc] init];
//            [self.navigationController pushViewController:userCenterController animated:YES];

            //切换tab
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate switchTab:2];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
            vc._strUserId = userId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }}

#pragma mark 弹出登录view
-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [self.navigationController pushViewController:loginControlller animated:YES];
}


#pragma mark 跳转到查找影片
-(void)pushToSearchMovieViewController
{
    SearchMovieViewController *searchMovieController = [[SearchMovieViewController alloc ] init];
    searchMovieController._strSearchCondition = self._searchBar._textFieldSearchInput.text;
    searchMovieController._searchMovieDelegate  = self;
    [self.navigationController pushViewController:searchMovieController animated:YES];
}
#pragma mark 跳转到影片详情
-(void)pushToMovieDetailViewController:(MovieModel*)model
{
    [MobClick event:mainViewbtn9];
    __weak typeof(self) weakSelf =self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieDetail:[model.movieId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         MoviePosterViewController* moviePosterController = [[MoviePosterViewController alloc]init];
         moviePosterController.currentIndex = 0;
         if ([movieDetail.buyTicketStatus integerValue] == 0)
         {
             //不能购票
             moviePosterController.arrCommingMovieData = @[movieDetail];
         }
         else
         {
             moviePosterController.arrMovieData = @[movieDetail];
         }
         [weakSelf.navigationController pushViewController:moviePosterController animated:YES];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [Tool showWarningTip:@"影片不存在" time:1];
     }];
    
}

//返回按钮
-(void)onButtonBack
{
    [MobClick event:mainViewbtn15];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 购票
-(void)onButtonBuy:(NSInteger)index
{
    [MobClick event:mainViewbtn10];
    MovieModel *movieModel = _arrMovie[index];
    ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
    showTimeVC.hotMovieModel = movieModel;
    [self.navigationController pushViewController:showTimeVC animated:YES];
    
}
-(void)hideKeyboard
{
    [self._searchBar._textFieldSearchInput resignFirstResponder];
}

#pragma mark 返回时带回的参数
-(void)searchContent:(NSString *)text
{
    //读取本地最后选择城市
    [self readLocationCity];
//    NSLog(@"%@",text);
    self._searchBar._textFieldSearchInput.text = text;
    if ([text length] == 0)
    {
        _isSearch = FALSE;
        [_arrUser removeAllObjects];
        [_arrMovie removeAllObjects];
        [_arrCinema removeAllObjects];
        [_arrOftenCinema removeAllObjects];
        _arrHistory = [Config getSearchHistory];
        [self getCinemaList:self._longitude latitude:self._latitude];
    }
    else
    {
        [self inputSearchText:text];
    }
    
}


@end
