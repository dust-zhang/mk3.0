//
//  OrderGoodsView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/12.
//
//

#import "OrderGoodsView.h"

@implementation OrderGoodsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame arrSale:(NSArray*)array orderModel:(BuildOrderModel*)model discountType:(DiscountType)type price:(float)price
{
    self = [super initWithFrame:frame];
    _arrGoods = [NSArray arrayWithArray:array];
    _orderModel = model;
    _totalPrice = price;
    self.discountType = type;
    _tableHeight = 0;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.userInteractionEnabled = YES;
    [self addSubview:_scroll];
    
    UITapGestureRecognizer* tapHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [_scroll addGestureRecognizer:tapHide];
    
    __weak typeof(self) weakSelf = self;
    [ServicesUser getMyInfo:[Config getUserId] model:^(UserModel *userModel) {
        weakSelf.strTel = userModel.mobileno;
        [weakSelf refreshTel];
        [_table reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    [self initTicketView];
    [self initSaleTable];
    [self initControl];

    keyboardShowing = NO;
    isShowKeyboard = NO;
    [self registerForKeyboardNotifications];
    
    return self;
}

-(void)initTicketView
{
    CGFloat heightTicketView = 0;
    if (_orderModel.arrSeats.count == 4 && SCREEN_WIDTH == 320)
    {
        //选了四个座，iPhone5
        heightTicketView = 200-15;
    }
    else
    {
        heightTicketView = 182-15;
    }
    
    _ticketView = [[OrderTicketView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, heightTicketView)];
    _ticketView.userInteractionEnabled = YES;
    [_ticketView setData:_orderModel];
    [_ticketView layoutFrame];
    [_scroll addSubview:_ticketView];
    
//    UITapGestureRecognizer* tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTo:)];
//    [_ticketView addGestureRecognizer:tap0];
}

-(void)initSaleTable
{
    CGFloat tableY = _ticketView.frame.origin.y+_ticketView.frame.size.height;
    if (_arrGoods.count>0)
    {
        for (int i = 0; i<_arrGoods.count; i++)
        {
            if (i == _arrGoods.count-1 && i==0)
            {
                _tableHeight += 129+10;
            }
            else
            {
                if (i == _arrGoods.count-1)
                {
                    _tableHeight += 129;
                }
                else
                {
                    _tableHeight += 115;
                }
            }
        }
        tableY = tableY + 10;
    }
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(15, tableY, SCREEN_WIDTH-30, _tableHeight)];
    _table.dataSource = self;
    _table.delegate = self;
    [_table setBackgroundColor:[UIColor whiteColor]];
    _table.scrollEnabled = NO;
    _table.layer.masksToBounds = YES;
    _table.layer.cornerRadius = 2;
    _table.layer.borderWidth = 0.5;
    _table.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    _table.separatorColor = [UIColor clearColor];
    _table.layer.borderWidth = 0.5;
    _table.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    [_scroll addSubview:_table];

}

-(void)initControl
{
    //权益优惠
    _viewDiscount = [[UIView alloc]initWithFrame:CGRectMake(15, _table.frame.origin.y+_table.frame.size.height+10, SCREEN_WIDTH-30, 45)];
    _viewDiscount.userInteractionEnabled = YES;
    _viewDiscount.layer.masksToBounds = YES;
    _viewDiscount.layer.cornerRadius = 2;
    _viewDiscount.layer.borderWidth = 0.5;
    _viewDiscount.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    _viewDiscount.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:_viewDiscount];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_viewDiscount addGestureRecognizer:tap];
    
    _labelDiscount = [[UILabel alloc]initWithFrame:CGRectMake(15, (90/2-15)/2, 150, 15)];
    _labelDiscount.font = MKBOLDFONT(15);
    _labelDiscount.text = @"权益优惠";
    _labelDiscount.backgroundColor = [UIColor clearColor];
    _labelDiscount.textColor = RGBA(51, 51, 51, 1);
    [_viewDiscount addSubview:_labelDiscount];
    
    _imageArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_viewDiscount.frame.size.width-15-5.5, (90/2-9)/2, 5.5, 9)];
    [_imageArrow setImage:[UIImage imageNamed:@"image_rightArrow_notRight.png"]];
    [_viewDiscount addSubview:_imageArrow];
    
    _labelHaveDiscount = [[UILabel alloc]initWithFrame:CGRectMake(_imageArrow.frame.origin.x - 5 - 150, (90/2-12)/2, 150, 12)];
    _labelHaveDiscount.font = MKFONT(12);
    _labelHaveDiscount.text = @"有可用优惠";
    _labelHaveDiscount.textAlignment = NSTextAlignmentRight;
    _labelHaveDiscount.backgroundColor = [UIColor clearColor];
    _labelHaveDiscount.textColor = RGBA(249, 97, 97, 1);
    [_viewDiscount addSubview:_labelHaveDiscount];
    
    //手机号
    _viewPhone = [[UIView alloc]initWithFrame:CGRectMake(15, _viewDiscount.frame.origin.y+_viewDiscount.frame.size.height+10, SCREEN_WIDTH-30, 45)];
    _viewPhone.userInteractionEnabled = YES;
    _viewPhone.layer.masksToBounds = YES;
    _viewPhone.layer.cornerRadius = 2;
    _viewPhone.layer.borderWidth = 0.5;
    _viewPhone.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    _viewPhone.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:_viewPhone];
    
    //星号
    UIImageView *imageStar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 7, 15)];
    [imageStar setImage:[UIImage imageNamed:@"image_phoneStar.png"]];
    [_viewPhone addSubview:imageStar];
    
    _labelPhone = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelPhone.font = MKBOLDFONT(15);
    _labelPhone.backgroundColor = [UIColor clearColor];
    _labelPhone.text = @"手机号";
    _labelPhone.frame = CGRectMake(imageStar.frame.origin.x+imageStar.frame.size.width+9, 0, [Tool calStrWidth:_labelPhone.text height:15], 45);
    _labelPhone.textColor = RGBA(51, 51, 51, 1);
    [_viewPhone addSubview:_labelPhone];
    
    //手机号码输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(_labelPhone.frame.origin.x+_labelPhone.frame.size.width+10, 15, SCREEN_WIDTH-30-_labelPhone.frame.origin.x-_labelPhone.frame.size.width-10, 15)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField setBackgroundColor:[UIColor clearColor]];
    [_textField setTextColor:RGBA(51, 51, 51, 1)];
    _textField.font = MKFONT(14);
    _textField.returnKeyType = UIReturnKeyDefault;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [_viewPhone addSubview:_textField];
    
    _labelDefault = [[UILabel alloc]initWithFrame:_textField.frame];
    _labelDefault.font = MKFONT(12);
    _labelDefault.backgroundColor = [UIColor clearColor];
    _labelDefault.textColor = RGBA(214, 214, 227, 1);
    _labelDefault.text = @"请输入手机号码，用于生成订单。";
    _labelDefault.hidden = NO;
    [_viewPhone addSubview:_labelDefault];
    
    //手机号码取消按钮
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.backgroundColor = [UIColor clearColor];
    _btnCancel.frame = CGRectMake(_viewPhone.frame.size.width-15-15, (_viewPhone.frame.size.height-15)/2, 15, 15);
    [_btnCancel setBackgroundImage:[UIImage imageNamed:@"image_CinemaClear.png"] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(onButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel.hidden = YES;
    [_viewPhone addSubview:_btnCancel];
    
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, _viewPhone.frame.origin.y+_viewPhone.frame.size.height+15+100);
}

-(void)refreshTel
{
    _textField.text = self.strTel;
    //获取最新下订单保存的手机号
    NSString* strPhone = [Config getUserOrderPhone:[Config getUserId]];
    if (strPhone.length>0)
    {
        _textField.text = strPhone;
        self.strTel = strPhone;
    }
    if (_textField.text.length<=0)
    {
        _labelDefault.hidden = NO;
    }
    else
    {
        _labelDefault.hidden = YES;
    }
}

-(void)onButtonCancel
{
    _textField.text = @"";
    _btnCancel.hidden = YES;
    _labelDefault.hidden = NO;
    self.strTel = @"";
}

-(void)textFiledValueChange:(UITextField*)textField
{
    int maxLength = 0;
    if (textField.text.length > 11)
    {
        maxLength = 11;
        [Tool showWarningTip:@"手机号不能超过11位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    self.strTel = textField.text;
    
    if (textField.text.length<=0)
    {
        _btnCancel.hidden = YES;
        _labelDefault.hidden = NO;
    }
    else
    {
        _btnCancel.hidden = NO;
        _labelDefault.hidden = YES;
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _btnCancel.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _scroll.frame = CGRectMake(0, 0, _scroll.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    [MobClick event:mainViewbtn43];
    if (_textField.text.length<=0)
    {
        _btnCancel.hidden = YES;
    }
    else
    {
        _btnCancel.hidden = NO;
    }
    
    keyboardShowing = YES;
    isShowKeyboard = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (_viewPhone.frame.origin.y+_viewPhone.frame.size.height+height>self.frame.size.height)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _scroll.frame = CGRectMake(0, 0, _scroll.frame.size.width, _scroll.frame.size.height-height+100);
            [_scroll setContentOffset:CGPointMake(0, _scroll.contentSize.height-_scroll.frame.size.height)];
        } completion:^(BOOL finished) {
            keyboardShowing = NO;
        }];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!keyboardShowing)
    {
        [self hideKeyboard];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

-(void)tapTo:(UIGestureRecognizer *)sender
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    if (isShowKeyboard)
    {
        isShowKeyboard = NO;
        [_textField resignFirstResponder];
    }
}

-(void)tap
{
    if (!isShowKeyboard)
    {
        if (![_labelHaveDiscount.text isEqualToString:@"无可用优惠"])
        {
            if ([self.showDelegate respondsToSelector:@selector(showDiscountView)])
            {
                [MobClick event:mainViewbtn38];
                [self.showDelegate showDiscountView];
            }
        }
    }
    else
    {
        [self hideKeyboard];
    }
}

-(void)refreshDiscount:(DiscountType)type
{
    if (type == 2)
    {
        //无可用优惠
        _labelHaveDiscount.text = @"无可用优惠";
        _labelHaveDiscount.textColor = RGBA(51, 51, 51, 0.3);
        _labelDiscount.textColor = RGBA(51, 51, 51, 0.3);
    }
    else if (type == 1)
    {
        //有可用优惠
        _labelHaveDiscount.text = @"有可用优惠";
        _labelHaveDiscount.textColor = RGBA(249, 97, 97, 1);
        _labelDiscount.textColor = RGBA(51, 51, 51, 1);
    }
    else if (type == 3)
    {
        //已选择优惠
        _labelHaveDiscount.text = @"已使用优惠";
        _labelHaveDiscount.textColor = RGBA(249, 97, 97, 1);
        _labelDiscount.textColor = RGBA(51, 51, 51, 1);
    }
}


-(void)registerForKeyboardNotifications
{
    //键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //键盘显示
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)refreshData:(DiscountType)type
{
    self.discountType = type;
    [self refreshDiscount:type];
}

#pragma mark - tableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrGoods.count;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _arrGoods.count - 1)
    {
        return 129;
    }
    else
    {
        return 105;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier= @"OrderGoosTableViewCell"; //[NSString stringWithFormat:@"OrderSaleTableViewCell%ld",(long)indexPath.row];//
    
    OrderGoosTableViewCell *cell = (OrderGoosTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[OrderGoosTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == _arrGoods.count - 1)
    {
        [cell setCellData:_arrGoods[indexPath.row] isLast:YES price:_totalPrice];
        [cell setCellFrame:YES];
    }
    else
    {
        [cell setCellData:_arrGoods[indexPath.row] isLast:NO price:0];
        [cell setCellFrame:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
}

-(void)showKeyBoard
{
    [_textField becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (!keyboardShowing)
//    {
//        [self hideKeyboard];
//    }
//}
//
////当键盘隐藏的时候
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _table.frame = CGRectMake(0, 0, _table.frame.size.width, self.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//- (void)keyboardWillShow:(NSNotification*)notification
//{
//    keyboardShowing = YES;
//    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    [UIView animateWithDuration:0.3 animations:^{
//        _table.frame = CGRectMake(0, 0, _table.frame.size.width, _table.frame.size.height-height+50);
//        [_table setContentOffset:CGPointMake(0, _table.contentSize.height-_table.frame.size.height) animated:NO];
//    } completion:^(BOOL finished) {
//        keyboardShowing = NO;
//    }];
//}
//
//-(void)contentTextFieldDidChange:(NSNotification*)notification
//{
//    UITextField *textField = notification.object;
//    int maxLength = 0;
//    if (textField.text.length > 11)
//    {
//        maxLength = 11;
//        [Tool showWarningTip:@"手机号不能超过11位"  time:0.5];
//    }
//    if (maxLength != 0)
//    {
//        textField.text = [textField.text substringToIndex:maxLength];
//    }
//    self.strTel = textField.text;
//    
//    //创建第0区第1行的indexPath
//    NSUInteger newIndex[] = {0, _arrGoods.count+2};
//    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
//    //找到对应的cell
//    OrderTelTableViewCell *nextCell = (OrderTelTableViewCell *)[_table cellForRowAtIndexPath:newPath];
//    if (textField.text.length<=0)
//    {
//        nextCell.btnCancel.hidden = YES;
//        nextCell.labelPlaceholder.hidden = NO;
//    }
//    else
//    {
//        nextCell.btnCancel.hidden = NO;
//        nextCell.labelPlaceholder.hidden = YES;
//    }
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if (![touch.view isKindOfClass:[UITextField class]])
//    {
//        [self hideKeyboard];
//    }
//}
//
//-(void)hideKeyboard
//{
//    //创建第0区第1行的indexPath
//    NSUInteger newIndex[] = {0, _arrGoods.count+2};
//    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
//    //找到对应的cell
//    OrderTelTableViewCell *nextCell = (OrderTelTableViewCell *)[_table cellForRowAtIndexPath:newPath];
//    if (nextCell.textField)
//    {
//        [nextCell.textField resignFirstResponder];
//    }
//}
//
//-(void)changeTel
//{
//    self.strTel = @"";
//}

@end
