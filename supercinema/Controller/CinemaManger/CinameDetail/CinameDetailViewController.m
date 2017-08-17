//
//  CinameDetailViewController.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "CinameDetailViewController.h"


@interface CinameDetailViewController ()
@end

@implementation CinameDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(28, 27, 30, 1);
    
    [self initHead];
    [self initController];
    [self refreshUI];
//    [self loadCinemaDetailData];
//    weakSelf._cinemaModel = model;
//    [self refreshUI];
}

//-(void)loadCinemaDetailData
//{
//    __weak typeof(self) weakSelf = self;
//    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
//    [ServicesCinema getCinemaDetail:[Config getCinemaId] cinemaModel:^(CinemaModel *model)
//     {
//         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
//         
//         weakSelf._cinemaModel = model;
//         [weakSelf refreshUI];
//        
//     } failure:^(NSError *error) {
//         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
//     }];
//}

- (void)initHead
{
    self._viewTop.backgroundColor = [UIColor clearColor];
    [self._btnBack setImage:[UIImage imageNamed:@"btn_backWhite.png"] forState:UIControlStateNormal];
    [self._btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    
    _btnShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-4-40.5,22.5,40.5,30)];
    [_btnShare setImage:[UIImage imageNamed:@"image_share.png"] forState:UIControlStateNormal];
    [_btnShare addTarget:self action:@selector(onButtonShare) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:_btnShare];
    
    _btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(_btnShare.frame.origin.x-40.5,22.5,40,30)];
    [_btnSearch setImage:[UIImage imageNamed:@"image_Search.png"] forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(onButtonSearch) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:_btnSearch];
    
}
- (void)initController
{
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    [imageViewBg setImage:[UIImage imageNamed:@"image_CinameBG.png"]];
    imageViewBg.userInteractionEnabled = YES;
    
    [self.view insertSubview:imageViewBg belowSubview:self._viewTop];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    [imageViewBg addSubview:_scrollView];
    
    _viewCinemaName = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_viewCinemaName];
    
    _labelCinemaName = [[UILabel alloc]init];
    _labelCinemaName.font = MKFONT(17);
    _labelCinemaName.numberOfLines = 0;
    [_viewCinemaName addSubview:_labelCinemaName];
    
    _buttonChangeCinema = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190/2,-2,80,25)];
    _buttonChangeCinema.backgroundColor = [UIColor clearColor];
    _buttonChangeCinema.titleLabel.font = MKFONT(14);
    [_buttonChangeCinema setTitle:@"切换影院" forState:UIControlStateNormal];
    _buttonChangeCinema.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,12.5-5);
    _buttonChangeCinema.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonChangeCinema.layer.borderColor = RGBA(255, 255, 255, 0.2).CGColor;
    [_buttonChangeCinema setTitleColor:RGBA(214, 214, 227, 0.6) forState:UIControlStateNormal];
    _buttonChangeCinema.layer.borderWidth = 1;
    _buttonChangeCinema.layer.masksToBounds = YES;
    _buttonChangeCinema.layer.cornerRadius = 12.5;
    UIImageView *arrawImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_CinameChange.png"]];
    arrawImageView.frame = CGRectMake(80-12.5,6.5,7.5,12);
    arrawImageView.userInteractionEnabled = YES;
    _buttonChangeCinema.userInteractionEnabled = YES;
    _viewCinemaName.userInteractionEnabled = YES;
    [_buttonChangeCinema addSubview:arrawImageView];
    [_viewCinemaName addSubview:_buttonChangeCinema];
    [_buttonChangeCinema addTarget:self action:@selector(onButtonChangeCinema) forControlEvents:UIControlEventTouchUpInside];
    
    _viewCinemaTags = [[CinemaDetailTagsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    _viewCinemaTags.backgroundColor = [UIColor clearColor];
    _viewCinemaTags.isCinemaTags = YES;
    [_scrollView addSubview:_viewCinemaTags];
    
    _viewEverCome = [[UIView alloc]initWithFrame:CGRectZero];
    _viewEverCome.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewEverCome];
    
    _labelPeopleNumber = [[UILabel alloc]init];
    _labelPeopleNumber.textColor = RGBA(255, 255, 255, 0.6);
    _labelPeopleNumber.font = MKFONT(12);
    _labelPeopleNumber.textAlignment = NSTextAlignmentLeft;
    [_viewEverCome addSubview:_labelPeopleNumber];
    
    
    _viewFacilityTags = [[CinemaDetailTagsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    _viewFacilityTags.isCinemaTags = NO;
    [_scrollView addSubview:_viewFacilityTags];
    
    
    _viewCinemaPublic = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_viewCinemaPublic];
    
    _viewWhiteLine = [[UIView alloc] initWithFrame:CGRectMake(15,0,2,14)];
    _viewWhiteLine.backgroundColor = RGBA(255, 255, 255, 1);
    [_viewCinemaPublic addSubview:_viewWhiteLine];
    
    _labelPublicTitle = [[UILabel alloc]initWithFrame:CGRectMake(27,-0.5, 100,15)];
    _labelPublicTitle.text = @"影院公告";
    _labelPublicTitle.font = MKFONT(15);
    _labelPublicTitle.textColor = RGBA(255, 255, 255, 1);
    [_viewCinemaPublic addSubview:_labelPublicTitle];
    
    _labelPublicContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelPublicContent.numberOfLines = 0;
    _labelPublicContent.font = MKFONT(12);
    _labelPublicContent.textColor = RGBA(255, 255, 255, 0.6);
    [_viewCinemaPublic addSubview:_labelPublicContent];
    
    
    _videoImageView = [[CinemaDetailVideoImageView alloc] initWithFrame:CGRectZero];
    _videoImageView.delagate = self;
    [_scrollView addSubview:_videoImageView];
    
    
    _viewCinemaLocation = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_viewCinemaLocation];
    
    _viewWhiteLine = [[UIView alloc] initWithFrame:CGRectMake(15,0,2,14)];
    _viewWhiteLine.backgroundColor = RGBA(255, 255, 255, 1);
    [_viewCinemaLocation addSubview:_viewWhiteLine];
    
    _labelLocationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelLocationTitle.textColor = RGBA(255, 255, 255, 1);
    _labelLocationTitle.text = @"影院地址";
    _labelLocationTitle.font = MKFONT(15);
    [_viewCinemaLocation addSubview:_labelLocationTitle];
    
    
    _buttonLocationShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLocationShare setImage:[UIImage imageNamed:@"image_location.png"] forState:UIControlStateNormal];
    [_viewCinemaLocation addSubview:_buttonLocationShare];
    [_buttonLocationShare addTarget:self action:@selector(onButtonLoaction) forControlEvents:UIControlEventTouchUpInside];
    
    _labelLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelLocation.font = MKFONT(14);
    _labelLocation.numberOfLines = 0;
    _labelLocation.textColor = RGBA(255, 255, 255, 1);
    [_viewCinemaLocation addSubview:_labelLocation];
    UITapGestureRecognizer *labelLocationTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonLoaction)];
    _labelLocation.userInteractionEnabled = YES;
    [_labelLocation addGestureRecognizer:labelLocationTap];
    
    _viewCinemaInfo = [[UIView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_viewCinemaInfo];
    
    _labelbBusinessHours = [[UILabel alloc]init];
    _labelbBusinessHours.textColor = RGBA(255, 255, 255, 1);
    _labelbBusinessHours.font = MKFONT(14);
    [_viewCinemaInfo addSubview:_labelbBusinessHours];
    
    _labelCinemaSeat = [[UILabel alloc]init];
    _labelCinemaSeat.textColor = RGBA(255, 255, 255, 1);
    _labelCinemaSeat.font = MKFONT(14);
    [_viewCinemaInfo addSubview:_labelCinemaSeat];
    
    _labelCreatedTime = [[UILabel alloc]init];
    _labelCreatedTime.textColor = RGBA(255, 255, 255, 1);
    _labelCreatedTime.font = MKFONT(14);
    [_viewCinemaInfo addSubview:_labelCreatedTime];
    
    _labelCircuit = [[UILabel alloc]init];
    _labelCircuit.textColor = RGBA(255, 255, 255, 1);
    _labelCircuit.font = MKFONT(14);
    [_viewCinemaInfo addSubview:_labelCircuit];
    
    
    _viewCinamePhone = [[CinemaPhoneView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 15, 90)];
    _viewCinamePhone.backgroundColor = [UIColor clearColor];
    [_viewCinemaInfo addSubview:_viewCinamePhone];
    [_viewCinamePhone addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonCallTel)]];
    
    
    _viewCooperation = [[UIView alloc]initWithFrame:CGRectZero];
    _viewCooperation.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewCooperation];
    
    
    _viewWhiteLine = [[UIView alloc] initWithFrame:CGRectMake(15,0,2,14)];
    _viewWhiteLine.backgroundColor = RGBA(255, 255, 255, 1);
    [_viewCooperation addSubview:_viewWhiteLine];
    
    _labelCooperationTitle = [[UILabel alloc]init];
    _labelCooperationTitle.textColor = RGBA(255, 255, 255, 1);
    _labelCooperationTitle.font = MKFONT(15);
    _labelCooperationTitle.text = @"合作商家";
    [_viewCooperation addSubview:_labelCooperationTitle];
    
}


- (void)refreshUI
{
    
    BOOL haveEverComeView = self._cinemaModel.visitCount > 0;
    BOOL haveCinemaTagsView = self._cinemaModel.tags.count > 0;
    BOOL haveFacilityTagsView = self._cinemaModel.featureList.count > 0;
    BOOL haveCinemaPublicView = self._cinemaModel.cinemaNotice.length > 0;
    BOOL haveVideoImageView = self._cinemaModel.images.count > 0 || self._cinemaModel.cinemaVideoInfo;
    BOOL haveCinemaLocationView = self._cinemaModel.address.length > 0;
    BOOL haveCinemaInfoView = YES;
    BOOL haveCooperationView = self._cinemaModel.merchants.count > 0;
    BOOL haveCinamePhoneView = self._cinemaModel.phoneNumberList.count > 0;
    
    _labelCinemaName.text = self._cinemaModel.fullName;
    _labelCinemaName.textColor = RGBA(255, 255, 255, 1);
    CGSize cinemaNameS = [Tool CalcString:_labelCinemaName.text fontSize:_labelCinemaName.font andWidth:SCREEN_WIDTH - 30 - 190/2];
    _labelCinemaName.frame = CGRectMake(15,0,SCREEN_WIDTH - 110-30, cinemaNameS.height);
    CGFloat viewCinemaNameH = CGRectGetMaxY(_labelCinemaName.frame) > CGRectGetMaxY(_buttonChangeCinema.frame) ? CGRectGetMaxY(_labelCinemaName.frame) : CGRectGetMaxY(_buttonChangeCinema.frame);
    _viewCinemaName.frame = CGRectMake(0,15, SCREEN_WIDTH,viewCinemaNameH);
    CGFloat  maxY = CGRectGetMaxY(_viewCinemaName.frame) +17/2;
    
    if (haveCinemaTagsView)
    {
        CGFloat tagsViewH  = [_viewCinemaTags heightWithTags:self._cinemaModel.tags];
        _viewCinemaTags.frame = CGRectMake(0, maxY, SCREEN_WIDTH, tagsViewH);
        maxY = maxY + 22/2 + tagsViewH;
    }
    _viewCinemaTags.hidden = !(haveCinemaTagsView);
    
    if (haveEverComeView)
    {
        UIView *lastView = nil;
        for (UIView *sub in _viewEverCome.subviews)
        {
            if (sub.tag >= 100)
            {
                [sub removeFromSuperview];
            }
        }
        
        if ([Config getLoginState]) {
            
            for (NSInteger i = 0; i < [self._cinemaModel.visitUsers count]; i ++)
            {
                VisitUsersListModel *userModel = [self._cinemaModel.visitUsers objectAtIndex:i];
                UIButton *btnIocn = [[UIButton alloc]initWithFrame:CGRectMake((30 * i)+(5*i),0,30,30)];
                btnIocn.layer.cornerRadius = 15;
                btnIocn.layer.masksToBounds = YES;
                btnIocn.tag =i;
                [Tool downloadImage:userModel.portraitUrl button:btnIocn imageView:nil defaultImage:@"image_defaultHead1.png"];
                [btnIocn addTarget:self action:@selector(onButtonShowUser:) forControlEvents:UIControlEventTouchUpInside];
                [_viewEverCome addSubview:btnIocn];
                lastView = btnIocn;
            }
            
            _labelPeopleNumber.text = [NSString stringWithFormat:@"%@人来过", [Tool numberFotmat:[self._cinemaModel.visitCount stringValue]] ];
            CGSize poneNumberSize = [Tool CalcString:_labelPeopleNumber.text fontSize:_labelPeopleNumber.font andWidth:MAXFLOAT];
            _labelPeopleNumber.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + 10,5,poneNumberSize.width, 20);
            _viewEverCome.frame = CGRectMake(15, maxY, SCREEN_WIDTH - 30,30);
            maxY = maxY + 20 + 110/2;
            
        }
        else
        {
            
            _labelPeopleNumber.text = [NSString stringWithFormat:@"%@人来过", [Tool numberFotmat:[self._cinemaModel.visitCount stringValue]] ];
            CGSize poneNumberSize = [Tool CalcString:_labelPeopleNumber.text fontSize:_labelPeopleNumber.font andWidth:MAXFLOAT];
            _labelPeopleNumber.frame = CGRectMake(CGRectGetMaxX(lastView.frame),5,poneNumberSize.width, 20);
            _viewEverCome.frame = CGRectMake(15, maxY, SCREEN_WIDTH - 30,30);
            maxY = maxY + 20 + 110/2;
        }
        
    }
    _viewEverCome.hidden = !haveEverComeView;
    
    if (haveFacilityTagsView)
    {
        NSMutableArray *arrTemp = [[NSMutableArray alloc ] initWithCapacity:0];
        for (FeatureListModel *model in self._cinemaModel.featureList)
        {
            [arrTemp addObject:model.featureCode];
        }
        CGFloat tagsViewH = [_viewFacilityTags heightWithTags:arrTemp];
        
        _viewFacilityTags.frame = CGRectMake(0, maxY, SCREEN_WIDTH, tagsViewH);
        maxY = maxY + tagsViewH + 45;
    }
    _viewFacilityTags.hidden = !haveFacilityTagsView;
    
    if (haveCinemaPublicView)
    {
        
        _labelPublicContent.text = self._cinemaModel.cinemaNotice;
        CGSize size = [Tool CalcString:_labelPublicContent.text fontSize:_labelPublicContent.font andWidth:SCREEN_WIDTH - 30];
        CGFloat viewH = size.height;
        _viewCinemaPublic.frame = CGRectMake(0, maxY, SCREEN_WIDTH, viewH + 29);
        _labelPublicContent.frame = CGRectMake(15, CGRectGetMaxY(_labelPublicTitle.frame) + 5 + 7, SCREEN_WIDTH - 30, viewH);
        maxY = maxY + _viewCinemaPublic.mssHeight + 45 - 10 + 13/2;
    }
    _viewCinemaPublic.hidden = !haveCinemaPublicView;
    
    if (haveVideoImageView)
    {
        [_videoImageView configWithVideos:self._cinemaModel];
        _videoImageView.frame = CGRectMake(0, maxY, SCREEN_WIDTH,157);
        maxY = maxY + (90+15)/2 + 157 - 10 - 7.5 + 6 + 6;
    }
    _videoImageView.hidden = !haveVideoImageView;
    
    if (haveCinemaLocationView)
    {
        _labelLocationTitle.frame = CGRectMake(27,0,100,15);
        _labelLocation.text = self._cinemaModel.address;
        [_labelLocation sizeToFit];
        CGSize labelSize = [Tool CalcString:_labelLocation.text fontSize:_labelLocation.font andWidth:SCREEN_WIDTH - 30 - 15 - 12];
        CGFloat viewH = labelSize.height;
        _labelLocation.frame = CGRectMake(15,15+10+2, labelSize.width, viewH);
        _buttonLocationShare.frame = CGRectMake(_labelLocation.mssRight + 11,26.5 + 1.5,12,13.5);
        _viewCinemaLocation.frame = CGRectMake(0, maxY, SCREEN_WIDTH, CGRectGetMaxY(_labelLocation.frame));
        maxY = maxY + 45 + _viewCinemaLocation.mssHeight - 1;
        
    }
    _viewCinemaLocation.hidden = !haveCinemaLocationView;
    
    if (haveCinemaInfoView)
    {
        CGFloat labelW = SCREEN_WIDTH - 30;
        NSString *businessStartTime = self._cinemaModel.businessStartTime;
        NSString *businessEndTime = self._cinemaModel.businessEndTime;
        NSString *businessHours;
        if ((businessStartTime.length > 0) && (businessEndTime.length > 0))
        {
            businessHours = [NSString stringWithFormat:@"营业时间：%@-%@",businessStartTime,businessEndTime];
        }
        else
        {
            businessHours = @"";
        }
        
        NSString *hallCount = [self._cinemaModel.hallCount stringValue];
        NSString *seatCount = [self._cinemaModel.seatCount stringValue];
        NSString *cinemaSeat;
        if ([self._cinemaModel.hallCount integerValue] > 0 && [self._cinemaModel.seatCount integerValue] > 0)
        {
            
            cinemaSeat  = [NSString stringWithFormat:@"影厅座位：%@厅 %@座位",hallCount,seatCount];
        }
        else
        {
            cinemaSeat = @"";
        }
        NSString *createdTime;
        if ([self._cinemaModel.establishedYear integerValue] == 0)
        {
            createdTime = @"";
        }
        else
        {
            createdTime = [NSString stringWithFormat:@"成立时间：%@",self._cinemaModel.establishedYear];
        }
        NSString *circuit;
        if (self._cinemaModel.owner.length == 0)
        {
            
            circuit = @"";
        }
        else
        {
            
            circuit = [NSString stringWithFormat:@"所属院线：%@",self._cinemaModel.owner];
        }
        
        CGFloat infoH = 0;
        _labelbBusinessHours.text = businessHours;
        if (businessHours.length)
        {
            _labelbBusinessHours.frame = CGRectMake(15, infoH, labelW, 12);
            infoH += 22+1;
        }
        _labelbBusinessHours.hidden = !businessHours.length;
        
        _labelCinemaSeat.text = cinemaSeat;
        if (cinemaSeat.length)
        {
            _labelCinemaSeat.frame = CGRectMake(15, infoH, labelW, 12);
            infoH += 22;
        }
        _labelCinemaSeat.hidden = !cinemaSeat.length;
        
        _labelCreatedTime.text = createdTime;
        if (createdTime.length)
        {
            _labelCreatedTime.frame = CGRectMake(15, infoH, labelW, 12);
            infoH += 22;
        }
        _labelCreatedTime.hidden = !createdTime.length;
        
        _labelCircuit.text = circuit;
        if (circuit.length)
        {
            _labelCircuit.frame = CGRectMake(15, infoH, labelW, 12);
            infoH += 22;
        }
        _labelCircuit.hidden = !circuit.length;
        
        if (haveCinamePhoneView)
        {
            _viewCinamePhone.phone = self._cinemaModel.phoneNumberList;
            CGFloat phoneViewH  = [_viewCinamePhone contentHeight];
            
            _viewCinamePhone.frame = CGRectMake(15, infoH,SCREEN_WIDTH - 15, phoneViewH);
            infoH += (10+phoneViewH);
        }
        _viewCinemaInfo.frame = CGRectMake(0, maxY, SCREEN_WIDTH, infoH + 10);
        maxY = maxY + 45 + infoH - 10 - 1.5;
    }
    _viewCinemaInfo.hidden = !haveCinemaInfoView;
    _viewCinamePhone.hidden = !haveCinamePhoneView;
    
    _merchantsData = [[NSMutableArray alloc] initWithArray:self._cinemaModel.merchants];
    if (haveCooperationView)
    {
        _labelCooperationTitle.frame = CGRectMake(27, 0, 100, 14);
        UIView *lastView = _labelCooperationTitle;
        for (UIView *sub in _viewCooperation.subviews)
        {
            if (sub.tag >= 100)
            {
                [sub removeFromSuperview];
            }
        }
        for (NSInteger i = 0; i < self._cinemaModel.merchants.count; i ++)
        {
            
            MerchantsModel *merchantsMoldel = [self._cinemaModel.merchants objectAtIndex:i];
            
            UIView *view = [self cooperationSingleView:merchantsMoldel.name activityContent:merchantsMoldel.activityContent];
            view.tag = 100 + i;
            view.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame) + 15, SCREEN_WIDTH - 20 -20, view.mssHeight);
            [_viewCooperation addSubview:view];
            lastView = view;
        }
        CGFloat viewH = CGRectGetMaxY(lastView.frame);
        _viewCooperation.frame = CGRectMake(0, maxY, SCREEN_WIDTH, viewH);
        maxY = maxY + 45 + viewH;
        
    }
    _viewCooperation.hidden = !haveCooperationView;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, maxY + 70 + 64);
    [_videoImageView imageAddTarget:self action:@selector(toMoreImageView)];
    [_videoImageView videoAddTarget:self action:@selector(onButtonMoreVideo)];
}

- (UIView *)cooperationSingleView:(NSString *)name activityContent:(NSString *)activityContent
{
    BOOL haveActivityContent = activityContent.length > 0;
    CGFloat H = 0;
    UIView *view = [[UIView alloc]init];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,-0.5,SCREEN_WIDTH - 30, 12)];
    if (haveActivityContent)
    {
        name = [NSString stringWithFormat:@"%@：",name];
    }
    nameLabel.text = name;
    nameLabel.font = MKFONT(12);
    nameLabel.textColor = RGBA(255, 255, 255, 0.6);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    
    H = 15;
    if (haveActivityContent)
    {
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,12 + 8 - 2,SCREEN_WIDTH - 40,12)];
        typeLabel.text = activityContent;
        typeLabel.numberOfLines = 0;
        typeLabel.font = MKFONT(12);
        typeLabel.textColor = RGBA(255, 255, 255, 0.6);
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.mssHeight = [Tool CalcString:activityContent fontSize:MKFONT(12) andWidth:SCREEN_WIDTH - 40].height;
        [view addSubview:typeLabel];
        H = typeLabel.mssBottom;
    }
    view.mssHeight = H;
    return view;
}

#pragma mark 定位
- (void)onButtonLoaction
{
    [MobClick event:mainViewbtn17];
    MapViewController *mapController = [[MapViewController alloc ] init];
    mapController._cinemaModel = self._cinemaModel;
    [self.navigationController pushViewController:mapController animated:YES];
}

- (void)onButtonBack
{
    [Tool showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 分享影院
- (void)onButtonShare
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCinema getCinemaShareInfo:[Config getCinemaId] model:^(CinemaShareInfoModel *model)
     {
         [weakSelf pushToCinemaShareView:model];
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         
     } failure:^(NSError *error) {
         
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [Tool showWarningTip:@"哎呀~出错了~" time:2];
     }];
    
}

-(void)pushToCinemaShareView:(CinemaShareInfoModel*)model
{
    _cinemaShareView = [[CinemaShareView alloc]initWithParentView:self.view model:model cinemaName:self._cinemaModel.fullName navigation:self.navigationController];
//    _cinemaShareView.delegate = self;
}

//-(void)pushToChangeCinemaImageViewController:(NSArray *)arrImage viewName:(NSString *)name;
//{
//    ChangeCinemaImageViewController *changeCinemaImageViewController = [[ChangeCinemaImageViewController alloc] init];
//    changeCinemaImageViewController._movidId = [NSNumber numberWithInt:665];
//    changeCinemaImageViewController._isPosters = YES;
//    changeCinemaImageViewController._arrImages = arrImage;
//    changeCinemaImageViewController._strViewName = name;
//    [self.navigationController pushViewController:changeCinemaImageViewController animated:YES];
//}

#pragma mark 搜索
- (void)onButtonSearch
{
    GlobalSearchViewController *globalSearchController = [[GlobalSearchViewController alloc ] init];
    [self.navigationController pushViewController:globalSearchController animated:YES];
}
#pragma mark 切换影院
- (void)onButtonChangeCinema
{
    CinemaSearchViewController *cinemaSearchController = [[CinemaSearchViewController alloc ] init];
    cinemaSearchController._viewName = @"CinameDetailViewController";
    [self.navigationController pushViewController:cinemaSearchController animated:YES];
}

#pragma mark -- 查看全部图片
- (void)toMoreImageView {
    
    MovieStillsViewController *movieStillVC = [[MovieStillsViewController alloc] init];
    movieStillVC.isCinameImage = YES;
    [self.navigationController pushViewController:movieStillVC animated:YES];
    
}

#pragma mark -- 查看全部视频
- (void)onButtonMoreVideo
{
    CinemaVideoListViewController *globalSearchController = [[CinemaVideoListViewController alloc ] init];
    [self.navigationController pushViewController:globalSearchController animated:YES];
}

#pragma mark -- 拨打电话
- (void)onCallTel
{
    [MobClick event:mainViewbtn18];
    if ([self._cinemaModel.phoneNumberList count] > 0)
    {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self._cinemaModel.phoneNumberList[0] ]];
        if ( !_phoneCallWebView )
        {
            _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
    
}


#pragma mark 弹出电话菜单
- (void)onButtonCallTel
{
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    contentSetView.backgroundColor = RGBA(246, 246, 251, 1);
    
    //电话按钮
    CGFloat sumHeight = 0;
    CGFloat height = 45;
    CGFloat lineHeight = 0.5;
    UIButton *btnCallPhone;
    NSArray *arrCall = self._cinemaModel.phoneNumberList;
    
    NSUInteger telIndex = [arrCall count];
    for (int i = 1; i < [arrCall count] + 1; i++)
    {
//        int j = i-1;
        telIndex--;
        btnCallPhone = [[UIButton alloc] initWithFrame:CGRectMake(0,sumHeight, SCREEN_WIDTH, height)];
        btnCallPhone.backgroundColor = [UIColor whiteColor];
        btnCallPhone.titleLabel.font = MKFONT(15);
        [btnCallPhone setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [btnCallPhone setTitle:arrCall[telIndex] forState:UIControlStateNormal];
        btnCallPhone.tag = telIndex;
        
        [btnCallPhone addTarget:self action:@selector(onButtonCallPhoneRuning:) forControlEvents:UIControlEventTouchUpInside];
        [contentSetView addSubview:btnCallPhone];
        
        //分割线
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, btnCallPhone.frame.origin.y, SCREEN_WIDTH, lineHeight)];
        [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
        
        [contentSetView addSubview:labelLine];
        sumHeight = sumHeight + height;
        
    }
    
    sumHeight = sumHeight + 14/2;
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, sumHeight, SCREEN_WIDTH, lineHeight)];
    [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
    [contentSetView addSubview:labelLine];
    sumHeight = sumHeight + lineHeight;
    
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, sumHeight, SCREEN_WIDTH, height)];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.titleLabel.font = MKFONT(15);
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.tag = 10;
    [btnCancel addTarget:self action:@selector(onBtnClosePhonePanel:) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnCancel];
    
    sumHeight = sumHeight + height;
    contentSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, sumHeight);
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
    
}

#pragma mark 拨打电话
-(void)onButtonCallPhoneRuning:(UIButton *)sender
{
    if ARRAY_IS_EMPTY(self._cinemaModel.phoneNumberList)
    {
        return;
    }
    NSString *phoneNum = [self._cinemaModel.phoneNumberList objectAtIndex:sender.tag];
    if(phoneNum != nil)
    {
        NSArray *arr = [phoneNum componentsSeparatedByString:@"-"];
        if(arr != nil && arr.count > 0)
        {
            if(arr.count == 1)
            {
                phoneNum = [arr objectAtIndex:0];
            }
            else
            {
                phoneNum = [NSString stringWithFormat:@"%@%@", [arr objectAtIndex:0], [arr objectAtIndex:1]];
            }
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            if ( !_phoneCallWebView )
            {
                _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            
        }
    }
}


#pragma mark 打开用户信息UI
-(void)onButtonShowUser:(UIButton *)sender
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        [Tool showWarningTip:@"哎呀~出错了~" time:2];
        return;
    }
    
    VisitUsersListModel *userModel = [self._cinemaModel.visitUsers objectAtIndex:sender.tag];
    if ( ![Config getLoginState ] )
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:userModel.id forKey:@"_strUserId"];
        [self showLoginController:param controllerName:@"OtherCenterViewController"];
    }
    else
    {
        if ([[Config getUserId] isEqualToString: [userModel.id stringValue]])
        {
            //切换tab
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate switchTab:2];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
            vc._strUserId = [userModel.id stringValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 弹出登录view
-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [self.navigationController pushViewController:loginControlller animated:YES];
}

#pragma mark -- CinameDeatilVideoImageViewDelegate
- (void)videoImageViewClick:(NSUInteger)section imageIndex:(NSUInteger)index
{
    if (section == 0)
    {
        switch ([MKNetWorkState getNetWorkState])
        {
            case ReachableViaWWAN:
                //运营商网络
            {
                UIAlertView* netAlert = [[UIAlertView alloc]initWithTitle:nil message:@"您正在使用非WIFI网络，继续观看可能会消耗较多流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续观看", nil];
                [netAlert show];
            }
                break;
            case ReachableViaWiFi:
                [self startPlayVideo];
                break;
            default:
                //无网络
                [Tool showWarningTip:requestErrorTip time:2];
                break;
        }
    }
    else
    {
        
        if (index >= 19) {
            
            MovieStillsViewController *movieStillVC = [[MovieStillsViewController alloc] init];
            movieStillVC.isCinameImage = YES;
            [self.navigationController pushViewController:movieStillVC animated:YES];
            
        }
        else
        {
            NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
            for(int i = 0;i < [self._cinemaModel.images count];i++)
            {
                StillModel* model = [[StillModel alloc]init];
                model = self._cinemaModel.images[i];
                MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
                
                browseItem.bigImageUrl = model.urlOfBig;
                [browseItemArray addObject:browseItem];
            }
            ImageBrowseViewController *imageBrowseController = [[ImageBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
            imageBrowseController.isEqualRatio = NO;
            [imageBrowseController showBrowseViewController];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //运营商网络下仍然播放视频
        [self startPlayVideo];
    }
}

//播放按钮
- (void)startPlayVideo
{
    UIWindow *lastWindow = [[UIApplication sharedApplication ].windows lastObject];
    if (!self._videoController)
    {
        self._videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cinemaVideoFinish)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self._videoController];
        __weak typeof(self)weakSelf = self;
        [self._videoController setDimissCompleteBlock:^{
            [weakSelf._videoController stop];
            weakSelf._videoController = nil;
        }];
    }
    self._videoController.contentURL = [NSURL URLWithString:self._cinemaModel.cinemaVideoInfo.videoUrl];
    [self._videoController showInView:lastWindow];
}

-(void) cinemaVideoFinish
{
    [self._videoController dismiss];
}

//取消
-(void)onBtnClosePhonePanel:(UIButton *)sender
{
    [[ExAlertView sharedAlertView] dismissAlertView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
