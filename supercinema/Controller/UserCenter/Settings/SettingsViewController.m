//
//  SettingsViewController.m
//  supercinema
//
//  Created by mapollo91 on 28/9/16.
//
//

#import "SettingsViewController.h"
#import "SDImageCache.h"
@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCtrl];
    [self loadUserInfo];
    [self getUserDefaultHeadImage];
}

-(void) getUserDefaultHeadImage
{
    [ServicesUser getDefaultHeadImgList:^(NSArray *array)
    {
        _arrHead = [[NSMutableArray alloc ] initWithArray:array];
        
    } failure:^(NSError *error) {
        
    }];
}
//渲染UI
-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"设置"];
    _tabViewSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_tabViewSettings setBackgroundColor:RGBA(246, 246, 255, 1)];
    [_tabViewSettings setSeparatorColor:[UIColor clearColor]];
    _tabViewSettings.delegate = self;
    _tabViewSettings.dataSource = self;
    [self.view addSubview:_tabViewSettings];
    
}

#pragma mark - TabelViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ||
        indexPath.row == 6 ||
        indexPath.row == 9)//10
    {
        //分割行（灰色）
        return 10;
    }
    else if (indexPath.row == 1)
    {
        //头像按钮
        return 66;
    }
    else if (indexPath.row == 13)
    {
        //退出按钮
        return 100;
    }
    else
    {
        //其他行
        return 45;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SettingsTableViewCell";
    _cellSet = [[SettingsTableViewCell alloc] initWithReuseIdentifier:identifier];
    _cellSet.selectionStyle = UITableViewCellSelectionStyleNone;
    _cellSet.backgroundColor = [UIColor whiteColor];
    _cellSet._delegete = self;
    
    //列表信息
    [_cellSet setSettingsTableCellDataAndRowAtIndexPath:indexPath cell:self._userModel];
    [_cellSet setSettingsTableCellFrameAndRowAtIndexPath:indexPath];
    
    return _cellSet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentCell = (SettingsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
  
    switch (indexPath.row)
    {
        case 1:
            //头像
            [MobClick event:myCenterViewbtn63];
            [self toChangeUserIcon];
            break;
        case 2://主页背景
            [MobClick event:myCenterViewbtn71];
            [self ModifyMainViewImage];
            break;
        case 3:
            //昵称
            [MobClick event:myCenterViewbtn75];
            [self toChangeNickname];
            break;
        case 4:
            //性别
            [MobClick event:myCenterViewbtn79];
            [self toChangeSex];
            break;
        case 5:
            //生日
            [MobClick event:myCenterViewbtn84];
            [self toChangeBirthday];
            break;
        case 7:
            //密码
            [MobClick event:myCenterViewbtn88];
            [self toChangePwd];
            break;
        case 8:
            //手机号
            [MobClick event:myCenterViewbtn93];
            [self toChangeMobile];
            break;
//        case 9:
//            //通知设置
//            [self toSettingsNotice];
//            break;
        case 10://11
            //清理缓存
            [self toClearTheCache];
            break;
        case 11:
            //意见反馈
            [MobClick event:myCenterViewbtn113];
            [self toFeedBack];
            break;
        case 12:
            //关于
            [MobClick event:myCenterViewbtn119];
            [self toAbout];
            break;
            
        default:
            break;
    }
}

//修改头像
-(void)toChangeUserIcon
{
    //弹起的View
    _strUploadType = @"uploadUserImage";
    
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 667/2)];
    contentSetView.backgroundColor = RGBA(246, 246, 251, 1);
    
    UILabel *labelTip = [[UILabel alloc ] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 12)];
    [labelTip setFont:MKFONT(12)];
    [labelTip setText:@"更换默认头像"];
    [labelTip setTextAlignment:NSTextAlignmentCenter];
    [labelTip setTextColor:RGBA(0, 0, 0, 0.5)];
    [contentSetView addSubview:labelTip];
    
    //默认头像
    for (int i = 0; i < [_arrHead count]; i++)
    {
        HeadImgListModel *model = _arrHead[i];
        UIImageView *imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(10+((SCREEN_WIDTH-50)/4+10)*i ,labelTip.frame.origin.y+labelTip.frame.size.height +10 , (SCREEN_WIDTH-50)/4, (SCREEN_WIDTH-50)/4)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"image_defaultHead1.png"]];
        [imageView setUserInteractionEnabled:YES];
        [imageView.layer setMasksToBounds:YES ];
        [imageView.layer setCornerRadius:134/4];
        [contentSetView addSubview:imageView];
        
        UIButton *btnHeadImage = [[UIButton alloc] initWithFrame:imageView.frame];
        btnHeadImage.backgroundColor = [UIColor clearColor];
        btnHeadImage.tag = i;
        [btnHeadImage addTarget:self action:@selector(onButtonChangeImage:) forControlEvents:UIControlEventTouchUpInside];
        [contentSetView addSubview:btnHeadImage];
       
    }
    //功能按钮
    NSArray *arrFunctionName = @[@"拍照",@"从手机相册中选择",@"保存图片"];
    
    for (int i = 0; i < [arrFunctionName count]; i++)
    {

        UIButton *btnChangeUserHeadImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 375/2.6+(45*i), SCREEN_WIDTH, 45)];
        btnChangeUserHeadImage.backgroundColor = [UIColor whiteColor];
        btnChangeUserHeadImage.titleLabel.font = MKFONT(15);
        [btnChangeUserHeadImage setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [btnChangeUserHeadImage setTitle:arrFunctionName[i] forState:UIControlStateNormal];
        btnChangeUserHeadImage.tag = i;
        [btnChangeUserHeadImage addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
        [contentSetView addSubview:btnChangeUserHeadImage];
        
        //分割线
//        if (i > 1)
        {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
            [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
            [btnChangeUserHeadImage addSubview:labelLine];
        }
    }
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 667/2-45, SCREEN_WIDTH, 45)];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.titleLabel.font = MKFONT(15);
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.tag = 10;
    [btnCancel addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnCancel];
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
}

-(void)onButtonMenu:(UIButton *)btn
{
//    NSLog(@"%ld",btn.tag);
    switch (btn.tag)
    {
        case 0:
            [MobClick event:myCenterViewbtn68];
            [self setPicture:0];
            break;
        case 1:
            [MobClick event:myCenterViewbtn69];
            [self setPicture:1];
            break;
        case 2:
            [MobClick event:myCenterViewbtn70];
            [self saveImageToPhotos];
            break;
        case 1000:
        {
            [MobClick event:myCenterViewbtn129];
            [self Logout];
        }
            break;
        default:
            break;
    }
    [MobClick event:myCenterViewbtn130];
    [[ExAlertView sharedAlertView] dismissAlertView];
}

-(void)Logout
{
    [ServicesUser loginLogout:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
    {
        [Config deleteUserLoactionData];
        [Config saveCredential:model.loginResult.credential];
        [Config saveUserType:[model.loginResult.passportType stringValue]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        //刷新捡便宜
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCARD object:nil];
        //刷新消遣
        [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHGAME object:nil];

        [[ExAlertView sharedAlertView] dismissAlertView];
        
    } failure:^(NSError *error) {
        if (error.code != 1 && error.code != noNetWorkCode )
        {
            //删除用户本地数据
            [Config deleteUserLoactionData];
        }
        
    }];
}

#pragma mark 保存头像到相册
- (void)saveImageToPhotos
{
    NSString *urlString =@"";
    NSData *data = nil;
    if ([_strUploadType isEqualToString:@"uploadBgImage"])
    {
        if(self._userModel.settingList[0] > 0)
        {
            SettingListModel *model =  self._userModel.settingList[0];
            urlString =[Tool urlIsNull:model.settingValue];
        }
    }
    else
    {
         urlString =[Tool urlIsNull:self._userModel.portrait_url];
    }
    if([urlString length] == 0)
    {
        data = UIImagePNGRepresentation([UIImage imageNamed:@"image_userCenterTopBG.png"]);
    }
    else
    {
        data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请在“设置-隐私-照片”选项中，允许超级电影院访问您的照片。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    
    if(error != NULL)
    {
        [alert show];
    }
    else
    {
        [Tool showSuccessTip:@"保存图片成功" time:1];
    }
    
}

//选择默认头像
-(void)onButtonChangeImage:(UIButton *)btn
{
    if(btn.tag == 0)
    {
        [MobClick event:myCenterViewbtn64];
    }
    if(btn.tag == 1)
    {
        [MobClick event:myCenterViewbtn65];
    }
    if(btn.tag == 2)
    {
        [MobClick event:myCenterViewbtn66];
    }
    if(btn.tag == 3)
    {
        [MobClick event:myCenterViewbtn67];
    }
    
    HeadImgListModel *model = _arrHead[btn.tag];
    [self upLoadImageAndContent:model.headImgUrl];

    [[ExAlertView sharedAlertView] dismissAlertView];
}

-(void)ModifyMainViewImage
{
    _strUploadType = @"uploadBgImage";

    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
    contentSetView.backgroundColor = RGBA(246, 246, 251, 1);
    //功能按钮
    NSArray *arrFunctionName = @[@"拍照",@"从手机相册中选择",@"保存图片"];
    UIButton *btnChangeUserHeadImage;
    for (int i = 0; i < [arrFunctionName count]; i++)
    {
        
        btnChangeUserHeadImage = [[UIButton alloc] initWithFrame:CGRectMake(0, (45*i), SCREEN_WIDTH, 45)];
        btnChangeUserHeadImage.backgroundColor = [UIColor whiteColor];
        btnChangeUserHeadImage.titleLabel.font = MKFONT(15);
        [btnChangeUserHeadImage setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [btnChangeUserHeadImage setTitle:arrFunctionName[i] forState:UIControlStateNormal];
        btnChangeUserHeadImage.tag = i;
        [btnChangeUserHeadImage addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
        [contentSetView addSubview:btnChangeUserHeadImage];
        
        //分割线
//        if (i > 1)
        {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
            [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
            [btnChangeUserHeadImage addSubview:labelLine];
        }
    }
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, btnChangeUserHeadImage.frame.origin.y+btnChangeUserHeadImage.frame.size.height+5, SCREEN_WIDTH, 45)];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.titleLabel.font = MKFONT(15);
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.tag = 10;
    [btnCancel addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnCancel];
    
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
    
//    [self setPicture:1];
}

-(void)setPicture:(NSInteger)type
{
    //跳转到相机或相册页面
    NSUInteger sourceType = type == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [ImageOperation changeHeadImageSize:image scaleToSize:CGSizeMake(500, 500)];
    [self uploadRequire:UIImagePNGRepresentation(image)];
}

#pragma mark - FSMediaPicker Delegate Methods
-(void)mediaPickerCameraAuth
{
    if (!_mediaAlert)
    {
        _mediaAlert = [[UIAlertView alloc]
                       initWithTitle:@"提示"
                       message:@"请在[系统设置]中打开相机服务"
                       delegate:self
                       cancelButtonTitle:@"取消"
                       otherButtonTitles:@"确定", nil];
    }
    [_mediaAlert show];
}

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    UIImage *image = [mediaInfo objectForKey:UIImagePickerControllerEditedImage];
    image = [ImageOperation changeHeadImageSize:image scaleToSize:CGSizeMake(500, 500)];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //buttonIndex 1为确定，0为取消
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark 上传头像 imgData 图片二进制流
-(void)uploadRequire:(NSData*)imageData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在上传..." withBlur:NO allowTap:NO];
    [ServicesUpload requestUpdateImage:1  type:@"user" success:^(NSDictionary *suc)
     {
         _arrayUpload = [ServicesUpload getUploadYpaiParam:suc];
         [weakSelf upLoadUpai:imageData];
         
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain  time:1.0f];
     }];
    
}

//将图片上传到又拍
-(void) upLoadUpai:(NSData*)imageData
{
    upLoadImageModel *upLoadimageModel = [_arrayUpload objectAtIndex:0];
    
    NSDictionary * parameDic = @{upLoadimageModel.policyKey:upLoadimageModel.policyValue ,
                                 upLoadimageModel.signatureKey:upLoadimageModel.signatureValue};
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setValue:[Config getCredential] forHTTPHeaderField:@"Authorization"];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    [sessionManager POST:upLoadimageModel.upload_url parameters:parameDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"file%@",[imageData detectImageSuffix]]
                                 mimeType:@"multipart/form-data"];
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
         
         NSLog(@"%@",responseObject);
         //如果上传又拍成功 继续上传到自己服务器s
         UpLoadModel* model = [[UpLoadModel alloc] initWithDictionary:responseObject error:nil];
         if ([model.code intValue] == 200)
         {
             if ([_strUploadType isEqualToString:@"uploadUserImage"])
             {
                  [self upLoadImageAndContent:model.url];
             }
             else
             {
                 [self modifyUserInfo:model.url nick:@"" birthday:@"" gender:@0];
             }
            
         }
         else
         {
             [Tool showWarningTip:@"上传头像失败"  time:1.0f];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [Tool showWarningTip:@"上传头像失败"  time:1.0f];
         NSLog(@"%@",error);
     }];
}

//图片地址保存在服务器上
-(void)upLoadImageAndContent:(NSString*)url
{
    __weak typeof(self) weakSelf = self;
    [ServicesUser upLoadUserHeadImage:url model:^(RequestResult *model)
    {
        [Tool showSuccessTip:@"上传成功" time:1];
        [weakSelf loadUserInfo];
        
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:1];
    }];
}


//修改昵称
-(void)toChangeNickname
{
    ChangeNicknameViewController *changeNicknameVC = [[ChangeNicknameViewController alloc] init];
    changeNicknameVC.delegate = self;
    changeNicknameVC._userModel = self._userModel;
    
    [self.navigationController pushViewController:changeNicknameVC animated:YES];
}

-(void)changeNickname:(NSString *)newNickName
{
    self._userModel.nickname = newNickName;
    [_tabViewSettings reloadData];
}

//修改性别
-(void)toChangeSex
{
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 143)];
    contentSetView.backgroundColor = RGBA(246, 246, 251, 1);

    //性别按钮
    NSArray *arrSexName = @[@"男", @"女"];
    for (int i = 1; i < [arrSexName count]+1 ; i++)
    {
        _btnChangeSex = [[UIButton alloc] initWithFrame:CGRectMake(0, (45*(i-1)), SCREEN_WIDTH, 45)];
        _btnChangeSex.backgroundColor = [UIColor whiteColor];
        _btnChangeSex.titleLabel.font = MKFONT(15);
        [_btnChangeSex setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_btnChangeSex setTitle:arrSexName[i-1] forState:UIControlStateNormal];
        _btnChangeSex.tag = i;
        [_btnChangeSex addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
        [contentSetView addSubview:_btnChangeSex];
    
        //分割线
//        if (i>1)
        {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
            [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
            [_btnChangeSex addSubview:labelLine];
        }
    }
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 45*2+1+7, SCREEN_WIDTH, 45)];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.titleLabel.font = MKFONT(15);
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.tag = 10;
    [btnCancel addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnCancel];
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
}

//点击修改 性别 事件
-(void)changeSex:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    if (tag == 1)
    {
        [MobClick event:myCenterViewbtn80];
    }
    else
    {
        [MobClick event:myCenterViewbtn81];
    }
    if(tag == 10)
    {
        [[ExAlertView sharedAlertView] dismissAlertView];
        return;
    }
    self._userModel.gender = [NSNumber numberWithInteger:tag] ;
    
    [[ExAlertView sharedAlertView] dismissAlertView];
    [_tabViewSettings reloadData];
    
    [self modifyUserInfo:@"" nick:@"" birthday:@"" gender:self._userModel.gender];
}

//修改生日
-(void)toChangeBirthday
{
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 279)];
    contentSetView.backgroundColor = RGBA(255, 255, 255, 1);
    
    //弹框顶部按钮区域
    UIView *viewAlertTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [viewAlertTop setBackgroundColor:RGBA(246, 246, 251, 1)];
    [contentSetView addSubview:viewAlertTop];
   
    //取消按钮
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 45)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack.titleLabel setFont:MKFONT(15)];
    [btnBack setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnBack setTitleColor:RGBA(51, 51, 51, 0.3) forState:UIControlStateHighlighted];
    [btnBack setTitle:@"取消" forState:UIControlStateNormal];
    btnBack.tag = 0;
    [btnBack addTarget:self action:@selector(onButtonChangeBirthday:) forControlEvents:UIControlEventTouchUpInside];
    [viewAlertTop addSubview:btnBack];
    
    //确认按钮
    UIButton *btnDefine = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 0, 65, 45)];
    [btnDefine setBackgroundColor:[UIColor clearColor]];
    [btnDefine.titleLabel setFont:MKFONT(15)];
    [btnDefine setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [btnDefine setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateHighlighted];
    [btnDefine setTitle:@"确认" forState:UIControlStateNormal];
    btnDefine.tag = 1;
    [btnDefine addTarget:self action:@selector(onButtonChangeBirthday:) forControlEvents:UIControlEventTouchUpInside];
    [viewAlertTop addSubview:btnDefine];
    
    //生日（日期选取器）
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,45,SCREEN_WIDTH,234)];
    //日期选取器模式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //设置时区(中国)
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    //设置为中文
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    
    //获得当前UIPickerDate所在的时间
    NSDate *selected = [_datePicker date];
    [_datePicker setDate:selected animated:YES];
    //设置显示最大时间（此处为当前时间）
    [_datePicker setMaximumDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if(self._userModel != nil && self._userModel.birthday != nil){
        //设置输出的格式
        NSDate *date = [dateFormatter dateFromString:self._userModel.birthday];
        _datePicker.date = date;
    }else{
        //设置输出的格式
        NSDate *date = [dateFormatter dateFromString:@"1988-08-18"];
        _datePicker.date = date;
    }
    
    [contentSetView addSubview:_datePicker];
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
}

//点击修改 生日 事件
-(void)onButtonChangeBirthday:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
           [MobClick event:myCenterViewbtn87];
            break;
        case 1:
            [MobClick event:myCenterViewbtn86];
            [self changeBirthday:_datePicker];
            break;
        default:
            break;
    }
    [[ExAlertView sharedAlertView] dismissAlertView];
}

-(void)changeBirthday:(UIDatePicker *)control
{
    self._userModel.birthday = [Tool dateToString:control.date format:@"yyyy-MM-dd"];
    [_tabViewSettings reloadData];
    [self modifyUserInfo:@"" nick:@"" birthday:[Tool dateToString:control.date format:@"yyyy-MM-dd"] gender:@0];
}

//修改密码
-(void)toChangePwd
{
    if ([self._userModel.mobileno length] == 0)
    {
        [Tool showWarningTip:@"请绑定手机号" time:2];
        return;
    }
    ChangePwdViewController *changePwdVC = [[ChangePwdViewController alloc] init];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}

//修改手机号
-(void)toChangeMobile
{
    if([self._userModel.mobileno length]>0)
    {
        ChangeMobileViewController *changeMobileController = [[ChangeMobileViewController alloc] init];
        [self.navigationController pushViewController:changeMobileController animated:YES];
    }
    else
    {
        BindTelNumberViewController *bindTelNumberController = [[BindTelNumberViewController alloc] init];
        [self.navigationController pushViewController:bindTelNumberController animated:YES];
    }
    
}

//通知设置
-(void)toSettingsNotice
{
    SettingsNoticeViewController *settingsNoticeController = [[SettingsNoticeViewController alloc] init];
    [self.navigationController pushViewController:settingsNoticeController animated:YES];
}

//清理缓存
-(void)toClearTheCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    [_tabViewSettings reloadData];
    [Tool showSuccessTip:@"清理完成" time:1];
}

//意见反馈
-(void)toFeedBack
{
    FeedBackViewController *feedBackVC = [[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

//关于
-(void)toAbout
{
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

#pragma mark 修改用户信息
-(void)modifyUserInfo:(NSString *)setViewBgImageUrl nick:(NSString *)nick  birthday:(NSString *)birthday  gender:(NSNumber *)gender
{
    __weak typeof(self) weakSelf = self;
    [ServicesUser updateUserInfo:nick gender:gender birthday:birthday signature:@""  headUrl:setViewBgImageUrl model:^(RequestResult *model)
    {
        if([setViewBgImageUrl length] > 0)
        {
            [Tool showSuccessTip:@"上传成功" time:1];
        }
        [weakSelf loadUserInfo];
        
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1];
     }];
}

-(void) loadUserInfo
{
    __weak typeof(self) weakSelf = self;
//    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesUser getMyInfo:@"" model:^(UserModel *userModel)
    {
//         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         weakSelf._userModel = userModel;
         [_tabViewSettings reloadData];
         
     } failure:^(NSError *error) {
//         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [Tool showWarningTip:error.domain time:1];
     }];
}

#pragma mark 退出
-(void)onButtonExit
{
    [MobClick event:myCenterViewbtn128];
    _strUploadType =@"exit";
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270/2)];
    contentSetView.backgroundColor = RGBA(246, 246, 251, 1);
    
    NSArray *arrFunctionName = @[@"确定要退出登录吗?",@"退出登录"];
    
    for (int i = 0; i < [arrFunctionName count]; i++)
    {
        UIButton *btnChangeUserHeadImage = [[UIButton alloc] initWithFrame:CGRectMake(0, (41*i)+i, SCREEN_WIDTH, 41)];
        if (i == 0 )
        {
            btnChangeUserHeadImage.frame  =CGRectMake(0, (45*i)+i, SCREEN_WIDTH, 45);
            [btnChangeUserHeadImage setTitleColor:RGBA(89, 89, 131, 1) forState:UIControlStateNormal];
            [btnChangeUserHeadImage.titleLabel setFont:MKFONT(12) ];
        }
        else
        {
            btnChangeUserHeadImage.titleLabel.font = MKFONT(15);
            [btnChangeUserHeadImage setTitleColor:RGBA(255, 0, 0, 1) forState:UIControlStateNormal];
            btnChangeUserHeadImage.tag = 1000;
            [btnChangeUserHeadImage addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnChangeUserHeadImage.backgroundColor = [UIColor whiteColor];
        [btnChangeUserHeadImage setTitle:arrFunctionName[i] forState:UIControlStateNormal];
        [contentSetView addSubview:btnChangeUserHeadImage];
    }
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 1)];
    [labelLine setBackgroundColor:RGBA(242, 242, 242, 3)];
    [contentSetView addSubview:labelLine];
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 270/2-45, SCREEN_WIDTH, 45)];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.titleLabel.font = MKFONT(15);
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.tag = 10;
    [btnCancel addTarget:self action:@selector(onButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnCancel];
    
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


