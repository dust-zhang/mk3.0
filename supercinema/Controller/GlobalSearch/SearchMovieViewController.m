//
//  SearchMovieViewController.m
//  supercinema
//
//  Created by dust on 16/11/9.
//
//

#import "SearchMovieViewController.h"

@interface SearchMovieViewController ()

@end

@implementation SearchMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor] ];
    self._labelTitle.text = @"影片搜索";
    _pageIndex = 1;
    _arrMovie = [[NSMutableArray alloc ] init];
    
    [self initController];
    [self initNoDataViewController];
    
    if ([self._strSearchCondition length ] > 0 )
    {
        _searchBar._textFieldSearchInput.text =  self._strSearchCondition;
        [_searchBar hideLabelAndClearbutton];
        [_searchBar._btnClear setHidden:NO];
    }
    _strSearchContent =self._strSearchCondition;
    [self loadSearchMovieData];
    
}
-(void)loadMoreMovieData
{
    _pageIndex+=1;
    [self loadSearchMovieData];
}


#pragma mark 查找内容
-(void)searchCinema:(NSString *)inputContent
{
    _pageIndex = 1;
    _strSearchContent =inputContent;
    if(inputContent.length >= 1)
    {
        [self loadSearchMovieData];
    }
    else
    {
        [_arrMovie removeAllObjects];
        [_tableviewMovie reloadData];
        [self loadNoSearchDataUI:NO];
        return;
    }
}


-(void) loadSearchMovieData
{
    __weak typeof(self) weakSelf = self;
    if ([_strSearchContent length] > 0 )
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [ServicesSearch searchMovie:_strSearchContent pageIndex:_pageIndex lastVisitCinemaId:[Config getCinemaId] model:^(SearchMovieListModel *model)
        {
            if (_pageIndex == 1)
            {
                [_arrMovie removeAllObjects];
            }
            [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
            [_arrMovie  addObjectsFromArray:model.movieList];
            [_tableviewMovie reloadData];
            
            if (_pageIndex < [model.pageTotal intValue])
            {
                [_tableviewMovie addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreMovieData)];
                [_tableviewMovie.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
                [_tableviewMovie.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
                [_tableviewMovie.footer endRefreshing];
            }
            else
            {
                [_tableviewMovie removeFooter];
            }
            if ([_arrMovie count] <= 0)
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
            [_tableviewMovie removeFooter];
            [Tool showWarningTip:error.domain time:1];
            [_arrMovie  removeAllObjects];
            [_tableviewMovie reloadData];
            [weakSelf initFailureView];
        }];
    }
}

-(void) initController
{
    [self._labelLine setHidden:YES];
    //搜索框
    _searchBar = [[ExUISearchBar alloc ] initWithFrame:CGRectMake(15, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+16, SCREEN_WIDTH-30, 30)];
    _searchBar.seatchBarDelegate = self;
    [_searchBar._textFieldSearchInput setPlaceholder:@"请输入影片名称"];
    [_searchBar._textFieldSearchInput addTarget:self action:@selector(searchChangeMovie:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchBar];
    
    UILabel *labelLine= [[UILabel alloc ] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y+_searchBar.frame.size.height+5.5 , SCREEN_WIDTH, 1)];
    [labelLine setBackgroundColor:RGBA(246,246,251,1)];
    [self.view addSubview:labelLine];
    
    //搜索结果列表
    _tableviewMovie = [[UITableView alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(_searchBar.frame.origin.y+_searchBar.frame.size.height+15) )];
    _tableviewMovie.delegate = self;
    _tableviewMovie.dataSource = self;
    _tableviewMovie.backgroundColor =[UIColor whiteColor];
    _tableviewMovie.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableviewMovie];
    
}


#pragma mark UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrMovie count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row == 0 )
    {
        SearchHistoryTableViewCell *cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.clearHistoryDelegate = self;
        [cell setReommmedCinema:@"电影" showHideBtn:TRUE cityName:@""];
        return cell;
    }
    else
    {
        MovieTableViewCell *cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell._buyTicketDelegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        MovieModel* model = [_arrMovie objectAtIndex:indexPath.row-1];
        [cell setMovieText:model index:indexPath.row-1 key:_searchBar._textFieldSearchInput.text];
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
        return 150;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_searchBar._textFieldSearchInput resignFirstResponder];
    [self pushToMovieDetailViewController:_arrMovie[indexPath.row  - 1] ];
}

#pragma mark 跳转到影片详情
-(void)pushToMovieDetailViewController:(MovieModel*)model
{
    __weak typeof(self) weakSelf =self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieDetail:[model.movieId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         MoviePosterViewController* vc = [[MoviePosterViewController alloc]init];
         vc.currentIndex = 0;
         if ([movieDetail.buyTicketStatus integerValue] == 0)
         {
             //不能购票
             vc.arrCommingMovieData = @[movieDetail];
         }
         else
         {
             vc.arrMovieData = @[movieDetail];
         }
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [Tool showWarningTip:@"影片不存在" time:1];
     }];
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

-(void)onButtonBuy:(NSInteger)index
{
    MovieModel *movieModel = _arrMovie[index];
    ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
    showTimeVC.hotMovieModel = movieModel;
    [self.navigationController pushViewController:showTimeVC animated:YES];
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

-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            
            [ws loadSearchMovieData];
            
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}


-(void)onButtonBack
{
    if ([self._searchMovieDelegate respondsToSelector:@selector(searchContent:)])
    {
        [self._searchMovieDelegate searchContent:_searchBar._textFieldSearchInput.text ];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchChangeMovie:(UITextField *)TextField
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
