//
//  ChangeCinemaImageViewController.m
//  supercinema
//
//  Created by mapollo91 on 12/4/17.
//
//

#import "ChangeCinemaImageViewController.h"

#define LOAD_COUNT_PER_TIME   30

@implementation ChangeCinemaImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrStillsImage = [[NSMutableArray alloc] init];
    _arrNewStillsImage = [[NSMutableArray alloc] init];
    
    [self initController];
    //影院分享
    if ([self._strViewName isEqualToString:@"cinemaShareView"])
    {
        [self initCinemaShareData];
    }
    else
    {
        [self initData];
    }
    
}
-(void)initCinemaShareData
{
     if ([[Config getSelectImageUrl:@"cinemaShareUrl"] length] == 0)
     {
         _arrStillsImage = [[NSMutableArray alloc] initWithArray:self._arrImages];
     }
     else
     {
         for (StillModel *mode in self._arrImages)
         {
             if ([mode.url isEqualToString:[Config getSelectImageUrl:@"cinemaShareUrl"]])
             {
                 [_arrStillsImage insertObject:mode atIndex:0];
             }
             else
             {
                 [_arrStillsImage addObject:mode];
             }
         }
     }
     
     if( [_arrStillsImage count] > 0 )
     {
         _indexImage = 0;
         [self copyData];
         [_pickerView reload];
         
         [self showImageWithStatus:NO isLoadSuccess:YES];
     }
     else
     {
         [self showImageWithStatus:YES isLoadSuccess:YES];
     }

}

-(void)initController
{
    self._labelTitle.text = @"更改图片";
    //确认按钮
    UIButton *btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-55,67/2, 40, 15)];
    [btnEnsure setTitle:@"确认" forState:UIControlStateNormal];
    btnEnsure.enabled = YES;
    [btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [btnEnsure.titleLabel setFont:MKFONT(15)];
    [btnEnsure addTarget:self action:@selector(onButtonEnsure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEnsure];
    
    if (self._arrImages.count == 0)
    {
        [btnEnsure setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
        [btnEnsure setUserInteractionEnabled:NO];//按钮不可点击
    }
    else
    {
        [btnEnsure setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [btnEnsure setUserInteractionEnabled:YES];//按钮可点击
    }
    
    //分享
    _pickerView  = [[PhotoPickerView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,  SCREEN_HEIGHT-64)];
    _pickerView.isSingleCheck = YES;
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.delegate = self;
    [self.view addSubview:_pickerView];
    //[_pickerView reload];
    
    //============================异常状态控件=================================
    //加载失败
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-73)/2, 103+64, 73, 67)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    _imageFailure.hidden = YES;
    [self.view addSubview:_imageFailure];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    _labelFailure.text = @"加载失败";
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    _labelFailure.hidden = YES;
    [self.view addSubview:_labelFailure];
    
    _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+25, 146/2, 24);
    [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnTryAgain.titleLabel.font = MKFONT(14);
    _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    _btnTryAgain.layer.masksToBounds = YES;
    _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
    [_btnTryAgain addTarget:self action:@selector(onButtonTryAgainShareList) forControlEvents:UIControlEventTouchUpInside];
    _btnTryAgain.hidden = YES;
    [self.view addSubview:_btnTryAgain];
    //============================异常状态控件=================================
}

#pragma mark 初始化数据
-(void)initData
{
    
    if ([[Config getSelectImageUrl:@"cinemaShareUrl"] length] == 0)
    {
        _arrStillsImage = [[NSMutableArray alloc] initWithArray:self._arrImages];
    }
    else
    {
        for (StillModel *mode in self._arrImages)
        {
            if (![mode.url isEqualToString:[Config getSelectImageUrl:@"cinemaShareUrl"]])
            {
                [_arrStillsImage addObject:mode];
            }
            else
            {
                [_arrStillsImage removeObject:mode];
            }
        }
        StillModel *mode = [[StillModel alloc ] init];
        mode.url = [Config getSelectImageUrl:@"cinemaShareUrl"];
        [_arrStillsImage insertObject:mode atIndex:0];
    }
    
    
    if( [self._arrImages count] > 0 )
    {
        _indexImage = 0;
        [self copyData];
        [_pickerView reload];
        
        [self showImageWithStatus:NO isLoadSuccess:YES];
    }
    else
    {
        [self showImageWithStatus:YES isLoadSuccess:YES];
    }


//    __weak typeof(self) weakSelf = self;
//    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
//    [ServiceStills getStills:self._movidId includeMainHaibao:[NSNumber numberWithInt:1] array:^(NSArray *arrStills)
//     {
//         if ([[Config getSelectImageUrl:@"cinemaShareUrl"] length] == 0)
//         {
//             _arrStillsImage = [[NSMutableArray alloc] initWithArray:arrStills];
//         }
//         else
//         {
//             for (StillModel *mode in arrStills)
//             {
//                 if (![mode.url isEqualToString:[Config getSelectImageUrl:@"cinemaShareUrl"]])
//                 {
//                     [_arrStillsImage addObject:mode];
//                 }
//                 else
//                 {
//                     [_arrStillsImage removeObject:mode];
//                 }
//             }
//            StillModel *mode = [[StillModel alloc ] init];
//            mode.url = [Config getSelectImageUrl:@"cinemaShareUrl"];
//            [_arrStillsImage insertObject:mode atIndex:0];
//         }
//         
//         
//         if( [arrStills count] > 0 )
//         {
//             _indexImage = 0;
//             [weakSelf copyData];
//             [_pickerView reload];
//             
//             [weakSelf showImageWithStatus:NO isLoadSuccess:YES];
//         }
//         else
//         {
//             [weakSelf showImageWithStatus:YES isLoadSuccess:YES];
//         }
//         
//         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
//     } failure:^(NSError *error) {
//         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
//         [Tool showWarningTip:error.domain time:2];
//         [weakSelf showImageWithStatus:NO isLoadSuccess:NO];
//     }];
}


-(void) showImageWithStatus:(BOOL)status isLoadSuccess:(BOOL)isLoadSuccess
{
    _imageFailure.hidden = isLoadSuccess;
    _labelFailure.hidden = isLoadSuccess;
    _btnTryAgain.hidden =  isLoadSuccess;
}

#pragma mark PhotoPickerViewDelegate
/*============================PhotoPickerViewDelegate Start=================================*/
//内容
-(void)itemView:(PhotoViewItem *)item AtIndex:(NSInteger)index
{
    item.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageViewSelected = [[UIImageView alloc] initWithFrame:CGRectMake(item.frame.size.width-5-21, 5, 21, 21)];
    imageViewSelected.tag = 1111;
    imageViewSelected.backgroundColor = [UIColor clearColor];
    [imageViewSelected setImage:[UIImage imageNamed:@"btn_selected.png"]];
    
    if (index == 0)
    {
        if (self._isPosters)
        {
            imageViewSelected.hidden = NO;
        }
        else
        {
            imageViewSelected.hidden = YES;
        }
    }
    else
    {
        imageViewSelected.hidden = YES;
    }
    
    [item addSubview:imageViewSelected];
    
    item._imageView.image = [UIImage imageNamed:@"image_cutLoading.png"];
    
    StillsModel *stillsModel = [_arrNewStillsImage objectAtIndex:index];
    [Tool downloadImage:stillsModel.url button:nil imageView:item._imageView defaultImage:@"image_cutLoading.png"] ;//img_ticketMoviePosterShare_default.png
}

//每行多少个
-(NSInteger)cellItemCount
{
    return 3;
}

//一共多少张图片
-(NSInteger)dataCount
{
    return _arrNewStillsImage.count;
}

//横向间距
-(CGFloat)itemPaddingRight
{
    return 1.5;
}

//纵向间距
-(CGFloat)itemPaddingBottom
{
    return 1.5;
}

//是否显示加载更多
-(BOOL)lastViewIsShow
{
    if (_arrStillsImage.count > _arrNewStillsImage.count)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)checkItemStatus:(PhotoViewItem *)item
{
    UIImageView *imageSelected = [item viewWithTag:1111];
    if(imageSelected != nil)
    {
        imageSelected.hidden = NO;//!imageSelected.hidden
    }
}

-(void)uncheckItemStatus:(PhotoViewItem *)item
{
    UIImageView *imageSelected = [item viewWithTag:1111];
    if(imageSelected != nil)
    {
        imageSelected.hidden = YES;
    }
}

#pragma mark 确认按钮
-(void)onButtonEnsure
{
    if (_imageURL == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Config saveSelectImageUrl:_imageURL key:@"cinemaShareUrl"];
        
        if ([self.delegate respondsToSelector:@selector(ChangeCinemaImageDelegate:)])
        {
            [self.delegate ChangeCinemaImageDelegate:_imageSelectedCinema];
        }
        
        
        //刷新海报分享页
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:_imageSelectedCinema forKey:@"returnImageCinema"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_CINEMASHAREIMAGE object:dic];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//点击图片
-(void)touchItem:(PhotoViewItem *)item AtIndex:(NSInteger)index
{
    //点击裁剪显示大图
    StillsModel *stillsModel = [_arrNewStillsImage objectAtIndex:index];

    _imageURL = stillsModel.url;
    _imageSelectedCinema = item._imageView.image;
    
    
//    [self popupCutImageViewImage:_imageURL];
}

////跳转到裁剪界面
//-(void)popupCutImageViewImage:(NSString *)_imageURL
//{
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    
//    CutImageView *cutImageView = [[CutImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) _imageURL:_imageURL control:0.7 nav:self.navigationController];
//    cutImageView.hidden=YES;
//    cutImageView.alpha=0;
//    cutImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    [window addSubview:cutImageView];
//    //将改变的图片在还原成缩略图
//    //    [Tool downloadImage:stillsModel.url button:nil imageView:item._imageView defaultImage:@"img_ticketMovie_default.png"] ;
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         cutImageView.transform = CGAffineTransformMakeScale(1, 1);
//                         cutImageView.hidden=NO;
//                         cutImageView.alpha=1;
//                     }completion:^(BOOL finish){
//                         
//                     }];
//}

//点击加载更多
-(void)touchLastView:(UIView *)lastView
{
//    NSLog(@"点击了加载更多");
//    [self copyData];
//    [_pickerView reload];
}

//上拉加载更多
-(void)pullLoadData
{
    [self copyData];
    [_pickerView reload];
}

//拷贝数据
-(void)copyData
{
    if (_arrStillsImage != nil && _arrStillsImage.count >0)
    {
        //如果展示的个数等于所有数据
        if(_arrStillsImage.count == _arrNewStillsImage.count)
        {
            return;
        }
        
        //放入数据的个数等于 图片的索引 加上加载的个数30
        NSInteger tempCount = _indexImage + LOAD_COUNT_PER_TIME;
        
        //如果图片的个数小于加载的个数
        if (_arrStillsImage.count < tempCount)
        {
            //图片的个数等于加载的个数
            tempCount = _arrStillsImage.count;
        }
        
        //放入数据
        for (NSInteger i = _indexImage; i < tempCount; i++, _indexImage++)
        {
            StillsModel *stillsModel = [_arrStillsImage objectAtIndex:i];
            [_arrNewStillsImage addObject:stillsModel];
        }
    }
}

//计算的最后一个View
-(void)lastView:(UIView *)lastView
{
    UILabel *labelMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, lastView.frame.size.width, 15)];
    labelMore.backgroundColor = [UIColor clearColor];
    labelMore.text = @"上拉加载更多...";
    labelMore.textColor = RGBA(123, 122, 152, 1);
    labelMore.font = MKFONT(15);
    labelMore.textAlignment = NSTextAlignmentCenter;
    [lastView addSubview:labelMore];
    
    lastView.backgroundColor = [UIColor clearColor];
//        lastView.backgroundColor = [UIColor yellowColor];
}
/*============================PhotoPickerViewDelegate End=================================*/

#pragma mark 重新加载
-(void)onButtonTryAgainShareList
{
    [self initData];
    //    [_pickerView reload];
}

#pragma mark 加载海报图片
-(void)loadPosterImageData
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
