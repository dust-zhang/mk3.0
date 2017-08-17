//
//  UserSearchViewController.m
//  supercinema
//
//  Created by dust on 16/11/9.
//
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()

@end

@implementation SearchUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor] ];
    self._labelTitle.text = @"用户搜索";
    _pageIndex = 1;
    _arrUser = [[NSMutableArray alloc ] init];
    [self initController];
    [self initNoDataViewController];
    
    if ([self._strSearchCondition length ] > 0 )
    {
        _searchBar._textFieldSearchInput.text =  self._strSearchCondition;
        [_searchBar hideLabelAndClearbutton];
        [_searchBar._btnClear setHidden:NO];
    }
    _strSearchContent = self._strSearchCondition;
    [self loadUserData];
}

-(void)onButtonBack
{
    if ([self._searchUserDelegate respondsToSelector:@selector(searchContent:)])
    {
        [self._searchUserDelegate searchContent:_searchBar._textFieldSearchInput.text ];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) initController
{
    [self._labelLine setHidden:YES];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [self.view addSubview:viewLine];
    
    //搜索框
    _searchBar = [[ExUISearchBar alloc ] initWithFrame:CGRectMake(15, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+16, SCREEN_WIDTH-30, 30)];
    _searchBar.seatchBarDelegate = self;
    [_searchBar._textFieldSearchInput setPlaceholder:@"请输入用户昵称"];
    [_searchBar._textFieldSearchInput addTarget:self action:@selector(searchChangeUser:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchBar];
    
    UILabel *labelLine= [[UILabel alloc ] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y+_searchBar.frame.size.height+5.5 , SCREEN_WIDTH, 0.5)];
    [labelLine setBackgroundColor:RGBA(246,246,251,1)];
    [self.view addSubview:labelLine];
    
    //搜索结果列表
    _tableviewUser = [[UITableView alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(_searchBar.frame.origin.y+_searchBar.frame.size.height+15) )];
    _tableviewUser.delegate = self;
    _tableviewUser.dataSource = self;
    _tableviewUser.backgroundColor =[UIColor whiteColor];
    _tableviewUser.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableviewUser];

}

-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            
            [ws loadUserData];
            
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}


-(void) loadUserData
{
    __weak typeof(self) weakSelf = self;
    if ([_strSearchContent length] > 0 )
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [ServicesSearch searchUser:_strSearchContent pageIndex:_pageIndex model:^(SearchUserListModel *model)
         {
             if (_pageIndex == 1)
             {
                 [_arrUser removeAllObjects];
             }
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
             [_arrUser  addObjectsFromArray:model.userList];
             [_tableviewUser reloadData];
             
             if (_pageIndex < [model.pageTotal intValue])
             {
                 [_tableviewUser addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreUserData)];
                 [_tableviewUser.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
                 [_tableviewUser.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
                 [_tableviewUser.footer endRefreshing];
             }
             else
             {
                 [_tableviewUser removeFooter];
             }
             
             //没有数据
             if ([_arrUser count] <= 0)
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
             [_tableviewUser removeFooter];
             [Tool showWarningTip:error.domain time:1];
             [_arrUser  removeAllObjects];
             [_tableviewUser reloadData];
             [weakSelf initFailureView];
         }];
    }
}


-(void)loadMoreUserData
{
    _pageIndex+=1;
    [self loadUserData];
}
-(void)searchCinema:(NSString *)inputContent
{
    _pageIndex = 1;
     [_tableviewUser removeFooter];
    _strSearchContent = inputContent;
    if(inputContent.length >= 1)
    {
        [self loadUserData];
    }
    else
    {
        [_arrUser removeAllObjects];
        [_tableviewUser reloadData];
        [self loadNoSearchDataUI:NO];
        return;
    }
}

#pragma mark UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrUser count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row == 0 )
    {
        SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.clearHistoryDelegate = self;
        [cell setReommmedCinema:@"用户" showHideBtn:TRUE cityName:@""];
        return cell;
    }
    else
    {
        UserTableViewCell *cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        FollowPersonListModel *model = [_arrUser objectAtIndex:indexPath.row-1];
        [cell setUserText:model key:_searchBar._textFieldSearchInput.text];
        return cell;

    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 )
    {
        return 45;
    }
    else
    {
        return 70;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_searchBar._textFieldSearchInput resignFirstResponder];
//    NSLog(@"%ld",indexPath.row);
    if(indexPath.row == 0)
        return;
    FollowPersonListModel *model = _arrUser[indexPath.row-1];
    if ([[Config getUserId] isEqualToString:[model.id stringValue]])
    {
        //切换tab
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchTab:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
        vc._strUserId = [model.id stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void) onButtonClear:(UIButton*)sender
{
    
}

-(void)onButtonHistory:(NSString *)strHistory
{
    
}
-(void)textFieldReturn
{
    
}
#pragma mark 创建无数据UI
-(void) initNoDataViewController
{
    _imageView= [[UIImageView alloc ] init];
    _imageView.frame = CGRectMake(SCREEN_WIDTH/2-(78/4),self._viewTop.frame.size.height+ 200, 78/2, 135/2);
    [self.view addSubview:_imageView];
    [_imageView setHidden:YES];
    
    _labelDesc = [[UILabel alloc ] init];
    _labelDesc.frame = CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+15, SCREEN_WIDTH, 14);
    [_labelDesc setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDesc setTextAlignment:NSTextAlignmentCenter];
    [_labelDesc setFont:MKFONT(14)];
    [self.view addSubview:_labelDesc];
    [_labelDesc setHidden:YES];
    
}


#pragma mark 加载失败 显示UI
-(void) loadNoSearchDataUI:(BOOL ) ShowHide
{
    [_labelDesc setHidden:ShowHide];
    [_imageView setHidden:ShowHide];
    
    _imageView.frame = CGRectMake(SCREEN_WIDTH/2-(104/4),self._viewTop.frame.size.height+ 150, 104/2, 152/2);
    [_imageView setImage:[UIImage imageNamed:@"image_NoDataCinemaSearch.png"]];
    
    _labelDesc.frame = CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+15, SCREEN_WIDTH, 40);
    [_labelDesc setText:@"就算一无所获,也别放弃寻找。\n譬如：换个关键词试试......"];
    [_labelDesc setNumberOfLines:0];
    [_labelDesc setLineBreakMode:NSLineBreakByCharWrapping];
    [Tool setLabelSpacing:_labelDesc spacing:4 alignment:NSTextAlignmentCenter];
    
}

-(void)searchChangeUser:(UITextField *)TextField
{
//    [self searchCinema:TextField.text];
    if ([TextField.text length] == 0)
    {
        [_searchBar._btnClear setHidden:YES];
    }
    else
    {
        [_searchBar._btnClear setHidden:NO];
    }
}

@end
