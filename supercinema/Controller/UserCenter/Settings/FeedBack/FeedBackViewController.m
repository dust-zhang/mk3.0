//
//  FeedBackViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/9/16.
//
//

#import "FeedBackViewController.h"


@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(246, 246, 251, 1);
    
    _arrayImage = [[NSMutableArray alloc ] initWithCapacity:0];
    _intImageCount = -1;
    _btnTag = 3;//默认为其他：3

    [self initCtrl];
    //放弃第一响应（触发键盘隐藏）
    [_textViewEmail resignFirstResponder];
    [_textViewContent resignFirstResponder];
}

//渲染UI
-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"意见反馈"];
    
    //确认按钮
    _btnFeedBackConfirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-35, 35, 35, 15)];
    [_btnFeedBackConfirm setBackgroundColor:[UIColor clearColor]];
    [_btnFeedBackConfirm.titleLabel setFont:MKFONT(15)];
    [_btnFeedBackConfirm setTitleColor:RGBA(117, 112, 255, 0.3) forState:UIControlStateNormal];
    _btnFeedBackConfirm.enabled = NO;
    [_btnFeedBackConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnFeedBackConfirm addTarget:self action:@selector(onButtonFeedBackConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFeedBackConfirm];
    
    //整体的ScrollView
    _wholeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _wholeScrollView.delegate = self;
    [_wholeScrollView setBackgroundColor:[UIColor clearColor]];
    
    //整体的View（移动）
    _viewAllBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _wholeScrollView.frame.size.width, _wholeScrollView.frame.size.height)];
    [_viewAllBG setBackgroundColor:[UIColor clearColor]];
    [_wholeScrollView addSubview:_viewAllBG];
    
    //意见说明提示
    UILabel *labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake( 15, 15, 170, 12)];
    [labelPrompt setBackgroundColor:[UIColor clearColor]];
    [labelPrompt setFont:MKFONT(14)];
    [labelPrompt setTextAlignment:NSTextAlignmentLeft];
    [labelPrompt setTextColor:RGBA(123, 122, 152, 1)];
    [labelPrompt setText:@"请选择意见反馈类型："];
    [_viewAllBG addSubview:labelPrompt];
    
    //意见类型 整体背景
    _viewFeedBackType = [[UIView alloc] initWithFrame:CGRectMake(0, 15+labelPrompt.frame.size.height+10, SCREEN_WIDTH, 30+21+15+21+30)];
    [_viewFeedBackType setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_viewAllBG addSubview:_viewFeedBackType];
    
    NSArray *arrTypeName = [NSArray arrayWithObjects:@"购票",@"会员卡",@"APP异常",@"其他", nil];
    int interval = (SCREEN_WIDTH-(21+10+60)*3-(30*2))/2;
    for (int i = 0; i < 4; i++)
    {
        //透明按钮
        UIButton *btnFeedBackType = [[UIButton alloc] initWithFrame:CGRectMake(30+(interval*(i%3)+(21+10+60)*(i%3)), 30+((21+15)*(i/3)), 21+10+60, 21)];
        [btnFeedBackType setBackgroundColor:[UIColor clearColor]];
        btnFeedBackType.tag = 11+i;
        [btnFeedBackType addTarget:self action:@selector(onButtonFeedBackType:) forControlEvents:UIControlEventTouchUpInside];
        [_viewFeedBackType addSubview:btnFeedBackType];

        //圆圈图片
        _imageRound[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        [_imageRound[i] setBackgroundColor:[UIColor clearColor]];
        [btnFeedBackType addSubview:_imageRound[i]];
        
        //类型名称
        UILabel *labelTypeName = [[UILabel alloc] initWithFrame:CGRectMake(21+10, 3, 60, 15)];
        [labelTypeName setBackgroundColor:[UIColor clearColor]];
        [labelTypeName setFont:MKFONT(15)];
        [labelTypeName setTextAlignment:NSTextAlignmentLeft];
        [labelTypeName setTextColor:RGBA( 51, 51, 51, 1)];
        [labelTypeName setText:arrTypeName[i]];
        [btnFeedBackType addSubview:labelTypeName];
        
        //显示按钮颜色逻辑
        if (i == 3)
        {
            [_imageRound[i] setImage:[UIImage imageNamed:@"image_feedbackRound.png"]];
        }
        else
        {
            [_imageRound[i] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
        }
    }
    
    //邮箱 & 意见内容 背景的View
    _viewControlsBG = [[UIView alloc] initWithFrame:CGRectZero];
    [_viewControlsBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_viewAllBG addSubview:_viewControlsBG];
    
    //电子邮箱背景View
    _textViewEmailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [_textViewEmailView setBackgroundColor:[UIColor clearColor]];
    [_viewControlsBG addSubview:_textViewEmailView];
    
    //电子邮箱TextField
    _textViewEmail = [[UITextField alloc ] initWithFrame:CGRectMake(19,_textViewEmailView.frame.origin.y, SCREEN_WIDTH-34, 44)];
    [_textViewEmail setFont:MKFONT(15)];
    [_textViewEmail setBackgroundColor:[UIColor clearColor]];
    [_textViewEmail setTextColor:RGBA(51, 51, 51, 1)];
    _textViewEmail.placeholder = @"请留下您的邮箱（必填）";
    [_textViewEmail setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    _textViewEmail.tintColor = RGBA(117, 112, 255, 1);
    _textViewEmail.returnKeyType = UIReturnKeyDone;
    _textViewEmail.delegate = self;
    [_textViewEmail addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [_textViewEmail becomeFirstResponder];
    [_textViewEmailView addSubview:_textViewEmail];
    
    //分割线
    UILabel *_labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _textViewEmail.frame.origin.y+_textViewEmail.frame.size.height, SCREEN_WIDTH, 1)];
    [_labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
    [_viewControlsBG addSubview:_labelLine];
    
    
    //内容TextView
    _textViewContent = [[UITextView alloc ] initWithFrame:CGRectMake(15, _textViewEmail.frame.origin.y+_textViewEmail.frame.size.height+1, SCREEN_WIDTH-30, 154)];
    [_textViewContent setFont:MKFONT(15)];
    [_textViewContent setTextColor:[UIColor blackColor]];
    [_textViewContent setBackgroundColor:[UIColor clearColor]];
    _textViewContent.tintColor = RGBA(117, 112, 255, 1);
    _textViewContent.delegate = self;
    [_textViewContent becomeFirstResponder];

    [_viewControlsBG addSubview:_textViewContent];

    
    
    _labelPlaceContent = [[UILabel alloc ] initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH-30, 15)];
    [_labelPlaceContent setFont:MKFONT(15) ];
    [_labelPlaceContent setText:@" 我想说...（必填）"];
    [_labelPlaceContent setTextColor:RGBA(180, 180, 180, 1)];
    [_labelPlaceContent setBackgroundColor:[UIColor clearColor]];
    [_textViewContent addSubview:_labelPlaceContent];
    
    _labelWordNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -15 - 100,_textViewContent.frame.origin.y+_textViewContent.frame.size.height+10 ,100,15)];
    _labelWordNum.attributedText = [self wordNumAttributeString:_textViewContent.text.length];
    _labelWordNum.numberOfLines = 1;
    _labelWordNum.textAlignment = NSTextAlignmentRight;
    [_viewControlsBG addSubview:_labelWordNum];
    
    
    //图片背景的位置
    if (IPhone5 || IPhone4)
    {
        _viewImage = [[UIView alloc] initWithFrame:CGRectMake(15,_textViewContent.frame.origin.y+154+10+15+10, SCREEN_WIDTH-15*2, 66)];
    }
    else if (IPhone6)
    {
        _viewImage = [[UIView alloc] initWithFrame:CGRectMake(15,_textViewContent.frame.origin.y+154+10+15+10, SCREEN_WIDTH-15*2, 79)];
    }
    else if (IPhone6plus)
    {
        _viewImage = [[UIView alloc] initWithFrame:CGRectMake(15,_textViewContent.frame.origin.y+154+10+15+10, SCREEN_WIDTH-15*2, 90)];
    }
    [_viewImage setBackgroundColor:[UIColor clearColor]];
    [_viewControlsBG addSubview:_viewImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardImage:) name:UIKeyboardWillHideNotification object:nil];
    
    //添加图片
    for (int i = 0 ; i < 4; i++)
    {
        _btnSelect[i] = [[UIButton alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-15*2))/4*i+(i+2)*1, 0, (_viewImage.frame.size.width-10*3)/4, (_viewImage.frame.size.width-10*3)/4)];
        _btnSelect[i].tag = i;
        [_btnSelect[i] setUserInteractionEnabled:YES];
        [_btnSelect[i] setImage:[UIImage imageNamed:@"btn_addImage+.png" ] forState:UIControlStateNormal];
        [_btnSelect[i] addTarget:self action:@selector(tapSelectImage:) forControlEvents:UIControlEventTouchUpInside];
        [_viewImage addSubview:_btnSelect[i]];
        
        //显示图片
        _imageviewTop[i] = [[UIImageView alloc] initWithFrame:_btnSelect[i].frame];
        [_imageviewTop[i] setBackgroundColor:[UIColor clearColor]];
        [_imageviewTop[i] setHidden:YES];
        [_viewImage addSubview:_imageviewTop[i]];
        
        //删除图片按钮
        _btnDelete[i] = [[UIButton alloc ] initWithFrame:CGRectMake((_imageviewTop[i].frame.origin.x+_imageviewTop[i].frame.size.width)-15, 0, 15, 15)];
        [_btnDelete[i] setBackgroundImage:[UIImage imageNamed:@"btn_feedbackDelete.png"] forState:UIControlStateNormal] ;
        _btnDelete[i].backgroundColor = [UIColor clearColor];
        [_btnDelete[i] addTarget:self action:@selector(onButtonDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete[i].tag = i;
        [_btnDelete[i] setHidden:YES];
        [_viewImage addSubview:_btnDelete[i]];
    }
    
    //设置按钮的显示隐藏状态
    [self reloadButton];
    
    _viewControlsBG.frame = CGRectMake(0, _viewFeedBackType.frame.origin.y+_viewFeedBackType.frame.size.height+10, SCREEN_WIDTH, 44+154+ _viewImage.frame.size.height + 20 + 15 + 10);
    
    float fViewHeight = 15+labelPrompt.frame.size.height+10+_viewFeedBackType.frame.size.height+10+_viewControlsBG.frame.size.height+60;
    _viewAllBG.frame = CGRectMake(0, 0, _wholeScrollView.frame.size.width, fViewHeight);
    
    //ScrollView内容的高度
    _wholeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,fViewHeight);
    [self.view addSubview:_wholeScrollView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    //将菜单view置于最上方，不会被遮住
    [self.view bringSubviewToFront:self._labelTitle];
    
}

- (NSAttributedString *)wordNumAttributeString:(NSInteger)lenth
{
    UIColor *wordNumColor = RGBA(153, 153, 153, 1);
    if (lenth > 500)
    {
        wordNumColor = RGBA(249, 81, 81, 1);
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",lenth] attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : wordNumColor}];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/500" attributes:@{NSFontAttributeName : MKFONT(15) , NSForegroundColorAttributeName : RGBA(153, 153, 153, 1)}]];
    return attrStr;
}

#pragma mark 确认按钮 
-(void)onButtonFeedBackConfirm
{
    [MobClick event:myCenterViewbtn117];
    [self hideKeyboard];

    //判断输入内容是否为空（邮箱格式是否正确）
    //检验内容正文是否为空
    if ([_textViewContent.text isEqualToString:@""])
    {
        [Tool showWarningTip:@"请输入问题原因"  time:1.0f];
        return;
    }
   // 检验内容正文文字是否超出限制
    if (_textViewContent.text.length > 500)
    {
        [Tool showWarningTip:@"别写了，写太多装不下了"  time:1.0f];
        return;
    }
    //检验邮箱格式
    if ([_textViewEmail.text isEqualToString:@""])
    {
        [Tool showWarningTip:@"请填写邮箱"  time:1.0f];
        return;
    }
    if (![Tool validateEmail:_textViewEmail.text])
    {
        [Tool showWarningTip:@"邮箱格式错误请检查" time:1.0f];
        return;
    }
    if ([_arrayImage  count] > 0 )//存在图片
    {
        [self uploadImage];
    }
    else//不存在图片
    {
        [self upLoadImageAndContent ];
    }
}

#pragma mark 选择意见反馈类型
-(void)onButtonFeedBackType:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 11:
            //购票
            _btnTag = 0;
            [_imageRound[0] setImage:[UIImage imageNamed:@"image_feedbackRound.png"]];
            [_imageRound[1] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[2] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[3] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            
            break;
            
        case 12:
            //会员卡
            _btnTag = 1;
            [_imageRound[0] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[1] setImage:[UIImage imageNamed:@"image_feedbackRound.png"]];
            [_imageRound[2] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[3] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            break;
            
        case 13:
            //APP异常
            _btnTag = 2;
            [_imageRound[0] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[1] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[2] setImage:[UIImage imageNamed:@"image_feedbackRound.png"]];
            [_imageRound[3] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            break;
            
        case 14:
            //其他
            _btnTag = 3;
            [_imageRound[0] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[1] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[2] setImage:[UIImage imageNamed:@"image_feedbackRound_gray.png"]];
            [_imageRound[3] setImage:[UIImage imageNamed:@"image_feedbackRound.png"]];
            break;
            
        default:
            break;
    }
}

#pragma mark  请求服务器得到要上传图片的url，然后再上传
- (void)uploadImage
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在提交..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    if ([_arrayImage count] > 0)
    {
        [ServicesUpload requestUpdateImage:[_arrayImage count]  type:@"article" success:^(NSDictionary *suc)
         {
             _arrayUpload = [ServicesUpload getUploadYpaiParam:suc];
             [weakSelf upLoadUpai];
             
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             [Tool showWarningTip:@"提交失败" time:1 ];
         }];
    }
    else
    {
        [self upLoadImageAndContent ];
    }
}

- (void)upLoadUpai
{
    _intImageCount++;
    if (_intImageCount >= [_arrayUpload count])
        return;
    
    upLoadImageModel *upLoadimageModel = [_arrayUpload objectAtIndex:_intImageCount];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    NSDictionary * parameDic = @{upLoadimageModel.policyKey:upLoadimageModel.policyValue ,upLoadimageModel.signatureKey:upLoadimageModel.signatureValue};
     __weak typeof(self) weakSelf = self;
    [manager POST:upLoadimageModel.upload_url parameters:parameDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         //遍历添加图片
         UIImage* previewImage = _arrayImage[_intImageCount];
         //图片
         NSData *imageData = UIImagePNGRepresentation(previewImage);
         [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"file%@",[imageData detectImageSuffix]]
                                 mimeType:@"multipart/form-data"];
         
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //如果上传又拍成功 继续上传到自己服务器
         if (_intImageCount == [_arrayUpload count]-1)
         {
             [weakSelf upLoadImageAndContent];
         }
         else
         {
             [weakSelf upLoadUpai];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
     }];
}

#pragma mark 上传图片地址和内容到服务器
-(void)upLoadImageAndContent
{
    ///反馈类型 0:购票问题 1:会员卡问题 2:app问题 3:其它问题
    NSMutableArray *imageArr = [[NSMutableArray alloc ] initWithCapacity:0];
    //遍历添加图片
    for (int n_intImageCount = 0 ; n_intImageCount< [_arrayImage count]; n_intImageCount++)
    {
        upLoadImageModel *upLoadimageModel = upLoadimageModel = [_arrayUpload objectAtIndex:n_intImageCount];
        [imageArr addObject:upLoadimageModel.path];
    }
     __weak typeof(self) weakSelf = self;
    [ServiceFeedback upLoadFeedbackContent:_btnTag feedbackContent:_textViewContent.text email:_textViewEmail.text imageList:imageArr model:^(RequestResult *model)
     {
         if ([model.respStatus intValue] == 1)
         {
             [Tool showWarningTip:@"提交成功，我们会尽快处理哒~" time:1.5];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }
         
     } failure:^(NSError *error){
         [Tool showWarningTip:@"上传失败" time:1];
     }];
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //监听向下滑动
    if (_wholeScrollView.contentOffset.y < 0)
    {
        [self hideKeyboard];
    }
}

#pragma mark 判断输入内容
- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger oldLength=textView.text.length;
    NSString *newTextValue=[Tool disableEmoji:[textView text]];
    if(newTextValue.length!=oldLength)
    {
        [textView setText:newTextValue];
    }
    if(oldLength>textView.text.length)
    {
        [Tool showWarningTip:@"不支持表情"  time:0.5f];
    }
//        itemText.content = _textViewContent.text;
    if (![_textViewContent.text isEqualToString:@""])
    {
        _labelPlaceContent.hidden = YES;
    }
    else
    {
        _labelPlaceContent.hidden = NO;
    }
    if (![_textViewEmail.text isEqualToString:@""])
    {
        _labelEmailContent.hidden = YES;
    }
    else
    {
        _labelEmailContent.hidden = NO;
    }
    
    NSInteger strACout = 500 - textView.text.length;
    NSString * str = [NSString stringWithFormat:@"%ld",(long)strACout];
    [_labelTextCount setText:str];
    
    if((int)strACout < 0 )
    {
        [_labelTextCount setTextColor:[UIColor redColor]];
    }
    else
    {
        [_labelTextCount setTextColor:RGBA(221, 221, 221, 1)];
    }
    [self refreshButtonState];
    
    _labelWordNum.attributedText = [self wordNumAttributeString:_textViewContent.text.length];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        float fBounceHeight = 0;
        
        if (IPhone5)
        {
            fBounceHeight = -165-15;
        }
        else
        {
            fBounceHeight = -70 - 25;
        }
        
        _viewAllBG.frame = CGRectMake(0, fBounceHeight, SCREEN_WIDTH, _viewAllBG.frame.size.height);
        
        CGRect frame = _wholeScrollView.frame;
        //键盘高度216
        int offset = frame.origin.y + 32 - (_wholeScrollView.frame.size.height - 216.0);
        if(offset > 0)
        {
             _wholeScrollView.frame = CGRectMake(0.0f, -offset, _wholeScrollView.frame.size.width, _wholeScrollView.frame.size.height);
        }
    }];
}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView
{
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFiledValueChange:(UITextField*)textField
{
    [self refreshButtonState];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textViewEmail resignFirstResponder];
    return YES;
}

//判断是否都输入后，确认能否点击
-(void)refreshButtonState
{
    if (_textViewEmail.text.length > 0 && _textViewContent.text.length > 0)
    {
        _btnFeedBackConfirm.enabled = YES;
        [_btnFeedBackConfirm setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    }
    else
    {
        _btnFeedBackConfirm.enabled = NO;
        [_btnFeedBackConfirm setTitleColor:RGBA(117, 112, 255,0.3) forState:UIControlStateNormal];
    }
    
//    _labelWordNum.attributedText = [self wordNumAttributeString:_textViewContent.text.length];
}

//隐藏键盘
-(void)hideKeyboard
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _viewAllBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, _viewAllBG.frame.size.height);
        
    } completion:^(BOOL finished) {
    }];
    
    
    [_textViewContent resignFirstResponder];
    [_textViewEmail resignFirstResponder];
}

//点击TextView的返回按钮收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([textView.text length] == 499)
//    {
//        [Tool showWarningTip:@"超出文字限制500字" time:1.5];
//        return YES;
//    }
    
    if([text length] == 0)
        return TRUE;
    
    NSString *strText = textView.text;
    NSUInteger textLength = [strText length];
    BOOL bChange =YES;
    if (textLength >= 500)
    {
        bChange = YES;
    }
    if (range.length == 1)
    {
        bChange = YES;
    }
    return bChange;
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSInteger strACout = 500 - textView.text.length;
    NSString *strText = [NSString stringWithFormat:@"%ld",(long)strACout];
    [_labelTextCount setText:strText];
    if((int)strACout < 0 )
    {
        [_labelTextCount setTextColor:[UIColor redColor]];
    }
    else
    {
        [_labelTextCount setTextColor:RGBA(221, 221, 221, 1)];
    }
    return TRUE;
}

#pragma mark - 添加删除图片
//刷新button，显示图片还是添加按钮
-(void) reloadButton
{
    [self hideAllButton];
    //没有选择的图片
    if ([_arrayImage count] == 0 )
    {
        //只显示加号按钮
        [_btnSelect[0] setHidden:NO];
        [_btnSelect[0] setImage:[UIImage imageNamed:@"btn_addImage+.png" ] forState:UIControlStateNormal];
        for (int i = 0 ; i < 3; i++)
        {
            //只显示加号按钮
            [_btnSelect[i+1] setHidden:YES];
            [_btnSelect[0] setBackgroundImage:nil forState:UIControlStateNormal];
            
            [_btnDelete[i] setHidden:YES];
            [_labelBlack[i] setHidden:YES];
            [_imageviewTop[i] setHidden:YES];
        }
    }
    //显示图片
    for (int i = 0 ; i < [_arrayImage count]; i++)
    {
        [_btnSelect[i] setHidden:NO];
        [_labelBlack[i] setHidden:NO];
        [_imageviewTop[i] setHidden:NO];
        [_btnDelete[i] setHidden:NO];
        [_imageviewTop[i] setImage:[_arrayImage objectAtIndex:i]];
    
        //显示添加图片按钮
        if([_arrayImage count] < 4 && [_arrayImage count] >0)
        {
            [_btnSelect[i+1] setHidden:NO];
            [_labelBlack[i+1] setHidden:YES];
            [_imageviewTop[i+1] setHidden:YES];
            [_btnSelect[i+1] setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

//每次刷新重新隐藏所有按钮
-(void)hideAllButton
{
    for (int i = 0 ; i < 4; i++)
    {
        [_btnSelect[i] setHidden:YES];
        [_btnDelete[i] setHidden:YES];
    }
}

#pragma mark 响应选择图片事件
-(void)tapSelectImage:(UIButton*)tapImage
{
    [MobClick event:myCenterViewbtn116];
    [self hideKeyboard];
    //隐藏键盘
    switch ((int)tapImage.tag)
    {
        case 0:
        {
            [self pushToPickerOrEditImage:(int)tapImage.tag];
        }
            break;
        case 1:
        {
            [self pushToPickerOrEditImage:(int)tapImage.tag];
        }
            break;
        case 2:
        {
            [self pushToPickerOrEditImage:(int)tapImage.tag];
        }
            break;
        case 3:
        {
            [self pushToPickerOrEditImage:(int)tapImage.tag];
        }
            break;

        default:
            break;
    }
}

- (void)hideKeyboardImage:(NSNotification *)notification
{
    [UIView beginAnimations:@"animal" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView commitAnimations];
}

-(void) pushToPickerOrEditImage:(int) index
{
    //没有图片，跳转到选择图片
    if([_arrayImage count] == index)
    {
        [self selectPicker];
    }
    else
    {
        [self pushToEditImageViewController:index];
        return;
    }
}

//选择相册
-(void) selectPicker
{
    [self hideKeyboard];
    PhotoImagePickerController *imagePickerController = [[PhotoImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    //最小照片张数
    imagePickerController.minimumNumberOfSelection = 1;
    //选择照片最大张数
    imagePickerController.maximumNumberOfSelection = 4;
    //已经选择了多少张照片
    imagePickerController.selectedImageCount = [_arrayImage count];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

-(void)pushToEditImageViewController:(int)index
{
    PhotoBrowser  *photoBorwser = [[PhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBorwser.photoBrowserDelegate = self;
    photoBorwser._image = _arrayImage[index];
    photoBorwser._selectedCount = index;
    [photoBorwser show:YES];
}

//点击大图查看大图后，再点删除按钮
-(void)deleteImage:(int)selectedCount
{
    if ([_arrayImage count] == 0)
        return;
    [_arrayImage removeObjectAtIndex:selectedCount];
    [self reloadButton];
}

#pragma mark 删除选择的图片
-(void)onButtonDeleteImage:(UIButton *) sender
{
    int imageTag = (int)sender.tag;
    if ([_arrayImage count] == 0)
        return;
    
    [_arrayImage removeObjectAtIndex:imageTag];
    [self reloadButton];
}

#pragma mark - Assets Picker Delegate
- (void)imagePickerController:(PhotoImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(PhotoImagePickerController *)imagePicker didSelectAssets:(NSArray *)albumAssets  isSource:(BOOL)source
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"处理中..." withBlur:NO allowTap:NO];
    //只有相册
    if ([albumAssets count] > 0)
    {
        _boolOnlyStills = FALSE;
        self._arrAssets = [NSMutableArray arrayWithArray:albumAssets];
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            [self setAsset:nil ];
        }];
    }
}

#pragma mark - 取消选中图片
- (void)imagePickerControllerDidCancel:(PhotoImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 解析相册图片
- (void)setAsset:(NSArray *)stillsAssets
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    
    for (JKAssets *jka in self._arrAssets)
    {
        ALAssetsLibrary   *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:jka.assetPropertyURL resultBlock:^(ALAsset *asset)
         {
             // Add asset
             [assets addObject:asset];
             // Check if the loading finished
             UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
             
             if (IPhone6plus)
             {
                 CGSize sizeImage = {[ImageOperation getImageWidthHeight:image].width/3,  [ImageOperation getImageWidthHeight:image].height/3};
                 UIImageView *imageview = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0,sizeImage.width/2, sizeImage.height/2)];
                 //进行等比缩放
                 [imageview setImage:[ImageOperation scaleToSizeImage:sizeImage image:image ]];
                 [_arrayImage  addObject:imageview.image];
                 
             }
             else
             {
                 CGSize sizeImage = {[ImageOperation getImageWidthHeight:image].width/2,  [ImageOperation getImageWidthHeight:image].height/2};
                 UIImageView *imageview = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0,sizeImage.width/2, sizeImage.height/2)];
                 //进行等比缩放
                 [imageview setImage:[ImageOperation scaleToSizeImage:sizeImage image:image ]];
                 [_arrayImage  addObject:imageview.image];
             }
             
             if (assets.count == self._arrAssets.count)
             {
                 [self reloadButton];
                 [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             }
             
         } failureBlock:^(NSError *error){
             
         }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
