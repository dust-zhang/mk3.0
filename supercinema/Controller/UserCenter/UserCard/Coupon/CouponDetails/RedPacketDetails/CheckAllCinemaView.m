//
//  CheckAllCinemaView.m
//  supercinema
//
//  Created by mapollo91 on 25/4/17.
//
//

#import "CheckAllCinemaView.h"

@implementation CheckAllCinemaView

-(id)initWithFrame:(CGRect)frame redPacketId:(NSNumber *) Id
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _redPacketId = Id;
        self.frame = frame;
        isRemoveFromSuperview = NO;
        [self abnormalInitialize];  //异常控件初始化
        [self loadRedPacketUserCinema];
    }
    return self;
}

-(void)loadRedPacketUserCinema
{
    __weak typeof(self) weakSelf= self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesRedPacket getRedPacketUseCinemaList:_redPacketId model:^(RedPacketCinemaListModel *model)
    {
        //加载成功
        [weakSelf drawCheckAllCinemaView:model];
        
        if(model != nil)
        {
            [weakSelf showImageWithStatus:NO isLoadSuccess:YES];
        }
        else
        {
            [weakSelf showImageWithStatus:YES isLoadSuccess:YES];
        }
        [FVCustomAlertView hideAlertFromView:self fading:YES];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:self fading:YES];
        //加载失败
        [Tool showWarningTip:error.domain time:2];
        [weakSelf showImageWithStatus:NO isLoadSuccess:NO];
        isRemoveFromSuperview = YES;
    }];
}

-(void)abnormalInitialize
{
    //============================异常状态控件=================================
    //加载失败
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((self._viewOverallBG.frame.size.width-73)/2, 103, 73, 67)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    _imageFailure.hidden = YES;
    [self._viewOverallBG addSubview:_imageFailure];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+14, self._viewOverallBG.frame.size.width, 14)];
    _labelFailure.text = @"加载失败";
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    _labelFailure.hidden = YES;
    [self._viewOverallBG addSubview:_labelFailure];
    
    _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTryAgain.frame = CGRectMake((self._viewOverallBG.frame.size.width-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+24, 146/2, 24);
    [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnTryAgain.titleLabel.font = MKFONT(14);
    _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    _btnTryAgain.layer.masksToBounds = YES;
    _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
    [_btnTryAgain addTarget:self action:@selector(onButtonCheckAllCinemaView) forControlEvents:UIControlEventTouchUpInside];
    _btnTryAgain.hidden = YES;
    [self._viewOverallBG addSubview:_btnTryAgain];
    //============================异常状态控件=================================
}

-(void)drawCheckAllCinemaView:(RedPacketCinemaListModel *)model
{
    if(!self._viewContent)
    {
        //初始化
        self._viewContent = [[SpreadListTableView alloc]initWithFrame:CGRectMake(0, 33, self._viewOverallBG.frame.size.width, self._viewOverallBG.frame.size.height-33-15)];
        self._viewContent.backgroundColor = [UIColor whiteColor];
        self._viewContent.hidden = YES;
        [self._viewOverallBG addSubview:self._viewContent];
        //绘制
        [self._viewContent drawSpreadListTableViewAndData:model];
    }
}

-(void) showImageWithStatus:(BOOL)status isLoadSuccess:(BOOL)isLoadSuccess
{
    _imageFailure.hidden = isLoadSuccess;
    _labelFailure.hidden = isLoadSuccess;
    _btnTryAgain.hidden =  isLoadSuccess;
    if (isLoadSuccess)
    {
        self._viewContent.hidden = status;
    }
    else
    {
        self._viewContent.hidden = !status;
    }
}

#pragma mark 重新加载
-(void)onButtonCheckAllCinemaView
{
    [self loadRedPacketUserCinema];
}

- (void)onButtonClose
{
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(cancelViewAndIsRemove:)])
    {
        [self.delegate cancelViewAndIsRemove:isRemoveFromSuperview];
    }
    
    /*
     [UIView animateWithDuration:0.3
     animations:^{
     self.transform = CGAffineTransformMakeScale(1.3, 1.3);
     self.alpha=0;
     
     }completion:^(BOOL finish){
     if (isRemoveFromSuperview)
     {
     [self removeFromSuperview];
     }
     }];
     */
}

@end
