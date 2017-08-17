//
//  SpreadListTableView.m
//  supercinema
//
//  Created by mapollo91 on 25/4/17.
//
//

#import "SpreadListTableView.h"

@implementation SpreadListTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        _isClickAll = NO;
    }
    return self;
}

-(void)initTableState:(NSInteger) count
{
    _arrState = [[NSMutableArray alloc ] initWithCapacity:0];
    for (int i = 0 ;i < count ; i ++)
    {
        [_arrState addObject:@"NO"];
    }
    
}

//画View
-(void)drawSpreadListTableViewAndData:(RedPacketCinemaListModel *)model
{
    [self initTableState:[model.cityIncludeCinemas count]];
    _model = model;
    
    /********* 头部View *********/
    UIView *viewTite = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 54.5)];
    viewTite.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewTite];
    
    UILabel *labelTite = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, viewTite.frame.size.width/2, 17)];
    labelTite.backgroundColor = [UIColor clearColor];
    [labelTite setFont:MKFONT(17)];
    [labelTite setTextColor:RGBA(51, 51, 51, 1)];
    [labelTite setTextAlignment:NSTextAlignmentLeft];
    labelTite.text = @"适用影院：";
    [viewTite addSubview:labelTite];
    
    //文字标识
    _labelSpreadType = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-15-7-5-viewTite.frame.size.width/2,labelTite.frame.origin.y+3,viewTite.frame.size.width/2,14)];
    _labelSpreadType.backgroundColor = [UIColor clearColor];
    [_labelSpreadType setFont:MKFONT(14)];
    [_labelSpreadType setTextColor:RGBA(102, 102, 102, 1)];
    [_labelSpreadType setTextAlignment:NSTextAlignmentRight];
    _labelSpreadType.text = @"全部展开";
    [viewTite addSubview:_labelSpreadType];
    
    //按钮标识
    _imageSpreadType = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-15-7, _labelSpreadType.frame.origin.y+(_labelSpreadType.frame.size.height-4)/2, 7, 4)];
    _imageSpreadType.backgroundColor = [UIColor clearColor];
    _imageSpreadType.image = [UIImage imageNamed:@"btn_spreadList_down.png"];
    [viewTite addSubview:_imageSpreadType];
    
    UIButton *btnSpreadListAll = [[UIButton alloc] initWithFrame:viewTite.frame];
    btnSpreadListAll.backgroundColor = [UIColor clearColor];
    [btnSpreadListAll addTarget:self action:@selector(onButtonSpreadListAll:) forControlEvents:UIControlEventTouchUpInside];
    btnSpreadListAll.tag = 0;//把节号保存到按钮tag，以便传递到onButtonExpandClicked方法
    [viewTite addSubview:btnSpreadListAll];
    
    //分割线
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(15, viewTite.frame.size.height-0.5, viewTite.frame.size.width-15, 0.5)];
    viewLine.backgroundColor = RGBA(242, 242, 242, 1);
    [viewTite addSubview:viewLine];
    
    /********* TableView 视图 *********/
    _tabSpreadList = [[UITableView alloc]initWithFrame:CGRectMake(0, 54.5, viewTite.frame.size.width, self.frame.size.height-54.5) style:UITableViewStylePlain];
    _tabSpreadList.backgroundColor = [UIColor clearColor];
    [_tabSpreadList setSeparatorColor:[UIColor clearColor]];
    [_tabSpreadList setDelegate:self];
    [_tabSpreadList setDataSource:self];
    [self addSubview: _tabSpreadList];
    
    [_tabSpreadList reloadData];
}

#pragma mark Table view data source
//有几个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_model.cityIncludeCinemas count];
}

//每个section中有几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //对指定节进行“展开”判断
    if (![self isExpanded:section])
    {
        //若是“折叠”的，其行数返回为0
        return 0;
    }
    
    CityIncludeCinemasModel *cityIncludeCinemasModel = _model.cityIncludeCinemas[section];
    return [cityIncludeCinemasModel.cinemaList count ];
}

//Cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.5;
}

//Cell中得内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    SpreadListTableViewCell *spreadListTableViewCell = (SpreadListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (spreadListTableViewCell == nil)
    {
        spreadListTableViewCell = [[SpreadListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [spreadListTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    CityIncludeCinemasModel *cityIncludeCinemasModel = _model.cityIncludeCinemas[indexPath.section];
    CinemaModel *model = [[CinemaModel alloc ] init];
    model = cityIncludeCinemasModel.cinemaList[indexPath.row];
    
    [spreadListTableViewCell setSpreadListTableViewCellFrameAndData:model.cinemaName];
    
    return spreadListTableViewCell;
}

// 设置header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

//section中的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    //section的背景
    UIView *viewHeadBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tabSpreadList.frame.size.width, 33)];
    viewHeadBG.backgroundColor = [UIColor whiteColor];
    
    //按钮填充整个视图
    UIButton *btnViewBG = [[UIButton alloc] initWithFrame:viewHeadBG.frame];
    btnViewBG.backgroundColor = [UIColor clearColor];
    [btnViewBG addTarget:self action:@selector(onButtonExpandClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnViewBG.tag = section;//把节号保存到按钮tag，以便传递到onButtonExpandClicked方法
    [viewHeadBG addSubview:btnViewBG];
    
    //组_名称
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, viewHeadBG.frame.size.width/2, 15)];
    labelName.backgroundColor = [UIColor clearColor];
    [labelName setFont:MKFONT(15)];
    [labelName setTextColor:RGBA(51, 51, 51, 1)];
    [labelName setTextAlignment:NSTextAlignmentLeft];
    
    CityIncludeCinemasModel *cityIncludeCinemasModel =_model.cityIncludeCinemas[section];
    labelName.text =cityIncludeCinemasModel.city.cityName;//[[self._arrData objectAtIndex:section] objectForKey:@"groupname"];
    [viewHeadBG addSubview:labelName];
    
    //组_个数
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(viewHeadBG.frame.size.width-15-7-5-viewHeadBG.frame.size.width/2,labelName.frame.origin.y,viewHeadBG.frame.size.width/2,15)];
    labelCount.backgroundColor = [UIColor clearColor];
    [labelCount setFont:MKFONT(15)];
    [labelCount setTextColor:RGBA(102, 102, 102, 1)];
    [labelCount setTextAlignment:NSTextAlignmentRight];
    [viewHeadBG addSubview:labelCount];
    
//    NSMutableArray *arrCinemaList;
//    for (CityIncludeCinemasModel *cityIncludeCinemasModel in self._arrData)
//    {
//        arrCinemaList = [[NSMutableArray alloc]initWithArray:cityIncludeCinemasModel.cinemaList];
//    }
    CityIncludeCinemasModel *cityCinemasModel = [[CityIncludeCinemasModel alloc ] init];
    cityCinemasModel =_model.cityIncludeCinemas[section];
    
    labelCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)[cityCinemasModel.cinemaList count]];
    
    //组_展开按钮方向
    UIImageView *imageSpread = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeadBG.frame.size.width-15-7, labelName.frame.origin.y+(labelCount.frame.size.height-4)/2, 7, 4)];
    imageSpread.backgroundColor = [UIColor clearColor];
    [viewHeadBG addSubview:imageSpread];
    
    //展开后的小三角
    UIImageView *imageSpreadTriangle = [[UIImageView alloc] initWithFrame:CGRectMake(51/2-2, viewHeadBG.frame.size.height-4, 12.5, 4)];
    imageSpreadTriangle.backgroundColor = [UIColor clearColor];
    [imageSpreadTriangle setImage:[UIImage imageNamed:@"image_spreadTriangle.png"]];
    imageSpreadTriangle.hidden = YES;
    [viewHeadBG addSubview:imageSpreadTriangle];
    
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
    {
        imageSpread.image = [UIImage imageNamed:@"btn_spreadList_up.png"];
        imageSpreadTriangle.hidden = NO;
    }
    else
    {
        imageSpread.image = [UIImage imageNamed:@"btn_spreadList_down.png"];
        imageSpreadTriangle.hidden = YES;
    }
    
    //分割线
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(15, viewHeadBG.frame.size.height-0.5, viewHeadBG.frame.size.width-15, 0.5)];
    viewLine.backgroundColor = RGBA(242, 242, 242, 1);
    [viewHeadBG addSubview:viewLine];
    
    return viewHeadBG;
}

//对指定的节进行“展开/折叠”操作
//-(void)collapseOrExpand:(NSInteger)section
//{
//    Boolean expanded = NO;
//    NSMutableDictionary *dic = [self._arrData objectAtIndex:section];
//    
//    //若本节model中的“expanded”属性不为空，则取出来
//    if([dic objectForKey:@"expanded"] != nil)
//    {
//        expanded=[[dic objectForKey:@"expanded"]intValue];
//    }
//    
//    [self isSpreadListAll:expanded];
//    
//    
//    //若原来是折叠的则展开，若原来是展开的则折叠
//    [dic setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
//}

#pragma mark section 按钮被点击时触发
-(void)onButtonExpandClicked:(id)sender
{
    UIButton* btn= (UIButton*)sender;
    NSInteger section= btn.tag; //取得tag知道点击对应哪个块
    
    [self modifyState:section];
    
    //刷新tableview
    [_tabSpreadList reloadData];
    
    //	NSLog(@"click %d", section);
//    [self collapseOrExpand:section];
}

#pragma mark 全部展开 & 全部收起
-(void)onButtonSpreadListAll:(UIButton *)sender
{
    if (_isClickAll == NO)
    {
        _isClickAll = YES;
        _labelSpreadType.text = @"全部收起";
        _imageSpreadType.image = [UIImage imageNamed:@"btn_spreadList_up.png"];
        
        for (int i = 0 ;i < _arrState.count ; i ++)
        {
            [_arrState removeObjectAtIndex:i];
            [_arrState insertObject:@"YES" atIndex:i];
        }
    }
    else
    {
        _isClickAll = NO;
        _labelSpreadType.text = @"全部展开";
        _imageSpreadType.image = [UIImage imageNamed:@"btn_spreadList_down.png"];

        for (int i = 0 ;i < _arrState.count ; i ++)
        {
            [_arrState removeObjectAtIndex:i];
            [_arrState insertObject:@"NO" atIndex:i];
        }
    }
    //刷新tableview
    [_tabSpreadList reloadData];
}

//判断展开逻辑
-(void)isSpreadListAll
{
    for (NSString *str in _arrState)
    {
        if([str  isEqualToString:@"YES"])
        {
            _isClickAll = YES;
            _labelSpreadType.text = @"全部收起";
            _imageSpreadType.image = [UIImage imageNamed:@"btn_spreadList_up.png"];
            return;
        }
     }
    _isClickAll = NO;
    _labelSpreadType.text = @"全部展开";
    _imageSpreadType.image = [UIImage imageNamed:@"btn_spreadList_down.png"];
}

//对指定的节进行“展开/折叠”操作
-(void)modifyState:(NSInteger)section
{
    //修改状态数组中的保存状态
    NSString *strState = _arrState[section];
    if ([strState  isEqualToString:@"YES"])
    {
        [_arrState removeObjectAtIndex:section];
        [_arrState insertObject:@"NO" atIndex:section];
    }
    else
    {
        [_arrState removeObjectAtIndex:section];
        [_arrState insertObject:@"YES" atIndex:section];
    }
    //判断展开逻辑
    [self isSpreadListAll];
}

//返回指定节的“expanded”值
-(BOOL)isExpanded:(NSInteger)section
{
    BOOL expanded = NO;
    NSString *strState = _arrState[section];
    if ([strState  isEqualToString:@"YES"])
    {
        expanded = YES;
    }
    else
    {
        expanded = NO;
    }
    return expanded;
}

@end
