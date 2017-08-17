//
//  CitySelectViewController.m
//  supercinema
//
//  Created by dust on 16/10/13.
//
//

#import "CitySelectViewController.h"

@implementation CitySelectViewController


static NSString *collectionHeadID = @"collectionHeadID";

-(void) viewDidAppear:(BOOL)animated
{
    [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self location];
    [self configLocationManager];
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

#pragma mark 配置定位信息
-(void)location
{
    __weak __typeof__(self) weakSelf = self;
    self._completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
                isLocating = NO;
               _strCurrentLocationCityName = @"定位失败，请点击重试";
                [weakSelf reloadCollection];
                return;
            }
        }
        //得到定位信息
        if (location)
        {
            if (regeocode)
            {
                NSLog(@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy);
            }
            isLocating = YES;
            if([regeocode.city length] == 0)
            {
                _strCurrentLocationCityName = @"定位失败，请点击重试";
            }
            else
            {
                _strCurrentLocationCityName = [NSString stringWithFormat:@"%@",regeocode.city];
            }
            [weakSelf reloadCollection];
        }

    };
}


-(void)reloadCollection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[path]];
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self._labelTitle setText:@"城市搜索"];
    _strCurrentLocationCityName = @"定位中...";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _newCityDic         = [[NSMutableDictionary alloc]init];
    _arrAllCityNames    = [[NSMutableArray alloc]init];
    _allKeysArray       = [[NSMutableArray alloc]init];
    self._arrSearchData = [[NSMutableArray alloc]init];
    _arrHostCities      = [[NSMutableArray alloc]init];
    _arrAllCityModel    = [[NSMutableArray alloc]init];
    _arrSearchHistory   = [Config getSearchCity];

    isLocating = NO;
    [self getHotCityArr];
}

#pragma mark 获取热门城市
-(void) getHotCityArr
{
    __weak typeof(self) weakSelf = self;
    
    [ServicesSearch getHotCity:^(HotCityListModel *model)
    {
        HotCityModel *Hotmodel = [[HotCityModel alloc ] init];
        for (Hotmodel in model.hotCityList)
        {
            [_arrHostCities addObject:Hotmodel.cityName];
        }
        [weakSelf getAllCityArr];
        
    } failure:^(NSError *error) {
        [weakSelf getAllCityArr];
    }];
}

#pragma mark 获取所有城市
-(void) getAllCityArr
{
    //加载本地文件中的城市列表
    [ServicesSearch readCityList:^(CityModel *model)
     {
         for ( int i = 0 ; i < [model.citylist count]; i ++)
         {
             citylistModel *model1 =model.citylist[i];
             [_arrAllCityNames addObject:model1.name];
             [_arrAllCityModel addObject:model1];
         }
         
         [self prepareCityListDatasourceWithArray:model.citylist andToDictionary:_newCityDic];
         
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark-排序城市
- (void)prepareCityListDatasourceWithArray:(NSArray *)array andToDictionary:(NSMutableDictionary *)dic
{
    for (citylistModel * cityModel in array)
    {
        
        NSString *cityPinyin =cityModel.py;
        
        NSString *firstLetter = [cityPinyin substringWithRange:NSMakeRange(0, 1)];
        
        if (![dic objectForKey:firstLetter]) {
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:firstLetter];
            
        }
        if ([[dic objectForKey:firstLetter] containsObject:cityModel.name]) {
            return;
        }
        [[dic objectForKey:firstLetter]addObject:cityModel.name];
    }
    
    [_allKeysArray addObjectsFromArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    [self initCtrl];
    
}

//渲染UI
-(void)initCtrl
{
    [self.collectionView registerClass:[CitySelectCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellID"];
    [self.collectionView registerClass:[CitySelectHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeadID];
    
    [self._labelLine setHidden:YES];
    //设置搜索框
    _searchBar = [[ExUISearchBar alloc ] initWithFrame:CGRectMake(15, self._viewTop.frame.origin.y+self._viewTop.frame.size.height+2, SCREEN_WIDTH-30, 30)];
    _searchBar.seatchBarDelegate = self;
    [self.view addSubview:_searchBar];
    
    UILabel *labelLine= [[UILabel alloc ] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y+_searchBar.frame.size.height+11/2 , SCREEN_WIDTH, 0.5)];
    [labelLine setBackgroundColor:RGBA(0,0,0,0.05)];
    [self.view addSubview:labelLine];
    
    //整体的TabelView（除搜索框之外的部分）
    self._mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height+1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40 -64)];
    self._mainTable.delegate = self;
    self._mainTable.dataSource = self;
    self._mainTable.tableFooterView = [UIView new];
    self._mainTable.backgroundColor = RGBA(246, 246, 251, 1);
    //拼音索引背景颜色
    self._mainTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:self._mainTable];
//    [self statLocation];
}

#pragma mark - 城市列表 上方区域collectionView（宽高 & 背景颜色）
-(UICollectionView *)collectionView
{
    if (!self._collectionView)
    {
        CGFloat height = 0;
        if(_arrSearchHistory.count > 0){
            height = 35 + 30;
        }
        
        //设置城市列表高度
        if (_arrHostCities.count <=3)
        {
            height = (35 + height + (30 + 35));
        }
        else if (_arrHostCities.count <=6 && _arrHostCities.count > 3)
        {
            height = (35 + height + (30 + 35 + 35 + 5));
        }
        else
        {
            height = (35 + height + (30 + 35 + 35 + 35 + 5 + 5));
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self._collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height) collectionViewLayout:flowLayout];
        self._collectionView.delegate = self;
        self._collectionView.dataSource = self;
        self._collectionView.backgroundColor = RGBA(246, 246, 251, 1);
    }
    return self._collectionView;
}



//返回
-(void)returnTopView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
//Sections分区（分为定位热门以及城市列表）
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
        //城市列表
        return  [[_newCityDic allKeys] count]+1;
    }
    else
    {
        //定位 & 热门
        return 1;
    }
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            NSArray *cityArray = [_newCityDic objectForKey:[_allKeysArray objectAtIndex:section-1]];
            return cityArray.count;
        }
    }
    else
    {
        return self._arrSearchData.count;
    }
}

//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSearch)
    {
        if (indexPath.section == 0)
        {
            
            CGFloat height = 0;
            if(_arrSearchHistory.count > 0){
                height = 30 + 35;
            }
            
            //设置城市列表高度
            if (_arrHostCities.count <=3)
            {
                return (35 + height + (30 + 35));
            }
            else if (_arrHostCities.count <=6 && _arrHostCities.count > 3)
            {
                height = (35 + height + (30 + 35 + 35 + 5));
                return height;
            }
            else
            {
                height = (35 + height + (30 + 35 + 35 + 35 + 5 + 5));
                return height;
            }
        }
        else
        {
            return 44;
        }
        
    }
    else
    {
        return 44;
    }
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //如果不是点击搜索功能显示的UI
    if (!_isSearch)
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"new"];
            [newCell addSubview:self.collectionView];
            return newCell;
        }
        else
        {
            NSArray *cityArray = [_newCityDic objectForKey:[_allKeysArray objectAtIndex:indexPath.section-1]];
            cell.textLabel.text = [cityArray objectAtIndex:indexPath.row];
            cell.textLabel.font = MKFONT(15);
        }
    }
    else
    {
        cell.textLabel.text = self._arrSearchData[indexPath.row];
    }
    return cell;
}

//Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *cityName ;
    if (!_isSearch)
    {
        cityName = cell.textLabel.text;
    }
    else
    {
        cityName = self._arrSearchData[indexPath.row];
    }
    [self saveSearchCityName:cityName];
    self.selectCity(cityName);
    
    [self returnTopView];
}
-(void) saveSearchCityName:(NSString *)cityName
{
    if ([cityName isEqualToString:@"定位中..."] || [cityName isEqualToString:@"定位失败，请点击重试"] )
    {
        return;
    }
    
    if( [[Config getSearchCity] count] <=3 )
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Config getSearchCity]];
        if ([cityName length]>0)
        {
            for(int i = 0 ;i < [arr count]; i++)
            {
                if ([arr[i]  isEqualToString:cityName])
                {
                    [arr removeObjectAtIndex:i];
                    [arr insertObject:cityName atIndex:0];
                    [Config saveSearchCity:arr];
                    return ;
                }
            }
            if([arr count] < 3)
            {
                [arr insertObject:cityName atIndex:0];
                [Config saveSearchCity:arr];
                return;
            }
            [Config saveSearchCity:arr];
            
            if ([arr count] == 3)
            {
                [arr removeObjectAtIndex:2];
                [arr insertObject:cityName atIndex:0];;
                [Config saveSearchCity:arr];
                return;
            }
        }
    }

    
    
}

//分区 头部标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        if (section == 0)
        {
            return nil;
        }
        else
        {
            return @"3232";// _arrAllCities[section - 1][@"title"];
        }
    }
    else
    {
        return nil;
    }
}

//分区section 背景 & 标题字体颜色大小
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        if (section == 0)
        {
            return nil;
        }
        else
        {
            UIView *viewSectionBG = [[UIView alloc] init];
            viewSectionBG.backgroundColor = RGBA(246, 246, 251, 1);
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 90, 22)];
            labelTitle.textColor = [UIColor blackColor];
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.text=[_allKeysArray objectAtIndex:section-1];
            [viewSectionBG addSubview:labelTitle];
            
            return viewSectionBG;

        }
    }
     return nil;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
        if (_allKeysArray.count>0)
        {
            return _allKeysArray;
        }
    }
    else
    {
        return nil;
    }
    return nil;
}

#pragma mark 索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //点击索引，列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    return index+1;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return _arrSearchHistory.count;
    }
    else
    {
        return _arrHostCities.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *collectionCellID = @"collectionCellID";
    [self.collectionView registerClass:[CitySelectCollectionViewCell class]  forCellWithReuseIdentifier:collectionCellID];
    CitySelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[CitySelectCollectionViewCell alloc]initWithFrame:CGRectZero];
    }
    
    if (indexPath.section == 0)
    {
        cell._labelTitle.text = _strCurrentLocationCityName;
        
        if (isLocating)
        {
            //显示定位地区
            [cell isShowGPSStatus:isLocationFail withLocationCityName:_strCurrentLocationCityName];
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    else if (indexPath.section == 1)
    {
        [cell._imageViewGPS setHidden:YES];
        cell._labelTitle.frame = CGRectMake(0, cell._labelTitle.frame.origin.y, cell._labelTitle.frame.size.width, cell._labelTitle.frame.size.height);
        if ([_arrSearchHistory count] > indexPath.row)
        {
            cell._labelTitle.text = _arrSearchHistory[indexPath.row];
        }
        cell._labelTitle.backgroundColor = [UIColor clearColor];
        [cell._labelTitle setTextAlignment:NSTextAlignmentCenter];
    }
    else
    {
        [cell._imageViewGPS setHidden:YES];
        cell._labelTitle.frame = CGRectMake(0, cell._labelTitle.frame.origin.y, cell._labelTitle.frame.size.width, cell._labelTitle.frame.size.height);
        if ([_arrHostCities count] > indexPath.row)
        {
            cell._labelTitle.text = _arrHostCities[indexPath.row];
        }
        cell._labelTitle.backgroundColor = [UIColor clearColor];
        [cell._labelTitle setTextAlignment:NSTextAlignmentCenter];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && !isLocationFail)
    {
        [MobClick event:modifyCityViewLocationBtn];
        if( [_strCurrentLocationCityName isEqualToString: @"定位失败，请点击重试" ] )
        {
            _strCurrentLocationCityName = @"定位中...";
            [self reloadCollection];
            [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
            return;
        }
        else if([_strCurrentLocationCityName isEqualToString: @"定位中..." ])
        {
            return;
        }
        else
        {
            self.selectCity(_strCurrentLocationCityName);
            [self saveSearchCityName:_strCurrentLocationCityName];
        }
        
    }
    else if(indexPath.section == 1)
    {
        self.selectCity(_arrSearchHistory[indexPath.row]);
        [self saveSearchCityName:_arrSearchHistory[indexPath.row]];
    }
    else if(indexPath.section == 2)
    {
        if ([_arrHostCities count] > indexPath.row)
        {
            self.selectCity(_arrHostCities[indexPath.row]);
            [self saveSearchCityName:_arrHostCities[indexPath.row]];
        }
    }
    [self returnTopView];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"collectionView";
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ])
    {
        reuseIdentifier = collectionHeadID;
    }
//    [self.collectionView registerClass:[CitySelectHeadCollectionReusableView class]  forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[CitySelectHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    CitySelectHeadCollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if (indexPath.section == 0)
        {
            view._labelSectionTitle.text = @"";
            
        }
        else if (indexPath.section == 1)
        {
            if(_arrSearchHistory.count > 0){
                view._labelSectionTitle.text = @"最近访问城市";
               
            }else{
                view._labelSectionTitle.text = @"";
            }
        }
        else
        {
            view._labelSectionTitle.text = @"热门城市";
        }
    }
     view.backgroundColor = [UIColor clearColor];
    return view;
}

//返回头HeaderView的大小 (标题文字的高度)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        //隐藏第一行的Title
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
    }
    else if(section == 1){
        if(_arrSearchHistory.count == 0){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
        }else{
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        }
    }else
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置collectionView布局
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //定位城市cell 高度
        return CGSizeMake(self.collectionView.frame.size.width, 35);
    }
    else
    {
        return CGSizeMake( (self.collectionView.frame.size.width- 90)/3, 35);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *flowLayout =
    (UICollectionViewFlowLayout *)collectionViewLayout;
    if (section == 0)
    {
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
    {
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        return UIEdgeInsetsMake(0, 15, 0, 40);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark searchBarDelegete
-(void)searchCinema:(NSString *)inputContent
{
    [self._arrSearchData removeAllObjects];
    if (inputContent.length  == 0)
    {
        self.isSearch = NO;
    }
    else
    {
        [MobClick event:modifyCityViewSearchBtn];
        self.isSearch = YES;
        if (inputContent == 0)
        {
            [self._arrSearchData addObjectsFromArray:_arrAllCityNames];
            _isSearch = NO;
        }
        else
        {
            citylistModel *cityModel = [[citylistModel alloc ] init];
            for(int i = 0 ; i < [_arrAllCityModel count] ;i++)
            {
                cityModel =[_arrAllCityModel objectAtIndex:i];
                //如果是中文
                if ([self deptNameInputShouldChinese:inputContent] )
                {
                    if([cityModel.name rangeOfString:inputContent].location !=NSNotFound)
                    {
                        [self._arrSearchData addObject:cityModel.name];
                    }
                }
                else
                {
                    //只输入一个字母
                    if ([inputContent length] == 1)
                    {
                        if ([[inputContent lowercaseString] isEqualToString:[cityModel.firstLetter lowercaseString]])
                        {
                            [self._arrSearchData addObject:cityModel.name];
                        }
                    }
                    else
                    {
                        if([cityModel.py rangeOfString:[inputContent lowercaseString]].location !=NSNotFound)
                        {
                            [self._arrSearchData addObject:cityModel.name];
                        }
                    }
                }
               
            }
            _isSearch = YES;
        }
    }
    [self._mainTable reloadData];
   
}
- (BOOL) deptNameInputShouldChinese:(NSString *)inputText
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:inputText])
    {
        return YES;
    }
    return NO;
}


-(void)textFieldReturn
{
    
}

@end
