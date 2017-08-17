//
//  CinemaSearchViewController.m
//  supercinema
//
//  Created by dust on 16/10/12.
//
//

#import "CinemaSearchViewController.h"

@interface CinemaSearchViewController ()

@end

@implementation CinemaSearchViewController

-(void) viewDidAppear:(BOOL)animated
{
    if (![Config getLoginState])
    {
        [_btnLogin setHidden:NO];
    }
    else
    {
        [_btnLogin setHidden:YES];
    }
    if( [[Config getLocationInfo] objectForKey:@"longitude"] ==nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] == 0 )
    {
        [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
    }
//    [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
}


-(void) viewWillAppear:(BOOL)animated
{
    //本地存在定位信息
    if( [[Config getLocationInfo] objectForKey:@"longitude"] !=nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] >0 )
    {
//        if ([_searchBar._textFieldSearchInput.text length] == 0)
        {
            [self getCityId:[[Config getLocationInfo] objectForKey:@"citycode"]];
            self._longitude = [[Config getLocationInfo] objectForKey:@"longitude"];
            self._latitude = [[Config getLocationInfo] objectForKey:@"latitude"];
            
            if ([self._strSearchCondition length ] <= 0 )
            {
                [self getOftenAndRecommendCinema];
            }
            else
            {
                [self loadSearchCinemaData];
            }
        }
    }
    else
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [self location];
        [self configLocationManager];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor] ];
    [self._labelTitle setText:@"随便逛逛"];
    [self._btnBack setHidden:YES];
    _arrCinema = [[NSMutableArray alloc ] initWithCapacity:0];
    _strLocationCity = @"北京市";
    _strSelectCityId = @"1";
    _strLocationCityId=@"1";
    self._longitude = @"";
    self._longitude = @"";
    _isSearch = FALSE;
    _pageIndex = 1;
    //读取本地最后选择城市
    [self readLocationCity];
    
    [self initController];
    [self initNoDataViewController];
    
    //全局搜索push 过来
    if ([self._strSearchCondition length ] > 0 )
    {
        _isSearch = TRUE;
        [self._labelTitle setText:@"影院搜索"];
        _searchBar._textFieldSearchInput.text =  self._strSearchCondition;
        [_searchBar._btnClear setHidden:NO];
        [self._btnBack setHidden:NO];
        _strSearchContent = self._strSearchCondition;
    }
    else
    {
        //影院详情切换过来
        if ([self._viewName isEqualToString:@"CinameDetailViewController"]
            || [self._viewName isEqualToString:@"CinemaDetailView"])
        {
            [self._labelTitle setText:@"影院搜索"];
            [self._btnBack setHidden:NO];
        }
    }
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
     __weak __typeof__(self) weakSelf = self;
    self._completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
                if ([self._strSearchCondition length ] <= 0 )
                {
                    [weakSelf getOftenAndRecommendCinema];
                }
                else
                {
                    [weakSelf loadSearchCinemaData];
                }
                return;
            }
        }
        //得到定位信息
        if (location)
        {
            [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
//            if (regeocode)
//            {
//                NSLog(@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy);
//            }
            [weakSelf getCityId:[NSString stringWithFormat:@"%@",regeocode.citycode]];
            weakSelf._longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            weakSelf._latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            //没有输入内容
            if ([self._strSearchCondition length ] <= 0 )
            {
                [weakSelf getOftenAndRecommendCinema];
            }
            else
            {
                 [weakSelf loadSearchCinemaData];
            }
            [weakSelf saveLoacationPostion:weakSelf._longitude latitude:weakSelf._latitude citycode:[NSString stringWithFormat:@"%@",regeocode.citycode]];
        }
    };
}

-(void)saveLoacationPostion:(NSString *)longitude latitude:(NSString *)latitude citycode:(NSString *)citycode
{
    NSDictionary *dic = @{@"longitude":longitude,
                          @"latitude":latitude,
                          @"citycode":citycode};
//    NSLog(@"%@",[Tool urlIsNull:citycode]);
    
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
    [_labelDesc setHidden:ShowHide];
    [_imageView setHidden:ShowHide];
    int historyHeight=0;
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

-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            if([_searchBar._textFieldSearchInput.text length] == 0)
            {
               [ws getOftenAndRecommendCinema];
            }
            else
            {
                [ws loadSearchCinemaData ];
            }         
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}


-(void) loadSearchCinemaData
{
    __weak typeof(self) weakSelf = self;
    if ([_strSearchContent length] > 0 )
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [ServicesSearch searchCinema:_strSearchContent pageIndex:_pageIndex cityId:_strSelectCityId latitude:self._latitude longitude:self._longitude model:^(CinemaListModel *model)
         {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             [_arrCinema  addObjectsFromArray:model.cinemaList];
             [_tableViewCinema reloadData];
             
             if(_pageIndex < [model.pageTotal intValue])
             {
                 [_tableViewCinema addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreCinemaData)];
                 [_tableViewCinema.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
                 [_tableViewCinema.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
                 [_tableViewCinema.footer endRefreshing];
             }
             else
             {
                 [_tableViewCinema removeFooter];
             }
                         //没有数据
             if ([_arrCinema count] <= 0)
             {
                 [weakSelf loadNoSearchDataUI:NO];
             }
             else
             {
                 [weakSelf loadNoSearchDataUI:YES];
             }
             _viewLoadFailed.hidden = YES;
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             [_tableViewCinema removeFooter];
             [Tool showWarningTip:error.domain time:1];
             [_arrCinema  removeAllObjects];
             [_tableViewCinema reloadData];
             [weakSelf initFailureView];
         }];
    }
}

//创建UI控件
-(void)initController
{
    [self._labelLine setHidden:YES];
    _searchBar = [[ExUISearchBar alloc ] initWithFrame:CGRectMake(15, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+16, SCREEN_WIDTH-30, 30)];
    _searchBar.seatchBarDelegate = self;
    [_searchBar._textFieldSearchInput setPlaceholder:@"请输入影院名称"];
    [_searchBar._textFieldSearchInput addTarget:self action:@selector(searchChangeCinema:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchBar];
    
    _labelLine= [[UILabel alloc ] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y+_searchBar.frame.size.height+5.5 , SCREEN_WIDTH, 0.5)];
    [_labelLine setBackgroundColor:RGBA(0,0,0,0.05)];
    [self.view addSubview:_labelLine];
    
    //搜索结果列表
    _tableViewCinema = [[UITableView alloc] initWithFrame:CGRectMake(0, _labelLine.frame.origin.y+_labelLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(_searchBar.frame.origin.y+_searchBar.frame.size.height+15) )];
    _tableViewCinema.delegate = self;
    _tableViewCinema.dataSource = self;
    _tableViewCinema.backgroundColor =[UIColor whiteColor];
    _tableViewCinema.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewCinema];
    
    _btnLogin = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-45, self._labelTitle.frame.origin.y+5, 30, 14)];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnLogin.titleLabel setFont:MKFONT(14) ];
    [_btnLogin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_btnLogin addTarget:self action:@selector(onButtonLogin) forControlEvents:UIControlEventTouchUpInside];
    if ( ![Config getLoginState ] )
    {
         [self.view addSubview:_btnLogin];
    }
}

#pragma mark 加载更多数据
-(void)loadMoreCinemaData
{
    _pageIndex+=1;
    _strSearchContent = _searchBar._textFieldSearchInput.text;
    [self loadSearchCinemaData];
}

#pragma mark 登录
-(void) onButtonLogin
{
    [MobClick event:cinemaSearchLoginBtn];
    LoginViewController *loginController = [[LoginViewController alloc ] init];
    loginController._strTopViewName = @"CinemaSearchViewController";
    [self.navigationController pushViewController:loginController animated:YES];
}

#pragma mark 查找电影院
-(void)searchCinema:(NSString *)inputContent;
{
    [MobClick event:cinemaSearchBtn];
    //输入查找条件后，重置pageindex =1
    _pageIndex = 1;
    //清空数据
    [_arrCinema removeAllObjects];
    
    if (self._longitude.length<=0)
    {
        self._longitude = @"";
    }
    if (self._latitude.length<=0)
    {
        self._latitude = @"";
    }
    
    _strSearchContent = inputContent;
    if(inputContent.length >= 1)
    {
        _isSearch = TRUE;
        [self loadSearchCinemaData];
    }
    else
    {
        _isSearch = FALSE;
        [self getOftenAndRecommendCinema];
    }
}

#pragma mark 获取推荐影院和常去影院
-(void)getOftenAndRecommendCinema
{
    if([_searchBar._textFieldSearchInput.text length] == 0)
    {
        __weak __typeof(self) weakSelf = self;
        //locationCityId定位出来的
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [ServicesCinema getOftenRecommendCinema:_strSelectCityId latitude:self._latitude longitude:self._longitude locationCityId:_strLocationCityId model:^(OftenRecommendCinemaModel *model)
         {
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
             _arrOftenCinema= [[NSMutableArray alloc ] initWithArray:model.mostVisitCinemaList];
             _arrCinema = [[NSMutableArray alloc ] initWithArray:model.recommendCinemaList];
             [_tableViewCinema reloadData];
             //删除上拉加载更多
             [_tableViewCinema removeFooter ];
             
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
             
         } failure:^(NSError *error) {
             [_tableViewCinema removeFooter ];
             [_arrCinema  removeAllObjects];
             [_tableViewCinema reloadData];
             [Tool showWarningTip:error.domain time:1];
             [weakSelf initFailureView];
         }];
    }
}

#pragma mark UITableviewDelegate
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
           return [_arrCinema count]+1;
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
                [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
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
                [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
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
                    [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
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
                [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
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
                SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
                [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
        else
        {
            if (indexPath.row == 0)
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
                CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
                [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
                return cell;
            }
        }
    }
    else
    {
        if (indexPath.row == 0 )
        {
            SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.clearHistoryDelegate = self;
            [cell setReommmedCinema:@"影院" showHideBtn:FALSE cityName:_strLocationCity];
            return cell;
        }
        else
        {
            SearchResultTableViewCell *cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setSearchCinemaCellText:model key:_searchBar._textFieldSearchInput.text];
            return cell;
        }
    }
   
   
    return cell;
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
                return 90;
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
                return 90;
            }
            else if (indexPath.row == 1)
            {
                return 10;
            }
            else if (indexPath.row == 2)
            {
                return 50;
            }
            else if (indexPath.row >2 && indexPath.row < [_arrOftenCinema count]+2)
            {
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
                return 50;
            }
            else
            {
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
                return 50;
            }
            else if (indexPath.row >0 && indexPath.row < [_arrOftenCinema count]+1)
            {
//                return 134/2;
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
                return 50;
            }
            else
            {
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
//                return 134/2;
//                NSLog(@"\n%ld",indexPath.row);
                CinemaModel *model =  _arrCinema[indexPath.row-1];
                //推荐影院
                CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
                return 25+size.height+30;
            }
        }
        
    }
    else
    {
        if (indexPath.row == 0 )
        {
            return 45;
        }
        else
        {
//            NSLog(@"\n%ld",indexPath.row);
            CinemaModel *model =  _arrCinema[indexPath.row-1];
            //推荐影院
            CGSize size =[Tool CalcString:model.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-100];
            return 25+size.height+30;
        }
    }
    return 0;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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
        if (indexPath.row > 0 )
        {
            CinemaModel* model = [_arrCinema objectAtIndex:indexPath.row-1];
            [self changeCinema:model];
        }
    }
    [_searchBar._textFieldSearchInput resignFirstResponder];
    
}

#pragma mark 切换影院
-(void) changeCinema:(CinemaModel*)cinemaModel
{
    [Config saveIsFirstStartUp:@"YES"];
    [self changeCinemaDetail:[cinemaModel.cinemaId stringValue]];
}

#pragma mark 获取影院详情
-(void) changeCinemaDetail:(NSString *)cinemaId
{
    [ServicesCinema getCinemaDetail:cinemaId cinemaModel:^(CinemaModel *model)
     {
         CinemaCountDownView *cinemaview = [[CinemaCountDownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cinemaModel:model navigation:self.navigationController];
         [self.view addSubview:cinemaview];
         
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1];
     }];
    
}


-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBar._textFieldSearchInput resignFirstResponder];
}

#pragma mark  保存搜索记录
-(void)textFieldReturn
{
    [_searchBar._textFieldSearchInput resignFirstResponder];
    if( [[Config getSearchHistory] count] < 5 )
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Config getSearchHistory]];
        if ([_searchBar._textFieldSearchInput.text length]>0)
        {
            for(int i = 0 ;i < [arr count]; i++)
            {
                if ([arr[i]  isEqualToString:_searchBar._textFieldSearchInput.text])
                {
                    [arr removeObjectAtIndex:i];
                    [arr insertObject:_searchBar._textFieldSearchInput.text atIndex:0];
                    [Config saveSearchHistory:arr];
                    return ;
                }
            }
            [arr insertObject:_searchBar._textFieldSearchInput.text atIndex:0];
            [Config saveSearchHistory:arr];
        }
    }
}

#pragma mark 定位
-(void) onButtonClear:(UIButton*)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text length] == 0)
    {
        return;
    }
    else
    {
        [MobClick event:cinemaSearchChangeCityBtn];
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
    if ([cityName length] > 0)
    {
        _strLocationCity = cityName ;
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
                 if ([_searchBar._textFieldSearchInput.text length]<=0)
                 {
                     _strSelectCityId =[ cityModel.id stringValue];
                     [weakSelf getOftenAndRecommendCinema];
                 }
                 else
                 {
                     _strSelectCityId =[ cityModel.id stringValue];
                     [_arrCinema removeAllObjects];
                     [weakSelf loadSearchCinemaData];
                 }
                 return ;
             }
         }
     } failure:^(NSError *error) {
         
     }];
    
    
}

-(void)searchChangeCinema:(UITextField *)TextField
{
//    NSLog(@"%@",TextField.text);
    if ([TextField.text length] == 0)
    {
         [_searchBar._btnClear setHidden:YES];
    }
    else
    {
        [_searchBar._btnClear setHidden:NO];
    }
}

-(void)onButtonHistory:(NSString *)strHistory
{
    
}

-(void)onButtonBack
{
    if ([self._viewName isEqualToString:@"CinameDetailViewController"] ||
        [self._viewName isEqualToString:@"CinemaDetailView"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([self._cinemaSearchDelegate respondsToSelector:@selector(searchContent:)])
        {
            [self._cinemaSearchDelegate searchContent:_searchBar._textFieldSearchInput.text ];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
